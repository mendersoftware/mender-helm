#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

log "deploying dependencies: minio"
helm install mender-minio minio/minio \
    --version 6.0.5 \
    --set resources.requests.memory=100Mi \
    --set accessKey=${MINIO_accessKey},secretKey=${MINIO_secretKey},persistence.enabled=false

log "deploying dependencies: mongodb"
helm install mender-mongo bitnami/mongodb \
    --version 10.21.1 \
    --set "auth.enabled=false,persistence.enabled=false"

log "deploying dependencies: nats"
helm install nats nats/nats \
    --version 0.8.2
