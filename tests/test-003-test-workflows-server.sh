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

echo "> Verify the workflows-server status end-point"
RESPONSE=$(kubectl exec ubuntu -- curl -s http://mender-workflows-server:8080/status -f)
echo "> $RESPONSE"

if [ "$RESPONSE" != '{"status":"ok"}' ]; then
    echo "> Workflows server unhealthy, aborting"
    exit 1
fi
