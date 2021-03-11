#!/bin/bash

set -e

helm uninstall $(helm list -q)
