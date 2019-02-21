#!/usr/bin/env bash

#====================================================
# Custom Bash Functions
#
# This script only needs to be sourced upon opening a new shell to configure the Bash shell environment.
#====================================================

#! Compress a file or folder into one of many types of archive formats.
# Compress a file or folder into one of many types of archive formats. Compression is based on the archive type specified.
# This function is based on http://bijayrungta.com/extract-and-compress-files-from-command-line-in-linux
#
# \param $1 Path to the file or folder to be archived.
# \param $2 Archive type; such as 'tar' or 'zip'.
compress()
{
	local dirPriorToExe=`pwd`
	local dirName=`dirname ${1}`
	local baseName=`basename ${1}`

	if [ -f "${1}" ]; then
		echo "Selected a file for compression. Changing directory to ${dirName}."
		cd "${dirName}"
		case "${2}" in
			tar.bz2)   tar cjf ${baseName}.tar.bz2 ${baseName} ;;
			tar.gz)    tar czf ${baseName}.tar.gz ${baseName}  ;;
			gz)        gzip ${baseName}                        ;;
			tar)       tar -cvvf ${baseName}.tar ${baseName}   ;;
			zip)       zip -r ${baseName}.zip ${baseName}      ;;
			*)
				echo "A compression format was not chosen. Defaulting to tar.bz2"
				tar cjf ${baseName}.tar.bz2 ${baseName}
				;;
		esac
		echo "Navigating back to ${dirPriorToExe}"
		cd "${dirPriorToExe}"
	elif [ -d "${1}" ]; then
		echo "Selected a directory for compression. Changing directory to ${dirName}."
		cd "${dirName}"
		case "${2}" in
			tar.bz2)   tar cjf ${baseName}.tar.bz2 ${baseName} ;;
			tar.gz)    tar czf ${baseName}.tar.gz ${baseName}  ;;
			gz)        gzip -r ${baseName}                     ;;
			tar)       tar -cvvf ${baseName}.tar ${baseName}   ;;
			zip)       zip -r ${baseName}.zip ${baseName}      ;;
			*)
				echo "A compression format was not chosen. Defaulting to tar.bz2"
				tar cjf ${baseName}.tar.bz2 ${baseName}
				;;
		esac
		echo "Navigating back to ${dirPriorToExe}"
		cd "${dirPriorToExe}"
	else
		echo "'${1}' is not a valid file or directory."
	fi
}

#! Extract multiple types of archive files.
# Extract multiple types of archive files. Extraction is based on the archive type, and whether they are compressed, and if so, the type of compression used.
# This function is based on https://github.com/xvoland/Extract.
#
# \param $1 Path to the archive file.
extract ()
{
	if [ -z "${1}" ]; then
		echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
		exit
	fi

	if [ -f "${1}" ]; then
		case "${1}" in
			*.tar.bz2)   tar xvjf "${1}"    ;;
			*.tar.gz)    tar xvzf "${1}"    ;;
			*.tar.xz)    tar xvJf "${1}"    ;;
			*.lzma)      unlzma "${1}"      ;;
			*.bz2)       bunzip2 "${1}"     ;;
			*.rar)       unrar x -ad "${1}" ;;
			*.gz)        gunzip "${1}"      ;;
			*.tar)       tar xvf "${1}"     ;;
			*.tbz2)      tar xvjf "${1}"    ;;
			*.tgz)       tar xvzf "${1}"    ;;
			*.zip)       unzip "${1}"       ;;
			*.Z)         uncompress "${1}"  ;;
			*.7z)        7z x "${1}"        ;;
			*.xz)        unxz "${1}"        ;;
			*.exe)       cabextract "${1}"  ;;
			*)           echo "extract: '${1}' - unknown archive method" ;;
		esac
	else
		echo "${1} - file does not exist"
	fi
}

