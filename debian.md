# Debian

## Requirements

List of requirements to install Debian 8 (Stable).
* Debian 8 installation DVD.

> Images for your architecture can be downloaded from [Debian's CD Torrent](https://www.debian.org/CD/torrent-cd/) page. You only need to download DVD image `1` for your architecture.

## Installation

These instructions assume that the user will be performing a standard installation of Debian using Debian's DVD installation image. They also assume that the user has loaded the DVD image into the system via an external media (CD, USB, etc.) and subsequently restarted the system. Assuming those statements are correct, proceed with the following steps.

On the Installation screen select the _Install_ option.

On the language screen select _English_ as the language.

On the country page select _United States_ as the country.

On the keyboard layout page select _American English_.

Do **NOT** set a password for the root account. Instead, press _Enter_. Pressing _Enter_ will cause the root account to be disabled.

When prompted to configure a user please follow these guidelines:
* Full name of the default user is: [FIRST NAME] [LAST NAME]
* Username for the account is: [FIRST NAME ALL LOWERCASE]
* Password for the account is: [PASSWORD]

You'll have to re-enter the password a second time to complete the user account setup.

The installation media will attempt to connect to a DHCP server. If the attempt fails, please feel free to skip the network setup step. With the DVD installation image, a full installation will be possible without network access. Just make sure to setup networking upon successfully installing Debian.

Select a hostname for the system.

For the domain name enter in the domain name you associate with your network.

Select your local time zone.

Select _Manual_ as the partitioning method.

Select _SCSI1 (0,0,0) (sda)_ for the disk to partition.

> If the number after _SCSI_ is different than what is mentioned above, select the intended hard drive or the top most on the list.

Setup the boot partition using the following values:
* Mount location: /boot
* File system: ext2
* Size: 255 MB

> A journaling filesystem, such as `ext3`, or `ext4`, is not necessary for a boot partition in which files are rarely written, or read.

Create an encrypted partition before proceeding to setup LVM:
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

When prompted, create a Volume Group using `[HOSTNAME]-vg` as the name, replacing `[HOSTNAME]` with the hostname of the system. For the Volume Group, select the Free Space device.

With the newly created Volume Group create several logical volumes that are mapped to directories within the file system. For each of the following directory mappings select _Create logical volume_, then select the `[HOSTNAME]-vg` volume group:

* /
	* Name: root-lv
	* Size: 20 GB
* /home
	* Name: home-lv
	* Size: Rest of available disk space.
* /tmp
	* Name: tmp-lv
	* Size: 1 GB
* /usr
	* Name: usr-lv
	* Size: 10 GB
* /var
	* Name: var-lv
	* Size: 3 GB
* /var/tmp
	* Name: var_tmp-lv
	* Size: 1 GB
* N/A
	* Name: swap-lv
	* Size: 2 * [SYSTEM MEMORY] + 1 GB

Once all logical volumes have been created select _Finish_ to move on.

Configure each Logical Volume in the following manner:

* root-lv
	* File-system: ext4
* home-lv
	* File-system: ext4
* tmp-lv
	* File-system: ext4
* usr-lv
	* File-system: ext4
* var-lv
	* File-system: ext4
* var_tmp-lv
	* File-system: ext4
* swap-lv
	* File-system: swap

Select the _Finish ..._ option.

Choose _Yes_ to write changes to disk.

_Installing the base system............_

Select _United States_ as the archive mirror country.

Select _ftp.us.debian.org_ as the archive mirror.

Simply leave the HTTP proxy prompt blank and press _Enter_.

Select _No_ for the package usage survey (unless you would like to contribute anonymous information on the packages installed to your system for the benefit of the Debian community).

From the _Software selection_ screen make sure only the following package groups are selected:
* SSH server

Select _Yes_ for the system clock being set to UTC. (This option may, or may not, appear)

At the _Installation Complete_ prompt, remove the installation media and then press _Continue_.

## Update Software

Because the system was installed form a DVD image several of the installed packages may be out-of-date. Therefore, prior to proceeding with any further configuration, it is imperative, for security reasons, to update all packages to the latest version available.

First the default apt-get sources list should be updated to include additional Debian repositories that we can use. Replace the apt sources list, `/etc/apt/sources.list`, with the following content:

[/etc/apt/sources.list](src/etc/apt/sources.list)

In addition to the list of repositories, we need to prioritize which packages should be installed from which repositories. These priorities are provided in the `preferences.d` directory of `apt/`. Create a file, `/etc/apt/preferences.d/kernel`, with the following content:

[/etc/apt/preferences.d/kernel](src/etc/apt/preferences.d/kernel)

We will be using Debian's [aptitude](https://wiki.debian.org/Aptitude) package manager (based on Debian's `apt-get` package manager).

