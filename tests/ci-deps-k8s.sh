#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh

log "cloning charts"
git clone --depth=1 https://github.com/helm/charts

log "deploying dependencies: minio"
helm install mender-minio ./charts/stable/minio --set accessKey="${MINIO_accessKey}" --set secretKey=${MINIO_secretKey}

log "deploying dependencies: mongodb"
helm install mender-mongo ./charts/stable/mongodb --set persistence.enabled=false --set usePassword=false

