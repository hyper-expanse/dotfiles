#!/usr/bin/env bash

#====================================================
# Profile Configuration
#
# This script only needs to be sourced upon logging into a system.
# Its contents configure the Bash shell environment.
#====================================================

# Set the path to our prefix directory containing our local build, and development, environment. This may be used by third-party tools as well as our own Bash scripts.
export PREFIX="${HOME}/.local"

# Add local Node.js module directory to the beginning of our PATH so that Node.js modules pulled down by a project, through, say, NPM and package.json, can be used rather than any global Node.js modules on the system, or in the user's local bin directory. This will ensure project builds use their desired versions of Node.js modules.
export PATH="./node_modules/.bin:${PATH}"

# Add our local binary directory to our PATH. This will allow us to utilize locally installed binaries when available. Furthermore, because we prepend our local binary directory to our PATH our local binaries will be used in favor of globally-installed system binaries.
export PATH="${PREFIX}/bin:${PATH}"

# Add our local info page directory to our MANPATH. This will allow the `man` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our MANPATH, our local manual pages will be used in favor of globally installed manual pages.
export MANPATH="${PREFIX}/share/man:${MANPATH}"

# Add our local info page directory to our INFOPATH. This will allow the `info` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our INFOPATH, our local manual pages will be used in favor of globally installed manual pages.
export INFOPATH="${PREFIX}/share/info:${INFOPATH}"

# Add our local `rbenv` script directory to a tool specific environmental variable.
export RBENV_ROOT="${PREFIX}/var/rbenv"

# Provide the path to a temporary directory that may contain executable scripts so that Homebrew may use that directory for storing, and executing, installation scripts. Though Linuxbrew will use the system's temp directory by default that directory may not be executable, depending on the security measures in place on the local system.
mkdir -p "${PREFIX}/tmp"
export HOMEBREW_TEMP="${PREFIX}/tmp"

# Export an additional environmental variable for our Linuxbrew temp directory for use by `ruby-build`.
export TMPDIR="${HOMEBREW_TEMP}"

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

# Set color for man pages viewed in `less`, such that they are easier to read.
export LESS_TERMCAP_mb=$'\E[01;36m'
export LESS_TERMCAP_md=$'\E[01;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Source the Bash configuration file to load environment variables required by each shell.
if [ -f "${HOME}/.bashrc" ]; then
	source "${HOME}/.bashrc"
fi
