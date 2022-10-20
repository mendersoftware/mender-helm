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

set -e

# create an ubuntu POD to run the tests
TMPFILE=`mktemp` || exit 1
cat > $TMPFILE <<EOF
kind: Pod
apiVersion: v1
metadata:
  name: ubuntu
spec:
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["/bin/bash", "-ec", "sleep 3600"]
EOF
kubectl apply -f "$TMPFILE"
rm $TMPFILE

echo -n "> Waiting for the ubuntu POD to become ready"
n=0
max_wait=512
while [ $n -lt $max_wait ]; do
    sleep 1
    NOT_READY=$(kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready | grep ubuntu | egrep -e 'false$' -e '<none>$' | wc -l)
    if [ $NOT_READY -eq 0 ]; then
        echo -e "\n> POD is ready:"
        kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready
        break
    fi
    echo -n "."
    n=$((n+1))
done

if [ $n -ge $max_wait ]; then
    echo -e "\n> POD is not ready, aborting"
    kubectl delete pod ubuntu
    rm "$TMPFILE"
    exit 1
fi

# install curl
kubectl exec ubuntu -- apt update
kubectl exec ubuntu -- apt install curl -y
