# Personal Desktop

## Package Installation

Packages:
* clamav
* clamav-daemon
* gir1.2-farstream-0.1: Audio/Video communications framework: GObject-Introspection. (Required for GTalk in Telepathy)
* gstreamer0.10-ffmpeg: FFmpeg plugin for GStreamer. (Required for GTalk in Telepathy)
* gstreamer1.0-plugins-bad: GStreamer plugins from the ``bad'' set. (Required for GTalk in Telepathy)
* gstreamer1.0-plugins-ugly: GStreamer plugins from the ``ugly'' set. (Required for GTalk in Telepathy)
* hunspell-en-us
* network-manager-vpnc
* network-manager-openvpn
* openvpn
* spamassasin
* telepathy-gabble: Required to connect to Jabber networks, such as Google Talk.
* telepathy-haze: Required to connecto to Jabber networks, such as Google Talk.
* telepathy-logger: Required for proper instant messaging.

## Display Server

Packages:
* xorg: This metapackage provides the components for a standalone workstation running the X Window System.

## Display Manager

Packages:
* lightdm: A light weight display manager providing a greeter screen, login functionality, and remote desktop support.
* policykit-1: Required by the system for authentication and policy management. Used by lightdm to gain access to core system functionality such as Shutdown/Restart (Without it you cannot shutdown or restart the system from the main desktop menu.).

Additional Packages - KDE
* lightdm-kde-greeter

Additional Packages - Qt
* lightdm-qt-greeter

## Window Manager

Packages:
* openbox: Standards compliant, fast, light-weight, extensible window manager.

or

Packages:
* kwin: Compositing window manager used by KDE.

## Desktop Environments

Several major all-inclusive desktop environments are available for installation on Linux systems. Some desktop environments are ``heavier'' than others; typically coming with a larger number of default applications, and requiring the downloading of additional libraries that must be loaded at runtime.

Furthermore, desktop environments are built on two major widget libraries, QT and GNOME.

For our purposes, we favor an environment that is based on the QT widget library.

### Qt-Based

Desktop environments based on the QT widget libraries.

In the last section, \autoref{sec:personal-desktop-desktop-environments-qt-based-desktop-environments-desktop-applications}, we provide a list of applications which are built using either the QT widget libraries or a superset of QT and KDE libraries.

#### KDE

In addition to providing the fundamental components required to offer a functional desktop environment, the kde-plasma-desktop package also include basic necessities such as a file manager, a password manager, along with other essential applicationsi. However, kde-plasma-desktop does NOT come with a large number of basic applications such as video and music player. Instead we leave it up to the user to choose what basic applications they want on their system.

Packages:
* kde-plasma-desktop: The KDE Plasma Desktop and minimal set of applications.

#### Desktop Applications

Packages:
* akregator: RSS feader. [KDE - Kontact] // TODO: Future replacement - quiterss
* ark: Archive utility. [KDE] // TODO: Future replacement - peazip-qt
* basket: Note taking and management. [KDE] // TODO: Future replacement - basqet
* calibre: E-book management library.
* calligra: Extensive productivity and creative suite. [Currently KDE]
* clementine: Music player and library manager.
* digiKam: Picture/video library. [KDE]
// * dragonplayer: Simple video player.
* gnuplot-qt: Portable command-line driven interactive data and function plotting utility that supports lots of output formats.
* gramps [GTK - Seems minimal enough to safely install on a KDE system.]
* gwenview: Image viewer. [KDE]
// * juk: Music jukebox and player. [KDE]
* kaddressbook: Address book and contact data manager. [KDE - Kontact]
* kate: K Advance Text Editor. [KDE]
* kcalc: Simple and scientific calculator. [KDE]
* kde-telepathy: IM application. [KDE]
* kdeplasma-addons: Addons for the Plasma desktop. [KDE - Plasma Desktop]
* keepassx: Password manager.
* kgpg: GNUPG graphical front-end. [KDE]
// * khelpcenter4: Help center. [KDE]
* kmail: Full featured graphical email client. [KDE - Kontact]
* kmix: Volume control and mixer. [KDE]
* kmymoney: KMyMoney is the Personal Finance Manager. [KDE]
// * knotes: Stickey notes applications. [KDE]
// * kopete: Instant messaging and chat application. [KDE]
* korganizer: Calendar and personal organizer. [KDE- Kontact]
* krecipes: Recipes manager [KDE]
// * kscreensaver: Additional screensaver for KScreenSaver. [KDE]
* ksnapshot: Screen capture tool. [KDE]
* kwalletmanager: Secure password waller manager. [KDE]
* okular: Universal document viewer. [KDE]
* partitionmanager: Partition editor and manager. [KDE]
* plasma-desktopthemes-artwork: Desktop themes for KDE Plasma Workspaces. [KDE]
* plasma-widget-networkmanagement: Network Management widget for KDE Plasma workspaces. [KDE]
// * sweeper: History and temporary file cleaner. [KDE]
* smplayer: MPLayer front-end.
* polit-kde-1: Required for proper mounting of encrypted external drives. [KDE]
* transmission-qt
* unetbootin: Installer of Linux/BSD distributions to a partition or USB drive.
* virtuoso-server

### GTK-based

#### GNOME

Packages:
* chromium
* dia
* gpredict
* gimp
* gourmet
* gnucash
* gnucash-*
* gramps
* handbrake-gtk
* inkscape
* liferea
* nautilus-clamscan
* pgadmin3
* seahorse
* shotwell
* rhythmbox
* virt-manager

### Other

These packages can be installed regardless of the Desktop Environment that is installed.

Packages:
* bibus

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

## GNUPG

GNUPG allows for the creation and management of encryption keys following the public/private key model.

Remove all default key servers using GNUPG's graphical interface (which will be be determined by the desktop environment used) as they don't provide a secure means to request keys from a public key server.

