#!/usr/bin/env bash

set -Eeo pipefail

########################################################################################################################
# Update dependencies, run migrations, and run anything else to keep your project up-to-date
########################################################################################################################

# Setup
SCRIPTS_DIR="$(cd "$(dirname "$0")" > /dev/null 2>&1 && pwd -P)"
SITE_DIR="$(dirname "$SCRIPTS_DIR")"
. "${SCRIPTS_DIR}/functions.sh"

# Flags
build_assets=0
clear_caches=0
fresh_and_seed=0

# Functions
usage() {
    cat << EOF
Usage: $(basename "${0}") [-h] [-a] [-c] [-f]

Run everything needed to keep you project up-to-date.

Options:
-h, --help            Print this help and exit
-a, --build-assets    Build assets
-c, --clear-caches    Clear all caches
-f, --fresh           Migrate fresh and seed
EOF
    return 0
}

invalid_argument() {
    echo "Invalid option: -${1} requires an argument" 1>&2
    exit 1
}

invalid_option() {
    echo "Invalid option: -${1}" 1>&2
    exit 1
}

parse_long_options() {
    case "$1" in
        help) usage; exit ;;
        build-assets) build_assets=1 ;;
        clear-caches) clear_caches=1 ;;
        fresh) fresh_and_seed=1 ;;
        *) invalid_option "-${OPTARG}" ;;
    esac

    return 0
}

parse_options() {
    while getopts ":hacf-:" opt; do
        case "$opt" in
            h) usage; exit ;;
            a) build_assets=1 ;;
            c) clear_caches=1 ;;
            f) fresh_and_seed=1 ;;
            :) invalid_argument "$OPTARG" ;;
            -) parse_long_options "$OPTARG" ;;
            \?) invalid_option "$OPTARG" ;;
        esac
    done

    shift $((OPTIND-1))

    return 0
}

# Start Script
########################################################################################################################
parse_options "$@"

echo
cmsg -m "Updating joelhaker.com"
#----------------------------------------------
cd "$SITE_DIR" || exit 1

echo
cmsg -c "Update PHP dependencies"
#----------------------------------------------
composer install
#----------------------------------------------
cmsg -c "Done"
echo

echo
cmsg -c "Update JavaScript dependencies"
#----------------------------------------------
yarn install
#----------------------------------------------
cmsg -c "Done"
echo

if [ "$clear_caches" == "1" ]; then
    echo
    cmsg -c "Clear all caches"
    #----------------------------------------------
    clear_caches
    #----------------------------------------------
    cmsg -c "Done"
    echo
fi

echo
cmsg -c "Run migrations"
#----------------------------------------------
if [ "$fresh_and_seed" == "1" ]; then
    php artisan migrate:fresh --seed --drop-views -v
else
    php artisan migrate -v
fi
#----------------------------------------------
cmsg -c "Done"
echo

if [ "$build_assets" == "1" ]; then
    echo
    #----------------------------------------------
    yarn run build --mode development
    #----------------------------------------------
    echo
fi

#----------------------------------------------
cmsg -m "Done!"
echo
