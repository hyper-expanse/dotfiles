#!/usr/bin/env bash

#====================================================
# Deploy Dotfiles
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

echo "Deploying dotfiles..."

# Symlink files into the user's home directory.
echo "> Symlinking files into the user's home directory (${HOME})."
for file in `find . -maxdepth 1 -type f -name '.*' -print`; do
	ln --symbolic --force "$(pwd)/${file#./}" "${HOME}/${file#./}"
done

# Symlink top-level directories to the user's home directory.
echo "> Symlinking directories not supported yet."
for directory  in `find . -maxdepth 1 -type d -print`; do
	if [ "${directory}" == './.git' -o "${directory}" == '.' ]; then
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
