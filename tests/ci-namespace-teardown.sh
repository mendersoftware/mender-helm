#!/bin/bash

. tests/variables.sh

set -e

kubectl delete namespace ${TEST_NAMESPACE}
echo "> Deleted namespace ${TEST_NAMESPACE}"

exit 0
