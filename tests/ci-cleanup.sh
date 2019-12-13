#!/bin/bash

. tests/functions.sh

log "cleaning up"
kind get clusters | while read; do 
 log " removing cluster \"$REPLY\""
 kind delete cluster --name="${REPLY}"
done

