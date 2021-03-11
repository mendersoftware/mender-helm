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
helm install mender-mongo --set "auth.enabled=false,persistence.enabled=false" bitnami/mongodb
