#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh

log "add help repo: stable"
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

log "deploying dependencies: minio"
helm install mender-minio stable/minio --version 2.5.18 --set accessKey=${MINIO_accessKey},secretKey=${MINIO_secretKey}

log "deploying dependencies: mongodb"
helm install mender-mongo stable/mongodb --set persistence.enabled=false --set usePassword=false

