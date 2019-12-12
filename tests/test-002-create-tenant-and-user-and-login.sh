#!/bin/bash

set -e

# create an ubuntu POD to run the tests
TEMPNAME=`basename $0`
TMPFILE=`mktemp` || exit 1
cat > $TMPFILE <<EOF
kind: Pod
apiVersion: v1
metadata:
  name: ubuntu
spec:
  containers:
    - name: ubuntu
    ***REMOVED*** ubuntu
      command: ["/bin/bash", "-ec", "sleep 3600"]
EOF
kubectl apply -f "$TMPFILE"

echo -n "> Waiting for the ubuntu POD to become ready"
n=0
while [ $n -lt 60 ]; do
    sleep 1
    NOT_READY=$(kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready | grep ubuntu | egrep -e 'false$' | wc -l)
    if [ $NOT_READY -eq 0 ]; then
        echo -e "\n> POD is ready:"
        kubectl get pods -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses[*].ready
        break
    fi
    echo -n "."
    n=$((n+1))
done

if [ $n -ge 60 ]; then
    echo -e "\n> POD is not ready, aborting"
    kubectl delete -f "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

# install curl
kubectl exec ubuntu -- apt update
kubectl exec ubuntu -- apt install curl -y

# create tenant and user
UUID=$(uuidgen)
TENANT_NAME="demo-$UUID"
ADMIN_USERNAME="admin-$UUID@mender.io"
ADMIN_PASSWORD="adminadmin"
USER_USERNAME="demo-$UUID@mender.io"
USER_PASSWORD="demodemo"

TENANTADM=$(kubectl get pods -o custom-columns=POD:metadata.name | grep tenantadm | head -n1)
USERADM=$(kubectl get pods -o custom-columns=POD:metadata.name | grep useradm | head -n1)


echo "> Creating a new tenant: $TENANT_NAME"
TENANT_ID=$(kubectl exec $TENANTADM -- tenantadm create-org --name $TENANT_NAME --username "$ADMIN_USERNAME" --password "$ADMIN_PASSWORD")

echo "> Creating a new user for the tenant: $USER_USERNAME / $USER_PASSWORD"
kubectl exec $USERADM -- useradm create-user --username "$USER_USERNAME" --password "$USER_PASSWORD" --tenant-id "$TENANT_ID"

# log in
echo "> Log in with credentials"
JWT=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v1/useradm/auth/login -u $USER_USERNAME:$USER_PASSWORD -X POST -H "Content-Type: application/json" -f)
if [ -z "$JWT" ]; then
    echo "> Login failed, aborting"
    kubectl delete -f "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi
echo "> JWT token: $JWT"

# verify the jwt token (TENANT_ID should be inside the decoded JSON)
if ! echo $JWT | cut -f2 -d. | base64 -Dd | grep -q $TENANT_ID; then
    echo "> JWT token is invalid"
    kubectl delete -f "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

# get the list of deployments
echo "> Get the list of deployments"
RESPONSE=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v1/deployments/deployments -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" -f)
echo "> Got: $RESPONSE"

if [ "$RESPONSE" != "[]" ]; then
    kubectl delete -f "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

# get the list of accepted devices
echo "> Get the list of accepted devices"
RESPONSE=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v2/devauth/devices/count?status=accepted -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" -f)
echo "> Got: $RESPONSE"

if [ "$RESPONSE" != '{"count":0}' ]; then
    kubectl delete -f "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

# clean up, remove the testing pod
kubectl delete -f "$TMPFILE"
rm "$TMPFILE"
