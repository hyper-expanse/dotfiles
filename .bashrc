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

# Append command to the bash command history file instead of overwriting it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

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

# Alias definitions.
# You may want to put all your additions into a separate file like ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Source our Bash prompt.
if [ -f ~/.prompt ]; then
	source ~/.prompt
fi

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

#! Extract multiple types of archive files.
# Extract multiple types of archive files. Extraction is based on the archive type, and whether they are compressed, and if so, the type of compression used.
# \param $1 Full path to the archive file.
extract ()
{
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xvjf $1		;;
			*.tar.gz)	tar xvzf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		unrar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xvf $1		;;
			*.tbz2)		tar xvjf $1		;;
			*.tgz)		tar xvzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1	;;
			*.7z)		7z x $1			;;
			*)			echo "Don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}


#! Launch NASA TV.
# Will hit NASA TV's HTTP live streaming source typically used by IPad and Android devices who don't have Adobe Flash. The script used to launch NASA TV will be forked into a TMUX-managed terminal. The script can be found at ~/Resources/Scripts/nasatv.sh.
# \param $@ Accepts any number of parameters offered by the NASATV script.
nasatv ()
{
	TEMP="$@" # We have to capture $@ in a temp variable to pass as part of the call to TMUX or, for some unknown reason, the variable arguments will be passed to TMUX and not to the script executed by Bash.
	tmux new-session -s NASATV -d "bash ~/Resources/Scripts/nasatv.sh ${TEMP}"
}
