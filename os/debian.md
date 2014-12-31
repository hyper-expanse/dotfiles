# Debian Server

## Requirements

* Debian Network Installer.
* Computer must be connected to the internet.

## Installation

These instructions assume that the user will be performing a standard installation of Debian using a CD image. It's also assumed that the user has loaded the CD image into the system via an external media (CD, USB, etc.) and restarted the system.

On the first screen select the _Install_ option.

On the languae screen select _English_ as the language.

On the country page select _United States_ as the country.

On the keyboard layout page select _American English_.

Do **NOT** set a password for the root account, but instead, press _Enter_. Pressing _Enter_ causes the root account to be disabled.

When prompted to configure a user please follow these guidelines:
* Full name of the default user is: [FIRST NAME] [LAST NAME]
* Username for the account is: [FIRST NAME]
* Password for the account is: [PASSWORD]

You'll have to re-enter the password a second time to complete the user account setup.

The installation media will attempt to connect to a DHCP server. If successful, then proceed to the next step. If not, please proceed with the following sub-steps:
* Enter a static IP address.
* Enter a netmask, which is typically 255.255.255.0.
* Enter the IP address of the DNS server which will handle DNS requests.

For the hostname follow one of the two following conventions, making sure to replace "[ANYTHING]" with the system's actual hostname:
	* [ANYTHING]

For the domain name use your network's local domain name.

Select the local time zone in which this server will operate.

For a robust, secure, and ideally, faster, filesystem we heavily customize a file system layout that does not contain a swap space, or a boot partition, and that uses the most appropriate filesystem for the partition.

Select "Manual" as the partitioning method.

Select "SCSI1 (0,0,0) (sda)" for the disk to partition.
* If the number after "SCSI" is different, then select either the intended hard drive or the top most on the list.

Setup the following:
* /boot ext4 255 MB

If this is a personal computer then create an encrypted partition before proceeding to setup LVM:
* _physical volume for encryption_
* _Configure the encryption volume_
* Select the Free Space device.
* _Write the changes to disks and configure encryption_
* Enter a password for the encrypted volume.

Create a physical volume to store our LVM setup.
* _physical volume for LVM_
* Select _logical_
* _physical volume for LVM_

Next select _Configure the Logical Volume Manager_.

Create a volume group:
* Name: Schema
* Select the Free Space device.

For each of the following volumes select _Create logical volume_, then select the _Schema_ volume group:
* /
	* Name: root
	* Size: 20 GB
* /home
	* Name: home
	* Size: 10 GB - 100 GB
* /tmp
	* Name: tmp
	* Size: 1 GB
* /usr
	* Name: usr
	* Size: 9 GB
* /var
	* Name: var
	* Size: 3 GB (100GB for the Gateway Server)
* /var/tmp
	* Name: var_tmp
	* Size: 1 GB

Select _Finish_ to move on.

Configure the Logical Volumes in the following manner:
* root
	* File-system: ext4
* home
	* File-system: ext4
* tmp
	* File-system: ext4
* usr
	* File-system: ext4
* var
	* File-system: ext4
* var\_tmp
	* File-system: ext4

Select the _Finish ..._ option.

A warning is presented indicating the system does not have a swap partition. Choose _No_ to continue on.

Choose Yes to write changes to disk.

_Installing the base system............_

Select _United States_ as the archive mirror country.

Select _ftp.us.debian.org_ as the archive mirror.

Simply leave the HTTP proxy prompt blank and press Enter.

Select _No_ for the package usage survey, as we do not wish to provide package installation information to a third party.

From the _Software selection_ screen make sure only the following package groups are selected:
* Standard system utilities
* SSH server
* Laptop (If installing Debian on a laptop system)

Select _Yes_ to install the GRUB boot loader.

Select _Yes_ for the system clock being set to UTC. (This option may, or may not, appear)

At the _Installation Complete_ prompt, remove the CD image and then press _Continue_.

## Update Software

Though a network installer was used to install the operating system, some packages are loaded from the CD image and installed, rather than downloaded from an online repository. This leads to potentially out-of-date packages being installed on the system. Therefore, prior to proceeding with any further configuration, it is imperative, for security reasons, to update all packages to the latest version available.

