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

echo -n "> Waiting for the Ingress Load Balancer to become ready"
n=0
max_wait=512
while [ $n -lt $max_wait ]; do
    sleep 1
    LB_HOSTNAME=$(kubectl get ing mender-ingress --no-headers -o custom-columns=HOST:".status.loadBalancer.ingress[0].hostname")
    if [ -n "${LB_HOSTNAME}" ] ; then
        echo -e "\n> LB is ready: ${LB_HOSTNAME}"
        break
    fi
    echo -n "."
    n=$((n+1))
done

if [ $n -ge $max_wait ]; then
    echo -e "\n> Ingress is not ready, aborting"
    kubectl get ing
    exit 1
fi

echo -n "> Waiting for the Load Balancer IP to become ready"
n=0
max_wait=512
while [ $n -lt $max_wait ]; do
    sleep 1
    LB_IP=$(dig +short ${LB_HOSTNAME} @1.1.1.1 | head -n1)
    if [ -n "${LB_IP}" ] ; then
        echo -e "\n> LB IP is ready: ${LB_IP}"
        break
    fi
    echo -n "."
    n=$((n+1))
done

if [ $n -ge $max_wait ]; then
    echo -e "\n> IP is not ready, aborting"
    dig +short ${LB_HOSTNAME} @1.1.1.1 
    exit 1
fi

# The actual test:
# getting Mender login page by
# intercepting the <title>Mender</title>
curl -L https://mender-helmci-tests.staging.hosted.mender.io --resolve "mender-helmci-tests.staging.hosted.mender.io:443:${LB_IP}" | grep Mender

if [[ $? -ne 0 ]]; then
  echo "ERROR - ingress is not working, please check"
  kubectl get ing
  echo "DEBUG - LB IP: ${LB_IP}"
  exit 1
else
  echo "INFO - ingress is working fine"
fi
