#!/bin/bash

# ============================================================================
# Inhibit - Prevent accidental execution of certain commands
# Copyright (C) 2018 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# ============================================================================

version="1.0.1"

# Set either to '1' to enable or to '0' to disable colored output
use_colors=1

command=$1
if [ -z "$command" ]; then
    echo "usage: inhibit.sh COMMAND"
    exit 0
fi

if [ $use_colors -eq 1 ]; then
    cn="\e[0m"      # none
    cc="\e[1;36m"   # cyan
    cg="\e[1;32m"   # green
    cr="\e[1;31m"   # red
    cy="\e[1;33m"   # yellow
else
    qt="'"
fi

hostname=$(hostname -s)
echo
echo -e "${cy}Warning!$cn The ${qt}${cc}$command${cn}${qt} command has been"\
        "${cr}inhibited${cn}!"
echo
echo "In order to proceed with the process you have to enter the hostname of"\
     "the"
echo "system to confirm."
echo
echo -e "${cc}Hostname:${cn} $hostname"
echo -e "${cc}Confirm:${cn}  \c"
read confirm
echo
if [ "$confirm" = "$hostname" ]; then
    echo -e "${cg}Proceeding.${cn}\n"
    $command
else
    echo -e "${cr}Canceled${cn}. Hostname and confirmation string do not"\
            "match.\n"
fi

# EOF
