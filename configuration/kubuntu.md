# Kubuntu

Instructions for setting up Kubuntu 20.04 (Based on Ubuntu 20.04 with the KDE desktop environment) on a Dell XPS 13 laptop (Developer Edition).

## Installer

An installer is available from Kubuntu's [Download page](https://kubuntu.org/getkubuntu/).

Select the _64-bit Download_ option and download the ISO image.

In addition to the ISO image, please copy the SHA256 checksum for the image you downloaded. You can get the checksum from the [_Alternative Downloads_](https://kubuntu.org/alternative-downloads) page.

## Image Verification

With the ISO installation image in hand, we need to validate the image to ensure it wasn't corrupted while at rest on the remote server or while in transit.

Within the directory containing the downloaded installer, run the following command, replacing `[ISO IMAGE NAME]` with the name of the ISO image downloaded:

```bash
sha256sum [ISO IMAGE NAME]
```

You should see something like:

```bash
$ sha256sum kubuntu-20.04-desktop-amd64.iso

ffddf52ad0122180a130f1d738a9a2cb77d87848a326a16cf830ac871a3c786f  kubuntu-20.04-desktop-amd64.iso
```

Compare the checksum output with the value you retrieved from the Kubuntu website.

## Installation

Load the ISO image downloaded above into the system (either by mounting the ISO for use with a virtual machine, or burning the image to a physical DVD or USB) and then restart the system.

An installation screen will launch providing two options; _Try Kubuntu_ and _Install Kubuntu_.

Choose _Install Kubuntu_.

On the _Keyboard layout_ screen, just press _Continue_ as the _English_ default is good enough.

Log into your wireless router to facilitate package installation and updates.

On the _Updates and other software_ screen, select the _Minimal installation_ option. We'll install additional software to meet our needs, without being burdended by software we don't use. Furthermore, select the _Install third-party software ..._ option so that we can be assured that our operating system has access to drivers needed to use all the features of the laptop.

On the _Installation type_ screen, select _Guided - use entire disk and set up encrypted LVM_ and proceed with _Install now_

On the _Where are you?_ screen, select the appropriate time zone.

On the _Who are you?_ screen, enter in your information.

When the installation is complete, choose _Restart Now_.

## Support HTTPS Repositories

Some package repositories use HTTPS as their transport protocol.

To support these repositories we need to install one additional system-level package:

```bash
sudo apt install apt-transport-https
```

Without `apt-transport-https` attempts to install packages from a repository over HTTPS will result in the following error - `The method driver /usr/lib/apt/methods/https could not be found.`

## Security Hardening

Hardening a laptop is an important process to carry-out for all newly provisioned, and existing in-production, systems to insure that information is secured and services can be provided in a continuous and reliable manner.

This section walks you through the process of securing a standard Kubuntu installation by installing various security tools, instituting _best practices_ for settings of pre-installed services, and insuring the latest protocols are utilized.

This guide, however, does not guarantee that a system is impervious to a security breach, nor does it account for the human factor in system security. Rather, it simply takes a _best effort_ at implementing the best standard of security on a system while leaving the maintenance of security to institutional policies.

> **Note:** This section is not comprehensive. Please do additional research to ensure you're applying all _best practices_ as they pertain to security.

### Firewall

A firewall helps prevent external intrusion into the system. However, it should be noted that possessing a firewall does not block malicious actions from occurring on the server itself.

For our firewall we'll use a package called `ufw`, short for _Uncomplicated Firewall_, which is a framework, and a command line frontend, for manipulating [iptables](https://en.wikipedia.org/wiki/Iptables).

Though `ufw` is installed, it is not automatically enabled, nor are any rules turned on by default.

To enable `ufw`, please run the following command:

```bash
sudo ufw enable
```

Next let's enable a few default rules to block all incoming traffic while allowing all outbound traffic:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

Lastly, let's verify `ufw` is running:

```bash
sudo ufw status verbose
```

You should see `Status: active` in the output along with the default rules you set earlier.

Please read Debian's [guide on `ufw`](https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29) for more on how to configure `ufw` to support your needs.

### Restricting Task Scheduling

Linux systems include four mechanisms for users to schedule one-time and regular tasks. Such tasks, when used maliciously, could be used to maintain open backdoors, exhaust system resources, etc. Therefore, restricting who's authorized to use the scheduling system could prevent malicious use by un-authorized, or compromised users.

Here's a list of those task scheduling systems:
- at: Runs a task once, at a specific time in the future.
- batch: Runs a particular task when the system load drops below a specified value.
- cron: Runs tasks at specific times according to a schedule.
- anacron: Periodically runs specified tasks when the system is available.

The `atd` service manages both `at` and `batch`. The `cron` and `anacron` task scheduling systems each use a separate service.

#### at and batch Restriction

To restrict user access to the `at` and `batch` scheduling systems, create a file called `/etc/at.allow`. If this file exists, `at` and `batch` will limit access to only those users listed in the file.

Create the `at.allow` file and restrict to the `root` user:

```bash
sudo echo "root" > /etc/at.allow
```

If a `/etc/at.deny` file exists it provides the reverse of `at.allow`. It enables all users to access `at`, except those whose usernames are listed in `at.deny`.

#### cron Restriction

To restrict user access to the `cron` scheduling system, create a file called `/etc/cron.allow`. If this file exists, `cron` will limit access to only those users listed in the file.

Create the `cron.allow` file and restrict to the `root` user:

```bash
sudo echo "root" > /etc/cron.allow
```

If a `/etc/cron.deny` file exists it provides the reverse of cron.allow. It enables all users to access cron, except those whose usernames are listed in `cron.deny`.

### Account Security

Account security involves the creation and management of user accounts on a system in a manner that ensures the security and integrity of that system. Account security has two aspects that must be handled; first, protecting the access to accounts on a system, and second, ensuring that an account is used in a manner that is appropriate given institutional policies.

#### User Home Folder Access

Kubuntu-based systems create world-readable home directories by default when accounts are created using `adduser`. This allows users on a shared system to access the files and folders inside of each other’s home directories. Access includes the ability to execute programs within the directories of other users, along with reading the contents of any file. This is a potential security and privacy issue, giving users access to material they shouldn't. So we're going to change the default to restrict access to home directories.

Execute the following command to re-configure the `adduser` program:

```bash
sudo dpkg-reconfigure adduser
```

An interactive configuration screen will appear to configure the `adduser` settings.

Select _No_ for system-wide readable home directories.

Next, we must secure all home directories that already exist on the system, removing world privileges, by executing the following command, replacing `[USERNAME]` with the name of the user's home directory:

```bash
sudo chmod -R o-rwx /home/[USERNAME]
```

Modify `/etc/adduser.conf` and change the following property:

```
DIR_MODE=0751
```

> `DIR_MODE` originally has the value of `0755`, but that value is changed to `0751` by our call to `dpkg-reconfigure`.

To the following value:

```
DIR_MODE=0750
```

Changing the default permissions from `751` to `750` disables the default permission that allows executables within a user's home directory to be executed by other users.

#### Default Permissions

Files and directories are typically created on a Unix system with world readable permissions. That means any user on that system, besides the file's owner, can read the contents of newly created files, even if that user is not the owner, or part of the group assigned as an owner of the file.

To mitigate the availability of file contents to third-parties on the same system we change the `UMASK` value used by the Linux system when setting the default permissions for new files and directories.

Edit `/etc/login.defs` and change the following line:

```
UMASK 022
```

To the following value:

```
UMASK	027
```

Please see [Umask](https://en.wikipedia.org/wiki/Umask) documentation to learn how changing `2` to `7` will prevent files from being set with world read permissions.

## Personal Desktop

This section covers customizing the [KDE](https://www.kde.org/) desktop environment.

### Multi-Factor Authentication Device

> This section specifically mentions [Yubico](https://www.yubico.com/) devices, but any two-factor authentication device is supported by the following instructions.

YubiKeys, a product of Yubico, provide support for [multi-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication), and specifically, [Universal 2nd Factor](https://en.wikipedia.org/wiki/Universal_2nd_Factor) authentication.

Install the required package for U2F support:

```bash
sudo apt install libu2f-host0 pcscd scdaemon gnupg2 pcsc-tools
```

> **Note:** Detailed instructions for setting up YubiKey on Debian are provided in Debian's [YubiKey4 docs](https://wiki.debian.org/Smartcards/YubiKey4).

### Desktop Applications

To provide a basic level of functionality for daily tasks, I've put together the following list of desktop applications. I've found these applications to be useful, and provide capabilities not offered by software pre-installed with Kubuntu.

```bash
sudo apt install [PACKAGE]
```

Please use the command above to install each package:
- akregator: RSS/ATOM reader.
- calibre: E-book library manager.
- dia: Diagram editor.
- elisa: Music player.
- gramps: Genealogy tool.
- gufw: Graphical user interface for `ufw` firewall.
- k3b: CD rip/burn application.
- kde-config-cddb: Module for loading CD metadata from internet.
- keepassxc: Offline password and secrets manager.
- kgpg: GNUPG graphical front-end.
- libreoffice-calc: Spreadsheet application.
- libreoffice-writer: Word application.
- rsibreak: Tool to encourage regular breaks from typing.

### Flatpak Applications

In addition to packages installed from Ubuntu's traditional package registry, we can also install packages from FlatHub, and package registry that receives regular updates to packages published directly from application developers.

To add support for Flatpak to KDE's _Discover_ package installer and the `flatpak` CLI tool, install the following package:

```
sudo apt install plasma-discover-flatpak-backend
```

Next, go into _Discover_ and navigate to _Settings_. Under _Settings_ click on the `Add Flathub` button to add the central Flathub repository as a source for installing Flatpak packages.

At this point you can install Flatpak packages from Flathub.

Please use the search feature in _Discover_ to install the following packages:
- Visual Studio Code (Flatpak)

### Additional VLC Setup

While VLC can play most multimedia formats, the version distributed with Kubuntu cannot play encrypted DVDs. Encrypted DVDs account for most commercially available movie DVDs. To play encrypted DVDs an additional library, called `libdvdcss2`, is required. `libdvdcss2` is not distributed with the Kubuntu version of VLC because for [legal reasons](https://en.wikipedia.org/wiki/Libdvdcss) that you are encouraged to be fully aware of before you proceed with this section.

Full instructions for installing `libdvdcss2` on Debian-based operating systems are available on the [VideoLAN website](https://www.videolan.org/developers/libdvdcss.html), though I have also included them here.

Start by installing the package that sets up the environment needed for installing `libdvdcss2`.

```bash
sudo apt install libdvd-pkg
```

Then reconfigure the package to trigger the installation of `libdvdcss2`.

```bash
sudo dpkg-reconfigure libdvd-pkg
```

Select _Yes_ to install `libdvdcss2`.

At this point VLC will be able to play encrypted DVDs.

### Virtual Machines

To provide processor emulator and virtualization, along with a GUI for monitoring virtualized resources, we need to install the QEMU support libraries and Virt Manager:

```bash
sudo apt install qemu qemu-kvm qemu-utils virt-manager libvirt-daemon-system libvirt-clients gir1.2-spiceclientgtk-3.0
```

> `gir1.2-spiceclientgtk-3.0` is required to display the virtual machine's desktop.

### Docker

> This section is a modification of the instructions on [Docker's Ubuntu CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/) site.

Add Docker's official GPG signing key to your system to validate the authenticity of the Docker CE package:

```bash
curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Next, verify the key installed for Docker (Fingerprint is available on Docker's website):

```bash
sudo apt-key fingerprint
```

To install the latest version of Docker we need to add Docker's repository to our `apt` list of Ubuntu package repositories:

```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Then update the list of available packages, including those available from the Docker repository:

```bash
sudo apt update
```

Ensure that the Docker package, `docker-ce`, will be installed from the Docker repository (`https://download.docker.com`):

```bash
apt-cache policy docker-ce
```

Install the latest version of Docker CE:

```bash
sudo apt install docker-ce
```

Lastly, check that Docker is running (Looking for `Active: active (running)`):

```bash
sudo systemctl status docker
```

To run Docker containers without using `sudo`, for the purpose of gaining `root` permissions, you'll need to add your account to the `docker` user group previously setup by the `docker-ce` installer.

> Before adding your account to the `docker` group please read through Docker's [Docker daemon attach surface documentation](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface) to understand the tradeoff of giving users root-like permissions through the `docker` group.

To do so simply add yourself to the `docker` user group:

```bash
sudo usermod -G docker -a ${USER}
```

Once you've added yourself to the `docker` group you will need to log out and back into your system for the group change to take effect.

Lastly, verify Docker was installed correctly by running their test image:

```bash
docker run hello-world
```

### GnuPG

[GnuPG](https://www.gnupg.org/) allows for the creation and management of encryption keys following the public/private key model.

Launch `KGpg`, Kubuntu's graphical user interface to GnuPG, and under _Settings -> Configure KGpg -> Key Servers_, remove all the default key servers.

A `~/.gnupg/gpg.conf` configuration file, used for configuring GnuPG clients, will be scaffolded by the _Personal Dotfiles_ section below.

When generating a new encryption key, set all keys with an expiration date 10 years in the future. Then set a calendar event as a reminder of when to replace an old key.

Create a single master key, and then a subkey for each purpose of Encryption, Signing, and Authentication.

A few good resources for setting up GPG keys:
- [Create GnuPG key with sub-keys to sign, encrypt, authenticate](https://blog.tinned-software.net/create-gnupg-key-with-sub-keys-to-sign-encrypt-authenticate/)
- [Creating the perfect GPG keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair/)

A few good resources for using GPG keys:
- [PGP and You](https://robots.thoughtbot.com/pgp-and-you)
- [yubikey and ssh authentication](https://www.isi.edu/~calvin/yubikeyssh.htm)

#### Generate Master Key

We'll delegate _Encryption_, _Signing_, and _Authentication_, to individual subkeys, but to manage those subkeys, such as creating, signing, and revocing, them, we'll need to first create a master key.

We'll generate our master key in _expert_ mode so that we can restrict our master key to the _Certify_ capability.

```bash
> gpg2 --expert --full-generate-key

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
   (9) ECC and ECC
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
Your selection? 8

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Sign Certify Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? S

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Certify Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? E

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Certify

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 10y
Key expires at Wed 12 Jan 2028 08:31:53 PM CST
Is this correct? (y/N) Y

GnuPG needs to construct a user ID to identify your key.

Real name: [FULL NAME]
Email address: [E-MAIL ADDRESS]
Comment:
You selected this USER-ID:
    "[FULL NAME] <[E-MAIL ADDRESS]>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: key [KEYID] marked as ultimately trusted
gpg: revocation certificate stored as '~/.gnupg/openpgp-revocs.d/[FINGERPRINT].rev'
public and secret key created and signed.
```

Move the revocation certificate to a safe location where no one, but you, can access in case you need to revoke your master key. Revocaing your master key may be neceesary in the event it's been compromised. If the key becomes compromised, this revocation certificate must be published to key servers to notify everyone that they should no longer trust the revoked key.

Lastly, using the `[KEYID]` shown in the output above, create a backup of your master key:

```bash
gpg2 --armor --export-secret-keys 0x[KEYID] > ~/0x[KEYID]-[E-MAIL ADDRESS].key
```

In a later section we'll talk about moving the backup to a safe location as well.

#### Generate Encryption Key

Generate an encryption subkey to be used for encrypting content before storing or transmitting that content.

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? S

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 10y
Key expires at Wed 12 Jan 2028 09:25:34 PM CST
Is this correct? (y/N) Y
Really create? (y/N) Y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> save
```

Create a backup of any subkeys associated with your master key:

```bash
gpg2 --armor --export-secret-subkeys 0x[KEYID] > ~/0x[KEYID]-[E-MAIL ADDRESS].subkeys
```

#### Generate Signing Subkey

Generate a signing subkey to be used for signing messages as originating from you.

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? E

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 10y
Key expires at Wed 12 Jan 2028 09:25:34 PM CST
Is this correct? (y/N) Y
Really create? (y/N) Y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> save
```

Create a backup of any subkeys associated with your master key:

```bash
gpg2 --armor --export-secret-subkeys 0x[KEYID] > ~/0x[KEYID]-[E-MAIL ADDRESS].subkeys
```

#### Generate Authentication Subkey

Generate an authentication subkey for authenticating with remote servers over SSH.

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? S

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? E

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions:

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? A

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Authenticate

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 10y
Key expires at Wed 12 Jan 2028 08:53:57 PM CST
Is this correct? (y/N) Y
Really create? (y/N) Y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> save
```

Create a backup of any subkeys associated with your master key:

```bash
gpg2 --armor --export-secret-subkeys 0x[KEYID] > ~/0x[KEYID]-[E-MAIL ADDRESS].subkeys
```

#### Add User Identities

Though the master key has been created with your provided name and e-mail address as your identity, you're welcome to add additional identities, such as an alternative name or e-mail address.

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> adduid
Real name: [ALTERNATE NAME]
Email address: [ALTERNATE E-MAIL ADDRESS]
Comment:
You selected this USER-ID:
    "[ALTERNATE NAME] <[ALTERNATE E-MAIL ADDRESS]>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>
[ unknown] (2)  [ALTERNATE NAME] <[ALTERNATE E-MAIL ADDRESS]>

gpg> save
```

The final output shows a `.` before the name of one of your identifies. This indicates which identity is considered your primary identity. If that identity is not your primary, then please make sure to change it:

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>
[ultimate] (2)  [ALTERNATE NAME] <[ALTERNATE E-MAIL ADDRESS]>

gpg> uid 2

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>
[ultimate] (2)* [ALTERNATE NAME] <[ALTERNATE E-MAIL ADDRESS]>

gpg> primary

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1)  [FULL NAME] <[E-MAIL ADDRESS]>
[ultimate] (2)* [ALTERNATE NAME] <[ALTERNATE E-MAIL ADDRESS]>

gpg> save
```

If you decided to add identities, please re-create your master key backup:

```bash
gpg2 --armor --export-secret-keys 0x[KEYID] > ~/0x[KEYID]-[E-MAIL ADDRESS].key
```

### Yubikey

Verify that GnuPG can interact with your Yubikey by running the following command:

```bash
gpg2 --card-status
```

You should see something like:

```bash
Reader ...........: Yubico Yubikey
```

Change the PIN and Admin PIN from the defaults (`123456` is default for PIN and `12345678` is default for Admin PIN):

```
> gpg2 --card-edit

Reader ...........: Yubico Yubikey

gpg/card> admin
Admin commands are allowed

gpg/card> passwd
gpg: OpenPGP card no. detected

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 1
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 3
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? Q

gpg/card> quit
```

Now let's move the subkeys to the Yubikey. We are moving the subkeys instead of copying them so that we don't leave the private subkeys on an internet-accessible device where they could be compromised.

Once moved to a Yukikey, the private subkeys cannot be retreived (Except with the backup file created earlier), though they can continue to be used for authenticating, encrypting, and signing.

We'll start with our _Authentication_ subkey by selecting the key that is setup for _Authentication_, as indicated with _usage_ of _A_.

```bash
> gpg2 --expert --edit-key 0x[KEYID]

Secret key is available.

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> key 1

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb* rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> keytocard
Please select where to store the key:
   (3) Authentication key
Your selection? 3

sec  rsa4096/0x[KEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: C
     trust: ultimate      validity: ultimate
ssb* rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: A
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: S
ssb  rsa4096/0x[SUBKEYID]
     created: 2018-01-15  expires: 2028-01-13  usage: E
[ultimate] (1). [FULL NAME] <[E-MAIL ADDRESS]>

gpg> save
```

Repeat the process for your _Encryption_ and _Signing_ subkeys.

Lastly, verify that the subkeys were properly moved to your Yubikey (Moved keys will appear with an `>` after `ssb`):

```bash
> gpg2 --card-status

Reader ...........: Yubico Yubikey
...
Signature key ....: [FINGERPRINT]
      created ....: 2018-01-15 03:25:16
Encryption key....: [FINGERPRINT]
      created ....: 2018-01-15 15:45:18
Authentication key: [FINGERPRINT]
      created ....: 2018-01-15 03:23:55
sec   rsa4096/0x[KEYID]     created: 2018-01-15  expires: 2028-01-13
ssb>  rsa4096/0x[SUBKEYID]  created: 2018-01-15  expires: 2028-01-13
                            card-no: [NUMBER]
ssb>  rsa4096/0x[SUBKEYID]  created: 2018-01-15  expires: 2028-01-13
                            card-no: [NUMBER]
ssb>  rsa4096/0x[SUBKEYID]  created: 2018-01-15  expires: 2028-01-13
                            card-no: [NUMBER]
```

Though the master key is shown in the output, once the master key has been moved off of the device with the Yubikey, it will appear as `sec#` when displaying card status using `gpg2 --card-status` (where `#` means the private key is not available).

#### Configuring GnuPG for SSH

You must first disable the standard SSH Agent so that SSH connection authentication is handled by the GnuPG agent.

Edit `/etc/X11/Xsession.options` and comment out `use-ssh-agent` by prepending `#`.

Next, install the following package so that `gpg-agent` can determine how to prompt the user to unlock the Yubikey.

```bash
sudo apt install dbus-user-session
```

Run the following to output your SSH public key:

```bash
gpg2 --export-ssh-key 0x[KEYID]
```

> You can also use the subkey ID associated with your _Authentication_ subkey.

#### Securing Your Master Key

As noted earlier, the revocation certificate for your master key should be kept somewhere safe where no one else can access it.

This may mean placing it on write-protected media, or printing it to paper, and then storing it in a safe location where only you have physical access.

In addition to the revocation certificate, you are encouraged to move your master key backup, `0x[KEYID]-[E-MAIL ADDRESS].key`, and subkeys backup, `0x[KEYID]-[E-MAIL ADDRESS].subkeys`, to the same location. This ensures that, should your computer become compromised, your private keys will remain safe.

Once the master key revocation certificate and backups are move elsewhere, you may remove the master private key (private subkeys have already been moved to the Yubikey):

```
gpg2 --delete-secret-keys 0x[KEYID]
```

After deleting the master private key, only the public portion of your master key and subkeys remain on your computer.

At this point, signing, encrypting, or authenticating, with your private subkeys can only be done with your Yubikey connected to your computer.

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publicly accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://gitlab.com/hyper-expanse/personal/dotfiles/blob/master/README.md).