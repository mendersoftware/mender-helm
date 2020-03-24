#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "deploying dependencies: ElasticSearch"
kubectl apply -f tests/service-elasticsearch.yaml
kubectl apply -f tests/elasticsearch.yaml

log "installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh

log "cloning charts"
git clone --depth=1 https://github.com/helm/charts

log "deploying dependencies: Minio"
helm install mender-minio ./charts/stable/minio --set accessKey="${MINIO_accessKey}" --set secretKey=${MINIO_secretKey}

log "deploying dependencies: Redis"
helm install mender-redis ./charts/stable/redis --set master.persistence.enabled=false  --set slave.persistence.enabled=false
helm install mender-mongo ./charts/stable/mongodb --set persistence.enabled=false --set usePassword=false

