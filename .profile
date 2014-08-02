#!/usr/bin/env bash

#====================================================
# Profile Configuration
#
# This script only needs to be sourced upon logging into a system.
# Its contents configure the Bash shell environment.
#====================================================

# Add local Node.js module directory to the beginning of our PATH so that Node.js modules pulled down by a project, through, say, NPM and package.json, can be used rather than any global Node.js modules on the system, or in the user's local bin directory. This will ensure project builds use their desired versions of Node.js modules.
export PATH="./node_modules/.bin:${PATH}"

# Add our local binary directory to our PATH. This will allow us to utilize locally installed binaries when available. Furthermore, because we prepend our local binary directory to our PATH our local binaries will be used in favor of globally-installed system binaries.
export PATH="${HOME}/.local/bin:${PATH}"

# Set Vim's runtime path so that it points to our local copy of Vim's runtime files (Runtime files are a collection of plugins, file type detection scripts, syntax highlighting scripts, etc, written by the maintainers of Vim, to be shipped along with the Vim binary.). Rather than relying on the runtime files installed as part of a system-wide installation of Vim, we download, and reference, our own local copy. That allows us to take advantage of the latest runtime files.
export VIMRUNTIME="${HOME}/.vim/runtime/"

# Set the default console editor.
export EDITOR=vim

# Specify the langugae and encoding for our shell environment.
export LANG=en_US.UTF8

export TERM="${TERM}" # Export what our environment already provides.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)

	# If our terminal has color support, and we're in an xterm window, modify our TERM environmental variable to indicate that it's a 256-color terminal.
	if [ "${TERM}" == "xterm" ]; then
		export TERM=xterm-256color
	fi
fi

# Source the Bash configuration file to load environment variables required by each shell.
if [ -f "${HOME}/.bashrc" ]; then
	source "${HOME}/.bashrc"
fi
