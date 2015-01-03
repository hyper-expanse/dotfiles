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
extract () {
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

#! Launch NASA TV.
# Will hit NASA TV's HTTP live streaming source typically used by IPad and Android devices who don't have Adobe Flash. The script used to launch NASA TV will be forked into a TMUX-managed terminal. The script can be found at ~/Resources/Scripts/nasatv.sh.
#
# \param $@ Accepts any number of parameters offered by the NASATV script.
nasatv ()
{
	local script="${HOME}/Resources/Scripts/nasatv.sh"

	if [ ! -f "${script}" ]; then
		echo "The required script, ${script}, does not exist."
		return
	fi

	local arguments="$@" # We have to capture $@ in a temp variable to pass as part of the call to TMUX or, for some unknown reason, the variable arguments will be passed to TMUX and not to the script executed by Bash.
	tmux new-session -s NASATV -d "bash ${script} ${arguments}"
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
	printf "\n> Removing ${HOME}/.local/ directory.\n"

	# Clear out our local system directory.
	if [ -d "${HOME}/.local/" ]; then
		rm -fr "${HOME}/.local/" &> /dev/null
	fi

	printf "\n> Removing ${HOME}/.vim/ directory.\n"

	# Clear out our Vim directory.
	if [ -d "${HOME}/.vim/" ]; then
		rm -fr "${HOME}/.vim/" &> /dev/null
	fi

	# Create our local system directory before any setup steps require its existence.
	mkdir "${HOME}/.local"

	# Create our local tmp directory for use by tools that cache compilation artifacts there. This directory must exist before those tools can create sub-directories within it.
	mkdir "${HOME}/.local/tmp"

	# Create our Vim directory before any setup steps require its existence.
	mkdir "${HOME}/.vim"

	# Download, build, and install core development environment tools.
	setupLinuxbrew
	setupPIP
	setupVim

	# Install general tools.
	installBrewPackages
	installNodePackages
	installPythonPackages

	updateVim
}

#! Update environment.
# Update our development environment by installing the latest version of our desired tools.
updateEnvironment ()
{
	# Update scripts and application plugins for specific applications.
	updateLinuxbrew

	source "${HOME}/.bashrc"

	# Update general tools.
	updateBrewPackages
	installNodePackages
	installPythonPackages

	updateVim
}

#! Setup Linuxbrew, the Linux-clone of HomeBrew.
# Install Linuxbrew locally so that we can download, build, and install tools from source.
setupLinuxbrew ()
{
	if command -v git &> /dev/null; then
		printf "\n> Installing Linuxbrew.\n"

		local currentDirectory=`pwd`

		cd "${HOME}/.local/"

		# If the requested command fails, exit rather than attempt to execute further commands.
		if [ "${?}" -gt 0 ]; then
			return
		fi

		git init

		git remote add origin https://github.com/Homebrew/linuxbrew.git

		git fetch --depth=1

		git checkout -b openssl-on-32bit --track origin/openssl-on-32bit

		cd "${currentDirectory}"

		# Link compilers into local bin directory for non-Debian systems, as non-Debian systems do not expose a version-named binary for compilers like gcc, or g++. For example, on Debian, you may find `gcc-4.4` in your path.
		local uname=`uname -a`
		local debian="debian"
		if [ "${uname/$debian}" = "${uname}" ] ; then
			printf "\n--> Linking compilers into prefix binary directory."

			if command -v gcc &> /dev/null; then
				ln -s $(which gcc) ${PREFIX}/bin/gcc-$(gcc -dumpversion |cut -d. -f1,2)
			fi

			if command -v g++ &> /dev/null; then
				ln -s $(which g++) ${PREFIX}/bin/g++-$(g++ -dumpversion |cut -d. -f1,2)
			fi

			if command -v gfortran &> /dev/null; then
				ln -s $(which gfortran) ${PREFIX}/bin/gfortran-$(gfortran -dumpversion |cut -d. -f1,2)
			fi
		fi
	else
		printf "\n> ERROR: `git` is required for setting up Linuxbrew, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `setupLinxBrew`.\n"
	fi
}

#! Setup pip, Python's package manager.
# Install and configure Python's package manager in the user's local environment.
setupPIP ()
{
	# Delete any existing file so that `wget` will download the file from scratch.
	if [ -f "/tmp/hutson-get-pip.py" ]; then
		rm "/tmp/hutson-get-pip.py"
	fi

	printf "\n> Downloading PIP installer.\n"

	# Download the PIP installer.
	wget --quiet https://bootstrap.pypa.io/get-pip.py -O /tmp/hutson-get-pip.py

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi

	printf "\n> Installing PIP user-wide.\n"

	python /tmp/hutson-get-pip.py --user

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi
}

#! Setup the command line editor Vim.
# Install and configure Vim and the environment in which it will run.
setupVim ()
{
	if command -v git &> /dev/null; then
		printf "\n> Cloning Vundle for Vim plugin management.\n"

		# Create the initial bundle directory that will be required for storing Vim plugins.
		mkdir --parents "${HOME}/.vim/bundle/vundle"

		# If the requested command fails, exit rather than attempt to execute further commands.
		if [ "${?}" -gt 0 ]; then
			return
		fi

		# Clone the required Vundle plugin into the newly created bundle directory.
		git clone https://github.com/gmarik/Vundle.vim.git ${HOME}/.vim/bundle/vundle --quiet --depth 1
	else
		printf "\n> ERROR: `git` is required for setting up Vundle, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `setupVim`.\n"
	fi
}

#! Update Linuxbrew environment.
# Update the Linuxbrew installation. This includes doing the following:
# 1) Pull down the latest commit from Linuxbrew's remote repository.
updateLinuxbrew ()
{
	if command -v brew &> /dev/null; then
		printf "\n> Updating Linuxbrew.\n"

		brew update
	else
		echo "ERROR: `brew` is required for updating the Linuxbrew installation, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `updateLinkBrew`."
	fi
}

#! Update Vim environment.
# Update plugins associated with the user's local environment. This includes doing the following:
# 1) Remove plugins from Vim's bundle directory that are no longer listed in the user's .vimrc configuration file.
# 2) Install plugins listed in the user's .vimrc file that are not already installed.
# 3) Update plugins that are already installed on the system.
updateVim ()
{
	printf "\n> Updating Vim.\n"

	# Make a directory to hold the font file containing the special Powerline font glyphs.
	mkdir --parents "${HOME}/.fonts/"

	# Make a directory to hold a font configuration file that will load the Powerline font glyphs, replacing the appropriate font characters in our font of choice.
	mkdir --parents "${HOME}/.config/fontconfig/conf.d/"

	# Download the Powerline font glyphs.
	wget --quiet https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf --directory-prefix="${HOME}/.fonts/"

	# Update our font cache.
	fc-cache -fv "${HOME}/.fonts/"

	# Download the font configuration file.
	wget --quiet https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf --directory-prefix="${HOME}/.config/fontconfig/conf.d/"

	# Update Vim plugins.
	if command -v vim &> /dev/null; then
		vim +PluginClean! +PluginInstall! +qa
	else
		printf "\n> ERROR: `vim` is required for updating Vim's plugins, but it's not available in your PATH. Please install `vim` and ensure it's in your PATH. Then re-run `updateVim`.\n"
	fi

	# Once the tern_for_vim plugin has been installed via the previous Vim plugin step we'll still need to download the plugin's required runtime dependencies. To accomplish this we jump into the plugin's directory and run `npm install`. That installation step will download the `tern` server that will be used by the tern_for_vim plugin.
	if command -v npm &> /dev/null; then
		local currentDirectory=`pwd`
		cd "${HOME}/.vim/bundle/tern_for_vim" && npm install && cd ${currentDirectory}
	else
		printf "\n> ERROR: `npm` is required for installing Tern runtime dependencies, but it's not available in your PATH. Please install `npm` and ensure it's in your PATH. Then re-run `updateVim`.\n"
	fi
}

#! Install packages via Linuxbrew.
# Install packages via Linuxbrew's `brew` CLI tool.
installBrewPackages()
{
	if command -v brew &> /dev/null; then
		printf "\n> Installing Brew packages.\n"

		# A collection of useful core libraries and utility programs.
		brew tap homebrew/dupes

		# Install a compiler toolchain.
		brew install linux-headers # Temporary until remaining toolchain is setup properly.

		brew install zlib
		## END

		# Install openssl, which is required by various other brew builds.
		brew install pkg-config # Dependency of openssl, required in some instances (some systems).
		brew install openssl

		# Install ncurses, which is required by various other brew builds.
		brew install ncurses

		# Install bash-completion. This allows us to leverage bash completion scripts installed by our brew installed packages.
		brew install bash-completion

		# Download and install wget.
		brew install wget

		# Download and install rbenv, a CLI tool for managing Ruby interpreter versions within the current shell environment.
		brew install rbenv

		# Download and install ruby-build, a tool for building and installing different versions of the Ruby interpreter.
		brew install ruby-build

		# Download and install Vim, an awesome IDE.
		if [ `uname -n` == "mini" ]; then
			brew install vim --HEAD
			brew link vim
		fi

		# Download and install Tmux, a terminal multiplexer.
		brew install tmux

		# Download and install tig, a ncurses-based tool for visualizing a Git repository.
		brew install tig

		# Download and install htop, a human-readable version of top.
		brew install htop

		# Download and install git, a distributed source code management tool. Must include curl as a dependency to correctly compile versions of git on Linux systems.
		brew install git --with-brewed-curl
		brew link git

		# Download and install elinks, a command line browser.
		brew install elinks

		# Download and install flac, a command line tool for re-encoding audio files into Flac format.
		brew install flac

		# Download and install NodeJS and npm.
		#if [ `uname -n` == "mini" ]; then
			# Determine the operating system architecture for use by build scripts where necessary.
			if [ "`uname -m`" == "i686" ]; then
				local architecture="x86";
			else
				local architecture="x64"
			fi

			wget "http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-${architecture}.tar.gz" --directory-prefix=/tmp
			tar -xf "/tmp/node-v0.10.33-linux-${architecture}.tar.gz" -C .local/ --strip-components=1
			rm "/tmp/node-v0.10.33-linux-${architecture}.tar.gz"
		#else
		#	brew install node --with-npm --with-completion
		#fi

	else
		echo "ERROR: `brew` is required for building and installing tools from source, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `installBrewPackages`."
	fi
}

#! Update brew packages via Linuxbrew.
# Update previously installed brew packages via Linuxbrew's `brew` CLI tool.
updateBrewPackages ()
{
	if command -v brew &> /dev/null; then
		printf "\n> Updating Brew packages.\n"

		brew upgrade

		brew reinstall vim --HEAD

		# Cleanup Linuxbrew installation.
		brew cleanup -s --force
	else
		echo "ERROR: `brew` is required for updating brew packages, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `updateBrewPackages`."
	fi
}

#! Install Node.JS packages.
# Install Node.JS packages via `npm`.
installNodePackages ()
{
	if command -v npm &> /dev/null; then
		printf "\n> Installing Node packages.\n"

		# Clear npm's cache so that the following packages are installed from npm's online repository rather than from a possibly stale local cache.
		npm cache clean

		# Update the version of `npm` installed in our environment.
		npm install -g npm

		# Required to render GitBook books.
		npm install -g gitbook

		# Required by vimrc to enable Syntastic checking for JavaScript files.
		npm install -g jscs
		npm install -g jshint

		# Required by vimrc to enable Syntastic checking for JSON files.
		npm install -g jsonlint

		# Required by vimrc to enable Tagbar to properly parse JavaScript files for tag information.
		npm install -g git://github.com/ramitos/jsctags.git

		# `Foreman`-like tool for managing arbitrary processes within a local environment.
		npm install -g foreman

		# CLI tool required to run Yeoman generators that scaffold projects.
		npm install -g yo
	else
		echo "ERROR: `npm` is required for installing Node.JS packages, but it's not available in your PATH. Please install `npm` and ensure it's in your PATH. Then re-run `installNodePackages`."
	fi
}

#! Install Python packages.
# Install Python packages via `pip`.
installPythonPackages ()
{
	if command -v pip &> /dev/null; then
		printf "\n> Installing Python packages.\n"

		# Update the version of `pip` installed in our environment.
		pip install --user pip --upgrade

		# Required to manage virtual Python environments.
		pip install --user virtualenv --upgrade

		# Required by vimrc to enable Syntastic checking for Python files.
		pip install --user pylint --upgrade
		pip install --user pep8 --upgrade
	else
		echo "ERROR: `pip` is required for installing Python packages, but it's not available in your PATH. Please install `pip` and ensure it's in your PATH. Then re-run `installPythonPackages`."
	fi
}
