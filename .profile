#!/usr/bin/env bash

#====================================================
# Profile Configuration
#
# This script only needs to be sourced upon logging into a system.
# Its contents configure the Bash shell environment.
#====================================================

# Source the Bash configuration file to load environment variables required by each shell.
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# Add local Node.js module directory to the beginning of our PATH so that Node.js modules pulled down by a project, through, say, NPM and package.json, can be used rather than any global Node.js modules on the system, or in the user's local bin directory. This will ensure project builds use their desired versions of Node.js modules.
export PATH="./node_modules/.bin:${PATH}"

# Add our local binary directory to our PATH. This will allow us to utilize locally installed binaries when available. Furthermore, because we prepend our local binary directory to our PATH our local binaries will be used in favor of globally-installed system binaries.
export PATH="~/.local/bin:${PATH}"

# Set the default console editor.
export EDITOR=vim

# Setup Bash prompt auto-completion for PIP; Python's package manager.
eval "`pip completion --bash`"
