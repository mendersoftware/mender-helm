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

errors=0

bash tests/ci-test-setup.sh

for i in tests/test-*.sh; do
    echo "=== $i"
    EXIT_CODE=0
    echo "> running: $i"
    bash $i || EXIT_CODE=$?
    echo "> done  $i"
    if [ $EXIT_CODE -eq 0 ]; then
        echo "=== PASS!"
    else
        echo "=== FAILED!"
        errors=1
    fi
done

bash tests/ci-test-teardown.sh || true

if [ "$errors" -gt 0 ]; then
    exit 1
else
    exit 0
fi
