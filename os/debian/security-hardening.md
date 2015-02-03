# Security Hardening

Hardening a system is an important process to conduct for all newly provisioned systems along with existing in-production systems to insure that information is secured and services can be provided in a continuous and reliable manner.

This configuration guide walks through the process of securing a standard Debian installation by installing various security tools, instituting "best practice" changes to the default settings of pre-installed services, and insuring the latest protocols are utilized. This guide, however, does not guarantee that a system is impervious to a security breach, nor does it account for the human factor in system security. Rather, it simply looks at implementing the best standard of security on a system while leaving the maintenance of security to institutional policies.

## Server Configuration

Each server can be configured to further enhance the security of that system. Configuration changes are typically related to kernel options which can prevent certain activities from occurring on the server, to system properties such as the default permissions on files, folders, and executable.

### Kernel Configuration

The standard Linux kernel is packages with a set of default options which could make a server vulnerable to third-party exploitation. Those options, however, can be changed and reloaded after a system restart. Custom kernel options should be placed into files within the `/etc/sysctl.d/` folder.

Create a new file at `/etc/sysctl.d/security.conf` and insert the following kernel options:

[src/etc/sysctl.d/security.conf](os/debian/src/security.conf)

Lastly, tell the kernel to load the new settings:

```bash
sudo sysctl -p /etc/sysctl.d/security.conf
```

## Account Security

Account security involves the creation and management of user accounts on a system in a manner that insures the security and integrity of that system. Account security has two aspects which must be handled; first, protecting the access to accounts on a system, and second, insuring that an account is used in a manner that is appropriate given institutional policies.

### Password Expiration

When new accounts are created on a system, the defaults for those accounts are pulled from `/etc/login.defs`. Those defaults include options for password expiration, and accounts expiration. These options must be changed to improve the standard security afforded by the default password expiration options.

Edit the following file, `/etc/login.defs`, and change the options so that they look like those below:
* `PASS_MAX_DAYS` is how often users must change their passwords.
	* `PASS_MAX_DAYS 180`
* `PASS_MIN_DAYS` is how long a user is forced to live with their new password before their allowed to change it again.
	* `PASS_MIN_DAYS 1`
* `PASS_WARN_AGE` is the number of days before the password expiration date that the user is warned that their password is about to expire.
	* `PASS_WARN_AGE 7`
* `LOGIN_RETRIES` is the number of attempts a user has to enter their password before the account is locked. Once an account is locked, it can only be unlocked by an administrator.
	* `LOGIN_RETRIES 5`
* `ENCRYPT_METHOD` is the method used to encrypt the user's password.
	* `ENCRYPT_METHOD SHA512`

Edit the following file, `/etc/default/useradd`, uncomment the following line and insure the line looks like the one below:

```
INACTIVE=10
```

Meaning of each value:
* `PASS_MAX_DAYS`: Passwords must expire after 180 days, thereby requiring a new password to be set.
* `PASS_MIN_DAYS`: Passwords may be changed only once per day at most as indicated by the 1 days between changes.
* `PASS_WARN_AGE`: A password expiration warning should be given each time a user logs into their account, beginning 7 days prior to the expiration date.
* `LOGIN_RETRIES`: Number of attempts a user has to enter their password before the account is locked. Once an account is locked, it can only be unlocked by an administrator.
* `ENCRYPT_METHOD`: The has algorithm used to encrypt the user's password for storage into the in-system password database.
* `INACTIVE`: Accounts should be locked as a result of inactivity 10 days after the password expires. This action requires an administrator to re-activate the account.

To look at the current state of a user's password expiration information:

```
sudo chage -l [USERNAME]
```

Change the state of each existing user's password expiration information:

```
sudo chage [USERNAME]
```

### Password Scheme

Insure users create a good password by enforcing an expectation on the quality of the password using the libpam-cracklib PAM module. What follows is a description of the libpam-cracklib module, the various configuration settings that are available, and how those settings should be changed to insure high quality passwords.

