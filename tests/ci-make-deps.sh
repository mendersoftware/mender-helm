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

local_seaweedfs_only=${1:-"false"}

log "deploying dependencies: seaweedfs"
helm install seaweedfs --wait -f tests/seaweedfs.yaml seaweedfs/seaweedfs

if [[ "$local_seaweedfs_only" == "true" ]]; then
  log "not deploying mongodb"
else
  log "deploying dependencies: mongodb"
  helm install mender-mongo bitnami/mongodb \
      --version 12.1.31 \
      --set "image.tag=6.0.13-debian-11-r21" \
      --set "auth.enabled=false" \
      --set "persistence.enabled=false" \
      -f ./tests/affinity-x86_64-standard.yaml
fi

if [[ "$local_seaweedfs_only" == "true" ]]; then
  log "not deploying nats"
else
log "deploying dependencies: nats"
helm install nats nats/nats \
    --version 0.8.2 \
    --set "nats.image=nats:2.9.25-scratch" \
    --set "nats.jetstream.enabled=true" \
    -f ./tests/affinity-x86_64-standard.yaml
fi
