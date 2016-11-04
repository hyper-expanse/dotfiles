# dotfiles

This repository contains a collection of configuration files used by various tools to establish expected, and desired, functionality. These dotfiles are predominately written for tools used in a POSIX-compliant shell environment.

## Installation

Installation is as simple as copying these files into your home directory, or extracting a copy of the repository into a suitable location and then creating symlinks from the repository files into your home directory.

First, pull down, and then extract, a copy of the repository into a hidden dotfiles directory.

```bash
wget https://gitlab.com/hyper-expanse/dotfiles/repository/archive.tar.gz?ref=master -O "/tmp/dotfiles.tar.gz"
mkdir "${HOME}/.dotfiles"
tar -xf "/tmp/dotfiles.tar.gz" -C "${HOME}/.dotfiles/" --strip-components=1
rm "/tmp/dotfiles.tar.gz"
```

Navigate into the `${HOME}/.dotfiles` directory. Once there, run the deployment script to symlink the files into your home directory. The symbolic links will have names matching the names of the files in the repository.

```bash
bash deploy.sh
```

Once deployed the `${HOME}/.profile` script will need to be sourced, just once, to expose the scripts contained within the dotfiles repository. To source the profile script run the following command:

```bash
source ~/.profile
```

## Guides

### Tmux

* General reference for Tmux: http://stevehhh.com/tmux-quick-reference/
* TMUX Cheat Sheet: https://gist.github.com/afair/3489752

### Vim

* http://tnerual.eriogerg.free.fr/vim.html
* http://michael.peopleofhonoronly.com/vim/
