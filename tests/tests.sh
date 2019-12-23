#!/bin/bash

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
