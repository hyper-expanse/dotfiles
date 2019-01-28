# Personal Desktop

This chapter covers setting up a graphical desktop environment over a standard macOS operating system. Sections in this chapter will walk you through configuring the desktop environment and installing various applications to meet your daily needs.

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://gitlab.com/hyper-expanse/dotfiles/blob/master/README.md).

## Changing The Default Shell

To properly setup Bash, the version installed through Homebrew, run the following command:

```bash
sudo bash -c 'echo [HOMEBREW PATH]/bin/bash >> /etc/shells'
```

> **Note:** Please replace `[HOMEBREW PATH]` with the location of the Homebrew installation. Default install location for Homebrew is `/usr/local`, unless you specifically chose a different location.

Once the brew installed Bash has been added to the list of allowed shells, your user account must be setup to use that version of Bash as the default:

```bash
chsh -s [HOMEBREW PATH]/bin/bash
```

## Setup Visual Studio Code

Please follow the _Launching from the Command Line_ section of the [Visual Studio Code on macOS](https://code.visualstudio.com/docs/setup/mac) guide to expose Visual Studio Code as a command line tool.

## 2nd Factor Login (YubiKey)

> It's strongly encouraged to setup two YubiKeys with your macOS laptop, where one is kept in a safe location as a backup.

> These instructions are for YubiKey, though other smartcard/challenge-response hardware keys may work with macOS.

Follow the _Setting Up Your YubiKey and Pairing with macOS_ section in [_Using Your YubiKey as a Smart Card in macOS_](https://support.yubico.com/support/solutions/articles/15000006468) to configure the YubiKey as a smart card to enable you to log into your macOS with either your password or YubiKey.
- The _YubiKey PIV Manager_, required in this setup guide, was installed through Homebrew in the _Personal Dotfiles_ section above.

Though YubiKey may be used in place of a password at login, it's only an alternative to the password. A password may still be used.

To enforce the use of your YubiKey, please follow the [_macOS Logon Tool Configuration Guide_](https://support.yubico.com/support/solutions/articles/15000015045-macos-logon-tool-configuration-guide).
- The _YubiKey Manager_, required in this setup guide, was installed through Homebrew in the _Personal Dotfiles_ section above.
- You will need to manually install [Yubico-PAM](https://www.yubico.com/products/services-software/download/computer-logon-tools/).
