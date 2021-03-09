#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh

log "add help repo: stable"
helm repo add stable https://charts.helm.sh/stable
helm repo update

log "deploying dependencies: minio"
helm repo add minio https://helm.min.io/
helm repo update
helm install mender-minio minio/minio --version 6.0.5 --set accessKey=${MINIO_accessKey},secretKey=${MINIO_secretKey},persistence.enabled=false

log "deploying dependencies: mongodb"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mender-mongo --set "auth.enabled=false,persistence.enabled=false" bitnami/mongodb
