#!/bin/bash

. tests/functions.sh

log "starting dockerd"
# start dockerd
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &> /var/log/docker.log 2>&1 < /dev/null &
# wait for dockerd to be up and running
rc=1
max_wait=128
while [ $max_wait -gt 0 ]; do
 sleep 1
 docker ps >/dev/null 2>&1 && { rc=0; break; }
 let max_wait--
done;
[ $rc -ne 0 ] && { log "failed to start dockerd."; exit 1; }
log "started dockerd."

