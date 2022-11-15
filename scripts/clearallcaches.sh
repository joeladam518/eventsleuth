#!/usr/bin/env bash

set -Eeo pipefail

########################################################################################################################
# Nuke the development environment cache
########################################################################################################################

# Setup
SCRIPTS_DIR="$(cd "$(dirname "$0")" > /dev/null 2>&1 && pwd -P)"
SITE_DIR="$(dirname "$SCRIPTS_DIR")"
. "${SCRIPTS_DIR}/functions.sh"

cmsg ""
cmsg -c "Clearing All Caches"
#----------------------------------------------
cd "$SITE_DIR" || exit 1
clear_caches
#----------------------------------------------
cmsg -c "Done!"
cmsg ""
