#!/bin/bash
# Copyright 2022 Northern.tech AS
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

. tests/variables.sh
. tests/functions.sh

set -e

log "installing Mender Helm chart mender-${MENDER_HELM_CHART_VERSION}.tgz"

if [ -z "$REGISTRY_MENDER_IO_USERNAME" -o -z "$REGISTRY_MENDER_IO_PASSWORD" ]; then
    log "error: missing registry.mender.io credentials"
    exit 1
fi

helm install mender -f mender/values.yaml -f tests/keys.yaml -f tests/values.yaml --set global.image.username=${REGISTRY_MENDER_IO_USERNAME} --set global.image.password="${REGISTRY_MENDER_IO_PASSWORD}" --set global.s3.AWS_ACCESS_KEY_ID="${MINIO_accessKey}" --set global.s3.AWS_SECRET_ACCESS_KEY="${MINIO_secretKey}" mender-${MENDER_HELM_CHART_VERSION}.tgz || exit 3;

log "pods:"
kubectl get pods || true

log "services:"
kubectl get services || true

log "deployments:"
kubectl get deployments || true

for p in `kubectl get pods -o custom-columns=POD:metadata.name --no-headers`; do
 echo
 log "logs $p:"
 kubectl logs $p || true
done

exit 0

