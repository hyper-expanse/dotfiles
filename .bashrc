#!/usr/bin/env bash

#====================================================
# Bash Environment Configuration
#
# This script only needs to be sourced upon logging into a system to configure the Bash shell environment.
#====================================================

# If not running interactively, don't do anything.
case "${-}" in
	*i*) ;;
	*) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

# Append command to the bash command history file instead of overwriting it.
shopt -s histappend

# Append command to the history after every display of the command prompt, instead of after terminating the session (the current shell).
PROMPT_COMMAND='history -a'

# Check the window size after each command and, if necessary update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set variable identifying the current chroot.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm window set the window title to user@host:dir.
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
	*)
		;;
esac

# Enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source  /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	fi
fi

# Source our custom shell aliases. All custom shell aliases should be in this external file rather than cluttering up this file.
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

# Source our custom prompt setup script.
if [ -f ~/.prompt ]; then
	source ~/.prompt
else
	# We're unable to locate our prompt setup file. Therefore we fall back to a minimal prompt.
	case "${TERM}" in
		xterm-256color)
			PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' ;;
		*)
			PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ ' ;;
	esac
fi

# Enable options available from our ~/.prompt script:
export PROMPT_ENABLE_GIT_REPO_IDENTIFICATION=1 # Display working directory's Git branch name.

# Setup Bash prompt auto-completion for PIP; Python's package manager.
if command -v pip &> /dev/null; then
	eval "`pip completion --bash`"
fi

# Setup Bash prompt auto-completion for Git; a source code management tool.
if [ -f "${HOME}/.local/etc/bash_completion.d/git-completion.bash" ]; then
	source "${HOME}/.local/etc/bash_completion.d/git-completion.bash"
fi

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

	# Download, build, and install core development environment tools.
	setupLinuxBrew
	setupPIP
	setupVim

	# Update development environment.
	updateEnvironment
}

#! Update environment.
# Update our development environment by installing the latest version of our desired tools.
updateEnvironment ()
{
	# Update scripts and application plugins for specific applications.
	updateGit
	updateLinuxBrew

	source "${HOME}/.bashrc"

	# Install and update general tools.
	installBrewPackages
	installNodePackages
	installPythonPackages

	updateVim
}

#! Setup LinuxBrew, the Linux-clone of HomeBrew.
# Install LinuxBrew locally so that we can download, build, and install tools from source.
setupLinuxBrew ()
{
	if command -v git &> /dev/null; then
		printf "\n> Installing LinuxBrew.\n"

		local currentDirectory=`pwd`

		cd "${HOME}/.local/"

		# If the requested command fails, exit rather than attempt to execute further commands.
		if [ "${?}" -gt 0 ]; then
			return
		fi

		git init

		git remote add origin https://github.com/Homebrew/linuxbrew.git

		git fetch

		git checkout --track origin/master

		cd "${currentDirectory}"
	else
		printf "\n> ERROR: `git` is required for setting up LinuxBrew, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `setupLinxBrew`.\n"
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
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle --quiet --depth 1
	else
		printf "\n> ERROR: `git` is required for setting up Vundle, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `setupVim`.\n"
	fi
}

#! Update Git environment.
# Update Git scripts used by the user's local environment. This includes doing the following:
# 1) Download and install Git's bash auto-completion script so that it can be sourced by this .bashrc file.
updateGit ()
{
	printf "\n> Updating Git.\n"

	mkdir --parents "${HOME}/.local/etc/bash_completion.d/"

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi

	wget --quiet https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --directory-prefix="${HOME}/.local/etc/bash_completion.d/"

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi

	source "${HOME}/.local/etc/bash_completion.d/git-completion.bash"
}

#! Update LinuxBrew environment.
# Update the LinuxBrew installation. This includes doing the following:
# 1) Pull down the latest commit from LinuxBrew's remote repository.
updateLinuxBrew ()
{
	if command -v git &> /dev/null; then
		printf "\n> Updating LinuxBrew.\n"

		local currentDirectory=`pwd`

		cd "${HOME}/.local/"

		# If the requested command fails, exit rather than attempt to execute further commands.
		if [ "${?}" -gt 0 ]; then
			return
		fi

		git pull

		cd "${currentDirectory}"
	else
		printf "\n> ERROR: `git` is required for updating LinuxBrew, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `updateLinuxBrew`.\n"
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
		printf "\n> ERROR: `npm` is required for installing Term runtime dependencies, but it's not available in your PATH. Please install `npm` and ensure it's in your PATH. Then re-run `updateVim`.\n"
	fi

	# Download Vim's runtime files into a local directory so that they can be used by Vim.
	rsync --archive --compress --checksum --partial --delete --delete-excluded --force --human-readable --exclude="dos" --exclude="spell" --recursive "ftp.nluug.nl::Vim/runtime/" "${HOME}/.vim/runtime"
}

#! Install packages via LinuxBrew.
# Install packages via LinuxBrew's `brew` CLI tool.
installBrewPackages()
{
	if command -v brew &> /dev/null; then
		printf "\n> Installing Brew packages.\n"

		local currentDirectory=`pwd`

		# Determine the operating system architecture for use by build scripts where necessary.
		if [ "`uname -m`" == "i686" ]; then
			local architecture="x86";
		else
			local architecture="x64"
		fi

		# Download and install Vim.
		brew reinstall vim --HEAD
		if [ `uname -n` == "mini" ]; then
			cd "${HOME}/.cache/Homebrew/vim--hg"
			./configure --prefix="${HOME}/.local" --mandir="${HOME}/.local/share/man" --enable-multibyte --with-tlib=ncurses --enable-cscope --with-features=huge --with-compiledby=Homebrew --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-gui=no --without-x
			make -j GetNumberOfCores
			make install
			cd ${currentDirectory}
		fi

		# Download and install NodeJS and npm.
		wget "http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-${architecture}.tar.gz" --directory-prefix=/tmp
		tar -xf "/tmp/node-v0.10.33-linux-${architecture}.tar.gz" -C .local/ --strip-components=1
		rm "/tmp/node-v0.10.33-linux-${architecture}.tar.gz"

	else
		echo "ERROR: `brew` is required for building and installing tools from source, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `installBrewPackages`."
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
