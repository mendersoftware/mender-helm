#!/bin/bash

set -e

echo -n "> Waiting for all the PODs to become ready"

n=0
max_wait=512
while [ $n -lt $max_wait ]; do
    NOT_READY=$(kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready | egrep -e 'false$' -e '<none>$' | wc -l)
    if [ $NOT_READY -eq 0 ]; then
        echo -e "\n> PODs are ready:"
        kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready
        exit 0
    fi
    echo -n "."
    sleep 1
    n=$((n+1))
done

echo "PODs are not ready after $n seconds, giving up!"
kubectl get pods --all-namespaces
exit 1
