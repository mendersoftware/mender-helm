#!/bin/bash

set -e

echo -n "> Waiting for all the PODs to become ready"

n=0
while [ $n -lt 60 ]; do
    NOT_READY=$(kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready | grep -v elasticsearch-master-0 | egrep -e 'false$' | wc -l)
    if [ $NOT_READY -eq 0 ]; then
        echo -e "\n> PODs area ready:"
        kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready
        exit 0
    fi
    echo -n "."
    sleep 1
    n=$((n+1))
done

echo "PODs are not ready after $n seconds, giving up!"
exit 1