#! Setup a watch and run a command.
# Watch for changes to files that match a given file specification, and on change, run the given command.
#
# \param $1 A command accessible in the user's PATH to execute.
# \param $2 A filespec; for example '*' or '/home/user'.
# \param [$3=modify] Any combination of comma-delimited inotify events to listen for on the given filespec. Defaults to listening for "modify" events.
watch ()
{
	if [ -z `command -v inotifywait` ]; then
		echo "'inotifywait', needed to run the watch command, is not accessible in your PATH."
		return
	fi

	# Validate the command parameter.
	if [ -z "${1}" ]; then
		echo "Invalid command, ${1}, provided. This command does not exist in your PATH."
		return
	fi

	# Validate the filespec parameter.
	if [ -z "${2}" ]; then
		echo "Invalid filespec."
		return
	fi

	# Set an appropriate inotify watch event default.
	local default="modify"
	local events="${3:-$default}"

	while inotifywait -e "${events}" "${2}"; do

		# If the script failed (thereby returning an error), exit rather than loop again.
		if [ "${?}" -gt 0 ]; then
			return
		fi

		# Evaluate the expression passed to the watch command so that commands that include command line arguments can be properly executed.
		eval "${1}"

		# If the requested command fails, exit rather than loop again.
		if [ "${?}" -gt 0 ]; then
			return
		fi
	done
}

#! Setup a local environment.
# Setup a local environment that contains all the tools and libraries needed for development work, and play.
setupEnvironment ()
{
	printf "\n> Removing ${PREFIX_DIRECTORY} directory.\n"

	# Clear out our local system directory.
	if [ -d "${PREFIX_DIRECTORY}" ]; then
		rm -fr "${PREFIX_DIRECTORY}" &> /dev/null
	fi

	printf "\n> Removing ${HOME}/.tmux/ directory.\n"

	# Clear out our Tmux directory.
	if [ -d "${HOME}/.tmux/" ]; then
		rm -fr "${HOME}/.tmux/" &> /dev/null
	fi

	# Create our local tmp directory for use by tools that cache compilation artifacts there. This directory must exist before those tools can create sub-directories within it.
	mkdir -p "${PREFIX_DIRECTORY}/tmp"

	# Setup Brew.
	setupBrew
	installBrewPackages

	# Enable the Large File Storage extension.
	git lfs install

	# Execute `nvm` script to configure our local environment to work with `nvm`.
	source "$(brew --prefix nvm)/nvm.sh"

	# Install general tools.
	nvm install
	installNodePackages
	installPythonPackages

	if [ "$(uname)" = "Linux" ]; then
		# Install Firefox.
		installFirefox
	fi
}

#! Update environment.
# Update our development environment by installing the latest version of our desired tools.
updateEnvironment ()
{
	# Update Brew.
	brew update

	# Upgrade all Brew-installed packages.
	brew upgrade

	# Cleanup Brew installation.
	brew cleanup -s

	# Update general tools.
	nvm install
	installNodePackages

	if [ "$(uname)" = "Linux" ]; then
		# Not supported on macOS at this time.
		installPythonPackages
	fi
}

#! Setup Brew, the Linux-clone of HomeBrew.
# Install Brew locally so that we can download, build, and install tools from source.
setupBrew ()
{
	printf "\n> Installing Brew.\n"

	# Create a local binary directory before any setup steps require its existence. It must exist for the tar extraction process to extract the contents of Brew into the `.local/` directory.
	mkdir -p "${HOME}/.local/bin"

	if [ "$(uname)" = "Darwin" ]; then
		# Download an archive version of the #master branch of Brew to the local system for future extraction. We download an archive version of Brew, rather than cloning the #master branch, because we must assume that the local system does not have the `git` tool available (A tool that will be installed later using Brew).
		curl -L https://github.com/Homebrew/brew/archive/master.tar.gz -o "/tmp/homebrew.tar.gz"

		# Extract archive file into local system directory.
		tar -xf "/tmp/homebrew.tar.gz" -C "${HOME}/.local/" --strip-components=1

		# Cleanup.
		rm -f "/tmp/homebrew.tar.gz"
	else
		# Download an archive version of the #master branch of Brew to the local system for future extraction. We download an archive version of Brew, rather than cloning the #master branch, because we must assume that the local system does not have the `git` tool available (A tool that will be installed later using Brew).
		wget https://github.com/Linuxbrew/brew/archive/master.tar.gz -O "/tmp/linuxbrew.tar.gz"

		# Extract archive file into local system directory.
		tar -xf "/tmp/linuxbrew.tar.gz" -C "${HOME}/.local/" --strip-components=1

		# Cleanup.
		rm -f "/tmp/linuxbrew.tar.gz"
	fi

	# Link compilers into local bin directory for non-Debian systems, as non-Debian systems do not expose a version-named binary for compilers like gcc, or g++. For example, on Debian, you may find `gcc-4.4` in your path.
	local uname=`uname -a`
	local debian="Debian"
	if [ "${uname/$debian}" = "${uname}" ] && [ "$(uname)" = "Linux" ]; then
		printf "\n--> Linking compilers into prefix binary directory."

		if command -v gcc &> /dev/null; then
			ln -s $(which gcc) ${PREFIX_DIRECTORY}/bin/gcc-$(gcc -dumpversion | cut -d. -f1,2)
		fi

		if command -v g++ &> /dev/null; then
			ln -s $(which g++) ${PREFIX_DIRECTORY}/bin/g++-$(g++ -dumpversion | cut -d. -f1,2)
		fi

		if command -v gfortran &> /dev/null; then
			ln -s $(which gfortran) ${PREFIX_DIRECTORY}/bin/gfortran-$(gfortran -dumpversion | cut -d. -f1,2)
		fi
	fi
}

