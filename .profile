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

# Add out local info page directory to our MANPATH. This will allow the `man` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our MANPATH, our local manual pages will be used in favor of globally installed manual pages.
export MANPATH="${HOME}/.local/share/man:${MANPATH}"

# Add out local info page directory to our INFOPATH. This will allow the `info` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our INFOPATH, our local manual pages will be used in favor of globally installed manual pages.
export INFOPATH="${HOME}/.local/share/info:${INFOPATH}"

# Set Vim's runtime path so that it points to our local copy of Vim's runtime files (Runtime files are a collection of plugins, file type detection scripts, syntax highlighting scripts, etc, written by the maintainers of Vim, to be shipped along with the Vim binary.). Rather than relying on the runtime files installed as part of a system-wide installation of Vim, we download, and reference, our own local copy. That allows us to take advantage of the latest runtime files.
export VIMRUNTIME="${HOME}/.vim/runtime/"

# Provide the path to a temporary directory that may contain executable scripts so that Homebrew may use that directory for storing, and executing, installation scripts. Though Linuxbrew will use the system's temp directory by default that directory may not be executable, depending on the security measures in place on the local system.
export HOMEBREW_TEMP="${HOME}/.local/tmp"
mkdir -p "${HOME}/.local/tmp"

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
