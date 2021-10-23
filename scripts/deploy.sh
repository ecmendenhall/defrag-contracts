#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
DefragFactoryAddr=$(deploy DefragFactory)
log "DefragFactory deployed at:" $DefragFactoryAddr
