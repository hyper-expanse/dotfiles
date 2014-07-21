#!/usr/bin/env bash

#====================================================
# Deploy Dotfiles
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

echo "Deploying dotfiles..."

# Symlink files to the user's home directory.
echo "> Symlinking files into the user directory (~)."
for file in `find . -type f -name '.*' -print`; do
	rm ~/${file#./} &> /dev/null
	ln -s `pwd`/${file#./} ~/${file#./}
done

# Symlink top-level directories to the user's home directory.
echo "> Symlinking directories not supported yet."
for directory  in `find . -maxdepth 1 -type d -print`; do
	if [ "${directory}" == './.git' -o "${directory}" == '.' ]; then
		continue
	fi
done

# Source the newly installed profile script to setup the user's environment.
source ${HOME}/.profile

# Pull down the Vundle repo into Vim's Bundle directory so that it's available for installing, and managing, Vim plugins.
if [ "$(type git 2> /dev/null)" ]; then
	echo "> Cloning Vundle for Vim plugin management."

	# Create the initial bundle directory that will be required for storing Vim plugins.
	mkdir -p ~/.vim/bundle/vundle

	# Clone the required Vundle plugin into the newly created bundle directory.
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle 2> /dev/null

	echo "> Installing Vim plugins through Vundle."

	# Install Vim plugins and their dependencies.
	updateVim
else
	echo "> ERROR: `git` is required for setting up Vundle, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run the deploy script."
fi

echo "Finished deploying dotfiles. Your environment has been sourced and setup. Enjoy."
