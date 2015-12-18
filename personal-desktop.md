# Personal Desktop

This chapter covers setting up a graphical desktop environment over a bare Debian operating system. My desktop of choice is based on the wonderful [KDE](https://www.kde.org/) desktop environment. The sections in this chapter will walk you through installing the desktop environment itself, to installing office suite applications.

## Package Installation

Before extending our system with a full desktop environment we need to install a few basic packages. These packages will be used by desktop applications that we'll install To install them, run `sudo aptitude install [PACKAGE]`.

Packages:
* clamav
* openvpn
* spamassasin

## Display Server

Packages:
* xorg: This metapackage provides the components for a standalone workstation running the X Window System.

## Window Manager

Packages:
* kwin: Compositing window manager used by KDE.

## Desktop Environments

Several major all-inclusive desktop environments are available for installation on Linux systems. Some desktop environments are ``heavier'' than others; typically coming with a larger number of default applications, and requiring the downloading of additional libraries that must be loaded at runtime.

For our purposes, we favor an environment that is based on the QT widget library. Our desktop environment of choice is therefore KDE.

In addition to providing the fundamental components required to offer a functional desktop environment, the `kde-plasma-desktop` package also include basic necessities such as a file manager, a password manager, along with other essential applicationsi. However, `kde-plasma-desktop` does **not** come with a large number of applications such as video and music players. Instead we leave it up to the user to choose what basic applications they want on their system.

When requested to install a package, use `sudo aptitude install [PACKAGE]`.

Install the basic KDE desktop package:
* kde-plasma-desktop: The KDE Plasma Desktop and minimal set of applications.

Next, install a graphical network manager:
* plasma-nm: Network Management widget for KDE Plasma workspaces.

Lastly, to support connecting to virtual prive networks we'll need two additional packages.
* network-manager-vpnc
* network-manager-openvpn

### Desktop Applications

A list of common applications to fullfill various _life_ type workflows is provided below.

Packages:
* quiterss: RSS reader.
* ark [KDE] // TODO: Future replacement - peazip-qt
* basket: Note taking and management. [KDE] // TODO: Future replacement - basqet
* calibre: E-book management library.
* calligra: Extensive productivity and creative suite. [KDE]
* clementine: Music player and library manager.
* gramps [GTK]
* gwenview: Image viewer.
* k3b: A CD/DVD ripper and burner. [KDE]
* kaddressbook: Address book and contact data manager. [KDE - Kontact]
* kate: K Advance Text Editor. [KDE]
* kcalc: Simple and scientific calculator. [KDE]
* kde-telepathy: Chat application. [KDE]
* kgpg: GNUPG graphical front-end. [KDE]
* kmail: Full featured graphical email client. [KDE - Kontact]
* kmix: Volume control and mixer. [KDE]
* kmymoney: KMyMoney is the Personal Finance Manager. [KDE]
* konversation: GUI IRC client. [KDE]
* korganizer: Calendar and personal organizer. [KDE- Kontact]
* krecipes: Recipes manager [KDE]
* ksnapshot: Screenshot capture tool. [KDE]
* kwalletmanager: Secure password waller manager. [KDE]
* luckybackup: File backup utility.
* okular: PDF viewer.
* transmission-qt: Qt front-end for the transmission instant messaging framework.

## Sounds

Our basic KDE desktop setup does not come with audio support. To enable audio for desktop applications we need to install the [pulseadio sound server](https://en.wikipedia.org/wiki/PulseAudio).

To install `pulseaudio` run the following command:

```bash
sudo aptitude install pulseaudio
```

## Network Manager

The Debian Network Manager is not configured to start automatically and manage the network interfaces. Therefore, we must first configure the Network Manager to manage all network interfaces, and then we must start the Network Manager daemon.

Edit the following file, /etc/NetworkManager/NetworkManager.conf, and enable the managed feature:

```
managed=true
```

Next, restart the Network-Manager service:

```bash
sudo /etc/init.d/network-manager restart
```

## LinuxBrew

Navigate to the [LinuxBrew](https://github.com/Homebrew/linuxbrew) and install all the required packages for your Linux distribution.

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://github.com/hbetts/dotfiles/blob/master/README.md).

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

## KeePassX

KeePassX is a tool for storing key/pair values securely in an encrypted vault.

Navigate to Extras -> Settings and use the following settings:

	General (1)
		* Show system tray icon.
		* Minimize to tray instead of taskbar.
		* Start minimized.
		* Start locked.
	General (2)
		* Automatically save database after every change.
	Security
		* Lock workspace when minimizing the main window.
		* Lock database after inactivity of [300] seconds.

 Create one, and only one, new key/pair database and give it the following name:
	* KeyDatabase.kdb

## Radio Stations

A collection of high quality, and highly recommended, radio stations. Playlists will need to be retrieved from their respective radio station websites.

* Jazz 24 - Jazz Music
* KHCB - Christian Radio (16k/11 khz)
* KUT 1 - News/Talk
* KUT 2 - Music
* Thistle Radio - Celtic Music - [Online Stream Information](http://somafm.com/thistle/)
