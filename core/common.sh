#!/usr/bin/env bash

# ============================================================================
# Inhibit - Prevent accidental execution of certain commands
# Common core script
# Copyright (C) 2019 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
# ============================================================================

version="1.2.0"

# Defaults for the configuration options in case the config file is missing.
# Do not change any of the values below.
use_colors=1
use_random=0
random_count=8
random_upper=0
services=""
inhibit_given_services=1

header_default="
####  ##    ##  ##    ##  ####  #######   ####  ########  ########  #######
 ##   ###   ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ####  ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ## ## ##  ########   ##   #######    ##      ##     ######    ##    ##
 ##   ##  ####  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ##   ###  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
####  ##    ##  ##    ##  ####  #######   ####     ##     ########  #######"

apply_config() {
    if [ ! "$use_random" = "1" ]; then
        use_random=0
    fi

    regex='^[0-9]+$'
    if [[ ! $random_count =~ $regex ]]; then
        random_count=8
    fi

    if [ ! "$random_upper" = "1" ]; then
        random_upper=0
    fi

    if [ ! "$max_tries" = "1" ]; then
        max_tries="$max_tries"
        if [ $max_tries -lt 1 ]; then
            max_tries=1
        elif [ $max_tries -gt 10 ]; then
            max_tries=10
        fi
    fi

    if [ ! "$inhibit_given_services" = "1" ]; then
        inhibit_given_services=0
    fi

    if [ ! "$show_header" = "1" ]; then
        show_header=0
    fi

    if [ ! -z "$header" ]; then
        header="$header"
    fi

    if [ "$use_colors" = "1" ]; then
        cn="\e[0m"      # none (default color)
        cc="\e[1;36m"   # cyan
        cg="\e[1;32m"   # green
        cr="\e[1;31m"   # red
        cy="\e[1;33m"   # yellow
    else
        use_colors=0
    fi
}

confirm_string() {
    echo
    echo -e "${cc}$confirm_type:${cn} $confirm_string"
    echo -e "${cc}Confirm:${cn}  \c"
    read user_input
    echo
    if [ "$confirm_string" = "$user_input" ]; then
        success=1
    fi
}

inhibit_command_execution() {
    if [ $show_header -eq 1 ]; then
        if [ -z "$header" ]; then
            echo -e "$header_default"
        else
            echo -e "$header"
        fi
    fi
    echo
    echo -e "${cy}Warning!$cn The '${cc}$inhibit_command${cn}'"\
            "command has been ${cr}inhibited${cn}!"
    echo
    echo "In order to proceed you have to confirm the process."

    success=0
    tries=$max_tries
    while [ $tries -gt 0 ]; do
        confirm_string
        if [ $success -eq 1 ]; then
            break
        else
            tries=$(( tries - 1 ))
            if [ $tries -gt 0 ]; then
                echo -e "Confirmation ${cr}failed${cn}. Please retry."
            fi
        fi
    done

    if [ $success -eq 1 ]; then
        echo -e "Confirmation ${cg}successful${cn}. Proceeding.\n"
        $inhibit_command  # execute inhibited command
    else
        echo -e "Confirmation ${cr}failed${cn}. Process ${cr}canceled${cn}.\n"
    fi
}

print_version() {
    echo "$version"
    exit
}

random_string() {
    if [ $random_count -gt 32 ]; then
        random_count=32
    elif [ $random_count -lt 4 ]; then
        random_count=4
    fi
    if [ $random_upper -eq 1 ]; then
        confirm_string=$(uuidgen | md5sum | base64 | head -c$random_count)
    else
        confirm_string=$(uuidgen | md5sum | head -c$random_count)
    fi
}

usage() {
    error_msg="$1"
    usage="usage: $script_file"
    echo -e "$usage \"COMMAND\" [--version]"
    if [ ! -z "$error_msg" ]; then
        echo
        echo -e "${cr}error:${cn} $error_msg."
        exit 1
    else
        exit 0
    fi
}

# EOF
