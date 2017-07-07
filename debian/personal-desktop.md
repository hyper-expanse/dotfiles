# Personal Desktop

This chapter covers setting up a graphical desktop environment over a bare Debian operating system. My desktop of choice is the wonderful [KDE](https://www.kde.org/) desktop environment. Sections in this chapter will walk you through installing the desktop environment and various applications to meet your daily needs.

## Package Installation

Before extending our system with a full desktop environment we need to install a few basic packages. These packages will be used by desktop applications that we'll install later.

To install the following packages run `sudo aptitude install [PACKAGE]`.

Packages:
* clamav
* openvpn
* spamassasin

## Display Server

To install them, run `sudo aptitude install [PACKAGE]`.

Packages:
* xorg: This metapackage provides the components for a standalone workstation running the X Window System.
* mesa-utils

> `mesa-utils` includes a command line tool called `glxinfo` that can display information about the OpenGL and GLX implementations employed by the running X display server. (For example, executing `glxinfo | grep OpenGL` will provide information on whether your system is using OpenGL for rendering.)

## Window Manager

To install the following packages run `sudo aptitude install [PACKAGE]`.

Packages:
* kwin-x11: Compositing window manager used by KDE.

## Desktop Environment

In addition to providing the fundamental components required to offer a functional desktop environment, the `kde-plasma-desktop` package also include basic necessities such as a file manager, and a password manager. However, `kde-plasma-desktop` does **not** come with a large number of applications, such as video and music players. Instead we leave it up to the user to choose what basic applications they want on their system.

To install the following packages run `sudo aptitude install [PACKAGE]`.

Packages:
* kde-plasma-desktop: The KDE Plasma desktop and minimal set of applications.
* plasma-nm: Network Management widget for KDE Plasma workspaces.
* network-manager-openvpn: Support for connecting to virtual private networks.

### Desktop Applications

A list of common applications to fulfill various workflows is provided below.

To install the following packages run `sudo aptitude install [PACKAGE]`.

Packages:
* ark: Archive tool.
* basket: Note taking. [KDE]
* calibre: E-book library manager.
* clementine: Music player and library manager.
* gramps: Genealogy tool. [GTK]
* gwenview: Image viewer. [KDE]
* k3b: A CD/DVD ripper and burner. [KDE]
* kaddressbook: Address book and contact data manager. [KDE - Kontact]
* kcalc: Simple and scientific calculator. [KDE]
* keepassx: Offline password and secrets manager.
* kgpg: GNUPG graphical front-end. [KDE]
* kmail: E-mail client. [KDE - Kontact]
* kmix: Volume control and mixer. [KDE]
* korganizer: Calendar and personal organizer. [KDE- Kontact]
* kde-spectacle: Screenshot capture tool. [KDE]
* luckybackup: File backup utility.
* okular: PDF viewer. [KDE]
* quiterss: RSS/ATOM reader.
* transmission-qt: Qt front-end for the Transmission BitTorrent client.

### KeePassX

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

## Sounds

Our basic KDE desktop setup does not come with audio support. To enable audio for desktop applications we need to install the [pulseadio sound server](https://en.wikipedia.org/wiki/PulseAudio).

To install the following packages run `sudo aptitude install [PACKAGE]`.

Packages:
* pulseaudio

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

## Vagrant

[Vagrant](https://www.vagrantup.com/) is a tool for configuring reproducible and portable development environments using one of several provisioning tools, such as virtual machines through libvirt, or docker containers.

First install `vagrant` by downloading the appropriate Debian package, based on your architecture, from the [Vagrant Download Page](https://www.vagrantup.com/downloads.html), and using the following command to install the downloaded package:
* `sudo dpkg --install [FILE NAME]`

Next install the [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) plugin so that `vagrant` can provision virtual machines through `libvirt`.

To install `vagrant-libvirt`, navigate to their [Installation Guide](https://github.com/vagrant-libvirt/vagrant-libvirt#installation).

> Please ensure you replace command line calls made to `apt-get` with calls to `aptitude` using `sudo`.

You'll first want to skip down to the section about _Possible problems_, as this section lists additional packages that may be required to correctly compile the plugin's primary dependencies. Install the packages listed for _Ubuntu/Debian_.

Once those packages are installed, scroll back up to the list of primary dependencies and install the packages listed under _Ubuntu/Debian_.

Once `vagrant-libvirt` has been installed, have vagrant install the plugin:
* `vagrant plugin install vagrant-libvirt`

To monitor virtual machines on your system outside of Vagrant, install `virt-manager`, a graphical tool for visualizing virtual machine resources.
* virt-manager

### Libvirt User

Using any `vagrant` command that modifies the state of a `libvirt` managed machine will require you to enter your password to authenticate.

To avoid the authentication prompt simply add yourself to the `libvirt` user group:
* `sudo usermod -G libvirt -a ${USER}`

## Docker

This section is a modification of the instructions on [Docker's Debian CE](https://docs.docker.com/engine/installation/linux/docker-ce/debian/) site.

Add Docker's official GPG key:

```bash
curl -sSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

Verify the integrity of the key:

```bash
sudo apt-key fingerprint
```

Then look for the following key in the output:

```bash
pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
```

To install the latest version of Docker we need to add Docker's repository to our `apt-get` list of Debian package repositories.

Add the following to a file named `docker.list` in the `/etc/apt/sources.list.d/` directory:

```
deb [arch=amd64] https://download.docker.com/linux/debian jessie stable
```

Then instruct Aptitude to fetch all packages available within that repository:

```bash
sudo aptitude update
```

Install the latest version of Docker CE:

```bash
sudo aptitude install docker-ce
```

## LinuxBrew

Navigate to the [LinuxBrew](https://github.com/Linuxbrew/brew) and install all the required packages for your Linux distribution.

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://gitlab.com/hyper-expanse/dotfiles/blob/master/README.md).

## GNUPG

GNUPG allows for the creation and management of encryption keys following the public/private key model.

Remove all default key servers using GNUPG's graphical interface (which will be be determined by the desktop environment used) as they don't provide a secure means to request keys from a public key server.

Create the `~/.gnupg/gpg.conf` configuration file required by GPG clients (Available from my [dotfiles]() project).

Next, create the configuration file `~/.gnupg/gpg-agent.conf` for the GPG Agent (Available from my [dotfiles]() project).

### Generating Key

Set all newly created keys with an expiration date 10 years in the future. Set all sub-keys with an expiration date 1 year in the future and then set a calendar event as a reminder when the sub-key needs to be renewed.

Next, generate the actual key.

After creating and configuring a key, create a revocation certificate so that the key can later be revoke if it is compromised. If the key becomes compromised, this revocation certificate must be published on key servers to notify everyone that they should no longer use the key. You can do this with the following command:

```bash
gpg --output revoke.asc --gen-revoke <keyid>
```

## Steam for Gaming

[Steam](http://store.steampowered.com/) is a content delivery platform, well known for distributing video games for Windows, OSX, and Linux.

Debian [offers a guide](https://wiki.debian.org/Steam) on how to install Steam.

For our purposes we only need to follow the _64-bit systems_ section.

A Debian non-free repository URL should already be setup in `/etc/apt/sources.list`, so skip step 1.

The `i386` architecture needs to be added as shown in step 2.

Lastly, Steam needs to be installed:

```bash
sudo aptitude install steam
```

Step 4 may be skipped as the XPS 13 does not come with a dedicated graphics card.

At this point Steam is installed on the system and can be accessed from the Applications menu.

## Radio Stations

A collection of high quality, and highly recommended, radio stations. Playlists will need to be retrieved from their respective radio station websites.

* Jazz 24 - Jazz Music
* KHCB - Christian Radio (16k/11 khz)
* KUT 1 - News/Talk
* KUT 2 - Music
* Thistle Radio - Celtic Music - [Online Stream Information](http://somafm.com/thistle/)

## Integrated Development Environment

[Visual Studio Code](https://code.visualstudio.com/), Microsoft's free and open source code editor is a fantastic tool for writing, organizing, testing, and debugging software.

To install Visual Studio Code, navigate to the [Visual Studio Code download page](https://code.visualstudio.com/Download), and download the appropriate Debian package for your architecture.

Next, open a command line window, navigate into the folder containing the downloaded package, and run the following command, replacing `[FILE NAME]` with the name of the file you downloaded:
* `sudo dpkg --install [FILE NAME]`

Visual Studio Code's package will automatically add its own package repository to your system's list of repositories. That ensures future updates of your system will also install the latest version of Visual Studio Code.

Because Visual Studio's package repository uses HTTPS, one additional system-level package will need to be installed.

```bash
sudo aptitude install apt-transport-https
```

Without `apt-transport-https` installed, attempts to update Visual Studio Code will result in the following error - `The method driver /usr/lib/apt/methods/https could not be found.`
