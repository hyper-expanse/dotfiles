#!/usr/bin/env bash

#====================================================
# Deploy Dotfiles
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

DIRECTORY=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Deploying dotfiles..."

# Symlink files into the user's home directory.
echo "> Symlinking files into the user's home directory (${HOME})."
for file in `find . -maxdepth 1 -type f -name '.*' -print`; do

	# Setup a symlink, per file, on Linux.
	if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		ln --symbolic --force "${DIRECTORY}/${file#./}" "${HOME}/${file#./}"

	# Setup a symlink, per file, on Windows
	elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
		# Setup symlinks on Windows (as per https://stackoverflow.com/questions/18641864/git-bash-shell-fails-to-create-symbolic-links).
		cmd <<< "mklink \"${DIRECTORY//\//\\}\${file#./}\" \"${HOME//\//\\}\${file#./}\"" > /dev/null
	fi
done

# Symlink top-level directories to the user's home directory.
echo "> Symlinking directories not supported yet."
for directory  in `find . -maxdepth 1 -type d -print`; do
	if [ "${DIRECTORY}" == './.git' -o "${DIRECTORY}" == '.' ]; then
		continue
	fi
done

# Symlink third-party scripts into appropriate directories.
echo "> Symlinking third-party scripts into the user's home directory (${HOME})."
ln --symbolic --force "$(pwd)/markdown2ctags/markdown2ctags.py" "${HOME}/.vim/markdown2ctags.py"

# Source the newly installed profile script to setup the user's environment.
source ${HOME}/.profile

# Install Vim and its environment.
setupVim

# Install Vim plugins and their dependencies.
updateVim

echo "Finished deploying dotfiles. Your environment has been sourced and setup. Enjoy."
