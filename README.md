# Inhibit

**Table of contents**
*   [Definition](#definition)
*   [Details](#details)
*   [Usage](#usage)

----

## Definition

Script to prevent accidental execution of critical commands, e. g. to shutdown or reboot the system.

[Top](#inhibit-)

## Details

Even though, you should always be concentrated when working on the shell of a server and think before yout type, careless mistakes can happen, especially under pressure of time. For example, accidently shutting down a virtualization server can (or will) lead to extensive consequences.

One solution is to create *Bash* aliases to prevent the execution of critical commands such as `shutdown`, `poweroff`, `halt` and `reboot`.

However, the problem with these aliases is that you may get used to typing them and also execute them on the wrong system.

So, to avoid this, the `inhibit.sh` script will prompt to confirm the hostname of the system you are on in order to execute the given command to shutdown, reboot or whatever.

[Top](#inhibit-)

## Usage

### Shell script

Now, to prevent the accidental execution of the `shutdown`, `poweroff`, `halt` and `reboot`, add the following lines either to `/etc/bashrc` (system wide) or `~/.bashrc` (current user, only).

In the following example `inhibit.sh` is located in `/opt/inhibit`.

```bash
# Prevent certain commands to shutdown the system in any way
alias halt='/opt/inhibit/inhibit.sh halt'
alias poweroff='/opt/inhibit/inhibit.sh poweroff'
alias reboot='/opt/inhibit/inhibit.sh reboot'
alias shutdown='/opt/inhibit/inhibit.sh shutdown'
```

By default the output of the script is colored. If you do not want that, you can disable it by simply setting the `use_colors` variable inside the script to `0`.

Then you can [apply the changes](#apply-changes).

### System commands

In case you do not want to use `inhibit.sh` for some reason, you can also use the following *Bash* aliases, but as already mentioned above, using them may lead to getting used to typing them.

If you want colored output you may use the following aliases

```bash
# Prevent certain commands to shutdown the system in any way
alias halt='echo -e "\n\e[1;31mSystem halt inhibited! \n\e[1;33mExplicitly run \e[1;36m/sbin/halt\e[1;33m to proceed anyway.\e[0m\n"'
alias poweroff='echo -e "\n\e[1;31mShutdown inhibited! \n\e[1;33mExplicitly run \e[1;36m/sbin/poweroff\e[1;33m to proceed anyway.\e[0m\n"'
alias reboot='echo -e "\n\e[1;31mReboot inhibited! \n\e[1;33mExplicitly run \e[1;36m/sbin/reboot\e[1;33m to proceed anyway.\e[0m\n"'
alias shutdown='echo -e "\n\e[1;31mShutdown inhibited! \n\e[1;33mExplicitly run \e[1;36m/sbin/shutdown\e[1;33m to proceed anyway.\e[0m\n"'
```

otherwise these:

```bash
# Prevent certain commands to shutdown the system in any way
alias halt='echo -e "\nSystem halt inhibited! \nExplicitly run /sbin/halt to proceed anyway.\n"'
alias poweroff='echo -e "\nShutdown inhibited! \nExplicitly run /sbin/poweroff to proceed anyway.\n"'
alias reboot='echo -e "\nReboot inhibited! \nExplicitly run /sbin/reboot to proceed anyway.\n"'
alias shutdown='echo -e "\nShutdown inhibited! \nExplicitly run /sbin/shutdown to proceed anyway.\n"'
```

### Apply changes

After adding the preferred aliases, you can apply the changes either by logging out and in again or by reloading the `.bashrc` file of the current user.

```bash
$ source ~/.bashrc
```

Now, if you really have to e. g. reboot the system, you will have to confirm the command or give the full path to the `reboot` command to do so.

[Top](#inhibit-)
