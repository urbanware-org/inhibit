#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Shell core script
# Copyright (c) 2024 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

header_default="
####  ##    ##  ##    ##  ####  #######   ####  ########  ########  #######
 ##   ###   ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ####  ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ## ## ##  ########   ##   #######    ##      ##     ######    ##    ##
 ##   ##  ####  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ##   ###  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
####  ##    ##  ##    ##  ####  #######   ####     ##     ########  #######"

confirm_string() {
    echo -e "${cc}${confirm_type}:${cn} ${confirm_string}"
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
            echo -e "${header_default}\e[0m"
        else
            echo -e "${header}\e[0m"
        fi
    fi
    echo
    echo -e "${cy}Warning!$cn The '${cc}${inhibit_command}${cn}'"\
            "command has been ${cr}inhibited${cn}!"
    echo
    echo "In order to proceed you have to confirm the process."
    echo
    local_ip="$(xargs <<< $(hostname -I))"
    if [[ "$local_ip" == *" "* ]]; then
        echo -e "${cc}Local IP addresses:${cn} $local_ip"
    else
        echo -e "${cc}Local IP address:${cn} $local_ip"
    fi
    if [ ! "$confirm_type" = "Hostname" ]; then
        echo -e "${cc}Hostname:${cn} $(hostname -s)"
    fi

    success=0
    tries=$max_tries
    while [ $tries -gt 0 ]; do
        echo
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
        if [ $notify_wall -eq 1 ]; then
            notify_wall_message confirmed
        fi
        $inhibit_command  # execute inhibited command
    else
        echo -e "Confirmation ${cr}failed${cn}. Process ${cr}canceled${cn}.\n"
        if [ $notify_wall -eq 1 ]; then
            notify_wall_message canceled
        fi
    fi
}

# EOF
