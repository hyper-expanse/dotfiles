# Personal Desktop

This chapter covers configuring a graphical desktop environment on a Windows machine. The sections in this chapter will walk you through configuring the desktop environment, to installing office suite applications.

## Desktop Applications

A list of common applications to fulfill various workflows is provided below.

### Chocolatey

Install [Chocolatey](https://chocolatey.org/).

Install the following packages using Chocolatey:
* clementine
* dia
* gpg4win
* keepassxc
* peazip
* quiterss
* sumatrapdf
* wget
* windirstat
* zoom

## Personal Dotfiles

A collection of useful automation tools, and setup scripts, are kept in a publically accessible repository for consumption by any individual that wishes to replicate the same environment I use.

Installation instructions are available in the dotfile project's [README](https://gitlab.com/hutson/dotfiles/blob/master/README.md).

## SSH Configuration

Create a new file called `~/.profile` and add the content specified under the _Auto-launching ssh-agent_ section of the [GitHub documentation on SSH keys](https://help.github.com/articles/working-with-ssh-key-passphrases/#auto-launching-ssh-agent-on-git-for-windows)

Next, execute the following command to add your private key to the SSH Agent so that the agent can use that private key when establishing connections to remote servers:

```bash
ssh-add ~/.ssh/id_rsa
```

> **Note:** This only needs to be done the first time you've setup the script. The script will execute `ssh-add` for you in the future.

## Vagrant

[Vagrant](https://www.vagrantup.com/) is a tool for configuring reproducible and portable development environments using one of several provisioning tools, such as virtual machines through libvirt, or docker containers.

To use Vagrant you will first need to install the `vagrant` package through `chocolatey`:
* vagrant

Lastly, we need a virtual machine manager to run our virtual machines. On Windows we'll use [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Install the `virtualbox` package through `chocolatey`:
* virtualbox

Lastly, you will need to install `cwrsync` so that you have access to a Rsync-compatible command line tool for synchronizing files between the local host and the remote virtual machine.
* cwrsync

For vagrant to correct rsync files from the host machine to the remote virtual machine, the source code for Vagrant needs to be modified. Open the following file in an editor that has been opened with Administrator permissions:
* `C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-<VERSION>\plugins\synced_folders\rsync\helper.rb`

Replace `<VERSION>` with the version of your Vagrant installation. Once you have that file opened, change the following line:

```
if Vagrant::Util::Platform.windows?
  # rsync for Windows expects cygwin style paths, always.
  hostpath = Vagrant::Util::Platform.cygwin_path(hostpath)
end
```

To:

```
if Vagrant::Util::Platform.windows?
  # rsync for Windows expects cygwin style paths, always.
  hostpath = "/cygdrive" + Vagrant::Util::Platform.cygwin_path(hostpath)
end
```

Once Vagrant has been installed on the system, you will need to install the `vagrant-vbguest` add-on. This add-on will install [VirtualBox guest additions](https://www.virtualbox.org/manual/ch04.html) into the guess virtual machine, which will allow us to take advatage of advance VirtualBox features; such as sharing folders between host and guest machines.

```bash
vagrant plugin install vagrant-vbguest
```

> Make sure to update Vagrant plugins on a regular basis with `vagrant plugins update.

As described in the [Vagrantfile documentation](https://www.vagrantup.com/docs/vagrantfile/), the contents of the `Vagrantfile` file in `~/.vagrant.d` act as defaults for project-specific `Vagrantfile` files.

## GPG Keys

Using the _Kleopatra_ application, create a new encryption key. (Please follow the [Security Policies](../tips/security-policies.md).)

## Integrated Development Environment

[Visual Studio Code](https://code.visualstudio.com/), Microsoft's free and open source code editor, is a solid tool, though simple compared to more feature rich IDE platforms, for writing, organizing, testing, and debugging software.

To install Visual Studio Code, navigate to the [Visual Studio Code download page](https://code.visualstudio.com/Download), and download the appropriate installer for Windows.

Once Visual Studio Code has been downloaded, open up _File Explorer_, navigate into your _Downloads_ directory, and run the installer.
