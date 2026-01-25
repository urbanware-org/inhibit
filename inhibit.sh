#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Main script
# Copyright (c) 2026 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

# Before version 1.2.0, the configuration options were simple variables here.
# Meanwhile, there is the separate configuration file 'inhibit.conf' which
# contains all options.

script_dir=$(dirname $(readlink -f $0))
script_file=$(basename "$0")

if [[ "$script_dir" = *[[:space:]]* ]]; then
    echo -e \
        "\e[91merror:\e[0m" \
        "Inhibit cannot be run from a path that contains spaces."
    exit 10
fi

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

# Handle certain terminal control characters
trap '' QUIT              # ignore the exit signal via Ctrl+\
trap '' TSTP              # ignore the suspend signal via Ctrl+Z
trap signal_exit HUP      # exit on terminal close or SSH drop
trap signal_exit TERM     # exit on graceful termination

# Handle Ctrl+C differently (which depends on the config file option)
if [ $ignore_sigint -eq 1 ]; then
    trap '' INT           # ignore interrupt signal
else
    trap signal_exit INT  # exit as usual
fi

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
    inhibit_self
fi

if [ $use_dialogs -eq 1 ]; then
    command -v dialog &>/dev/null
    if [ $? -ne 0 ]; then
        usage "The required tool 'dialog' does not seem to be installed"
    fi
fi

if [ $notify_wall -eq 1 ]; then
    notify_wall_message "executed"
fi

if [[ $inhibit_command == *systemctl* ]]; then
    inhibit_service_control
else
    if [ $use_timer -eq 1 ]; then
        use_dialogs=0
    fi
    if [ $use_dialogs -eq 1 ]; then
        inhibit_command_execution_dialog
    else
        inhibit_command_execution
    fi
fi

# EOF
