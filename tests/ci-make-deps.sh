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

log "deploying dependencies: minio"
helm install mender-minio minio/minio \
    --version 8.0.10 \
    --set "image.tag=RELEASE.2021-02-14T04-01-33Z" \
    --set resources.requests.memory=100Mi \
    --set accessKey=${MINIO_accessKey},secretKey=${MINIO_secretKey},persistence.enabled=false

log "deploying dependencies: mongodb"
helm install mender-mongo bitnami/mongodb \
    --version 11.2.0 \
    --set "image.tag=4.4.13-debian-10-r63" \
    --set "auth.enabled=false" \
    --set "persistence.enabled=false"

log "deploying dependencies: nats"
helm install nats nats/nats \
    --version 0.8.2 \
    --set "nats.image=nats:2.6.5-alpine" \
    --set "nats.jetstream.enabled=true"

export OPENSEARCH_CONFIG=$(cat <<EOF
cluster.name: opensearch-cluster
network.host: 0.0.0.0
plugins.security.disabled: true
EOF
)

log "deploying dependencies: opensearch"
helm install opensearch opensearch/opensearch \
    --version 2.9.0 \
    --set "persistence.enabled=false" \
    --set "config.opensearch\\.yml=$OPENSEARCH_CONFIG"
