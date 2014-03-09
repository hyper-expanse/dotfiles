#!/usr/bin/env bash

#====================================================
# Bash Environment Configuration
#
# This script only needs to be sourced upon logging into a system to configure the Bash shell environment.
#====================================================

# If not running interactively, don't do anything.
case $- in
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

# Append command to the history after every display of the command prompt instead of after terminating the session.
PROMPT_COMMAND='history -a'

# Check the window size after each command and, if necessary update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned off by default to not distract the user: the focus in a terminal window should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
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
fi

# Add local Node.js module directory to the beginning of our PATH so that Node.js modules pulled down by a project, through, say, NPM and package.json, can be used rather than any global Node.js modules on the system, or in the user's local bin directory. This will ensure project builds use their desired versions of Node.js modules.
export PATH=./node_modules/.bin:$PATH

# Retrieve the name of our operating system platform.
platform=`uname -o`

# Disable console beeps that occur as alerts to gain operator attention.
if [ $platform == 'GNU/Linux' ]; then
	setterm -bfreq 0
elif [ $platform == 'Cygwin' ]; then
	set bell-style none
fi

# Set the default console editor.
export EDITOR=vim

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

	if [ -f ${1} ] ; then
		echo "Selected a file for compression. Changing directory to ${dirName}."
		cd ${dirName}
		case ${2} in
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
		cd ${dirPriorToExe}
	elif [ -d ${1} ] ; then
		echo "Selected a directory for compression. Changing directory to ${dirName}."
		cd ${dirName}
		case ${2} in
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
		cd ${dirPriorToExe}
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

	if [ -f "${1}" ] ; then
		case ${1} in
			*.tar.bz2)   tar xvjf ../${1}    ;;
			*.tar.gz)    tar xvzf ../${1}    ;;
			*.tar.xz)    tar xvJf ../${1}    ;;
			*.lzma)      unlzma ../${1}      ;;
			*.bz2)       bunzip2 ../${1}     ;;
			*.rar)       unrar x -ad ../${1} ;;
			*.gz)        gunzip ../${1}      ;;
			*.tar)       tar xvf ../${1}     ;;
			*.tbz2)      tar xvjf ../${1}    ;;
			*.tgz)       tar xvzf ../${1}    ;;
			*.zip)       unzip ../${1}       ;;
			*.Z)         uncompress ../${1}  ;;
			*.7z)        7z x ../${1}        ;;
			*.xz)        unxz ../${1}        ;;
			*.exe)       cabextract ../${1}  ;;
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
	local script="~/Resources/Scripts/nasatv.sh"

	if [ ! -f "${script}" ]; then
		echo "The required script, ${script}, does not exist."
		exit 1
	fi

	local arguments="$@" # We have to capture $@ in a temp variable to pass as part of the call to TMUX or, for some unknown reason, the variable arguments will be passed to TMUX and not to the script executed by Bash.
	tmux new-session -s NASATV -d "bash ${script} ${arguments}"
}

#! Setup a watch and run a command.
# Watch for changes to files that match a given file specification, and on change, run the given command.
#
# \param $1 A command accessible in the user's PATH.
# \param $2 A filespec; for example '*' or '/home/user'.
watch ()
{
	if [ ! -z `command -v inotifywait` ]; then
		echo "'inotifywait', needed to run the watch command, is not accessible in your PATH."
		return
	fi

	# Validate the command parameter.
	if [ -z "${1}" ]; then
		echo "Invalid command."
		return
	fi

	# Validate the filespec parameter.
	if [ -z "${2}" ]; then
		echo "Invalid filespec."
		return
	fi

	# Set an appropriate inotify watch event default.
	local default="modify"
	local events=${3:-$default}

	while inotifywait -e "${events}" "${2}"; do

		# If the script failed (thereby returning an error), exit rather than loop again.
		if [ $? -gt 0 ]; then
			return
		fi

		"${1}"

		# If the requested command fails, exit rather than loop again.
		if [ $? -gt 0 ]; then
			return
		fi
	done
}
