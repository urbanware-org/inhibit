#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Common core script
# Copyright (c) 2024 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

version="1.4.1"

notify_wall_message() {
    status="$1"

    message="The command '${inhibit_command}' has been"
    if [ "$(whoami)" = "root" ]; then
        executed_by="${status} by root"
    else
        executed_by="$status by user '$(whoami)'"
    fi
    wall "Inhibit [$$]: ${message} ${executed_by} on '$(tty)'." &>/dev/null
}

apply_config() {
    if [ $config_missing -eq 1 ]; then
        # Defaults for the configuration options in case the config file is
        # missing. Do not change any of the values below.
        use_random=0
        random_count=8
        random_upper=0
        max_tries=1
        notify_wall=0
        services=""
        inhibit_given_services=1
        show_header=1
        header=""
        use_colors=1
        use_dialogs=0
        dialog_shadow=1
    else
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

        if [ ! "$notify_wall" = "1" ]; then
            notify_wall=0
        fi

        if [ ! "$show_header" = "1" ]; then
            show_header=0
        fi

        if [ ! -z "$header" ]; then
            header="$header"
        fi
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

    if [ ! "$use_dialogs" = "1" ]; then
        use_dialogs=0
    fi

    if [ "$dialog_shadow" = "1" ]; then
        dlg_shadow=""
    else
        dlg_shadow="--no-shadow"
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
    usage="${cc}usage:${cn} $script_file"
    echo -e "$usage [--version] \"COMMAND\""
    if [ ! -z "$error_msg" ]; then
        echo
        echo -e "${cr}error:${cn} $error_msg."
        exit 1
    else
        exit 0
    fi
}

# EOF
