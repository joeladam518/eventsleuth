#!/usr/bin/env bash

clear_caches() {
    # Clear composer caches
    composer dumpautoload

    echo

    # Clear the Laravel caches
    php artisan optimize:clear
}

cmsg() {
    # Output messages in color! :-)
    local CHOSEN_COLOR BOLD IS_BOLD NO_NEWLINE opt OPTIND RESET
    IS_BOLD="0"
    NO_NEWLINE="0"
    OPTIND=1
    BOLD=$(tput bold)
    RESET="$(tput sgr0)"
    while getopts ":ndrgbcmyaw" opt; do
        case "$opt" in
            n) NO_NEWLINE="1" ;; # no new line
            d) IS_BOLD="1" ;; # bold
            r) CHOSEN_COLOR="$(tput setaf 1)"   ;; # color red
            g) CHOSEN_COLOR="$(tput setaf 2)"   ;; # color green
            b) CHOSEN_COLOR="$(tput setaf 4)"   ;; # color blue
            c) CHOSEN_COLOR="$(tput setaf 6)"   ;; # color cyan
            m) CHOSEN_COLOR="$(tput setaf 5)"   ;; # color magenta
            y) CHOSEN_COLOR="$(tput setaf 3)"   ;; # color yellow
            a) CHOSEN_COLOR="$(tput setaf 245)" ;; # color gray
            w) CHOSEN_COLOR="$(tput setaf 7)"   ;; # color white
            \? ) echo "cmsg() invalid option: -${OPTARG}" 1>&2; return 1; ;;
        esac
    done
    shift $((OPTIND-1))

    local message="$*"
    local message_cmd="echo -e"

    # add -n flag if we want no new line
    if [ "$NO_NEWLINE" == "1" ]; then
        message_cmd="${message_cmd}n"
    fi

    # add color and bold
    if [ -n "$CHOSEN_COLOR" ] && [ "$IS_BOLD" == "1" ]; then
        message_cmd="${message_cmd} \"${BOLD}${CHOSEN_COLOR}${message}${RESET}\""
    elif [ -n "$CHOSEN_COLOR" ] && [ "$IS_BOLD" == "0" ]; then
        message_cmd="${message_cmd} \"${CHOSEN_COLOR}${message}${RESET}\""
    elif [ -z "$CHOSEN_COLOR" ] && [ "$IS_BOLD" == "1" ]; then
        message_cmd="${message_cmd} \"${BOLD}${message}${RESET}\""
    else
        message_cmd="${message_cmd} \"${message}\""
    fi

    # Finally, print the message with color!
    eval "$message_cmd"
    return 0
}
