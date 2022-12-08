#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Service control core module
# Copyright (c) 2022 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

inhibit_service_control() {
    if [ -z "$services" ] ||
       [[ $inhibit_command =~ "systemctl status $service" ]]; then
        # Checking the status of the service is harmless, so there is no need
        # to inhibit that. Thus, the command will be executed.
        $inhibit_command
        exit
    fi

    if [ $inhibit_given_services -eq 1 ]; then
        for service in $services; do
            if [[ $inhibit_command =~ "$service" ]]; then
                inhibit_command_execution
                break
            fi
        done
    else
        match=0
        for service in $services; do
            if [[ $inhibit_command =~ "$service" ]]; then
                match=1
                break
            fi
        done
        if [ $match -eq 0 ]; then
            inhibit_command_execution
            break
        fi
    fi
}

# EOF
