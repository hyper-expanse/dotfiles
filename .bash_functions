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

#! Replace content in `package.json` files in multiple directories.
# Replace the content of individual lines within `package.json` files within multiple directories.
#
# \param $1 Key in the `package.json` file.
# \param $2 The original value associated with the key.
# \param $3 New content to replace the original value associated with the key.
replacePackageContentRecursively ()
{
	find . -maxdepth 2 -type f -name package.json -exec sed -i "s/\"${1}\": \"${2}\"/\"node\": \"${3}\"/g" {} \;
}

#! Copy a single file from one sub-folder into all top-level folders under the current directory.
# Copy a single file, as provided to the function, from one sub-folder into all top-level folders under the current working directory.
#
# \param $1 Path to the desired file for copying, relative to the current working directory.
copyFileAcrossGroup ()
{
	for dir in *; do
		echo $dir;
		cd $dir;

		# Ignore `cp` alias which may interfere with the ability to quickly copy a file across multiple directories.
		\cp "../${1}" . --archive --verbose;

		cd ..;
		echo;
	done
}

#! Checkout, add, commit, and then push, across a group of sub-folders.
# Checkout a new branch, add all modified, new, or deleted files, create a commit, and then push the new branch to the remote fork of the authoritative repository.
#
# \param $1 Branch name to use for the branch that will be created and eventually pushed to the remote fork.
# \param $2 Commit message to use for the commit that will be created from modified, new, or deleted, files.
gitGroupPush ()
{
	for dir in *; do
		echo $dir;
		cd $dir;

		if [ -n "$(git status -s)" ]; then
			git checkout -b "${1}"
			git add --all;
			git commit -m "${2}";
			git push -u hutson "${1}";
		fi;

		cd ..;
		echo;
	done
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

	printf "\n> Removing ${HOME}/.tmux/ directory.\n"

	# Clear out our Tmux directory.
	if [ -d "${HOME}/.tmux/" ]; then
		rm -fr "${HOME}/.tmux/" &> /dev/null
	fi

	printf "\n> Removing ${XDG_DATA_HOME}/nvim/ directory.\n"

	# Clear out our neovim directory.
	if [ -d "${XDG_DATA_HOME}/nvim/" ]; then
		rm -fr "${XDG_DATA_HOME}/nvim/" &> /dev/null
	fi

	# Create our local tmp directory for use by tools that cache compilation artifacts there. This directory must exist before those tools can create sub-directories within it.
	mkdir --parents "${HOME}/.local/tmp"

	# Setup Linuxbrew.
	setupLinuxbrew
	installBrewPackages

	# Install general tools.
	installPythonPackages

	# Install Firefox.
	installFirefox

	#updateNeovim
}

#! Update environment.
# Update our development environment by installing the latest version of our desired tools.
updateEnvironment ()
{
	# Update Linuxbrew.
	updateLinuxbrew
	updateBrewPackages

	# Update general tools.
	installNodePackages
	installPythonPackages

	#updateNeovim
}

