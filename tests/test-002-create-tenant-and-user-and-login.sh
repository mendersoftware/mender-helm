#!/bin/bash

set -e

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
TENANT_ID=$(kubectl exec $TENANTADM -- tenantadm create-org --name $TENANT_NAME --username "$ADMIN_USERNAME" --password "$ADMIN_PASSWORD" --plan "enterprise")

echo "> Creating a new user for the tenant: $USER_USERNAME / $USER_PASSWORD"
kubectl exec $USERADM -- useradm create-user --username "$USER_USERNAME" --password "$USER_PASSWORD" --tenant-id "$TENANT_ID" --roles "RBAC_ROLE_PERMIT_ALL"

# sleep one second, to let the workflow execute
sleep 1

# log in
echo "> Log in with credentials"
JWT=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v1/useradm/auth/login -u $USER_USERNAME:$USER_PASSWORD -X POST -H "Content-Type: application/json" -f)
if [ -z "$JWT" ]; then
    echo "> Login failed, aborting"
    exit 1
fi
echo "> JWT token: $JWT"

# verify the jwt token (TENANT_ID should be inside the decoded JSON)
if ! echo $JWT | cut -f2 -d. | base64 --decode 2>/dev/null | grep -qF '"mender.tenant":"'${TENANT_ID}'"'; then
    echo "> JWT token is invalid"
    exit 1
fi

# get the list of deployments
echo "> Get the list of deployments"
RESPONSE=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v1/deployments/deployments -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" -f)
echo "> Got: $RESPONSE"

if [ "$RESPONSE" != "[]" ]; then
    exit 1
fi

# get the list of accepted devices
echo "> Get the list of accepted devices"
RESPONSE=$(kubectl exec ubuntu -- curl -s -k https://mender-api-gateway/api/management/v2/devauth/devices/count?status=accepted -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" -f)
echo "> Got: $RESPONSE"

if [ "$RESPONSE" != '{"count":0}' ]; then
    exit 1
fi
