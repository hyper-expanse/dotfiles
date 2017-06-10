# Security Hardening

Hardening a system is an important process to conduct for all newly provisioned systems along with existing in-production systems to insure that information is secured and services can be provided in a continuous and reliable manner.

This configuration guide walks through the process of securing a standard Debian installation by installing various security tools, instituting "best practice" changes to the default settings of pre-installed services, and insuring the latest protocols are utilized. This guide, however, does not guarantee that a system is impervious to a security breach, nor does it account for the human factor in system security. Rather, it simply looks at implementing the best standard of security on a system while leaving the maintenance of security to institutional policies.

## Server Configuration

Each server can be configured to further enhance the security of that system. Configuration changes are typically related to kernel options which can prevent certain activities from occurring on the server, to system properties such as the default permissions on files, folders, and executable.

### Kernel Configuration

The standard Linux kernel is packages with a set of default options which could make a server vulnerable to third-party exploitation. Those options, however, can be changed and reloaded after a system restart. Custom kernel options should be placed into files within the `/etc/sysctl.d/` folder.

Create a new file at `/etc/sysctl.d/security.conf` and insert the following kernel options:

```
#########################
# Kernel Settings
#########################

# Disables the magic-sysrq key
kernel.sysrq = 0
```

Lastly, tell the kernel to load the new settings:

```bash
sudo sysctl -p /etc/sysctl.d/security.conf
```

### Restricting Task Scheduling

Current Linux systems include four mechanisms for users to schedule one-time and regular tasks. Such tasks, when used maliciously, could be used to maintain open backdoors, exhaust system resources, etc. Therefore, restricting who's authorized to use the scheduling system could prevent malicious use by un-authorized, or compromised users.

Here's a list of those task scheduling systems:
* at: Runs a task once, at a specific time in the future.
* batch: Runs a particular task when the system load drops below a specified value.
* cron: Runs tasks at specific times according to a schedule.
* anacron: Periodically runs specified tasks when the system is available.

The `atd` service manages both `at` and `batch`. The `cron` and `anacron` task scheduling systems each use a separate service.

### at and batch Restriction

To restrict user access to the `at` and `batch` scheduling systems, create a file called `/etc/at.allow`. If this file exists, at and batch limit access to specific users. Only those users listed in the file may schedule tasks with at and batch.

To create a list of authorized accounts, create the following file:

```bash
sudo touch /etc/at.allow
```

Edit `/etc/at.allow` and add the following user(s):

```bash
root
```

If an `/etc/at.allow` file exists then no user may access `at` or `batch` unless their account is explicitly listed in that file.

Each facility checks for an `at.allow` file before reading `at.deny`.

### cron Restriction

To restrict user access to the `cron` scheduling system, create a file called `/etc/cron.allow`. If this file exists, cron limits access to specific users. Only those users listed in the file may schedule tasks with cron.

To create a list of authorized accounts, create the following file:

```bash
sudo touch /etc/cron.allow
```

Edit `/etc/cron.allow` and add the following user(s):

```bash
root
```

If a `/etc/cron.deny` file exists it provides the reverse of cron.allow. It enables all users to access cron, except those whose usernames are listed in `cron.deny`.

### Mount Protection

Each partition on a Linux system can be mounted to a directory relative to the root directory. When mounting a partition, the principle of lease privileges should be followed by restricting the permissions and activities that can be carried out on the mounted partition. This is achieved by mounting each partition with the most restrictive mount options available without impacting required functionality.

#### Mount Options

* nodev: Do not interpret character or block special devices on the file system.
* nosuid: Do not allow set-user-identifier or set-group-identifier bits to take effect.
* noexec: Do not allow direct execution of any binaries on the mounted filesystem.

#### Recommended Application

| Partition | nodev | nosuid | noexec |
| /boot     | Yes   | Yes    | Yes    |
| /home     | Yes   | Yes    | Yes (Only if code will not be executed out of the home directories.) |
| /tmp      | Yes   | Yes    | Yes (Only if packages will not be build from scratch on this system.) |
| /usr      | No    | No     | No     |
| /var      | No    | No     | No     |
| /var/tmp  | Yes   | Yes    | Yes    |

#### Application

Edit the mount configuration file, `/etc/fstab`, and apply the appropriate permission mentioned in _Recommended Application_ section by appending the permissions to the `<options>` column for each mounted partition:

```bash
sudo nano /etc/fstab
```

## Account Security

Account security involves the creation and management of user accounts on a system in a manner that insures the security and integrity of that system. Account security has two aspects which must be handled; first, protecting the access to accounts on a system, and second, insuring that an account is used in a manner that is appropriate given institutional policies.

### SSH Auto-Logout

The OpenSSH daemon allows administrators to set an idle timeout interval. After this interval has passed, any idle users will be automatically logged out, and their SSH connection terminated.

Edit the `/etc/ssh/sshd_config` configuration file and add the following at the bottom of the file:

```
ClientAliveInterval 1800
ClientAliveCountMax 0
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

## Debian Vulnerability Scanner

Debian provides a vulnerability scanner that will determine if there are any security updates available for packages that are installed on the current system. By default the Debian Vulnerability Scanner (debsecan) configures a cron job that causes debsecan to e-mail a report every night to the root account with a list of vulnerable packages installed on the system along with a list of packages for which updates are available. This default behavior is sufficient to inform the administrator of vulnerability with packages, but lacks fine tunning that can be achieved through additional configuration.

### Package Installation

Packages:
* debsecan

### Configuration

Modify the configuration file, `/etc/default/debsecan`, for `debsecan` so that the version of Debian is specified:

Change:

```
SUITE=GENERIC
```

To:

```
SUITE=[DEBIAN VERSION]
```

Replacing [DEBIAN VERSION] with the version of Debian installed. For example, if running the unstable version of Debian, replace [DEBIAN VERSION] with `SID`.

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

## Update Host SSH Keys

The host keys for the server need to be updated to use a larger key size for better cryptographic security.

Temporarily log into the root account using `sudo`:

```bash
sudo su
```

Run the following two commands to generate new SSH keys for the host system:

```bash
yes | ssh-keygen -t rsa -b 16384 -N '' -f /etc/ssh/ssh_host_rsa_key
yes | ssh-keygen -t dsa -b 1024 -N '' -f /etc/ssh/ssh_host_dsa_key
```

**Note:** We call `yes` here to auto answer prompts affirmatively, so that the process can be automated.

**Note:** DSA keys can only be as large as 1024 bits in length. This is a restriction imposed by FIPS 186-2 and enforced by OpenSSL (The manager of SSH keys).
