#!/usr/bin/env bash

#====================================================
# Deploy Dotfiles
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

echo "Deploying dotfiles..."

# Make sure any submodules have been pulled down (in case the user did not clone this repository using `--recursive`).
git submodule update --init --recursive &> /dev/null

# Symlink files into the user's home directory.
echo "> Symlinking files into the user's home directory (${HOME})."
for file in `find . -maxdepth 1 -type f -name '.*' -print`; do
	ln --symbolic --force "$(pwd)/${file#./}" "${HOME}/${file#./}"
done

# Symlink SSH files.
echo "> Symlinking SSH files into the SSH directory (${HOME}/.ssh)."
mkdir --parents "${HOME}/.ssh"
ln --symbolic --force "$(pwd)/.ssh/config" "${HOME}/.ssh/config"

# Symlink GNUPG files.
echo "> Symlinking GNUPG files into GNUPG directory (${HOME}/.gnupg)."
mkdir --parents "${HOME}/.gnupg"
ln --symbolic --force "$(pwd)/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln --symbolic --force "$(pwd)/.gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"

# Symlink NeoVim/Vim files.
echo "> Symlinking NeoVim/Vim files into config directory (${HOME}/.config/nvim)."
mkdir --parents "${HOME}/.config/nvim"
ln --symbolic --force "$(pwd)/.config/nvim/init.vim" "${HOME}/.config/nvim/init.vim"
ln --symbolic --force "$(pwd)/.config/nvim/init.vim" "${HOME}/.vimrc"

# Symlink third-party scripts into the appropriate directories.
echo "> Symlinking third-party scripts into the user's home directory (${HOME})."
mkdir --parents "${HOME}/.vim"
ln --symbolic --force "$(pwd)/markdown2ctags/markdown2ctags.py" "${HOME}/.vim/markdown2ctags.py"

# Source the newly installed profile script to setup the user's environment.
source "${HOME}/.profile"

echo "Finished deploying dotfiles. Your environment has been sourced and setup. Enjoy."
