# Debian

This chapter describes how to install and setup a Debian 9 system for use as either a server, or desktop environment.

## Installer

An installer for our architecture can be downloaded from [Debian's CD Images](https://www.debian.org/CD/torrent-cd/) site. Once we've navigated to the Debian site, it's recommended to choose the appropriate architecture under the _DVD_ section. There will be several ISO images containing all available Debian packages for the chosen architecture. All of those images should be downloaded.

> To minimize the burden on Debian's infrastructure use BitTorrent to download ISO images.

In addition to the ISO images, please download the `SHA512SUMS` and `SHA512SUMS.sign` files. The _SHA512_ files will be used to validate the downloaded ISO files to ensure they have not been tampered with.

## Image Verification

Once we've successfully downloaded all the required ISO images, the contents need to be validated to ensure they weren't tampered with while at rest on the remote server, or in transit.

Within the directory containing the downloaded files, run the following command, replacing `[ISO IMAGE NAME]` with the name of each ISO image downloaded:

```bash
sha512sum --check SHA512SUMS 2> /dev/null | grep [ISO IMAGE NAME]
```

> The _SHA512SUMS_ file contains the hash value of all Debian ISO images. The `2> /dev/null` redirects errors about missing ISO images in your local directory to `/dev/null`, so that those errors aren't printed to console. The call to `grep` will only show the validation status for the image specified.

Assuming `debian-9.0.0-amd64-DVD.iso` was downloaded, we will see the following output:

```bash
debian-9.0.0-amd64-DVD.iso: OK
```

Once each ISO image has been verified to match their respective checksum in `SHA512SUMS`, we need to verify the authenticity of the `SHA512SUMS` file to ensure it too hasn't been tampered with. For this step use the downloaded `SHA512SUMS.sign` file. The `SHA512SUMS.sign` file contains a cryptographic hash generated using a [GPG private key](https://www.gnupg.org/gph/en/manual.html) and the contents of `SHA512SUMS`.

To verify the signature file was signed by a private key owned by Debian, run the following:

```bash
gpg --keyring /usr/share/keyrings/debian-role-keys.gpg --verify SHA512SUMS.sign
```

The following output will be seen:

```bash
Good signature from "Debian CD signing key <debian-cd@lists.debian.org>"
```

At this point we can be reasonably sure that the contents of the downloaded ISO images have not been tampered with since they were created by Debian.

## Installation

Load the first ISO image downloaded above into the system (either via mounting the ISO for use with a virtual machine, or burning the image to a physical DVD or USB) and restart the system.

Assuming those statements are correct, proceed with the following steps.

On the _Main Menu_ screen select the _Install_ option.

On the _Select a language_ screen select _English_ as the language.

On the _Select your location_ screen select _United States_ as the country.

On the _Configure the keyboard_ screen select _American English_.

The installation media will attempt to connect to a DHCP server. If the attempt fails, please feel free to skip the network setup step. With the DVD installation image, a full installation will be possible without network access. Just make sure to setup networking upon successfully installing Debian.

Next, select a hostname for the system.

Do **NOT** set a password for the root account. Instead, press _Enter_. Pressing _Enter_ will cause the root account to be disabled.

When prompted to configure a user please follow these guidelines:
* Full name of the default user is: [FIRST NAME] [LAST NAME]
* Username for the account is: [FIRST NAME ALL LOWERCASE]
* Password for the account is: [PASSWORD]

Re-enter the password a second time to complete the user account setup.

Select the local time zone.

Select _Manual_ as the partitioning method.

Select _SCSI1 (0,0,0) (sda)_ for the disk to partition.

> If the number after _SCSI_ is different than what is mentioned above, select the intended hard drive or the top most on the list.

Select _Yes_ to create a new partition table for the device.

Navigate to the newly created `pri/log` partition and select it.

Choose _Create a new partition_.

Setup the boot partition using the following values:
* Use as: ext4
* Mount location: /boot
* Partition type: Primary
* Location for new partition: Beginning
* Size: 255 MB
* Bootable flag: on

Select the remaining free space, and when prompted, choose _Create a new partition_.

Setup the new partition using the following values:
* Use as: physical volume for encryption
* Partition type: Logical
* Size: All remaining.

Once the encrypted partition has been created, navigate through the menu to the _Configure the Logical Volume Manager_ option to configure our LVM setup.

Choose _Create volume group_ and name the volume group `[HOSTNAME]-vg`, replacing `[HOSTNAME]` with the hostname of the system.

When prompted for the volume group device, choose the device tagged as `crypto`, and then allow the changes to be written to disk.

Once the volume group has been created, move on to creating several logical volumes, one for distinct directory for which we want to create a separate file system. For each of the following directory mappings select _Create logical volume_, then select the `[HOSTNAME]-vg` volume group:

* /
	* Name: root-lv
	* Size: 20 GB
* /home
	* Name: home-lv
	* Size: All remaining disk space minus 20GB.
* /tmp
	* Name: tmp-lv
	* Size: 1 GB
* /usr
	* Name: usr-lv
	* Size: 10 GB
* /var
	* Name: var-lv
	* Size: 20 GB
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
	* Mount point: /root
* home-lv
	* File-system: ext4
	* Mount point: /home
* tmp-lv
	* File-system: ext4
	* Mount point: /tmp
* usr-lv
	* File-system: ext4
	* Mount point: /usr
* var-lv
	* File-system: ext4
	* Mount point: /var
* var_tmp-lv
	* File-system: ext4
	* Mount point: /var/tmp
* swap-lv
	* File-system: swap

Select the _Finish ..._ option.

Choose _Yes_ to write changes to disk.

_Installing the base system............_

Select _No_ for the package usage survey (unless you would like to contribute anonymous information on the packages installed to your system for the benefit of the Debian community).

From the _Software selection_ screen make sure only the following package groups are selected:
* SSH server
* standard system utilities

Choose _Yes_ to install the GRUB boot loader to the master boot record, and then select the primary hard drive.

At the _Installation Complete_ prompt, remove the installation media and then press _Continue_.

## Install Aptitude

We will be using Debian's [aptitude](https://wiki.debian.org/Aptitude) package manager (based on Debian's `apt-get` package manager) for installing software at the system-level (as opposed to within user directories.).

