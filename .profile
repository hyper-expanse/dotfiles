#!/usr/bin/env bash

#====================================================
# Profile Configuration
#
# This script only needs to be sourced upon logging into a system.
# Its contents configure the Bash shell environment.
#====================================================

# Set the path to our prefix directory containing our local build, and development, environment. This may be used by third-party tools as well as our own Bash scripts.
export PREFIX_DIRECTORY="${HOME}/.local"

# Add our local binary directories to our PATH. This will allow us to utilize locally installed binaries when available. Furthermore, because we prepend our local binary directory to our PATH our local binaries will be used in favor of globally-installed system binaries.
export PATH="${PREFIX_DIRECTORY}/bin:${PREFIX_DIRECTORY}/sbin:${PATH}"

# Add our local info page directory to our MANPATH. This will allow the `man` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our MANPATH, our local manual pages will be used in favor of globally installed manual pages.
export MANPATH="${PREFIX_DIRECTORY}/share/man:${MANPATH}"

# Add our local info page directory to our INFOPATH. This will allow the `info` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our INFOPATH, our local manual pages will be used in favor of globally installed manual pages.
export INFOPATH="${PREFIX_DIRECTORY}/share/info:${INFOPATH}"

# Specify the directory where `nvm` should install various versions of node and npm packages.
export NVM_DIR="${PREFIX_DIRECTORY}/var/nvm"

# Provide the path to a temporary directory that may contain executable scripts so that Homebrew may use that directory for storing, and executing, installation scripts. Though Brew will use the system's temp directory by default that directory may not be executable, depending on the security measures in place on the local system.
mkdir -p "${PREFIX_DIRECTORY}/tmp"
export HOMEBREW_TEMP="${PREFIX_DIRECTORY}/tmp"

# Set arguments that cmake should respect when it's invoked.
# CMAKE_INSTALL_PREFIX - Instruct `cmake` to use our local system directory as the installation directory for cmake-based builds.
export EXTRA_CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=${PREFIX_DIRECTORY} -DPYTHON_LIBRARY=${PREFIX_DIRECTORY}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR=${PREFIX_DIRECTORY}/include/python2.7"

# Set the default provider used by Vagrant to provision new machines.
# This setting assumes that the `vagrant-libvirt` plugin as been installed into the local vagrant installation.
export VAGRANT_DEFAULT_PROVIDER=libvirt

# Disable Brew analytics so that my usage is not reported to the Brew account on the Google Analytics platform.
export HOMEBREW_NO_ANALYTICS=1

# Set the default console editor.
export EDITOR=nvim

# Specify the language and encoding for our shell environment.
export LANG=en_US.UTF8

# Only allow the Docker client to download and use "trusted" images (Trust is associated with the `TAG` pointing to an image, where the `TAG` has been cryptographically signed).
export DOCKER_CONTENT_TRUST=1

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

# If the XDG configuration home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_CONFIG_HOME}" ]; then
	export XDG_CONFIG_HOME="${HOME}/.config"
fi

# If the XDG data home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_DATA_HOME}" ]; then
	export XDG_DATA_HOME="${PREFIX_DIRECTORY}/share"
fi

# If the XDG cache home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_DATA_HOME}" ]; then
	export XDG_DATA_HOME="${HOME}/.cache"
fi

uname=`uname -a`
debian="Debian"
if [ "${uname/$debian}" = "${uname}" ] && [ "$(uname)" = "Linux" ]; then
	export SSH_AGENT_PID=""
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
