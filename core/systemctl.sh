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
    if [[ $inhibit_command =~ "status $service" ]]; then
        # Checking the status of the service is harmless, so there is no need
        # to inhibit that. Thus, the command will be executed.
        $inhibit_command
        exit
    fi

    for service in $services; do
        if [[ $inhibit_command =~ "$service" ]]; then
            inhibit_command_execution
            break
        fi
    done
}

# EOF
