# *Inhibit* <img src="inhibit.png" alt="Inhibit logo" height="128px" width="128px" align="right"/>

**Table of contents**
*   [Definition](#definition)
*   [Details](#details)
*   [Usage](#usage)
*   [Contact](#contact)

----

## Definition

Script to prevent accidental execution of critical commands, e.g. to shutdown or reboot the system by prompting the user to enter its hostname.

[Top](#inhibit-)

## Details

Even though, you should always be concentrated when working on the shell of a server and think before you type, careless mistakes can happen, especially under pressure of time. For example, accidently shutting down a virtualization server can (or will) lead to extensive consequences.

### Shell commands

One solution is to create *Bash* aliases to prevent the execution of critical commands such as `shutdown`, `poweroff`, `halt` and `reboot`.

However, the problem with these aliases is that you may get used to typing them and also execute them on the wrong system.

So, to avoid this, *Inhibit* will prompt to enter the hostname of the system you are on in order to execute the given command to shutdown, reboot or whatever.

### Services

This also applies to services controlled by `systemctl`. You can use *Inhibit* to force the confirmation for starting, stopping, restarting and reloading services.

However, checking the status of a service (using `systemctl status`) does not require any confirmation as this is harmless.

[Top](#inhibit-)

## Usage

### Preventing shell commands

Now, to e.g. prevent the accidental execution of the `shutdown`, `poweroff`, `halt` and `reboot` commands, add the following lines either to `/etc/bashrc` (system wide) or `~/.bashrc` (for the current user, only).

In the following examples `inhibit.sh` is located in `/opt/inhibit`.

```bash
# Prevent certain commands to shutdown the system in any way
alias halt='/opt/inhibit/inhibit.sh halt'
alias poweroff='/opt/inhibit/inhibit.sh poweroff'
alias reboot='/opt/inhibit/inhibit.sh reboot'
alias shutdown='/opt/inhibit/inhibit.sh shutdown'
```

You can also give command-line arguments for the inhibited command, for example:

```bash
alias poweroff='/opt/inhibit/inhibit.sh poweroff -f'
```

### Preventing `systemctl` related commands

As already mentioned above, you can also inhibit commands for services controlled by `systemctl`.

```bash
alias systemctl='/opt/inhibit/inhibit.sh systemctl'
```

Notice that this alias will have no effect unless you explicitly add the name of the service (or services) which should be confirmed to the service list inside `inhibit.conf`. Details can be found inside that file.

After adding the preferred aliases, you can apply the changes either by logging out and in again or by reloading the `.bashrc` file of the current user (depending on in which file you have added the aliases).

```bash
$ source ~/.bashrc
```

### Example

For example, if you add the line

```bash
alias poweroff='/opt/inhibit/inhibit.sh poweroff -f'
```

to your `.bashrc` file and reload it (e.g. manually using the `source` command or automatically by login) and try to execute the `poweroff` command, the following confirmation prompt will appear.

```

####  ##    ##  ##    ##  ####  #######   ####  ########  ########  #######
 ##   ###   ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ####  ##  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ## ## ##  ########   ##   #######    ##      ##     ######    ##    ##
 ##   ##  ####  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
 ##   ##   ###  ##    ##   ##   ##    ##   ##      ##     ##        ##    ##
####  ##    ##  ##    ##  ####  #######   ####     ##     ########  #######

Warning! The 'poweroff' command has been inhibited!

In order to proceed you have to confirm the process.

Hostname: foobar-host
Confirm:

```

So, the command will only be executed if the confirmation was successful.

### Customization

The header can be fully customized and colorized using *Bash* color codes

For example, using different characters:

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃    ████ ██    ██ ██    ██ ████ ███████  ████ ████████ ████████ ███████     ┃
┃     ██  ███   ██ ██    ██  ██  ██    ██  ██     ██    ██       ██    ██    ┃
┃     ██  ████  ██ ██    ██  ██  ██    ██  ██     ██    ██       ██    ██    ┃
┃     ██  ██ ██ ██ ████████  ██  ███████   ██     ██    ██████   ██    ██    ┃
┃     ██  ██  ████ ██    ██  ██  ██    ██  ██     ██    ██       ██    ██    ┃
┃     ██  ██   ███ ██    ██  ██  ██    ██  ██     ██    ██       ██    ██    ┃
┃    ████ ██    ██ ██    ██ ████ ███████  ████    ██    ████████ ███████     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

[Top](#inhibit-)

## Contact

Any suggestions, questions, bugs to report or feedback to give?

You can contact me by sending an email to [dev@urbanware.org](mailto:dev@urbanware.org) or by opening a *GitHub* issue (which I would prefer if you have a *GitHub* account).

Further information can be found inside the `CONTACT` file.

[Top](#inhibit-)