#! Install packages via Brew.
# Install packages via Brew's `brew` CLI tool.
installBrewPackages()
{
	if command -v brew &> /dev/null; then
		printf "\n> Installing Brew packages.\n"

		# Install python version 3, which `pip` is also included, as the header files are required by natively-built pip packages.
		brew install python

		# Install Go compiler and development stack.
		brew install go

		# Install bash-completion. This allows us to leverage bash completion scripts installed by our brew installed packages.
		brew install bash-completion

		# Install nvm, a CLI tool for managing Node interpreter versions within the current shell environment.
		brew install nvm

		# Install alternative JavaScript package manager called `yarn`. Install without the Node dependency, as we will use the Node installation provided by the `nvm` tool.
		brew install yarn --without-node

		# Install Tmux, a terminal multiplexer.
		brew install tmux

		# Install htop, a human-readable version of top.
		brew install htop

		# Install git, a distributed source code management tool.
		brew install git

		# Install the Large File Storage (LFS) git extension. The Large File Storage extension replaces large files that would normally be committed into the git repository, with a text pointer. Each revision of a file managed by the Large File Storage extension is stored server-side. Requires a remote git server with support for the Large File Storage extension.
		brew install git-lfs

		# Install flac, a command line tool for re-encoding audio files into Flac format.
		brew install flac

		# Install ncdu, a command line tool for displaying disk usage information.
		brew install ncdu

		# Install scrub, a command line tool for securely deleting files.
		brew install scrub

		# Cross-platform, open-source, build system.
		brew install cmake

		# Static site generator and build tool.
		brew install hugo

		# Tool used to compute CPU load for prompt line.
		brew install bc

		# Install resource orchestration tool.
		brew install terraform

		# Install tflint, a linter/validator for Terraform files.
		brew tap wata727/tflint
		brew install tflint

		if [ "$(uname)" = "Darwin" ]; then
			# Latest GNU core utilities, such as `rm`, `ls`, etc.
			brew install coreutils

			brew install bash
			brew install wget
			brew install pinentry-mac
			brew cask install firefox
			brew cask install visual-studio-code
			brew cask install calibre
			brew cask install clementine

			# Required for successful installation of `dia`.
			brew cask install xquartz

			brew cask install dia
			brew cask install gramps
			brew cask install keepassxc
			brew cask install musicbrainz-picard
			brew cask install transmission
			brew cask install gpg-suite
			brew cask install vlc
			brew cask install iterm2
			brew cask install spectacle
			brew cask install alfred

			# General purpose archive/extractor tool.
			brew cask install keka
		fi

		if [ `uname -n` == "startopia" ]; then

			# GNU data recovery tool.
			brew install ddrescue

			# Tool for ripping DVD's from the command line.
			brew install dvdbackup
		fi
	else
		echo "ERROR: `brew` is required for building and installing tools from source, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `installBrewPackages`."
	fi
}