To update aptitude's cache of available packages:

```bash
sudo aptitude update
```

To install software updates and gracefully handle package dependencies:

```bash
sudo aptitude full-upgrade
```

Choose _Y_ to begin installation of package updates.

Once all software updates have been installed, reboot the system. This will ensure only the latest versions of applications are running.

## Additional System Packages

The following additional packages should be installed onto your system. To install them, run `sudo aptitude install [PACKAGE]`.

Packages:
* apt-listbugs: Will display a list of known issues with packages before they're installed by `aptitude install/full-upgrade`.
* ntp: Service for updating the system's time from Debian time servers.
* sshfs: Userland-based filesystem over SSH.

## Firewall

A firewall helps prevent external intrusion into the system. However, it should be noted that possessing a firewall does not block malicious actions while on the server.

For the firewall, a package called `arno-iptables-firewall` will be used. It configures the pre-installed `iptables` package for locking down ports and protecting ports from unauthorized access or use. To install:

```bash
sudo aptitude install arno-iptables-firewall
```

An interactive configuration screen will appear to configure the firewall settings.
* Select _Yes_ for managing the firewall setup with debconf.
* Select _Ok_ for the interface notice.
* For the network interfaces enter the names of every Internet facing interface, such as `eth0`..
* Enter `22` as the external TCP-port that will allow traffic through the firewall for:
	* SSH
* If an interface is acting as a gateway interface, place that into the _Internal Interfaces_ list, otherwise, leave the list blank.
* Select _No_ on whether the system should be pingable from the network.
* Select _Yes_ to restart the firewall at the conclusion of the configuration.
* Select _Yes_ again to restart the firewall.

Edit the `/etc/arno-iptables-firewall/plugins/ssh-brute-force-protection.conf` file and change `ENABLE = 0` to `ENABLE = 1` to enable SSH brute force protection.

Restart the firewall to allow for the additional protection plugins to take effect:

```bash
sudo /etc/init.d/arno-iptables-firewall restart
```

## SSH Configuration

Several options can be configured for SSH which will secure a system more thoroughly than what is configured by default. There are many additional options which can be configured but those listed below should limit system vulnerabilities considerably.

Edit the SSH server configuration file `/etc/ssh/sshd\_config`. Change the SSH options so that they look like those below:

* Do not permit root login over SSH:
	* `PermitRootLogin no`
* Uncomment the logon introduction message:
	* `Banner /etc/issue.net`

Restart the SSH server:

```bash
sudo /etc/init.d/ssh restart
```

Edit the login banner files, `/etc/issue` and `/etc/issue.net`, to conform to a security statement that informs users that they are responsible for their actions, and their activities will be monitored. Please modify these files as appropriate for your network, or situation.

[/etc/issue](src/etc/issue)

[/etc/issue.net](src/etc/issue.net)

## Security Hardening

To improve the security of this system follow the _Security Hardening_ guide linked below:
* [Security Hardening](security-hardening.md)

## Performance

To improve the performance of this system follow the _Performance_ guide linked below:
* [Performance](performance.md)