Install `aptitude`:

```bash
sudo apt-get install aptitude
```

Choose _Y_ to begin installation of package updates.

## Update Software

Because the system was installed from an ISO image, several of the installed packages may be out-of-date. Therefore, prior to proceeding with any further configuration, it is imperative, for security reasons, to update all packages to the latest version available.

First the default apt-get sources list should be updated to include additional Debian repositories that we can use. Replace the apt sources list, `/etc/apt/sources.list`, with the following content:

```
deb http://deb.debian.org/debian stretch main
deb-src http://deb.debian.org/debian stretch main

deb http://deb.debian.org/debian stretch-updates main
deb-src http://deb.debian.org/debian stretch-updates main

deb http://security.debian.org/ stretch/updates main
deb-src http://security.debian.org/ stretch/updates main
```

In addition to updating the list of repositories, we need to prioritize the repository a package should be installed from. These priorities are defined within files in the `preferences.d` directory located under `/etc/apt/`.

Create a file named `stable` in the `/etc/apt/preferences.d/` directory with the following content:

```
Package: *
Pin: release o=Debian,n=stretch
Pin-Priority: 700
```

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

Packages for Debian distributions are regularly updated within the main software repositories with enhancements and security fixes. Though these updated packages could be downloaded and installed manually, doing so would be tedious. Therefore we create scripts to automate the process of downloading and installing updated packages, keeping our system up-to-date.

Create a new cron job to run on a daily basis by creating the `/etc/cron.daily/aptitude-updates` file, and putting the following content into it:

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
* apt-listbugs: Will display a list of known issues with packages before they're installed using tools such as `apt-get` or `aptitude`.
* ntp: Service for updating the system's time from Debian time servers.

## SSH Configuration

Several options can be configured for SSH which will secure a system more thoroughly than what is configured by default.

Edit the SSH server configuration file `/etc/ssh/sshd_config`, and change the SSH options so that they look like those below:

* Do not permit root login over SSH:
	* `PermitRootLogin no`
* Uncomment the logon introduction message:
	* `Banner /etc/issue.net`

Restart the SSH server:

```bash
sudo /etc/init.d/ssh restart
```

Edit the login banner files, `/etc/issue` and `/etc/issue.net`, to conform to a security statement that informs users that they are responsible for their actions, and their activities will be monitored.

Please modify these files as appropriate for your network, or situation.

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

## Personal Desktop

> This section is only necessary if you want to setup your Debian system with a desktop environment.

* [Personal Desktop](personal-desktop.md)
