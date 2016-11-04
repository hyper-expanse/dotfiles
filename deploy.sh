#!/usr/bin/env bash

#====================================================
# Deploy Dotfiles
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

# If the XDG configuration home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_CONFIG_HOME}" ]; then
	export XDG_CONFIG_HOME="${HOME}/.config"
fi

# If the XDG data home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_DATA_HOME}" ]; then
	export XDG_DATA_HOME="${PREFIX_DIRECTORY}/share"
fi

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

# Symlink Neovim files.
echo "> Symlinking Neovim files into the config directory (${XDG_CONFIG_HOME}/nvim)."
ln --symbolic --force "$(pwd)/.config/nvim" "${XDG_CONFIG_HOME}"

# Symlink tmux files.
echo "> Symlinking tmux files into the config directory (${XDG_CONFIG_HOME}/tmux)."
ln --symbolic --force "$(pwd)/.config/tmux" "${XDG_CONFIG_HOME}"

# Symlilnk Visual Studio Code files.
echo "> Symlinking Visual Studio Code files into the config directory (${XDG_CONFIG_HOME}/Code/User)."
mkdir --parents "${HOME}/.config/Code/User"
ln --symbolic --force "$(pwd)/.config/Code/User/settings.json" "${XDG_CONFIG_HOME}/Code/User/settings.json"

# Symlink third-party scripts into the appropriate directories.
echo "> Symlinking third-party scripts into the data directory (${XDG_DATA_HOME})."
mkdir --parents "${XDG_DATA_HOME}/nvim"
ln --symbolic --force "$(pwd)/markdown2ctags/markdown2ctags.py" "${XDG_DATA_HOME}/nvim/markdown2ctags.py"

# Source the newly installed profile script to setup the user's environment.
source "${HOME}/.profile"

echo "Finished deploying dotfiles. Your environment has been sourced and setup. Enjoy."
