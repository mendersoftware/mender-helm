#!/bin/bash

. tests/functions.sh

set -e

log "installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 755 get_helm.sh
./get_helm.sh

log "add helm repo: stable"
helm repo add stable https://charts.helm.sh/stable

log "add helm repo: minio"
helm repo add minio https://helm.min.io/

log "add helm repo: mongodb"
helm repo add bitnami https://charts.bitnami.com/bitnami

log "add helm repo: nats"
helm repo add nats https://nats-io.github.io/k8s/helm/charts/

log "update help repositories"
helm repo update
