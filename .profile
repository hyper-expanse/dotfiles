#!/usr/bin/env bash

#====================================================
# Profile Configuration
#
# This script only needs to be sourced upon logging into a system.
# Its contents configure the Bash shell environment.
#====================================================

# Set the path to our local storage directory.
export PREFIX_DIRECTORY="${HOME}/.local"

# Set the path to our prefix directory containing our local build, and development, environment as setup by Linuxbrew.
export HOMEBREW_PREFIX="${HOME}/.linuxbrew";
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew";

# Add our local binary directories to our PATH. This will allow us to utilize locally installed binaries when available. Furthermore, because we prepend our local binary directory to our PATH our local binaries will be used in favor of globally-installed system binaries.
# Adding `/opt/python/libexec/` to path so that `python` and `pip` point to Python 3, and pip 3, respectively, instead of Python 2.
export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/opt/python/libexec/bin:${HOME}/Applications:${PATH}"

# Add our local info page directory to our MANPATH. This will allow the `man` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our MANPATH, our local manual pages will be used in favor of globally installed manual pages.
export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH:-}"

# Add our local info page directory to our INFOPATH. This will allow the `info` utility to load manual pages from our local manual directory. Furthermore, because we prepend our local manual directory to our INFOPATH, our local manual pages will be used in favor of globally installed manual pages.
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"

# Specify the directory where `nvm` should install various versions of node and npm packages.
export NVM_DIR="${PREFIX_DIRECTORY}/var/nvm"

# Inform `pkg-config` of additional pkgconfig metadata available from our brew installation.
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/lib/pkgconfig/:${HOMEBREW_PREFIX}/share/pkgconfig/:${PKG_CONFIG_PATH}"

# Disable Brew analytics so that my usage is not reported to the Brew account on the Google Analytics platform.
export HOMEBREW_NO_ANALYTICS=1

# Set the default console editor.
export EDITOR=nvim

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
if [ -z "${XDG_CONFIG_HOME:-}" ]; then
	export XDG_CONFIG_HOME="${HOME}/.config"
fi

# If the XDG data home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_DATA_HOME:-}" ]; then
	export XDG_DATA_HOME="${PREFIX_DIRECTORY}/share"
fi

# If the XDG cache home directory is not already set within the current environment, then default it to the value below, which matches the XDG specification.
if [ -z "${XDG_CACHE_HOME:-}" ]; then
	export XDG_CACHE_HOME="${HOME}/.cache"
fi

# Start our GPG agent so that it can begin responding to requests for a private key (SSH or signing requests), but only from the local system.
if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
	SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
	export SSH_AUTH_SOCK
	gpgconf --launch gpg-agent
fi

if [ "$(uname -n)" == "startopia" ]; then
	# Disable the prompt from AppImage binaries that ask to integrate with your desktop environment.
	# Asking to integrate with the desktop environment does not work natively with KDE Plasma.
	mkdir -p "${PREFIX_DIRECTORY}/share/appimagekit/"
	touch "${PREFIX_DIRECTORY}/share/appimagekit/no_desktopintegration"]]

	# Unknown issue where the `repo` directory exists but not the `objects` sub-directory.
	# The `objects` sub-directory is required when launching Flatpak applications, either through the UI or via `flatpak run [APPLICATION]`.
	# When the `repo` directory is deleted, the next Flatpak application to launch will re-create the required directory structure and the application will launch correctly.
	rm -rf "${PREFIX_DIRECTORY}/share/flatpak/repo"
fi

# Must be at end of file to allow the environment (variables) to be configured.
case $- in
	*i*)
		bash=$(type -p bash)
		if [ -z "${TMUX}" ] && [ -n "${SSH_TTY}" ]; then
			exec tmux new-session -A -D -s hutson

		# If this is an interactive login session (Such as SSH connection), attempt to launch the version of Bash installed with Homebrew.
		elif [ -x "${bash}" ]; then
			# Set SHELL so that other tools, such as TMUX, know which shell launched them.
			export SHELL="${bash}"
			exec "${bash}"
		fi
esac
