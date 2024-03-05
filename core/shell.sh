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
    echo
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

# EOF
