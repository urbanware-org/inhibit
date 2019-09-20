# *Inhibit*

**Table of contents**
*   [Definition](#definition)
*   [Details](#details)
*   [Usage](#usage)
*   [Preferences](#preferences)
*   [Contact](#contact)

----

## Definition

Script to prevent accidental execution of critical commands, e.g. to shutdown or reboot the system by prompting the user to enter its hostname.

[Top](#inhibit)

## Details

Even though, you should always be concentrated when working on the shell of a server and think before you type, careless mistakes can happen, especially under pressure of time. For example, accidently shutting down a virtualization server can (or will) lead to extensive consequences.

One solution is to create *Bash* aliases to prevent the execution of critical commands such as `shutdown`, `poweroff`, `halt` and `reboot`.

However, the problem with these aliases is that you may get used to typing them and also execute them on the wrong system.

So, to avoid this, the `inhibit.sh` script will prompt to enter the hostname of the system you are on in order to execute the given command to shutdown, reboot or whatever.

[Top](#inhibit)

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

Since version 1.0.5 you can also give command-line arguments for the inhibited command, for example:

```bash
alias poweroff='/opt/inhibit/inhibit.sh poweroff -f'
```

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

Now, if you really have to e.g. reboot the system, you will have to confirm the execution of the command or explicitly give the full path to the `reboot` command to do so.

[Top](#inhibit)

## Preferences

Inside the `inhibit.sh` you can find a few preferences that can be set:

*   `use_colors`<br>Enable colored output which highlights more or less significant terms.
    *   `0` = disabled
    *   `1` = enabled (default)<br><br>
*   `use_random`<br>Use a random string to confirm instead of the hostname of the system. By default, it only contains lowercase letters and numbers.
    *   `0` = disabled (default)
    *   `1` = enabled<br><br>
*   `random_count`<br>Number of random characters (if `use_random` is enabled).
    *   `4` = minimum
    *   `8` = default
    *   `32` = maximum<br><br>
*   `random_upper`<br>Additionally use uppercase letters in the random string  (if `use_random` is enabled).
    *   `0` = disabled (default)
    *   `1` = enabled

[Top](#inhibit)

## Contact

Any suggestions, questions, bugs to report or feedback to give?

You can contact me by sending an email to <dev@urbanware.org>.

[Top](#inhibit)