#### Package Installation

Packages:
* libpam-cracklib

#### Enabling pam_cracklib

The pam_cracklib module is enabled via the system's standard PAM configuration interface. This is the `/etc/pam.d/common-password` file . The typical configuration looks something like this:

```
password	requisite					pam_cracklib.so retry=3 minlen=8 difok=3
password	[success=1 default=ignore]	pam_unix.so obscure use_authtok try_first_pass sha512
```

The first line enables the `pam_cracklib` module and sets several module parameters. `retry=3` means that users get three chances to pick a good password before the `passwd` program aborts. Users can always re-run the `passwd` program and start over again, however. `minlen=8` sets the minimum number of characters in the password. `difok=3` sets the minimum number of characters that must be different from the previous password. If you increase `minlen`, you may also want to increase the `difok` value as well.

The second line invokes the standard `pam_unix` module. The `SHA512` argument here is what enables standard Linux SHA512 password hashes, though you have the option of using old-style DES56 hashes for backwards compatibility with legacy Unix systems. `use_authtok` tells pam_unix to not bother doing any of its own internal password checks, which duplicate many of the checks in `pam_cracklib`, but instead accept the password that the user inputs after it's been thoroughly checked by `pam_cracklib`.

Edit the `/etc/pam.d/common-password` file and make the following changes to improve the default security:
* Change the pam_cracklib.so line to match the one below:

```
password	requisite	pam_cracklib.so retry=3 minlen=8 difok=4 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-2
```

Account password policy is as follows:
* Minimum password length of 8 characters. (minlen)
* At least 4 characters in the new password which must not also be in the old password. (difok)
* At least one lower-case character. (lcredit)
* At least one upper-case character. (ucredit)
* At least one digit character. (dcredit)
* At least two non-alphanumeric characters. (ocredit)

The `minlen` value is actually the minimum required length for a password consisting of all lower-case letters. But users get `length credits` for using upper- and lower-case letters, numbers, and non-alphanumeric characters. The default is normally that you can only get a maximum of `1 credit` for each type of character. So if the administrator sets `minlen=12`, a user could still have an 8 character password if they used all four types of characters. Actually, since using a lower-case letter gets you a credit, the real minimum length for an all lower-case password is minlen-1. The maximum credit for any particular class of characters is actually customizable. The four parameters `lcredit`, `ucredit`, `dcredit`, and `ocredit` are used to set the maximum credit for lower-case, upper-case, numeric (digit), and non-alphanumeric (other) characters, respectively. However, when the values for these four parameters is set to a negative number, then the user receives no credit for using that type of character. Rather, they are required to use that type of character the number of times given be the negative number. Therefore, if the value is `-1`, then at least one of that type of character must be used in the password.

Edit the `/etc/pam.d/common-password` file and make the following changes to improve the default security:
* Change the pam_unix.so line, and add the following as the end:

```
remember=400
```

The value of the `remember` parameter is the number of old passwords you want to store for a user. It turns out that there's an internal maximum of 400 previous passwords, so values higher than 400 are all equivalent to 400. Before you complain about this limit, consider that even if your site forces users to change passwords every 30 days, 400 previous passwords represents over 30 years of password history. This is probably sufficient for even the oldest of legacy systems.

### Shell Auto-Logout

It is an important security measure to insure that shell prompts are closed when not being used by a user. By configuring a user's shell to automatically log out after a pre-defined amount of idle time, the amount of time a malicious user could have to come upon the open shell is greatly reduced.

Create the `/etc/profile.d/autologout.sh` file and add the following:

```bash
#!/usr/bin/env bash

TMOUT=1800
readonly TMOUT
export TMOUT
```

Next, set the permissions of the file so that it can be pulled in as part of the login process:

```bash
sudo chmod 644 /etc/profile.d/autologout.sh
```

