#!/bin/bash

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
    --version 10.21.1 \
    --set "image.tag=4.4.6-debian-10-r29" \
    --set "auth.enabled=false" \
    --set "persistence.enabled=false"

log "deploying dependencies: nats"
helm install nats nats/nats \
    --version 0.8.2 \
    --set "nats.image=nats:2.6.5-alpine" \
    --set "nats.jetstream.enabled=true"
