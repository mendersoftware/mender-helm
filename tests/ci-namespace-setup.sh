#!/bin/bash

. tests/variables.sh

set -e

# create an unique namespace where to install the chart and run the tests
TMPFILE=`mktemp` || exit 1
cat > $TMPFILE <<EOF
kind: Namespace
apiVersion: v1
metadata:
  name: ${TEST_NAMESPACE}
  labels:
    name: ${TEST_NAMESPACE}
EOF
kubectl apply -f "$TMPFILE"
rm $TMPFILE

kubens ${TEST_NAMESPACE}
echo "> Switched to namespace ${TEST_NAMESPACE}"

exit 0
