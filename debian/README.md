# Debian

This chapter describes how to setup a Debian 9 system for use as either a server, or desktop environment.

## Requirements

List of requirements to install Debian 9 (Debian's _Stable_ Version).
* Debian 9 installation ISO image.

> An installation image for your architecture can be downloaded from [Debian's Live Image](https://www.debian.org/CD/live/) site.

To help minimize the burden on Debian's infrastructure, please use BitTorrent to download the image for your architecture.

Debian's Live images are built so that you can boot your hardware into a usable desktop using the desktop environment of your choice (KDE, GNOME, etc.).

Please download the desktop environment you want to work with, as well as the `SHA512SUMS` and `SHA512SUMS.sign` files. The _SHA512_ files will be used to validate the downloaded ISO file to ensure it has not been tampered with.

## Image Verification

Upon successfully downloading a DVD image, you need to validate the contents to ensure they weren't tampered with while at rest on the remote server, or in transit.

Within the directory containing the downloaded files, run the following command, replacing `[ISO IMAGE NAME]` with the name of the ISO image you downloaded:

```bash
sha512sum --check SHA512SUMS 2> /dev/null | grep [ISO IMAGE NAME]
```

> The _SHA512SUMS_ file contains the hash value of all Debian ISO images. The `2> /dev/null` redirects errors about missing ISO images in your local directory to `/dev/null`, so that those errors aren't printed to console. The call to `grep` will only show the validation status for the image you actually downloaded.

Assuming you downloaded `debian-live-9.0.0-amd64-kde.iso`, you will see the following output:

```bash
debian-live-9.0.0-amd64-kde.iso: OK
```

Lastly, we need to verify the authenticity of the `SHA512SUMS` file to ensure it wasn't tampered with. For this step we will use the downloaded `SHA512SUMS.sign` file. The `SHA512SUMS.sign` file contains a cryptographic hash generated using a [GPG private key](https://www.gnupg.org/gph/en/manual.html) and the contents of `SHA512SUMS`.

To verify the signature file was signed by a private key owned by Debian, run the following:

```bash
gpg --keyring /usr/share/keyrings/debian-role-keys.gpg --verify SHA512SUMS.sign
```

You should see the following in the output:

```bash
Good signature from "Debian CD signing key <debian-cd@lists.debian.org>"
```

At this point you can be reasonably sure that the contents of your downloaded ISO image have not been tampered with since they were created by Debian.

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

Because the system was installed from an ISO image, several of the installed packages may be out-of-date. Therefore, prior to proceeding with any further configuration, it is imperative, for security reasons, to update all packages to the latest version available.

First the default apt-get sources list should be updated to include additional Debian repositories that we can use. Replace the apt sources list, `/etc/apt/sources.list`, with the following content:

```
deb http://httpredir.debian.org/debian jessie main contrib non-free
deb-src http://httpredir.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free
deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

deb http://httpredir.debian.org/debian unstable main contrib non-free
deb-src http://httpredir.debian.org/debian unstable main contrib non-free
```

In addition to updating the list of repositories, we need to prioritize the repository a package should be installed from. These priorities are defined in files in the `preferences.d` directory located under `/etc/apt/`. Create a file named 'stable' in the `/etc/apt/preferences.d/` directory with the following content:

```
Package: *
Pin: release o=Debian,a=stable
Pin-Priority: 700
```

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

Once all software updates have been installed, reboot the system. This will ensure only the latest version of packages are running.

> Please remember to update your system on a regular basis (such as once a day). The same `update` and `full-upgrade` steps must be carried out in each case.

## Automatic Updates

Packages for Debian distributions are regularly updated within the main software repositories with enhancements and security fixes. Though these updated packages could be downloaded and installed manually, doing so would be tedious. Therefore we create scripts to automatically download and install updated packages, keeping our system up-to-date.

Create a new cron job to run on a daily basis by creating the `/etc/cron.daily/aptitude-updates` file:

```bash
#!/usr/bin/env bash

# Capture our start time.
start=$(date +%s)

# Set the date for UTC date.
utcdate=$(date -u --rfc-3339=seconds)

# Location of the output log file.
log=/var/log/aptitude-updates

# Begin executing commands.
echo "*******************************************" >> $log
echo "[Aptitude Updates]: $utcdate Z" >> $log
echo "*******************************************" >> $log

# Update our list of repository packages
aptitude update >> $log

# Install all package updates where the update does not require the removal of another package. Assume yes where applicable (--assume-yes) and do not install recommended packages but only those that are required (--no-install-recommends).
aptitude safe-upgrade --assume-yes --without-recommends >> $log

# Clean up cache files. Assume yes where applicable (--assume-yes).
aptitude clean --assume-yes >> $log

# Calculate and log total execution time.
end=$(date +%s)
difference=$(($end - $start))

echo >> $log
echo "Execution time: $difference seconds." >> $log
echo >> $log
```

Run the following command to make the file executable:

```bash
sudo chmod 755 /etc/cron.daily/aptitude-updates
```

Create a new log rule for rotating and compressing log files associated with the automatic updates file by creating the `/etc/logrotate.d/aptitude-updates` file:

```
/var/log/aptitude-updates {
	rotate 2
	weekly
	size 250k
	compress
	notifempty
}
```

Run the following command to set the proper permissions:

```bash
sudo chmod 644 /etc/logrotate.d/aptitude-update
```

Set the proper owner, and group, for both files:

```bash
sudo chown root:root /etc/cron.daily/aptitude-updates
sudo chown root:root /etc/cron.daily/aptitude-updates
```

## Additional System Packages

The following additional packages should be installed onto your system. To install them, run `sudo aptitude install [PACKAGE]`.

Packages:
* apt-listbugs: Will display a list of known issues with packages before they're installed by `aptitude install/full-upgrade`.
* ntp: Service for updating the system's time from Debian time servers.

## Firewall

A firewall helps prevent external intrusion into the system. However, it should be noted that possessing a firewall does not block malicious actions from occurring on the server itself.

For the firewall, a package called `arno-iptables-firewall` will be used. `arno-iptables-firewall` acts as an [IPtables frontend](https://wiki.debian.org/Firewalls). It configures the pre-installed `iptables` package; locking down ports and protecting ports from unauthorized access or use.

First, let's create a file that defines our desired configuration:

```
#######################################################################
# Feel free to edit this file.  However, be aware that debconf writes #
# to (and reads from) this file too.  In case of doubt, only use      #
# 'dpkg-reconfigure -plow arno-iptables-firewall' to edit this file.  #
# If you really don't want to use debconf, or if you have specific    #
# needs, you're likely better off using placing an additional         #
# configuration snippet into/etc/arno-iptables-firewall/conf.d/.      #
# Also see README.Debian.                                             #
#######################################################################

# External network interfaces (such as those connected to the internet).
EXT_IF="wlan0"

# Set to '1' is external IP is retrieved from DHCP.
EXT_IF_DHCP_IP=1

# TCP ports to allow through external network interfaces.
OPEN_TCP=""

# UDP ports to allow through external network interfaces.
OPEN_UDP=""

# Internal network interfaces.
INT_IF=""

# Configuration for routing internal traffic from other systems, through this system's external network interfaces, and to the public internet.
NAT=0
INTERNAL_NET=""
NAT_INTERNAL_NET=""

# Set to '1' if the system should respond to PING messages on external network interfaces.
OPEN_ICMP=0
```

> Make sure to change the value of *EXT_IF* to match the names of your system's external interfaces.

Next, install the `arno-iptables-firewall` package:

```bash
sudo aptitude install arno-iptables-firewall
```

An interactive configuration screen will appear to configure the firewall settings.
* Select _Yes_ for managing the firewall setup with debconf.
* Select _Ok_ for the interface notice.
* For the network interfaces enter the names of every Internet facing interface, such as `eth0`..
* Do not open any inbound TCP ports.
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

Edit the SSH server configuration file `/etc/ssh/sshd_config`. Change the SSH options so that they look like those below:

* Do not permit root login over SSH:
	* `PermitRootLogin no`
* Uncomment the logon introduction message:
	* `Banner /etc/issue.net`

Restart the SSH server:

```bash
sudo /etc/init.d/ssh restart
```

Edit the login banner files, `/etc/issue` and `/etc/issue.net`, to conform to a security statement that informs users that they are responsible for their actions, and their activities will be monitored. Please modify these files as appropriate for your network, or situation.

```
===========================
HyperExpanse Network Notice
===========================

Unauthorized access to this computer system is prohibited. Users have no expectation of privacy except as otherwise provided by applicable privacy laws. All activities are monitored, logged, and analyzed. Unauthorized access and activities or any criminal activity will be reported to appropriate authorities.
```

## Security Hardening

To improve the security of this system follow the _Security Hardening_ guide linked below:
* [Security Hardening](security-hardening.md)

## Performance

To improve the performance of this system follow the _Performance_ guide linked below:
* [Performance](performance.md)