First the default apt-get sources list needs to be updated to include additional Debian and Linux repositories that will be used throughout the setup of our Debian server. Replace the apt sources list, `/etc/apt/sources.list`, with the following content:

[/etc/apt/sources.list](src/etc/apt/sources.list)

Type the following to update apt-get's cache of available deb packages:

```bash
sudo apt-get update
```

Type the following to install software updates and gracefully handle package dependencies:

```bash
sudo apt-get dist-upgrade --no-install-recommends
```

Choose _Y_ to begin installation of package updates.

Once all software updates have been installed, reboot the system. This will ensure only the latest versions of applications are running.

## Package Installation

Packages:
* apt-listbugs
* backupninja
* debsecan
* duplicity
* git
* gnupg2
* libmtp-runtime: Required by udev for retrieving sensor information from the system.
* ntp
* openssl
* p7zip-full
* rsync
* smartmontools
* snmpd

## Schedule Automatic System Updates

Packages for Debian distributions are regularly updated within the main software repositories with upgrades, and security fixes. Though these updated packages could be downloaded and installed manually, doing so would be tedious across a cluster of systems. Given that a stable version of Ubuntu is being used, all updated packages should not have adverse effects on the stability of the system. We therefore create scripts that will automatically download and install updated packages, thereby keeping the system up-to-date with the latest software in the repository.

Create a new cron job which will be executed on a daily basis by creating the `/etc/cron.daily/apt-updates` file:

[/etc/cron.daily/apt-updates](src/etc/cron.daily/apt-updates)

Execute the following command to make the file executable:

```bash
sudo chmod 755 /etc/cron.daily/apt-updates
```

Set the proper owner, and group, for both files:

```bash
sudo chown root:root /etc/cron.daily/apt-updates
sudo chown root:root /etc/cron.daily/apt-updates
```

Create a new log rule for rotating and compressing log files associated with the automatic updates file by creating the /etc/logrotate.d/apt-updates file:

[/etc/logrotate.d/apt-updates](src/etc/logrotate.d/apt-updates)

Execute the following command to set the proper permissions:

```bash
sudo chmod 644 /etc/logrotate.d/apt-update
```

Set the proper owner, and group, for both files:

```bash
sudo chown root:root /etc/logrotate.d/apt-updates
sudo chown root:root /etc/logrotate.d/apt-updates
```

# Firewall

A firewall helps prevent external intrusion into the system. However, it should be noted that possessing a firewall does not block malicious actions while on the server.

For the firewall, a package called arno-iptables-firewall will be used. It configures the pre-installed iptables package for locking down ports and protecting ports from unauthorized use. To install:

```bash
sudo apt-get install arno-iptables-firewall --no-install-recommends
```

An interactive configuration screen will appear to configure the firewall settings.
* Select _Yes_ for managing the firewall setup with debconf.
* Select _Ok_ for the interface notice.
* For the network interfaces enter the names of every interface, i.e. `eth0`, which are not acting as a gateway interface.
* Enter `22` as the external TCP-port that will allow traffic through the firewall for:
	* SSH
* For UDP ports allow port `161` through the firewall for:
	* SNMP.
* If an interface is acting as a gateway interface, place that into the _Internal Interfaces_ list, otherwise, leave the list blank.
* Select _No_ on whether the system should be pingable from the network.
* Select _Yes_ to restart the firewall at the conclusion of the configuration.
* Select _Yes_ again to restart the firewall.

Edit the `/etc/arno-iptables-firewall/plugins/ssh-brute-force-protection.conf` file and change `ENABLE = 0` to `ENABLE = 1` to enable SSH brute force protection.

Restart the firewall to allow for the additional protection plugins to take effect:

```bash
sudo /etc/init.d/arno-iptables-firewall restart
```

# SSH Configuration

Several options can be configured for SSH which will secure a system more thoroughly than what is configured by default. There are many additional options which can be configured but those listed below should limit system vulnerabilities considerably.

Edit the SSH server configuration file `/etc/ssh/sshd\_config`. Change the SSH options so that they look like those below:
* Do not permit root login over ssh:
	* `PermitRootLogin no`
* Do not allow for login using an account with an empty password:
	* `PermitEmptyPasswords no`
