#!/usr/bin/env bash

#====================================================
# Custom Aliases
#
# This script only needs to be sourced upon logging into a system to provide useful command aliases.
#====================================================

# Do not allow deletion of content at the root level, /, and prompt the user once before removing more than three files or when removing files and directories recursively.
alias rm='rm -I --preserve-root'

# Enable common comand confirmations with additional verbosity.
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -i'

# Enable case insensitivity for grep'ing.
alias grep='grep -i'

# Enable color support for various commands.
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'

fi

# List content, including hidden files and folders, of a directory in long format.
alias ll='ls -lha'

# Enable a traditional login shell when using sudo or su.
alias root='sudo -i'
alias su='sudo -i'

# Clear out the bash history and clear the screen.
alias scram='history -c; clear; /usr/bin/env rm -r ~/.vim/undo; /usr/bin/env rm -r ~/.vim/backups'

# Find the top 5 largest files within the current, and sub, directories.
alias findbig='find . -type f -exec ls -lha {} \; | sort --stable --parallel=2 -t" " -k5rh | head -5'

# Package management.
alias pkgfind='dpkg -S' # Find the package containing a particular binary image.
alias pkglist='dpkg -l' # List all installed packages.

# Navigate directories more easily.
alias ..2='cd ../../'
alias ..3='cd ../../../'
alias ..4='cd ../../../../'

# List all ports currently opened on the system with port numbers and processes shown.
alias ports='netstat -tulanp'

# Alias wget so that it will always attempt to continue a file that was not successfully downloaded to begin with.
alias wget='wget -c'

# Enable the standard math library for the math command line tool.
alias bc='bc -l'

# Quickly find and print the top four processes consuming CPU cycles.
alias psmem='ps auxf | sort -nr -k 4'

# Update a system on one command.
alias update='sudo apt-get update && sudo apt-get dist-upgrade --no-install-recommends'

# Connect to the Hyper-Expanse OpenVPN access point.
alias connect='tmux new-session -s OpenVPN "sudo openvpn --config ~/Documents/OpenVPN/client.conf"'

# Run a custom backup script to backup the system to an external server.
alias backup='bash ~/Resources/Scripts/backup.sh'
