#!/usr/bin/env bash

#====================================================
# Bash Environment Configuration
#
# This script only needs to be sourced upon opening a new shell to configure the Bash shell environment.
#====================================================

# If not running interactively, don't do anything.
case "${-}" in
	*i*) ;;
	*) return;;
esac


# BEGIN HISTORY

# Don't push duplicate lines, or lines starting with space, in the history. The second ignore condition allows you to execute commands with a leading space, thereby instructing Bash to not place them into history.
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE.
HISTSIZE=32768
HISTFILESIZE=$HISTSIZE

# Include date and timestamps in history output.
HISTTIMEFORMAT='%h %d %H:%M:%S> '

# Ignore certain commands given by the user, for the sake of history, such that they don't show up in Bash history.
HISTIGNORE="cd:cd -:pwd;exit:date:* --help"

# Append command to the bash command history file instead of overwriting it.
shopt -s histappend

# Append command to the history file after every display of the command prompt, instead of after terminating the session (the current shell).
# We no longer reload the contents of the history file into the history list (which is kept in memory). By reloading the history file (history -r) after appending commands to the file, we could have loaded history saved by other sessions currently running. However, that can cause commands from multiple sessions to intermix, making it difficult to re-produce your actions within the current session by following the command history in a linear fashion.
PROMPT_COMMAND='history -a'

# END HISTORY


# Correct minor spelling errors in a `cd` command; such as transposed, missing, or extra, characters without the need for retyping.
shopt -s cdspell

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

# Source our custom prompt setup script.
if [ -f "${HOME}/.prompt" ]; then
	source "${HOME}/.prompt"
fi

# Setup Bash prompt auto-completion for PIP; Python's package manager.
if command -v pip &> /dev/null; then
	eval "$(pip completion --bash)"
fi

# Enable command line auto-completion for the `rbenv` tool.
if command -v rbenv &> /dev/null; then
	eval "$(rbenv init -)"
fi

# Enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source  /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	fi
fi

# Source the Linuxbrew bash completion script. This script will subsequently sources bash completion scripts installed into the Linuxbrew bash_completion.d directory.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	source $(brew --prefix)/etc/bash_completion
fi

# Source our custom shell aliases. All custom shell aliases should be in this external file rather than cluttering up this file.
if [ -f "${HOME}/.bash_aliases" ]; then
	source "${HOME}/.bash_aliases"
fi

# Source our custom bash functions.
if [ -f "${HOME}/.bash_functions" ]; then
	source "${HOME}/.bash_functions"
fi