* Set the SSH protocol to the latest version:
	* `Protocol 2`
* Uncomment the logon introduction message:
	* `Banner /etc/issue.net`

Restart the SSH server:

```bash
sudo /etc/init.d/ssh restart
```

Edit the SSH client configuration file `/etc/ssh/ssh\_config`. Change the SSH options so that they look like those below:
* Enable the output of remote host cryptopgraphic signatures:
	* `VisualHostKey yes`

Edit the login banner files, `/etc/issue` and `/etc/issue.net`, to conform to a security statement that informs users that they are responsible for their actions, and their activities will be monitored.

[/etc/issue](src/etc/issue)

[/etc/issue.net](src/etc/issue.net)

# Security Hardening

To further improve the security of this system follow the _Security Hardening_ guide linked below:

* [Security Hardening](other/security-hardening.md)

# Power Improvments

## Laptop

Various tools and scripts can be installed for laptop platforms to improve the power efficiency of the platform.

### Package Installation

Packages:
* cpufrequtils
* hdparm: Required for configuring various hard disk parameters for high performance computing.
* laptop-mode-tools

### Configuration

Each laptop-mode-tools utility has a configuration file in the `/etc/laptop-mode-tools/conf.d` directory.

If Bluetooth is not needed then it can be disabled completely. Edit `/etc/laptop-mode/conf.d/bluetooth.conf` and set the following options:

```
CONTROL_BLUETOOTH=1
BATT_ENABLE_BLUETOOTH=0
AC_ENABLE_BLUETOOTH=0
BLUETOOTH_INTERFACES=``hci0''
```

For CPU frequency control edit `/etc/laptop-mode/conf.d/cpufreq.conf` and set the following options:

```
BATT_CPU_GOVERNOR=conservative
```

For Ethernet control edit `/etc/laptop-mode/conf.d/ethernet.conf` and set the following options:

```
BATT_THROTTLE_ETHERNET=1
```

For video-out ports edit `/etc/laptop-mode/conf.d/video-out.conf` and set the following options:

```
CONTROL_VIDEO_OUTPUTS=1
```

## LinxBrew

### Package Installation

Packages
* build-essential
* libbz2-dev
* libcurl4-openssl-dev
* libexpat-dev
* libncurses-dev
* texinfo
* zlib1g-dev

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

### Installation

To start, the dotfiles repository needs to be cloned to the local system within a directory in the user's folder.

```bash
git clone https://github.com/hbetts/dotfiles.git ${HOME}/.dotfiles
```

Once the dotfiles repository has been cloned to a local directory we need to symlink the dotfiles into their proper locations at the root of the user's folder.

```bash
sh "${HOME}/.dotfiles/deploy.sh"
```

The profile script will need to be sourced, just once, to expose the scripts contained within the dotfiles repository. To source the profile script run the following command:

```bash
source "${HOME}/.profile"
```

Now all our dotfile scripts are exposed within our current shell. We need to finish our setup by running our `setupEnvironment` script. This script will download, build, install, and configure all the tools we want in our local shell environment.

```bash
setupEnvironment
```

## SSH Filesystem Configuration}

Support for remote files systems tunneled over an SSH connection.

### Package Installation}

Packages
* sshfs

### Update User Permissions

For each user execute the following command, replacing [USERNAME] with the user's username:

```bash
sudo usermod -a -G fuse [USERNAME]
```

## SNMP Configuration

Running an SNMP server allows for remote hosts to query for status information about the server. This can include the processor, disk, RAM, or network utilization. In addition, it allows for services on the system to be monitored by external management systems.

Edit the configuration file `/etc/snmp/snmpd.conf` and make the following changes:
* Comment out the first `agentAddress` and un-comment the second `agentAddress` which specifies accepting connection from all interfaces.
* Comment out `rocommunity` choices under Access Control.
* Edit the `sysLocation` line, replacing [ROOM] with the room that the server resides within:

```
sysLocation [ROOM]
```

* Edit the `sysContact` line, replacing [CONTACT E-MAIL] with the administrators e-mail:

```
sysContact [NAME] <[CONTACT E-MAIL]>
```

Create a user with a password and encryption key that will be used to access SNMP data from any network interface.

