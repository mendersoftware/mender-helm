#!/bin/bash

set -e

errors=0

for i in tests/test-*.sh; do
    echo "=== $i"
    EXIT_CODE=0
    bash $i || EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo "=== PASS!"
    else
        echo "=== FAILED!"
        errors=1
    fi
done

if [ "$errors" -gt 0 ]; then
    exit 1
else
    exit 0
fi
