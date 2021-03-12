#!/bin/bash

set -x

# Remove all installed helm charts
helm uninstall $(helm list -q)

# Delete other resources remaining in the namespace
kubectl delete deployments,statefulsets,pods,jobs,cronjobs --all
