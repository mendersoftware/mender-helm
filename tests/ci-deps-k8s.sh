#!/bin/bash
# Copyright 2023 Northern.tech AS
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
