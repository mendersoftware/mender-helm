#!/bin/bash

. tests/variables.sh
. tests/functions.sh

set -e

# create k8s cluster for testing
log "creating $K8S_CLUSTER_NAME k8s cluster"
kind create cluster --name="${K8S_CLUSTER_NAME}" --image kindest/node:${K8S_VERSION}
echo
status="starting"
max_wait=128
while [ $max_wait -gt 0 ]; do
 status=`kubectl get nodes | tail -n+2 | awk '{print($2);}'`
 [ "$status" == "Ready" ] && break
 sleep 1
 echo -ne "\r`date` waiting for node to be ready."
 let max_wait--
done
[ "$status" == "Ready" ] || { log "failed to start k8s cluster."; exit 2; }
log "started k8s cluster"

