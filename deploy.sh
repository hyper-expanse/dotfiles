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
find . -maxdepth 1 -type f -name '.*' -exec ln -s -f "$(pwd)/{}" "${HOME}/{}" \;

# Symlink SSH files.
# Note: Must set `.ssh` directory to 700 to protect files and because some programs may throw a permission error if they see a globally readable symlink file (Which is unavoidable) in the `.ssh` directory. Setting the directory's permissions to be more restrictive usually avoids the error.
echo "> Symlinking SSH files into the SSH directory (${HOME}/.ssh)."
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"
ln -s -f "$(pwd)/.ssh/config" "${HOME}/.ssh/config"

# Symlink GNUPG files.
echo "> Symlinking GNUPG files into GNUPG directory (${HOME}/.gnupg)."
mkdir -p "${HOME}/.gnupg"
ln -s -f "$(pwd)/.gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -s -f "$(pwd)/.gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"

# Symlink Neovim configuration files.
echo "> Symlinking Neovim files into the config directory (${XDG_CONFIG_HOME}/nvim)."
mkdir -p "${XDG_CONFIG_HOME}/nvim"
ln -s -f "$(pwd)/.config/nvim/init.vim" "${XDG_CONFIG_HOME}/nvim/init.vim"

# Symlink Powerline files.
echo "> Symlinking powerline files into the config directory (${XDG_CONFIG_HOME}/powerline)."
mkdir -p "${XDG_CONFIG_HOME}"
rm "${XDG_CONFIG_HOME}/powerline" &> "/dev/null"
ln -s -f "$(pwd)/.config/powerline" "${XDG_CONFIG_HOME}/powerline"

# Symlink Visual Studio Code files.
if [ "$(uname)" = "Darwin" ]; then
	echo "> Symlinking Visual Studio Code files into the Library directory (Library/Application Support/Code/User)."
	mkdir -p "${HOME}/Library/Application Support/Code/User"
	ln -s -f "$(pwd)/.config/Code/User/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
fi

# Symlink Konsole files.
if [ "$(uname -n)" == "startopia" ]; then
	echo "> Symlinking Konsole files."
	mkdir -p "${XDG_CONFIG_HOME}"
	mkdir -p "${XDG_DATA_HOME}/konsole"
	ln -s -f "$(pwd)/.config/konsolerc" "${XDG_CONFIG_HOME}/konsolerc"
	ln -s -f "$(pwd)/icons/noun_1058899_edited_white.png" "${XDG_DATA_HOME}/konsole/noun_1058899_edited_white.png"
	ln -s -f "$(pwd)/konsole/hutson.profile" "${XDG_DATA_HOME}/konsole/hutson.profile"
fi

echo "Finished deploying your dotfiles. Please run 'source ~/.profile' to use your new setup."