```bash
sudo /etc/init.d/snmpd stop
sudo net-snmp-config --create-snmpv3-user -ro -a SHA -A [PASSWORD] -x AES -X [ENCRYPTION KEY] authOnlyUser
sudo /etc/init.d/snmpd start
```

Issue the following command, on another server, to verify that SNMP is working correctly:

```bash
snmpwalk -v 3 -u authOnlyUser -l authPriv -a SHA -A [PASSPHRASE] -x AES -X [PASSPHRASE] [IP ADDRESS OR HOSTNAME]
```

## Terminal Multiplexer (tmux)

Configuring tmux establishes the behavior of the tmux tool for managing multiplexed shells.

Configuration is managed by the `${HOME}/.tmux.conf` file from the personal dotfiles repository.

## Nano

One simple yet powerful text editor for Linux is called Nano.It does not have the powerful IDE features of some text editors, but Nano still supports syntax highlighting and accomplishes that while maintaining simplicity of the control interface.

### Configuration

Nano supports several configurable options that make it a more functional text editor. Configurability is supported through a user-based configuration file.

Edit Nano's configuration file `${HOME}/.nanorc` and make the following modifications:

* Add the following options to the top of the configuration file:

```
set autoindent
unset backup
set backwards
set casesensitive
set const
set cut
unset historylog
unset morespace
unset mouse
unset noconvert
set nonewlines
set nowrap
set smooth
set regexp
set tabsize 4
unset tabstospaces
set wordbounds
```

* Next, syntax highlighting support must be added to the bottom of the configuration file. Syntax highlighting support is captured in a set of Nano configuration files that can be found in `/usr/share/nano/`. For each file located in that directory, add the following line to Nano's user configuration file:

```
include "/usr/share/nano/[FILE NAME]"
```

## Terminal Text Editor (vim)

As a powerful text editor Vim gives the user the power to leverage the VIM environment to edit text as easily as a GUI-based text editor but with the additional power of a full Integrated Development Environment.

**Note:** These instructions are only applicable to the Vim configuration of a single individual. For a multi-user environment these instructions must be repeated for each user that wants Vim configured in this manner.

### Package Installation

To configure Vim as a fully functional text editor and integrated development environment we must install pre-written Vim scripts that bring additional functionality into the editor. These scripts are downloaded from public repositories and unpacked into the Vim configuration folder. A generic approach is taken whenever possible, but in some instances installation instructions have been included for specific operating systems.

We do not install Vim from the Debian repository, but instead, rely upon the version of Vim installed through Linxuxbrew via the `brew install vim --head` command baked into our `setupEnvironment` script.

### Configuration

To begin we setup a default Vim configuration file to provide some standard features and behaviors that could be leveraged by software developers.

Configuration is managed by the `${HOME}/.vimrc` file from the personal dotfiles repository.

### Omni Complete

Omni Complete affords the ability to auto-complete C/C++ syntax based on the Standard Template Library and any local source code.

#### Script

Omni Complete for C++ auto completion must be added to Vim as it is not part of the default installation. This work was originally described in \cite{1}.

The latest version of the Omni CPP Complete script is pulled from the vim-scripts Github repository through the inclusion of the Vundle 'Plugin' statement in the vimrc file.

#### Package Installation

To build tag files for Omni Complete to aford auto completion, you will need the exubert-ctag tool.

Packages
* exuberant-ctags

#### C++ Source Code

We need to download a modified version of the C++ STL header files so that a Ctags tag database can be generated.

Download the C++ STL headers:
* http://www.vim.org/scripts/script.php?script_id=2358

Extract the archive into the Vim tags folder:
* ~/.vim/tags

Then rename the extracted folder, "cpp_src", to "stl_src":
* mv ~/.vim/tags/cpp_src ~/.vim/tags/stl_src

Navigate into the tags folder:
* cd ~/.vim/tags

Lastly, run Ctags to build the tags database:
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f stl stl_src

**Note:** On Windows use the downloaded Ctags executable to build the Ctags database. Do NOT use the Ctags application that comes with Cygwin.

#### Examples

After installation and configuration of Omni Complete, auto-complete should work immediately in C/C++ files.

To use begin a standard C++ syntax:

```cpp
std::
```

