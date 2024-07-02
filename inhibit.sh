#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Main script
# Copyright (c) 2024 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

# Before version 1.2.0, the configuration options were simple variables here.
# By now, there is a separate configuration file. See the file 'inhibit.conf'
# for preferences.

script_dir=$(dirname $(readlink -f $0))
script_file=$(basename "$0")
source ${script_dir}/core/common.sh
source ${script_dir}/core/dialogs.sh
source ${script_dir}/core/shell.sh
source ${script_dir}/core/systemctl.sh

config_file="$script_dir/inhibit.conf"
config_missing=0
if [ -f "$config_file" ]; then
    source $config_file
else
    config_missing=1
fi
apply_config

if [ -z "$1" ] || [ "$1" = "--help" ]; then
    usage
elif [ "$1" = "--version" ]; then
    print_version
else
    inhibit_command="$@"
fi

command -v $inhibit_command &>/dev/null
if [ $? -ne 0 ]; then
    usage "The given command does not exist"
fi

if [ $use_random -eq 1 ]; then
    random_string
    confirm_type="Sequence"
else
    confirm_string=$(hostname -s)
    confirm_type="Hostname"
fi

if [[ $inhibit_command == *inhibit.sh* ]]; then
    usage "Inhibiting the script itself does not make any sense"
fi

if [ $use_dialogs -eq 1 ]; then
    command -v dialog &>/dev/null
    if [ $? -ne 0 ]; then
        usage "The required tool 'dialog' does not seem to be installed"
    fi
fi

if [ $notify_wall -eq 1 ]; then
    message="The command '${inhibit_command}' has been"
    if [ "$(whoami)" = "root" ]; then
        executed_by="executed by root"
    else
        executed_by="executed by user '$(whoami)'"
    fi
    wall "Inhibit: ${message} ${executed_by} on '$(tty)'." &>/dev/null
fi

if [[ $inhibit_command == *systemctl* ]]; then
    inhibit_service_control
else
    if [ $use_dialogs -eq 1 ]; then
        inhibit_command_execution_dialog
    else
        inhibit_command_execution
    fi
fi

# EOF
