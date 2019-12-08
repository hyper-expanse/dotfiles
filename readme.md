# dotfiles

This repository contains a collection of configuration files used by various tools to establish expected, and desired, functionality. These dotfiles are predominately written for tools used in a POSIX-compliant shell environment.

## Installation

Installation is as simple as copying these files into your home directory, or extracting a copy of the repository into a suitable location and then creating symlinks from the repository files into your home directory.

First, pull down, and then extract, a copy of the repository into a hidden dotfiles directory.

```bash
curl -L https://github.com/hyper-expanse/dotfiles/archive/master.zip -o "/tmp/dotfiles.zip"
unzip /tmp/dotfiles.zip && mv dotfiles-master .dotfiles
rm "/tmp/dotfiles.tar.gz"
```

Navigate into the `${HOME}/.dotfiles` directory. Once there, run the deployment script to symlink the files into your home directory. The symbolic links will have names matching the names of the files in the repository.

```bash
bash deploy.sh
```

If on Linux, navigate to the [Homebrew for Linux](https://docs.brew.sh/Homebrew-on-Linux) website and install all the required packages for your Linux distribution.

If using macOS, navigate to the [Homebrew](https://github.com/Linuxbrew/brew) website and install all the required packages for your Linux distribution. Then run `git` on the Terminal once, and follow the instructions to install Apple's Developer Tools. This will ensure `git` is available for use by Homebrew, when we use Homebrew to install both command line tools and applications.

Once deployed the `${HOME}/.profile` script will need to be sourced, just once, to expose the scripts contained within the dotfiles repository. To source the profile script run the following command:

```bash
source ~/.profile
```