#! Install NodeJS packages.
# Install NodeJS packages via `yarn`.
installNodePackages ()
{
	if command -v yarn &> /dev/null; then
		printf "\n> Installing Node packages.\n"

		# Install command line tab completion for `yarn`.
		yarn global add yarn-completions

		# `Foreman`-like tool for managing arbitrary processes within a local environment.
		yarn global add foreman

		# Tool to update a markdown file, such as a `README.md` file, with a Table of Contents.
		yarn global add doctoc

		# Tool to configure many GitHub projects to use a given set of settings.
		yarn global add @hutson/github-metadata-sync

		# Tool to run Yeoman generators for scaffolding new projects.
		yarn global add yo
	else
		echo "ERROR: `yarn` is required for installing NodeJS packages, but it's not available in your PATH. Please install `yarn` and ensure it's in your PATH. Then re-run `installNodePackages`."
	fi
}

#! Install Python packages.
# Install Python packages via `pip`.
installPythonPackages ()
{
	if command -v pip &> /dev/null; then
		printf "\n> Installing Python packages.\n"

		# Update the version of `pip` installed in our environment.
		pip install pip --upgrade

		# Package and virtual environment manager for Python.
		pip install pipenv --upgrade

		# Configuration management tool.
		pip install ansible --upgrade

		# Shell prompt configuration and theming tool.
		pip install powerline-status --upgrade
	else
		echo "ERROR: `pip` is required for installing Python packages, but it's not available in your PATH. Please install `pip` and ensure it's in your PATH. Then re-run `installPythonPackages`."
	fi
}

#! Install Visual Studio Code extensions.
# If running on a desktop with Visual Studio Code installed, install our selection of Visual Studio Code extensions.
installVisualStudioCodeExtensions ()
{

	if command -v $(code --help) &> /dev/null; then
		printf "\n> Installing Visual Studio Code extensions.\n"

		# ESLint linter for JavaScript.
		code --install-extension dbaeumer.vscode-eslint

		# TSLint linter for TypeScript.
		code --install-extension eg2.tslint

		# Chrome debugger integration.
		code --install-extension msjsdiag.debugger-for-chrome

		# General, offline, spell checker.
		code --install-extension streetsidesoftware.code-spell-checker

		# Support for Git blame annotations.
		code --install-extension eamodio.gitlens

		# Docker support.
		code --install-extension PeterJausovec.vscode-docker

		# Go support.
		code --install-extension ms-vscode.go

		# Terraform support.
		code --install-extension mauve.terraform
	else
		echo "ERROR: `code` is required for installing Visual Studio Code extensions, but it's not available in your PATH. Please install Visual Studio Code and ensure it's in your PATH. Then re-run `installVisualStudioCodeExtensions`."
	fi
}

#! Install the latest stable version of Firefox.
# Install the latest stable version of Firefox directly from Mozilla's website, as Debian archives do not have the latest version of Firefox.
# Based on the instructions available here - https://wiki.debian.org/Firefox
installFirefox ()
{
	printf "\n> Installing Firefox.\n"

	# Create a local ad-hoc directory before any setup steps require its existence. It must exist for the tar extraction process to extract the contents of Firefox into the `${HOME}/.local/opt/` directory.
	mkdir -p "${HOME}/.local/opt"

	# Download an archive version of the latest version of Firefox to the local system for future extraction.
	wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" -O "/tmp/firefox.tar.bz2"

	# Extract archive file into an ad-hoc local system directory.
	rm -rf "${HOME}/.local/opt/firefox"
	tar -jxf "/tmp/firefox.tar.bz2" -C "${HOME}/.local/opt/"

	# Symlink the extracted Firefox binary into our standard local binary directory.
	ln -s -f "${HOME}/.local/opt/firefox/firefox" "${HOME}/.local/bin/firefox"

  # Generate a desktop configuration file to add our local Firefox installation to our desktop application/start menu.
	echo "
[Desktop Entry]
Name=Firefox
Comment=Web Browser
GenericName=Web Browser
X-GNOME-FullName=Firefox Web Browser
Exec=${HOME}/.local/bin/firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=${HOME}/.local/opt/firefox/browser/chrome/icons/default/default128.png
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Firefox
StartupNotify=true" > "${HOME}/.local/share/applications/firefox-stable.desktop"

	# Cleanup.
	rm "/tmp/firefox.tar.bz2"
}