After completing the initial C++ syntax a box will open with suggestions to complete the call.

Both meta-commands <C-N> and <C-P> can be used to navigate the list of auto-complete options. To open the suggestion box manually use: <C-X><C-O>.

In addition to a list box of auto-complete options, a window will appear above the current Vim window. Within this window will be the full signature of the function.

#### References

* http://vim.wikia.com/wiki/VimTip1608

#### Notes

For generating tags for other libraries:

* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f gl /usr/include/GL/
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f sdl /usr/include/SDL/
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f qt4 /usr/include/qt4/

If a Ctags database needs to be generated for local variable within the current code base just add the '+l' (Letter "l" from local.) to the c++-kinds argument as shown:

* map <C-F12> :!ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

At this time Omni Completion does not work with boost shared pointers.

# Network Configuration

Assuming that every instruction has been followed up to this point, then it can be assumed that either an IP address was retrieved dynamically from a DHCP server, or that one was configured manually during the installation process. In either case, the network interfaces configuration file should be check to insure that it's been written correctly by the installation program. Remember that the `eth0` block of commands can be repeated multiple times for each Ethernet interface on the system.

If using a static IP address update the contents of the `/etc/network/interfaces` file with the following:

```
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet static
	address [IP ADDRESS]
	broadcast [BROADBAST ADDRESS]
	gateway [GATEWAY IP ADDRESS]
	netmask [NETMASK]
	network [NETWORK]
```

If using a DHCP IP address update the contents of the `/etc/network/interfaces` file with the following:

```
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
```

# Backups

Typically there are single copies of files and folders on a server. However, that does not provide assurance that those files or folders will not be accidentally removed or modified.	Therefore it is imperative that additional backups be made. These steps create backup copies of critical files that are not part of the standard configuration process. Backups are made nightly at 1:00am, thereby replacing the previous nights copied state.

Edit `/etc/backupninja.conf` and change the following so that backups run with this groups permissions:

```
admingroup = sudo
```

In addition create backup scripts for the following folders, if those folders are required to be backed up, in `/etc/backup.d/`

* 20.log.sh

```
rsync -avr --delete --delete-excluded --force /var/log /var/backups
```

Change the permissions on the scripts in the backup.d folder so that only root can read them.

```bash
sudo chmod 600 -R /etc/backup.d
```

# Network Anonymity

## Tor

### Package Installation

Packages:
* tor
* tor-arm: Command line application for managing the Tor daemon.

### Configuration

First we need to generate a hashed password for securing the Tor Control port. To generate this password execute the following command, replacing [PASSWORD] with a pseudo-random password.

```bash
sudo tor --hash-password [PASSWORD]
```

**Note:** Temporarily record the hashed password which should appear just before the next command prompt.

Open the Tor configuration file so that the Tor daemon can be configured to accept requests from external application for control:

```bash
sudo nano /etc/tor/torrc
```

Enable support for external control by changing the following property:

From:

```
#ControlPort 9051
```

To:

```
ControlPort 9051
```

Set the password for the Tor Control port by uncommenting the following line and replacing the string that follows "HashedControlPassword".

Uncomment:

```
#HashedControlPassword [HASHED PASSWORD]
```

Lastly, restart the Tor daemon to allow the configuration change to take effect:

```bash
sudo /etc/init.d/tor restart
```

# Performance Improvements

## Disable Services

Disable the following services, thereby preventing them from loading at boot time.

```bash
sudo update-rc.d -f bluetooth disable
sudo update-rc.d -f snmpd disable
sudo update-rc.d -f tor disable
```

### Boot-up

With the installation of packages, additional services are installed which can lead to a slow-down in a system booting up. Therefore, we make several configuration changes to limit the time applications take to restart, or boot-up, from a cold state.

First the e-mail server/client needs to be reconfigured to eliminate its costly DNS lookups conducted at boot time.
* Type `sudo dpkg-reconfigure exim4-config` and press _Enter_.
* Answer all other questions using the defaults except for the question regarding _Dial-on-Demand_. Answer _Yes_ for that option.

Next, GRUB2 shows the user a boot menu from which they may select the version of Linux they wish to boot into. However, this menu incurs a five second delay. We can reduce this delay under the assumption that the user will rarely, if ever, choose a different option than the default:
* Execute the following to edit the grub configuration file:

