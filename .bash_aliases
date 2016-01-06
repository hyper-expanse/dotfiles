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

# Enable color support for those GNU tools that support colorized output.
if command -v dircolors &> /dev/null; then
	# Check if user has a dircolors database (a file that maps file types, and file permissions, to colors). If the user has such a file, then instruct dircolors to use that file to map Bash color commands to the desired colors.
	if [ -f "${HOME}/.dircolors" ]; then
		eval "$(dircolors --bourne-shell "${HOME}/.dircolors")"
	else
		eval "$(dircolors --bourne-shell)"
	fi

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
alias scram='history -c; clear; /usr/bin/env rm -r ${HOME}/.vim/undo; /usr/bin/env rm -r ${HOME}/.vim/backups'

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

# Enable SSH Agent authentication forwarding. This allows authentication against remote servers using the private SSH key-pair residing on the local system.
alias ssh='ssh -A'

# Quickly find and print the top five processes consuming CPU cycles.
alias pscpu='ps aux | sort --stable --parallel=2 -k3rh | head -n 5'

# Quickly find and print the top five processes consuming memory.
alias psmem='ps aux | sort --stable --parallel=2 -k4rh | head -n 5'

# Show a tree view of all processes owned by the current user.
alias processes='ps xf'

# Set a default pastebin website for the pastebinit utility.
alias pastebinit='pastebinit -b http://paste.ubuntu.com'

# Update a system, global packages and the like, through the use of a single command.
alias update='sudo aptitude update && sudo aptitude full-upgrade && sudo aptitude clean && sudo aptitude autoclean'

# Connect to the Hyper-Expanse OpenVPN access point.
alias connect='tmux new-session -s OpenVPN "cd ${HOME}/Documents/OpenVPN/; sudo openvpn --config ${HOME}/Documents/OpenVPN/client.conf"'

# Instruct `cmake` to use our local system directory as the installation directory for cmake-based builds.
alias cmake='cmake -DCMAKE_INSTALL_PREFIX=${PREFIX_DIRECTORY}'

# Create a Python virtual environment using the Python 3 interpreter and the standard _env_ directory.
alias createVirtualEnvironment='virtualenv --python=python3 venv'

# Activate the `env` Python virtual environment installed within the local directory.
alias activateVirtualEnvironment='source ./venv/bin/activate'

# Instruct Celibre to add each sub-directory of the designated directory as a book to the Calibre book database.
alias addBookDirectories='calibredb add --one-book-per-directory -r'