### SSH Auto-Logout

The OpenSSH daemon allows administrators to set an idle timeout interval. After this interval has passed, any idle users will be automatically logged out, and their SSH connection terminated.

Edit the `/etc/ssh/sshd_config` configuration file and add the following at the bottom of the file:

```
ClientAliveInterval 1800
ClientAliveCountMax 0
```

Finally, restart the SSH daemon:

```bash
sudo /etc/init.d/ssh restart
```

### User Home Folder Access

Debian-based systems create world-readable home directories by default when creating accounts using `adduser`. This allows users on a shared system to access the files and folders inside of each other’s home directories. Access includes the ability to execute programs within the directories of other users, along with reading the contents of any file. This is a potential security vulnerability, giving users access to material they shouldn't. Therefore, we must change this default.

Execute the following command to re-configure the `adduser` program:

```bash
sudo dpkg-reconfigure adduser
```

An interactive configuration screen will appear to configure the `adduser` settings.

Select No for system-wide readable home directories.

Next, we must secure all home directories that already exist on the system, removing world privileges, by executing the following command, replacing `[USERNAME]` with the name of the user's home directory:

```bash
sudo chmod -R o-rwx /home/[USERNAME]
```

Modify `/etc/adduser.conf`, and change the following property:

```
DIR_MODE=0751
```

To:

```
DIR_MODE=0750
```

Changing the default permission from `751` to `750` disables the default permission that allows a user's home directory to be world readable, or readable by all users of the system.

## Data Destruction

Removing data beyond simple file deletion is the act of destroying the data in a manner that prevents or hinders retrieval or data remanence. Traditional means of deleting a file leave the contents of the file on the disk. Those contents are not destroyed until the operating system overwrites that physical location on the disk. Therefore, after the deletion of a file, there is no assurance that the contents of that file can not later be retrieved. Subsequently, the physical location on disk must be written to in a manner that make retrieval of that original file contents improbable.

Therefore, using the application tool below for data removal is a secure and reliable means to permanently destroy data short of the physical destruction of the disk.

### Package Installation

Packages:
* scrub

### Data Destruction Process

There are several ways that scrub can be used to make data on a disk nearly impossible to retrieve. As part of a daily routine, and for most information, the standard scrub defaults are sufficient. Those defaults can be used in the manner shown below. For further assurance read the help manual on scrub to learn of more thorough algorithms that can scrub data.

To scrub a file, execute the following command:
* scrub [FILE NAME]

Additional commands:
* To remove the file after scrubbing: -r
* To scrub a file after it has already been scrubbed: -f

## Default Permissions

Files and directories are typically created on a Unix system with world readable permissions. That means any users on that system, besides the file's owner, can, by default, read the contents of newly created files, even if that user is not the owner, or part of the group assigned to the file.

To mitigate the availablility of file contents to third-parties, we change the UMASK used by Unix systems when setting the default permissions on new files and directories.

Edit `/etc/login.defs` and change the following line:

From:
```
UMASK 022
```

To:
```
UMASK	027
```

Next we edit the PAM configuration file, `/etc/pam.d/common-session`, to force the UMASK value to accepted, by adding the following to bottom of the file:

```
session required	pam_umask.so umask=0027
```

## Disable Unnecessary Services

For added security it's best to disable any services on the local machine which are not being used.

Comment out each line in `/etc/inetd.conf` using the character '\#'.

## Update Host SSH Keys

The host keys for the server need to be updated to use a larger key size for better cryptographic security.

Sudo into the root account:

```bash
sudo su
```

Run the following two commands to generate new SSH keys for the host system:

```bash
ssh-keygen -t rsa -b 16384 -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key
```

**Note:** When prompted for a password just press `Enter` to make the key passwordless.

**Note:** DSA keys can only be as large as 1024 bits in length. This is a restriction imposed by FIPS 186-2 and enforced by OpenSSL (The manager of SSH keys).
