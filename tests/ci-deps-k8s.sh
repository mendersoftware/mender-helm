#!/bin/bash

. tests/functions.sh

set -e

log "installing helm"
curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | DESIRED_VERSION="v3.8.2" bash

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
