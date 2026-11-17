#!/bin/bash
# Copyright 2026 Northern.tech AS
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

set -euo pipefail

NAMESPACE=${NAMESPACE:?NAMESPACE must be set}
HOST=mender.example.com
GATEWAY=mender-gateway
ROUTE=mender-httproute
OTHER_NAMESPACE="${NAMESPACE}-other"
TIMEOUT=${GATEWAY_TIMEOUT:-900}
RATE_LIMIT_TIMEOUT=${RATE_LIMIT_TIMEOUT:-120}

log() { echo "$(date +%T) $*"; }
fail() { log "FAIL - $*"; exit 1; }

wait_for() {
    local what=$1 limit=$2
    shift 2
    local end=$((SECONDS + limit))
    until "$@"; do
        [ "$SECONDS" -lt "$end" ] || fail "$what"
        sleep 10
    done
}

route_condition() {
    kubectl -n "$1" get httproute "$2" \
        -o jsonpath="{.status.parents[0].conditions[?(@.type==\"$3\")].${4:-status}}" 2>/dev/null || true
}
condition_is() { [ "$(route_condition "$1" "$2" "$3")" = "$4" ]; }
condition_set() { [ -n "$(route_condition "$@")" ]; }

http_code() {
    curl -s -o /dev/null -w '%{http_code}' --max-time 10 -H "Host: $2" "http://${ALB}$1" || true
}
is_healthy() { [ "$(http_code /healthz "$HOST")" = 200 ]; }

log "Gateway is programmed"
kubectl -n "$NAMESPACE" wait --for=condition=Programmed "gateway/${GATEWAY}" --timeout="${TIMEOUT}s" \
    || fail "Gateway ${GATEWAY} is not Programmed"

log "HTTPRoute is accepted and its references resolved"
wait_for "HTTPRoute not Accepted" 300 condition_is "$NAMESPACE" "$ROUTE" Accepted True
wait_for "HTTPRoute references not resolved" 300 condition_is "$NAMESPACE" "$ROUTE" ResolvedRefs True

ALB=$(kubectl -n "$NAMESPACE" get gateway "$GATEWAY" -o jsonpath='{.status.addresses[0].value}')
[ -n "$ALB" ] || fail "the Gateway has no address"
log "load balancer: ${ALB}"

log "health endpoint answers through the load balancer"
wait_for "no 200 from /healthz" "$TIMEOUT" is_healthy

log "the UI is served"
body=$(curl -s --max-time 10 -H "Host: ${HOST}" "http://${ALB}/ui/" || true)
grep -q Mender <<<"$body" || fail "the UI does not answer with the Mender page"

log "an unknown host is not served"
code=$(http_code / other.example.com)
if [ "$code" = 200 ] || [ "$code" = 000 ]; then
    fail "an unknown host got ${code}, expected the load balancer to answer and refuse it"
fi

log "the target group follows the TargetGroupConfiguration"
lb_arn=$(aws elbv2 describe-load-balancers \
    --query "LoadBalancers[?DNSName=='${ALB}'].LoadBalancerArn | [0]" --output text) \
    || fail "aws elbv2 describe-load-balancers failed"
if [ -z "$lb_arn" ] || [ "$lb_arn" = None ]; then
    fail "no load balancer has the address ${ALB}"
fi
target_group=$(aws elbv2 describe-target-groups --load-balancer-arn "$lb_arn" \
    --query 'TargetGroups[0].[HealthCheckPath,Matcher.HttpCode]' --output text) \
    || fail "aws elbv2 describe-target-groups failed"
read -r hc_path hc_codes <<<"$target_group"
if [ "$hc_path" != / ] || [ "$hc_codes" != 200-499 ]; then
    fail "target group health check is ${hc_path} ${hc_codes}, expected / 200-499"
fi

log "a route from another namespace is not accepted"
trap 'kubectl delete ns "$OTHER_NAMESPACE" --ignore-not-found --wait=false >/dev/null 2>&1 || true' EXIT
kubectl create ns "$OTHER_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$OTHER_NAMESPACE" apply -f - <<EOT
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: isolation
spec:
  parentRefs:
    - name: ${GATEWAY}
      namespace: ${NAMESPACE}
  hostnames:
    - ${HOST}
  rules:
    - backendRefs:
        - name: mender-api-gateway
          port: 80
EOT
wait_for "isolation route not reconciled" 120 condition_set "$OTHER_NAMESPACE" isolation Accepted
accepted=$(route_condition "$OTHER_NAMESPACE" isolation Accepted)
reason=$(route_condition "$OTHER_NAMESPACE" isolation Accepted reason)
if [ "$accepted" != False ] || [ "$reason" != NotAllowedByListeners ]; then
    fail "a route from ${OTHER_NAMESPACE} got Accepted=${accepted} reason=${reason}, expected False NotAllowedByListeners"
fi

log "a spoofed X-Forwarded-For does not bypass the rate limit"
probe() {
    curl -s -o /dev/null -w '%{http_code}\n' --max-time 10 \
        -H "Host: ${HOST}" -H "X-Forwarded-For: 10.$(($1 / 256 % 256)).$(($1 % 256)).1" \
        "http://${ALB}/api/management/v1/useradm/users" || echo 000
}
export -f probe
export HOST ALB
limited=false
round=0
end=$((SECONDS + RATE_LIMIT_TIMEOUT))
while [ "$limited" = false ] && [ "$SECONDS" -lt "$end" ]; do
    codes=$(seq $((round * 500 + 1)) $((round * 500 + 500)) | xargs -P 50 -I{} bash -c 'probe {}' | sort | uniq -c)
    echo "$codes"
    if grep -q ' 429$' <<<"$codes"; then limited=true; fi
    round=$((round + 1))
done
[ "$limited" = true ] || fail "no request was rate limited in ${RATE_LIMIT_TIMEOUT}s, the X-Forwarded-For header may be trusted"

log "PASS"
