#!/usr/bin/env bash

#
# Inhibit - Prevent accidental execution of certain commands
# Interactive dialog core script
# Copyright (c) 2024 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/inhibit
# GitLab: https://gitlab.com/urbanware-org/inhibit
#

inhibit_command_execution_dialog() {

    confirm_type_lc=$(tr '[:upper:]' '[:lower:]' <<< $confirm_type)

    dlg_head="                      \Z1■   W A R N I N G !   ■\Z0"
    dlg_text=$(echo "\n$dlg_head\n\nThe '\Z4$inhibit_command\Z0'" \
                    "command has been \Z1inhibited\Z0!\n\nIn order to" \
                    "proceed you have to confirm the process by entering" \
                    "the $confirm_type_lc below. \n\n\Z2→\Z0$confirm_string")

    dlg_failed=$(echo "\nConfirmation \Z1failed\Z0. Please retry.\n")
    dlg_canceled=$(echo "\nConfirmation \Z1failed\Z0. Process" \
                        "\Z1canceled\Z0.\n")

    success=0
    tries=$max_tries

    while [ $tries -gt 0 ]; do
        user_input=$(dialog --colors --title "Confirm execution" \
                            --ok-label "Confirm" --cancel-label "Cancel" \
                            --inputbox "$dlg_text" 18 74 --output-fd 1)

        if [ $? -eq 1 ]; then
            # Exit the program without any dialog feedback
            clear
            exit
        fi

        if [ "$user_input" = "$confirm_string" ]; then
            success=1
            break
        fi

        tries=$(( tries - 1 ))
        if [ $tries -gt 0 ]; then
            dialog --colors --title "Confirmation failure" \
                   --msgbox "$dlg_failed" 7 38
            continue
        else
            break
        fi
    done
    clear

     if [ $success -eq 1 ]; then
        # Execute the command without any dialog feedback
        $inhibit_command
    else
        dialog --colors --title "Confirmation failure" \
               --msgbox "$dlg_canceled" 7 42
        clear
    fi
}

# EOF
