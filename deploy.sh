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
	export XDG_DATA_HOME="${HOME}/.local/share"
fi

echo "Deploying dotfiles..."

# Symlink files into the user's home directory.
echo "> Symlinking files into the user's home directory (${HOME})."
for file in `find . -maxdepth 1 -type f -name '.*' -print`; do
	ln -s -f "$(pwd)/${file#./}" "${HOME}/${file#./}"
done

# Symlink SSH files.
echo "> Symlinking SSH files into the SSH directory (${HOME}/.ssh)."
mkdir -p "${HOME}/.ssh"
ln -s -f "$(pwd)/.ssh/config" "${HOME}/.ssh/config"

# Symlink GNUPG files.
echo "> Symlinking GNUPG files into GNUPG directory (${HOME}/.gnupg)."
mkdir -p "${HOME}/.gnupg"
ln -s -f "$(pwd)/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -s -f "$(pwd)/.gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"

# Symlink tmux files.
echo "> Symlinking tmux files into the config directory (${XDG_CONFIG_HOME}/tmux)."
mkdir -p "${XDG_CONFIG_HOME}"
rm "${XDG_CONFIG_HOME}/tmux" &> "/dev/null"
ln -s "$(pwd)/.config/tmux" "${XDG_CONFIG_HOME}/tmux"

# Symlink Visual Studio Code files.
if [ "$(uname)" = "Darwin" ]; then
	echo "> Symlinking Visual Studio Code files into the Library directory (Library/Application Support/Code/User)."
	mkdir -p "${HOME}/Library/Application Support/Code/User"
	ln -s -f "$(pwd)/.config/Code/User/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
else
	echo "> Symlinking Visual Studio Code files into the config directory (${XDG_CONFIG_HOME}/Code/User)."
	mkdir -p "${XDG_CONFIG_HOME}/Code/User"
	ln -s -f "$(pwd)/.config/Code/User/settings.json" "${XDG_CONFIG_HOME}/Code/User/settings.json"
fi

# Symlink Vagrant configuration file.
echo "> Symlinking Vagrant configuration file into the Vagrant directory (${HOME}/.vagrant.d)."
mkdir -p "${HOME}/.vagrant.d"
ln -s -f "$(pwd)/.vagrant.d/Vagrantfile" "${HOME}/.vagrant.d/Vagrantfile"

echo "Finished deploying your dotfiles. Please run 'source ~/.profile' to use your new setup."
