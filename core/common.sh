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

apply_config() {
    if [ $config_missing -eq 1 ]; then
        # Defaults for the configuration options in case the config file is
        # missing. Do not change any of the values below.
        use_timer=0
        ignore_sigint=0
        notify_wall=0
        show_header=1
        header=""
        use_colors=1
        use_dialogs=0
        dialog_shadow=1
        timeout=10
        max_tries=1
        use_random=0
        random_count=8
        random_upper=0
        services=""
        inhibit_given_services=1
    else
        num_regex='^[0-9]+$'

        if [ "$use_timer" = "1" ]; then
            trap '' INT
        else
            use_timer=0
        fi

        if [ "$ignore_sigint" = "1" ]; then
            trap '' INT
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

        if [ ! "$use_colors" = "1" ]; then
            use_colors=0
        fi

        if [ ! "$use_dialogs" = "1" ]; then
            use_dialogs=0
        fi

        if [ ! "$dialog_shadow" = "1" ]; then
            dialog_shadow=0
        fi

        if [[ ! $timeout =~ $num_regex ]]; then
            timeout=10
        else
            if [ $timeout -lt 1 ]; then
                timeout=1
            elif [ $timeout -gt 120 ]; then
                timeout=120
            fi
        fi

        if [[ ! $max_tries =~ $num_regex ]]; then
            max_tries=10
        else
            if [ $max_tries -lt 1 ]; then
                max_tries=1
            elif [ $max_tries -gt 10 ]; then
                max_tries=10
            fi
        fi

        if [ ! "$use_random" = "1" ]; then
            use_random=0
        fi

        if [[ ! $random_count =~ $num_regex ]]; then
            random_count=8
        fi

        if [ ! "$random_upper" = "1" ]; then
            random_upper=0
        fi

        if [ ! "$inhibit_given_services" = "1" ]; then
            inhibit_given_services=0
        fi

    fi

    if [ $use_colors -eq 1 ]; then
        cn="\e[0m"      # none (default color)
        cc="\e[1;36m"   # cyan
        cg="\e[1;32m"   # green
        cr="\e[1;31m"   # red
        cy="\e[1;33m"   # yellow
    fi

    if [ $dialog_shadow -eq 1 ]; then
        dlg_shadow=""
    else
        dlg_shadow="--no-shadow"
    fi
}

inhibit_self() {
    echo -e "${cc}confused:${cn} Inhibiting the Inhibit script itself does" \
            "not make any sense."
    exit 1
}

notify_wall_message() {
    status="$1"

    message="The command '${inhibit_command}' has been"
    user_name=$(whoami)
    user_id=$(id -u $user_name)
    executed_by="${status} by $user_name ($user_id)"
    wall "Inhibit [$$]: ${message} ${executed_by} on '$(tty)'." &>/dev/null
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
