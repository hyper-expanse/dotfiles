# Personal Desktop

This chapter covers setting up a graphical desktop environment over a bare Debian operating system. My desktop of choice is the wonderful [KDE](https://www.kde.org/) desktop environment. Sections in this chapter will walk you through installing the desktop environment and various applications to meet your daily needs.

## Display Server

To install them, run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* xorg: This metapackage provides the components for a standalone workstation running the X Window System.
* mesa-utils

> `mesa-utils` includes a command line tool called `glxinfo` that can display information about the OpenGL and GLX implementations employed by the running X display server. (For example, executing `glxinfo | grep OpenGL` will provide information on whether your system is using OpenGL for rendering.)

## Window Manager

To install the following packages run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* kwin-x11: Compositing window manager used by KDE.

## Desktop Environment

In addition to providing the fundamental components required to offer a functional desktop environment, the `kde-plasma-desktop` package also include basic necessities such as a file manager, and a password manager. However, `kde-plasma-desktop` does **not** come with a large number of applications, such as video and music players. Instead we leave it up to the user to choose what basic applications they want on their system.

To install the following packages run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* kde-plasma-desktop: The KDE Plasma desktop and minimal set of applications.
* plasma-nm: Network Management widget for KDE Plasma workspaces.
* network-manager-openvpn: Support for connecting to virtual private networks.

## Network Manager

The Debian Network Manager is not configured to start automatically, nor is it setup to manage the system's network interfaces. Therefore we must first configure the Network Manager to manage all network interfaces, and then we must restart the Network Manager daemon for that change to take effect.

Edit the following file, `/etc/NetworkManager/NetworkManager.conf`, and enable the managed feature:

```
managed=true
```

Then restart the Network-Manager service:

```bash
sudo /etc/init.d/network-manager restart
```

## Sound

Our basic KDE desktop setup does not come with audio support. To enable audio for desktop applications we need to install the [pulseadio sound server](https://en.wikipedia.org/wiki/PulseAudio).

To install the following packages run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* pulseaudio

## Multi-Factor Authentication Device

> This section specifically mentions [Yubico](https://www.yubico.com/) devices, but any two-factor authentication device is supported by the following instructions.

YubiKeys purchased from Yubico provide support for [multi-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication), and specifically, [Universal 2nd Factor](https://en.wikipedia.org/wiki/Universal_2nd_Factor) authentication.

Background information, and detailed instructions for setting up YubiKey on Debian, are provided in Debian's [YubiKey4 docs](https://wiki.debian.org/Smartcards/YubiKey4).

However, for most uses, including support for non-YubiKey devices.

To install the following packages run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* libu2f-host0

## Desktop Applications

A list of common applications to fulfill various workflows is provided below.

To install the following packages run `sudo aptitude install [PACKAGE] --without-recommends`.

Packages:
* ark: Archive tool. [KDE]
* calibre: E-book library manager.
* clementine: Music player and library manager.
* dia: Diagram editor.
* gramps: Genealogy tool. [GTK]
* gufw: Graphical user interface for `ufw` firewall. [GTK]
* gwenview: Image viewer. [KDE]
* k3b: A CD/DVD ripper and burner. [KDE]
* kcalc: Simple and scientific calculator. [KDE]
* keepassx: Offline password and secrets manager.
* kgpg: GNUPG graphical front-end. [KDE]
* kde-spectacle: Screenshot capture tool. [KDE]
* libreoffice-calc: Spreadsheet application.
* libreoffice-kde: For improved integration of LibreOffice into KDE theme. [KDE]
* libreoffice-writer: Word application.
* okular: PDF viewer. [KDE]
* picard: Cross-platform music tagger.
* quiterss: RSS/ATOM reader.
* transmission-qt: Qt front-end for the Transmission BitTorrent client.
* vlc: Multimedia player.

## Additional VLC Setup

While VLC can play most multimedia formats, the version distributed with Debian cannot play encrypted DVDs. Encrypted DVDs account for most commercially available movie DVDs. To play encrypted DVDs an additional library, called `libdvdcss`, is required. `libdvdcss` is not distributed with the Debian version of VLC because of [legal concerns](https://en.wikipedia.org/wiki/Libdvdcss).

Full instructions for installing `libdvdcss` on Debian are available on the [VideoLAN website](https://www.videolan.org/developers/libdvdcss.html), but they are included here (with a few changes that align with other instructions in the _Configuration_ guide).

Add VideoLAN's official GPG signing key:

```bash
curl -sSL https://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -
```

Verify key integrity:

```bash
sudo apt-key fingerprint
```

Then look for the following key in the output:

```bash
pub   rsa2048 2013-08-27 [SC]
      8F08 45FE 77B1 6294 429A  7934 6BCA 5E4D B842 88D9
uid           [ unknown] VideoLAN APT Signing Key <videolan@videolan.org>
sub   rsa2048 2013-08-27 [E]
```

Add the following to a file named `videolan.list` in the `/etc/apt/sources.list.d/` directory:

```
deb [arch=amd64] https://download.videolan.org/pub/debian/stable/ /
deb-src [arch=amd64] https://download.videolan.org/pub/debian/stable/ /
```

Then instruct Aptitude to update it's list of available packages, including those available in the VideoLAN repository.

```bash
sudo aptitude update
```

Install the latest version of `libdvdcss``:

```bash
sudo aptitude install libdvdcss2 --without-recommends
```

At this point VLC should be able to play any encrypted DVD.

## Vagrant

[Vagrant](https://www.vagrantup.com/) is a tool for configuring reproducible and portable development environments using one of several provisioning tools, such as virtual machines through `libvirt`, or Docker containers.

First, install `vagrant` from the Debian repository:

```bash
sudo aptitude install vagrant --without-recommends
```

Next, we'll need to install the [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) plugin so that `vagrant` can provision virtual machines through `libvirt` (Our preferred provisioning interface for virtual machines).

To install `vagrant-libvirt`, navigate to their [Installation Guide](https://github.com/vagrant-libvirt/vagrant-libvirt#installation) and install the packages listed for Debian.

> Please ensure you replace command line calls made to `apt-get` with calls to `aptitude` using `sudo`.

Once all dependencies for `vagrant-libvirt` have been installed, have vagrant install the plugin:
* `vagrant plugin install vagrant-libvirt`

To monitor virtual machines on your system outside of Vagrant, install `virt-manager`, a graphical tool for visualizing virtual machine resources.

```bash
sudo aptitude install virt-manager --without-recommends
```

### Libvirt User

Using any `vagrant` command that modifies the state of a `libvirt` managed machine will require you to enter your password to authenticate.

To avoid the authentication prompt simply add yourself to the `libvirt` user group:
* `sudo usermod -G libvirt -a ${USER}`

## Docker

> This section is a modification of the instructions on [Docker's Debian CE](https://docs.docker.com/engine/installation/linux/docker-ce/debian/) site.

Add Docker's official GPG signing key:

```bash
curl -sSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

Verify key integrity:

```bash
sudo apt-key fingerprint
```

Then look for the following key in the output:

```bash
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

To install the latest version of Docker we need to add Docker's repository to our `apt` list of Debian package repositories.

Add the following to a file named `docker.list` in the `/etc/apt/sources.list.d/` directory:

```
deb [arch=amd64] https://download.docker.com/linux/debian stretch stable
```

Then instruct Aptitude to update it's list of available packages, including those available in the Docker repository.

```bash
sudo aptitude update
```

Install the latest version of Docker CE:

```bash
sudo aptitude install docker-ce --without-recommends
```

To run Docker containers without using `sudo` to gain `root` user permissions, you can add your account to the `docker` user group previously setup by the `docker-ce` installer.

> Before adding your account to the `docker` group, please read through Docker's [Docker daemon attach surface documentation](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface) to understand the tradeoff of giving users root-like permissions through the `docker` group.

To do so simply add yourself to the `docker` user group:
* `sudo usermod -G docker -a ${USER}`

Once you've added yourself to the `docker` group you will need to log out, and back into, your system for the group change to take effect.

Lastly, verify Docker was installed correctly by running their test image:

```bash
docker run hello-world
```

## GnuPG

[GnuPG](https://www.gnupg.org/) allows for the creation and management of encryption keys following the public/private key model.

Launch `KGpg`, KDE's graphical user interface to GnuPG, and under _Settings -> Configure KGpg -> Key Servers_, remove all the default key servers.

A `~/.gnupg/gpg.conf` configuration file, used for configuring GnuPG clients, will be scaffolded by the _Personal Dotfiles_ section below.

Lastly, install the following dependency for the `gpg2` command line tool:

```bash
sudo aptitude install dirmngr --without-recommends
```

> `dirmngr` is used by GnuPG's command line tool, `gpg`, to connect to third-party servers to upload, or download, keys.

When generating a new encryption key, set all keys with an expiration date 10 years in the future. Then set a calendar event as a reminder of when to replace an old key.

Create a single master key, and then a subkey for each purpose of Encryption, Signing, and Authentication.

A few good resources for setting up GPG keys:
* [Create GnuPG key with sub-keys to sign, encrypt, authenticate](https://blog.tinned-software.net/create-gnupg-key-with-sub-keys-to-sign-encrypt-authenticate/)
* [Creating the perfect GPG keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair/)

A few good resources for using GPG keys:
* [PGP and You](https://robots.thoughtbot.com/pgp-and-you)
* [yubikey and ssh authentication](https://www.isi.edu/~calvin/yubikeyssh.htm)

### Generate Master Key

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

### Generate Encryption Key

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

### Generate Signing Subkey

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

### Generate Authentication Subkey

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

### Add User Identities

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

## Yubikey

Install package required for GnuPG to recognize the Yubikey as a smart card.

```bash
sudo aptitude install scdaemon --without-recommends
```

Once the smart card package has been installed, you can verify that GnuPG can interact with your Yubikey by running the following command:

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

### Configuring GnuPG for SSH

You must first disable the standard SSH Agent so that SSH connection authentication is handled by the GnuPG agent.

Edit `/etc/X11/Xsession.options` and comment out `use-ssh-agent` by prepending `#`.

Next, install the following package so that `gpg-agent` can determine how to prompt the user to unlock the Yubikey.

```bash
sudo aptitude install debus-user-session --without-recommends
```

Run the following to output your SSH public key:

```bash
gpg2 --export-ssh-key 0x[KEYID]
```

> You can also use the subkey ID associated with your _Authentication_ subkey.

### Securing Your Master Key

As noted earlier, the revocation certificate for your master key should be kept somewhere safe where no one else can access it.

This may mean placing it on write-protected media, or printing it to paper, and then storing it in a safe location where only you have physical access.

In addition to the revocation certificate, you are encouraged to move your master key backup, `0x[KEYID]-[E-MAIL ADDRESS].key`, and subkeys backup, `0x[KEYID]-[E-MAIL ADDRESS].subkeys`, to the same location. This ensures that, should your computer become compromised, your private keys will remain safe.

Once the master key revocation certificate and backups are move elsewhere, you may remove the master private key (private subkeys have already been moved to the Yubikey):

```
gpg2 --delete-secret-keys 0x[KEYID]
```

After deleting the master private key, only the public portion of your master key and subkeys remain on your computer.

At this point, signing, encrypting, or authenticating, with your private subkeys can only be done with your Yubikey connected to your computer.

## Integrated Development Environment

[Visual Studio Code](https://code.visualstudio.com/), Microsoft's free and open source code editor is a fantastic tool for writing, organizing, testing, and debugging software.

To install Visual Studio Code, navigate to the [Visual Studio Code download page](https://code.visualstudio.com/Download), and download the appropriate Debian package for your architecture.

Next, open a command line window, navigate into the folder containing the downloaded package, and run the following command, replacing `[FILE NAME]` with the name of the file you downloaded:
* `sudo dpkg --install [FILE NAME]`

Visual Studio Code's package will automatically add its own package repository to your system's list of repositories. That ensures future updates of your system will also install the latest version of Visual Studio Code.

> Visual Studio's repository uses HTTPS, which is supported as a result of installing the `apt-transports-https` package in an earlier section. Without `apt-transport-https` installed, attempts to update Visual Studio Code will result in the following error - `The method driver /usr/lib/apt/methods/https could not be found.`

## Steam for Gaming

[Steam](http://store.steampowered.com/) is a content delivery platform, well known for distributing video games for Windows, OSX, and Linux.

Debian [offers a guide](https://wiki.debian.org/Steam) on how to install Steam.

For our purposes we only need to follow the _64-bit systems_ section.

A Debian non-free repository URL should already be setup in `/etc/apt/sources.list`, so skip step 1.

The `i386` architecture needs to be added as shown in step 2.

Lastly, Steam needs to be installed:

```bash
sudo aptitude install steam --without-recommends
```

Step 4 may be skipped as the XPS 13 does not come with a dedicated graphics card.

At this point Steam is installed on the system and can be accessed from the Applications menu.

## KeePassX

[KeePassX](https://www.keepassx.org/) is a tool for storing key/pair values securely in an encrypted vault.

Once installed, launch the application and navigate to _Tools -> Settings_ and use the following settings:
* General
	* Remember last databases
	* Remember last key files
	* Open previous databases on startup
	* Automatically save after every change
	* Use entry title to match windows for global auto-type
	* Show a system tray icon
	* Hide window to system tray when minimized
* Security
	* Clear clipboard after 30 seconds
	* Lock databases after inactivity of 300 sec
	* Always ask before performing auto-type

> KeePassX will likely be replaced with [KeePassXC](https://keepassxc.org/) at a later date once KeePassXC is available in the Debian repository.

## LinuxBrew

Navigate to the [LinuxBrew](https://github.com/Linuxbrew/brew) and install all the required packages for your Linux distribution.

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://gitlab.com/hyper-expanse/dotfiles/blob/master/README.md).

## Radio Stations

A collection of high quality, and highly recommended, radio stations. Playlists will need to be retrieved from their respective radio station websites.

* Jazz 24 - Jazz Music
* KHCB - Christian Radio (16k/11 khz)
* KUT 1 - News/Talk
* KUT 2 - Music
* Thistle Radio - Celtic Music - [Online Stream Information](http://somafm.com/thistle/)