#! Setup Linuxbrew, the Linux-clone of HomeBrew.
# Install Linuxbrew locally so that we can download, build, and install tools from source.
setupLinuxbrew ()
{
	printf "\n> Installing Linuxbrew.\n"

	# Create a local binary directory before any setup steps require its existence. It must exist for the tar extraction process to extract the contents of LinuxBrew into the `.local/` directory.
	mkdir --parents "${HOME}/.local/bin"

	# Download an archive version of the #master branch of LinuxBrew to the local system for future extraction. We download an archive version of LinuxBrew, rather than cloning the #master branch, because we must assume that the local system does not have the `git` tool available (A tool that will be installed later using LinuxBrew).
	wget https://github.com/Linuxbrew/brew/archive/master.tar.gz -O "/tmp/linuxbrew.tar.gz"

	# Extract archive file into local system directory.
	tar -xf "/tmp/linuxbrew.tar.gz" -C "${HOME}/.local/" --strip-components=1

	# Cleanup.
	rm "/tmp/linuxbrew.tar.gz"

	# Link compilers into local bin directory for non-Debian systems, as non-Debian systems do not expose a version-named binary for compilers like gcc, or g++. For example, on Debian, you may find `gcc-4.4` in your path.
	local uname=`uname -a`
	local debian="Debian"
	if [ "${uname/$debian}" = "${uname}" ] ; then
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

	# Tap for the neovim text editor.
	brew tap neovim/neovim
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

#! Update neovim environment.
# Update plugins associated with the user's local environment. This includes doing the following:
# 1) Remove plugins from neovim's bundle directory that are no longer listed in the user's configuration file.
# 2) Install plugins listed in the user's configuration file that are not already installed.
# 3) Update plugins that are already installed on the system.
updateNeovim ()
{
	printf "\n> Updating neovim.\n"

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

	# Update neovim plugins.
	if command -v nvim &> /dev/null; then
		nvim +PlugUpgrade +PlugClean! +PlugUpdate +qa
	else
		printf "\n> ERROR: `nvim` is required for updating neovim's plugins, but it's not available in your PATH. Please install `nvim` and ensure it's in your PATH. Then re-run `updateNeovim`.\n"
	fi
}

#! Install packages via Linuxbrew.
# Install packages via Linuxbrew's `brew` CLI tool.
installBrewPackages()
{
	if command -v brew &> /dev/null; then
		printf "\n> Installing Brew packages.\n"

		# Install openssl, which is required by various other brew builds. (git)
		brew install pkg-config # Dependency of openssl, required in some instances (some systems).
		brew install openssl # (git)

		# Install python version 3, which `pip` is also included, as the header files are required by natively-built pip packages.
		brew install python3

		# Install bash-completion. This allows us to leverage bash completion scripts installed by our brew installed packages.
		brew install bash-completion

		# NODE
			# We call `installNodePackages` after installing each version of Node so as to install our global Node modules within the `node_modules` directory associated with the currently enabled version of Node. This is necessary since some Node modules must be built against the currently enabled version of Node. Therefore they can't be installed in a global directory shared by all installed versions of Node.

			# Download and install nvm, a CLI tool for managing Node interpreter versions within the current shell environment.
			brew install nvm

			# Execute `nvm` script to configure our local environment to work with `nvm`.
			source "$(brew --prefix nvm)/nvm.sh"

			# Install the latest LTS version of Node.
			nvm install 6

			# Install alternative JavaScript package manager called `yarn`.
			brew install yarn

			# Once our `yarn` package manager has been installed, install all our Node packages.
			installNodePackages

		## NODE END

		# Download and install go, a compiler and runtime.
		brew install go

		# Download and install neovim, a terminal text editor.
		brew install gperf # A dependency of neovim, but not installed by their homebrew formula.
		#brew install neovim

		# Download and install Tmux, a terminal multiplexer.
		# Need to install `libevent` first. `libevent` is a dependency of `tmux`.
		brew install libevent
		brew install tmux

		# Download and install htop, a human-readable version of top.
		brew install htop

		# Download and install git, a distributed source code management tool.
		brew install git

		# Install the Large File Storage (LFS) git extension. The Large File Storage extension replaces large files that would normally be committed into the git repository, with a text pointer. Each revision of a file managed by the Large File Storage extension is stored server-side. Requires a remote git server with support for the Large File Storage extension.
		brew install git-lfs

		# Enable the Large File Storage extension.
		git lfs install

		# Download and install flac, a command line tool for re-encoding audio files into Flac format.
		brew install flac

		# Download and install ncdu, a command line tool for displaying disk usage information.
		brew install ncdu

		# Download and install scrub, a command line tool for securely deleting files.
		brew install scrub

		# Cross-platform, open-source, build system.
		brew install cmake

		# Static site generator and build tool.
		brew install hugo

		# Tool to run multiple jobs in parallel using all available CPUs.
		brew install parallel

		# Tool used to compute CPU load for prompt line.
		brew install bc

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

#! Update brew packages via Linuxbrew.
# Update previously installed brew packages via Linuxbrew's `brew` CLI tool.
updateBrewPackages ()
{
	if command -v brew &> /dev/null; then
		printf "\n> Updating Brew packages.\n"

		# Update the brew installation.
		brew update

		# Upgrade all Brew-installed packages.
		brew upgrade --all

		# Cleanup Linuxbrew installation.
		brew cleanup -s --force
	else
		echo "ERROR: `brew` is required for updating brew packages, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `updateBrewPackages`."
	fi
}

#! Install NodeJS packages.
# Install NodeJS packages via `yarn`.
installNodePackages ()
{
	if command -v yarn &> /dev/null; then
		printf "\n> Installing Node packages.\n"

		# Update the version of `npm` installed in our environment.
		yarn global add npm

		# Install command line tab completion for `yarn`.
		yarn global add yarn-completions

		# Required to enable Syntastic checking for JavaScript files.
		yarn global add jscs
		yarn global add jshint
		yarn global add eslint
		yarn global add tslint
		yarn global add jsonlint

		# Required to enable Tagbar to properly parse JavaScript files for tag information.
		yarn global add git://github.com/ramitos/jsctags.git#aa16b21dadeb40645aa66dec7002eb39c537ee77

		# `Foreman`-like tool for managing arbitrary processes within a local environment.
		yarn global add foreman

		# CLI tool required to run Yeoman generators that scaffold projects.
		yarn global add yo

		# Required for running a project based on the gulp task runner.
		yarn global add gulp-cli

		# Required for running a project based on the grunt task runner.
		yarn global add grunt-cli

		# Tool to update a markdown file, such as a `README.md` file, with a Table of Contents.
		yarn global add doctoc

		# Tool for viewing and manipulating Git repositories on Secure Scuttlebutt (SSB).
		yarn global add git-ssb
	else
		echo "ERROR: `yarn` is required for installing NodeJS packages, but it's not available in your PATH. Please install `yarn` and ensure it's in your PATH. Then re-run `installNodePackages`."
	fi
}

#! Install Python packages.
# Install Python packages via `pip`.
installPythonPackages ()
{
	if command -v pip3 &> /dev/null; then
		printf "\n> Installing Python packages.\n"

		# Update the version of `pip` installed in our environment.
		pip3 install --user pip --upgrade

		# Required to manage virtual Python environments.
		pip3 install --user virtualenv --upgrade

		# Required to enable Syntastic checking for Python files.
		pip3 install --user pylint --upgrade
		pip3 install --user pep8 --upgrade

		# Required by neovim to support vim Python packages in neovim.
		pip3 install --user neovim --upgrade
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

		# Python development tools.
		code --install-extension donjayamanne.python

		# GO development tools.
		code --install-extension lukehoban.Go

		# C++ development tools.
		code --install-extension ms-vscode.cpptools

		# General, offline, spell checker.
		code --install-extension streetsidesoftware.code-spell-checker

		# Material icon theme.
		code --install-extension PKief.material-icon-theme

		# Support for Git blame annotations.
		code --install-extension eamodio.gitlens

		# Docker support.
		code --install-extension PeterJausovec.vscode-docker
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
	mkdir --parents "${HOME}/.local/opt"

	# Download an archive version of the latest version of Firefox to the local system for future extraction.
	wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" -O "/tmp/firefox.tar.bz2"

	# Extract archive file into an ad-hoc local system directory.
	rm -rf "${HOME}/.local/opt/firefox"
	tar -jxf "/tmp/firefox.tar.bz2" -C "${HOME}/.local/opt/"

	# Symlink the extracted Firefox binary into our standard local binary directory.
	rm "${HOME}/.local/bin/firefox"
	ln -s "${HOME}/.local/opt/firefox/firefox" "${HOME}/.local/bin/firefox"

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
Icon=${HOME}/.local/opt/firefox/browser/icons/mozicon128.png
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Firefox
StartupNotify=true" > "${HOME}/.local/share/applications/firefox-stable.desktop"

	# Cleanup.
	rm "/tmp/firefox.tar.bz2"
}
