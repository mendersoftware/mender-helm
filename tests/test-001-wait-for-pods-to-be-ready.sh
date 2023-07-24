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

set -e

echo -n "> Waiting for all the PODs to become ready"

n=0
max_wait=512
while [ $n -lt $max_wait ]; do
    NOT_READY=$(kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready | grep -v 'mender-deployments-storage-daemon' | egrep -e 'false$' -e '<none>$' | wc -l)
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
