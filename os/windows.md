# Windows

## Chocolatey

Install the Chocolatey package manager as per their [website](https://chocolatey.org/).

Once Chocolatey is installed on your Windows system, please install the packages specified in the _Package Installation_ section.

## Package Installation

Packages:
* Calibre (E-book library manager)
* CCleaner
* Cygwin
* Dia (Diagram Editor)
* Eclipse (Download and install the C/C++ version.)
* FileZilla (FTP Client)
* Flash Player (Adobe)
* Gimp (Image Editor)
* Google Chrome Standalone Enterprise
* HexChat
* InfraRecorder (ISO Burner)
* Inkscape (Vector graphics editor)
* Java X (Oracle's Java JRE.)
* Maxima (Numerical Analysis)
* Microsoft Office
* Microsoft Security Essentials (Anti-virus tool, scanner, and quarentine manager.)
* Microsoft Visual Studio
* Mozilla Firefox
* OpenVPN (Full installation, including GUI.)
* Python 2.x 32-bit (Must install 32-bit version for Scons.)
* Python 3.x 32-bit (Must install 32-bit version for Scons.)
* Strawberry Perl (Perl interpreter and libraries.)
* Sumatra (PDF Reader)
* TortoiseGit (Revision Control Software for Git.) (When prompted choose "TortoisePLink".)
* Transmission-Qt Win (A Windows port of the Transmission common and GUI packages.)

## Optional Packages

Packages:
* SolidWorks

## Software Configuration

All Windows-based software should be configured identically to their respective software on a Linux installation.

### Google Chrome

#### Extensions

Extensions help improve on the user's experience surfing the internet by improving upon the capabilities of the Chrome browser.

Install the following extensions from the Google Chrome App Store:

* HTTPS Everywhere
* Proxy Switchy!

### Python

When prompted for the installation directory, append "-32" for the 32-bit version or "-64" for the 64-bit version.

Next we need to modify the `PATH` enironmental variable to allow for the Python interpreter, and packages, to be discoverable by Windows applications. To do this:

* Right-click _Computer_ and select _Properties_.
* In the dialog box, select _Advanced System Settings_.
* In the next dialog, select _Environment Variables_.
* In the _User Variables_ section, edit the `PATH` statement to append the following to the end of the path for each version of Python, replacing "XX" with the version of Python installed:

```
C:\\PythonXX-32;C:\\PythonXX-32\\Lib\\site-packages\\;C:\\PythonXX-32\\Scripts\\;
```

### Cygwin

Cygwin provides a Linux-like environment on the Windows platform.

#### Installation and Configuration

Download the Cygwin installer, `setup.exe`, from the official [Cygwin](http://www.cygwin.com/) homepage.

When using the setup tool for Cygwin, use the following options for the prompts:

* Choose A Download Source
	* Install from Internet.
* Select Root Install Directory
	* Root Directory: C:\\cygwin
	* Install For: All Users
* Select Local Package Directory
	* Local Package Directory: C:\\cygwin
* Select Your Internet Connection
	* Direct Connection
* Choose A Download Site
	* [CHOOSE ANY SITE]

Install all desired Cygwin packages by clicking on _Default_ next to their name to switch to _Install_.
