#!/bin/bash

# ============================================================================
# Inhibit - Prevent accidental execution of certain commands
# Service control core module
# Copyright (C) 2019 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
# ============================================================================

function inhibit_service_control() {
    if [[ $inhibit_command =~ "systemctl status $service" ]]; then
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
        for service in $services; do
            if [[ ! $inhibit_command =~ "$service" ]]; then
                inhibit_command_execution
                break
            fi
        done
    fi
}

# EOF
