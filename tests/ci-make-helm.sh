#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "installing Mender Helm chart mender-${MENDER_HELM_CHART_VERSION}.tgz"
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