Create the .gnupg/gpg.conf configuratio file required by GPG clients:

\lstinputlisting{src/home/.gnupg/gpg.conf}

Next, create the configuration file, ~/.gnupg/gpg-agent.conf, for the GPG Agent:

\lstinputlisting{src/home/.gnu/gpg-agent.conf}

### KDE Configuration

KDE Desktop Environment does not initialize a GPG Agent automatically when users login. Instead, and shell script must be created, marked as executable, and placed into KDE's configuration director to be called automatically when a user logs in.

Create the KDE executable script, ~/.kde/env/gpg-agent.sh, that will start a GPG Agent when logging in:

\lstinputlisting{src/home/.kde/env/gpg-agent.sh}

Mark the file as executable:

```bash
chmod +x ~/.kde/env/gpg-agent.sh
```

Create the KDE executable script that will terminate the GPG Agent when logging out of a KDE session:

\lstinputlisting{src/home/.kde/shutdown/gpg-agent.sh}

Mark the file as executable:

```bash
chmod +x ~/.kde/shutdown/gpg-agent.sh
```

In addition to configuring KDE to start a GPG Agent when logging in, we must also install a software package that will provide the password prompt required by the GPG Agent to open GPG keys.

#### Package Installation

Packages:
* pinentry-qt4

### Generating Key

Set all newly created keys with an expiration date 10 years in the future. Set all sub-keys with an expiration date 1 year in the future and then set a calendar event as a reminder when the sub-key needs to be renewed.

Next, generate the actual key.

After creating and configuring a key, create a revocation certificate so that the key can later be revoke if it is compromised. If the key becomes compromised, this revocation certificate must be published on key servers to notify everyone that they should no longer use the key. You can do this with the following command:

```bash
gpg --output revoke.asc --gen-revoke <keyid>
```

## Office Suite

Better than OpenOffice and LibreOffice alternatives since Calligra is written in C++, and only depends on QT and KDE libraries, rather than a Java Runtime Environment.

### Package Installation

Packages:
* calligra

## Mail Setup

### Spam Filter Setup - OPTIONAL

Spamassassin is responsible for filtering e-mail when requested by an e-mail client. It learns a set of filtering rules as established by user filtered junk mail.

**Note:** This section only needs to be followed if the mail application used will be using Spamassassin in daemon-mode rather than directly. Kmail uses Spamassassin directly, and therefore this section is not required.

Edit `/etc/default/spamassassin` and set the zeros, `0`, to ones, `1`.

Start the SpamAssassin service:

```bash
sudo /etc/init.d/spamassassin start
```

### ClamAV Filter Setup - OPTIONAL

ClamAV can be used for scanning e-mail attachments for standard Windows virus' based on virus signatures.

**Note:** This section only needs to be followed if the mail application used will be using ClamAV in daemon-mode rather than directly. Kmail uses ClamAV directly, and therefore this section is not required.

Create a filtering script at `~/.clamav-filter`:

\lstinputlisting{src/home/.clamav-filter}

Add a message filter to Evolution that filters all e-mail by this script and moves detected viruses (a return of 1) to a Virus folder.

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

## Calibre

### Add Books

Script to update the Calibre library.

```bash
calibredb add --one-book-per-directory -r generated/
```

## Radio Stations

A collection of highly suggested radio stations to be added to Rhythmbox. The actual playlist URIs will need to be retrieved from the respective radio station websites. Radio stations given in the list below is also indicative of the names that should be used in Rhythmbox.
* Absolute Classic Rock (Broadband)
* Absolute Classic Rock (Modem)
* Chinese Ministry (KHCB) (32Kbps, 24kHz)
* KHCB: Christian Radio (16k/11 khz)
* KUT 1 - News/Talk
* KUT 2 - Music
* ThistleRadio - Celtic

## Browser

### Plugins

Install the following plugins:
* HTTPS Everywhere - Electronic Frontier Foundation

## Taskbar Modifications

Additional changes need to be made to the taskbar to enhance the working experience.

Add Chromium to the task bar.

Then right click and add the following right before ``%U'' in the Command input option:

```
--incognito
```

## Performance Improvements

### Preload Applications

Preload is a daemon that runs continously in the background monitoring and gathering usage information. With usage information Preload and cache binaries of the most widely used applications in memory, effectively pre-fetching those applications are most used. By caching application in memory the reponsiveness of the system can be improved.

Preload is not meant to improve boot time of the system. It is intended to improve the loading of large desktop applications by leveraging the available RAM on the system. To accomplish this, Preload polls running applications every 'cycle' and tracks those applications that consist of binaries larger than a particular size.

#### Package Installation

Packages:
* preload

### Disable Services

Disable the following services, thereby preventing them from loading at boot time.

```bash
sudo update-rc.d -f clamav-daemon disable
sudo update-rc.d -f snmpd disable
sudo update-rc.d -f tor disable
```

## DVD Managements

### Package Installation

Packages:
* gddrescue: GNU data recovery tool.
* dvdbackup: Tool to rip DVD's from the command line.

### libdvdcss Package

Download the latest version of the libdvdcss Debian package from the following website to the ~/Download folder:

http://www.videolan.org/developers/libdvdcss.html

```bash
sudo dpkg --install ~/Downloads/[PACKAGE NAME]
```

Packages:
* libdvdcss2: To allow applications to access some of the more advanced features of the DVD format.

## Space - OPTIONAL

Optional applications that focus on space.

### Package Installation

Packages:
* celestia
* stellarium

## Numerical Analysis - OPTIONAL

### Package Installation

Packages:
* maxima
* python-matplotlib
* python-numpy
* python-scipy
* python-sympy
* python-rpy2
* python-xlrd
* r-recommended
