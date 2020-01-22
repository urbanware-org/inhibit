#!/usr/bin/env bash

# ============================================================================
# Inhibit - Prevent accidental execution of certain commands
# Main script
# Copyright (C) 2019 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
# ============================================================================

# Before version 1.2.0, the configuration options were simple variables here.
# My now, there is a separate configuration file. See the file 'inhibit.conf'
# for preferences.

script_dir=$(dirname $(readlink -f $0))
script_file=$(basename "$0")
source ${script_dir}/core/common.sh
source ${script_dir}/core/systemctl.sh

config_file="$script_dir/inhibit.conf"
if [ -f "$config_file" ]; then
    source $config_file
fi
apply_config

if [ -z "$1" ] || [ "$1" = "--help" ]; then
    usage
elif [ "$1" = "--version" ]; then
    print_version
else
    inhibit_command="$@"
fi

if [ $use_random -eq 1 ]; then
    random_string
    confirm_type="Sequence"
else
    confirm_string=$(hostname -s)
    confirm_type="Hostname"
fi

if [[ $inhibit_command == *inhibit.sh* ]]; then
    usage "Inhibiting the script itself? This does not make any sense"
fi

if [[ $inhibit_command == *systemctl* ]]; then
    inhibit_service_control
else
    inhibit_command_execution
fi

# EOF
