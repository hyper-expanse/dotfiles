#!/usr/bin/env bash

#====================================================
# Custom Aliases
#
# This script only needs to be sourced upon logging into a system to provide useful command aliases.
#====================================================

if [ "$(uname)" = "Darwin" ]; then
	# Prompt the user once before removing any file.
	alias rm='rm -i'
else
	# Do not allow deletion of content at the root level, /, and prompt the user once before removing more than three files or when removing files and directories recursively.
	alias rm='rm -I --preserve-root'
fi

# Enable common command confirmations with additional verbosity.
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -i'

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
alias scram='history -c; clear; /usr/bin/env rm -r ${XDG_DATA_HOME}/nvim/shada/ ${XDG_DATA_HOME}/nvim/undo/'

# Find the top 5 largest files within the current, and sub, directories.
alias findbig='find . -type f -exec ls -lha {} \; | sort --stable --parallel=2 -t" " -k5rh | head -5'

# List all ports currently opened on the system with port numbers and processes shown.
alias ports='netstat -tulanp'

# Alias wget so that it will always attempt to continue a file that was not successfully downloaded to begin with.
alias wget='wget -c'

# Quickly find and print the top five processes consuming CPU cycles.
alias pscpu='ps aux | sort --stable --parallel=2 -k3rh | head -n 5'

# Quickly find and print the top five processes consuming memory.
alias psmem='ps aux | sort --stable --parallel=2 -k4rh | head -n 5'

# Show a tree view of all processes owned by the current user.
alias processes='ps xf'

# Update system packages and local packages through the use of a single command.
alias update='updateSystem && updateEnvironment'

# Update system packages.
alias updateSystem='sudo apt update && sudo apt full-upgrade && sudo apt autoremove'

# Instruct Celibre to add each sub-directory of the designated directory as a book to the Calibre book database.
alias addBookDirectories='calibredb add --one-book-per-directory -r'

# Print out the status, using `git status`, of each top-level git directory under the current working directory.
alias gitGroupStatus='find . -maxdepth 1 -type d -not -path . -exec sh -c "echo \"{}\"; cd \"{}\"; git status --short --branch; cd ..; echo;" \;'

# Run `git setup` within each top-level folder under the current working directory to clean-up each working repository of any build artifacts, un-committed changes, etc.
alias gitGroupSetup='find . -maxdepth 1 -type d -not -path . -exec sh -c "echo \"{}\"; cd \"{}\"; git setup && git cleanup; cd ..; echo;" \;'

# Call `git diff` within every sub-folder under the current working directory, with the assumption that each sub-folder is a git directory.
alias gitGroupDiff='find . -maxdepth 1 -type d -not -path . -exec sh -c "echo \"{}\"; cd \"{}\"; git diff --unified; cd ..; echo;" \;'

# Spin up Node development environment within a Docker container.
alias nodeDocker='docker run --rm --user node -v "$(pwd)":/app -w /app -it node:12 sh -c "yarn install; yarn test; sh"'

# Reset our GPG environment to work with a different Yubikey (One Yubikey was removed from the system and another Yubikey key was plugged in.)
alias yubiset='rm -rf ~/.gnupg/private-keys-v1.d/ && gpgconf --kill gpg-agent && gpgconf --launch gpg-agent'

# List file extensions in use, starting at the current working directory and searching recursively.
alias fileExtensions='find . -type f | perl -ne "print $1 if m/\.([^.\/]+)$/" | sort | uniq -c | sort -n'
