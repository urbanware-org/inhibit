#!/bin/bash

# ============================================================================
# Inhibit - Prevent accidental execution of certain commands
# Copyright (C) 2019 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
# ============================================================================

version="1.1.0"

script_dir=$(dirname $(readlink -f $0))
config_file="$dirname/inhibit.conf"

# Do not change any of the values below! See the 'inhibit.conf' file for
# configuration options.
use_colors=1
use_random=0
random_count=8
random_upper=0

if [ -f "$config_file" ]; then
    source $config_file
fi

command=$1
if [ -z "$command" ]; then
    echo "usage: inhibit.sh COMMAND"
    exit 0
fi

if [ $use_colors -eq 1 ]; then
    cn="\e[0m"      # none (default color)
    cc="\e[1;36m"   # cyan
    cg="\e[1;32m"   # green
    cr="\e[1;31m"   # red
    cy="\e[1;33m"   # yellow
else
    qt="'"
fi

if [ $use_random -eq 1 ]; then
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
    confirm_type="Sequence"
else
    confirm_string=$(hostname -s)
    confirm_type="Hostname"
fi

echo
echo -e "${cy}Warning!$cn The ${qt}${cc}$command${cn}${qt} command has been"\
        "${cr}inhibited${cn}!"
echo
echo "In order to proceed you have to confirm the process."
echo
echo -e "${cc}$confirm_type:${cn} $confirm_string"
echo -e "${cc}Confirm:${cn}  \c"
read user_input
echo
if [ "$confirm_string" = "$user_input" ]; then
    echo -e "Confirmation ${cg}successful${cn}. Proceeding."
    $@
else
    echo -e "Confirmation ${cr}failed${cn}. Process canceled.\n"
fi

# EOF
