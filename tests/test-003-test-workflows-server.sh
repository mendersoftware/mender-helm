#!/bin/bash

set -e

echo "> Verify the workflows-server status end-point"
RESPONSE=$(kubectl exec ubuntu -- curl -s http://mender-workflows-server:8080/status -f)
echo "> $RESPONSE"

if [ "$RESPONSE" != '{"status":"ok"}' ]; then
    echo "> Workflows server unhealthy, aborting"
    exit 1
fi
