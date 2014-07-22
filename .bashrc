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

# Retrieve the name of our operating system platform.
platform=`uname -o`

# Disable console beeps that occur as alerts to gain operator attention.
if [ "${platform}" == 'GNU/Linux' ]; then
	setterm -bfreq 0
elif [ "${platform}" == 'Cygwin' ]; then
	set bell-style none
fi

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

		"${1}"

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
	# Clear out our local system directory before initiating a fresh install of our environment.
	rm -fr "${HOME}/.local/" &> /dev/null

	# Download, build, and install tools.
	setupPIP
	setupVim
	setupVirtualEnv

	# Update scripts and application plugins.
	updateGit
	updateVim

	source "${0}"
}

#! Setup pip, Python's package manager.
# Install and configure Python's package manager in the user's local environment.
setupPIP ()
{
	# Download the PIP installer.
	echo "Downloading PIP installer."
	wget --quiet https://bootstrap.pypa.io/get-pip.py > /tmp/hutson-get-pip.py

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi

	echo "Installing PIP user-wide."
	python /tmp/hutson-get-pip.py --user

	# If the requested command fails, exit rather than attempt to execute further commands.
	if [ "${?}" -gt 0 ]; then
		return
	fi

	# Upgrade the user-wide version of pip.
	echo "Upgrading PIP to latest version."
	pip install --user pip --upgrade
}

#! Setup the command line editor Vim.
# Install and configure Vim and the environment in which it will run.
setupVim ()
{
	if command -v git &> /dev/null; then
		echo "Cloning Vundle for Vim plugin management."

		# Create the initial bundle directory that will be required for storing Vim plugins.
		mkdir -p ~/.vim/bundle/vundle

		# Clone the required Vundle plugin into the newly created bundle directory.
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle 2> /dev/null
	else
		echo "ERROR: `git` is required for setting up Vundle, but it's not available in your PATH. Please install `git` and ensure it's in your PATH. Then re-run `setupVim`."
	fi
}

#! Setup Python's virtual environment tool.
# Install and configure Python's virtual environment tool in the user's local environment.
setupVirtualEnv ()
{
	if command -v pip &> /dev/null; then
		pip install --user virtualenv
	else
		echo "ERROR: `pip` is required for setting up virtualenv, but it's not available in your PATH. Please install `pip` and ensure it's in your PATH. Then re-run `setupVirtualEnv`."
	fi
}

#! Update Vim environment.
# Update plugins associated with the user's local environment. This includes doing the following:
# 1) Remove plugins from Vim's bundle directory that are no longer listed in the user's .vimrc configuration file.
# 2) Install plugins listed in the user's .vimrc file that are not already installed.
# 3) Update plugins that are already installed on the system.
updateVim ()
{
	# Make a directory to hold the font file containing the special Powerline font glyphs.
	mkdir --parents ${HOME}/.fonts/

	# Make a directory to hold a font configuration file that will load the Powerline font glyphs, replacing the appropriate font characters in our font of choice.
	mkdir --parents ${HOME}/.config/fontconfig/conf.d/

	# Download the Powerline font glyphs.
	wget --quiet https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf --directory-prefix=${HOME}/.fonts/

	# Update our font cache.
	fc-cache -fv ${HOME}/.fonts/

	# Download the font configuration file.
	wget --quiet https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf --directory-prefix=${HOME}/.config/fontconfig/conf.d/

	# Update Vim plugins.
	vim +PluginClean! +PluginInstall! +qa
}

#! Update Git environment.
# Update Git scripts used by the user's local environment. This includes doing the following:
# 1) Download and install Git's bash auto-completion script so that it can be sourced by this .bashrc file.
updateGit ()
{
	mkdir --parents "${HOME}/.local/etc/bash_completion.d/"

	wget --quiet https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --directory-prefix="${HOME}/.local/etc/bash_completion.d/"

	source "${HOME}/.local/etc/bash_completion.d/git-completion.bash"
}
