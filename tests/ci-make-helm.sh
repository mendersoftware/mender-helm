#!/bin/bash

. tests/variables.sh
. tests/functions.sh

log "helm chart: make lint"
make lint || exit 1

log "helm chart: make package"
make package || exit 2

log "installing Mender Helm chart /builds/Northern.tech/Mender/mender-helm/mender-${MENDER_HELM_CHART_VERSION}.tgz"
helm install mender -f mender/values.yaml -f tests/keys.yaml -f tests/values.yaml --set global.image.username=${REGISTRY_MENDER_IO_USERNAME} --set global.image.password="${REGISTRY_MENDER_IO_PASSWORD}" --set global.s3.AWS_URI=http://mender-minio:9000 --set global.mongodb.URL=mender-mongo-mongodb --set conductor.env.REDIS=mender-redis-master:6379 --set conductor.env.ELASTICSEARCH=mender-elasticsearch5:9300 --set global.s3.AWS_ACCESS_KEY_ID="${MINIO_accessKey}" --set global.s3.AWS_SECRET_ACCESS_KEY="${MINIO_secretKey}" /builds/Northern.tech/Mender/mender-helm/mender-${MENDER_HELM_CHART_VERSION}.tgz || exit 3;

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