```bash
sudo nano /etc/default/grub
```

* Edit the line which says:

```
GRUB_TIMEOUT=5
```

* To say:

```
GRUB_TIMEOUT=2
```

* Lastly, execute the following to re-build the Grub menu:

```bash
sudo update-grub2
```

Enable the concurrent loading and execution of init scripts, scripts that initialize the system, by adding the following lines to the `/etc/default/rcS` file:

```
# Enable the concurrent loading and execution of init scripts.
CONCURRENCY=startpar
```

### Temp Directories in Memory

Some applications on a system will use a system-wide directory for storing temporary files that are not expected to live across reboots of the system. These temporary directories allow applications to off-load data into a secure directory stored on disk that can be loaded when required.

However, the act of writing temporary files to disk can be an expensive operation. Depending on the size of each temporary file or the quantity of temporary files, applications can be bogged down by I/O overhead.

To off-set the overhead, these temporary directories can be mounted as in-memory file systems. Applications can write to their temporary files on the system-wide temporary directories, but those directories get mounted in a way that causes all data to be written to memory. This will greatly improve the performance and responsiveness of applications.

To configure the `/tmp` directory so that it's mounted in memory add the following line to the bottom of the `/etc/fstab` file:

```
tmpfs       /tmp        tmpfs   defaults,noatime        0   0
```

### Kernel Configuration

The standard Linux kernel is packages with a set of default options that have an impact on the system's performance. Those options, however, can be changed and reloaded after a system restart. Custom kernel options should be placed into files within the `/etc/sysctl.d/` folder.

Create a new file at `/etc/sysctl.d/performance.conf` and insert the following kernel options:

[/etc/sysctl.d/performance.conf](src/etc/sysctl.d/performance.conf)

Lastly tell the kernel to load the new settings:

```bash
sudo sysctl -p /etc/sysctl.d/performance.conf
```

## Remove Software

As part of a standard installation, some packages are always installed that are quite unnecessary, either because they will never be used in a typical installation, because they could potentially lead to bad practice, or because they impose a security risk. Therefore we delete these packages from the system to prevent their use.

To remove all applications that are unnecessary execute the following command:

```bash
sudo apt-get purge [PACKAGE NAME]
```

Choose ``Y'' to begin the removal process.

Remove the following packages:
* telnet

## Per-system Specialization

Though this configuration guide is supposed to be generic enough that every new installation can be configured in the same manner prior to specialization, there are a few steps that require system-specific knowledge.

### Per-installation

If this system is part of a multi-node cluster, and this system will backup its files to a remote location (On another system in the same cluster or a system that is geography distant), please follow the [Backup Client](services/backup-client.md) configuration guide.

### Virtual Machine Images

When using an existing disk image for the instantiation of a new server, several configuration changes must be made to insure all name changes have been made to the system.

* Execute `sudo dpkg-reconfigure exim4-config` and change the hostname to the new hostname for this particular instance of the Debian Server.
* Edit the `/etc/hosts` and `/etc/hostname` to update the hostname of this instance of the Debian server.
* Execute `sudo hostname -b [HOSTNAME]` where _hostname_ is the name of this particular instance of Debian Server.

Also, Linux distributions use a system called udev to permanently record the MAC address for each network card attached to a system. This way, as additional network cards are added, the system won't re-assign names, like eth0, to the network cards that where already attacked. Rather, the same names will be applied to the network card with the particular MAC address associated with that name. To allow a single virtual disk image to be re-used, we must disable this feature. This is because a disk image might be used with a different set of MAC addresses each time it boots. This could cause problems with Ethernet names.

Remove the existing set of recorded MAC address to network card mappings:

```bash
sudo echo -n > /etc/udev/rules.d/70-persistent-net.rules
```

Disable the creation of those mapping by udev (command depends on Linux distribution):

```bash
mv /lib/udev/rules.d/75-persistent-net-generator.rules /lib/udev/rules.d/75-persistent-net-generator.rules.disabled
```

or

```bash
mv /etc/udev/rules.d/75-persistent-net-generator.rules /etc/udev/rules.d/75-persistent-net-generator.rules.disabled
```
