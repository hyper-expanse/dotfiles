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
		echo "Selected a file for compression. Changing directory to '${dirName}''."
		cd "${dirName}"
		case "${2}" in
			tar.bz2)   tar cjf ${baseName}.tar.bz2 ${baseName} ;;
			tar.gz)    tar czf ${baseName}.tar.gz ${baseName}  ;;
			gz)        gzip ${baseName}                        ;;
			tar)       tar -cvvf ${baseName}.tar ${baseName}   ;;
			zip)       zip -r ${baseName}.zip ${baseName}      ;;
			*)
				echo "A compression format was not chosen. Defaulting to tar.gz"
				tar czf ${baseName}.tar.gz ${baseName}
				;;
		esac
		echo "Navigating back to ${dirPriorToExe}"
		cd "${dirPriorToExe}"
	elif [ -d "${1}" ]; then
		echo "Selected a directory for compression. Changing directory to '${dirName}''."
		cd "${dirName}"
		case "${2}" in
			tar.bz2)   tar cjf ${baseName}.tar.bz2 ${baseName} ;;
			tar.gz)    tar czf ${baseName}.tar.gz ${baseName}  ;;
			gz)        gzip -r ${baseName}                     ;;
			tar)       tar -cvvf ${baseName}.tar ${baseName}   ;;
			zip)       zip -r ${baseName}.zip ${baseName}      ;;
			*)
				echo "A compression format was not chosen. Defaulting to tar.gz"
				tar czf ${baseName}.tar.gz ${baseName}
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

#! Convert a Zip file to a compressed Tar file (*.tar.gz).
# Take a Zip file, extract the contents to a temporary directory, and then re-archive the extracted contents into a compressed Tar file.
#
# \param $1 Path to the Zip archive file.
convertZip ()
{
	tmpdir="$(mktemp -d)"

	unzip -q "${1}" -d "${tmpdir}/"

	outfilename="$(echo "$(basename "${1}")" | rev | cut -d. -f2- | rev).tar"

	tar --create --exclude="${outfilename}" --file="${tmpdir}/${outfilename}" -C "${tmpdir}/" .

	pigz -9 "${tmpdir}/${outfilename}"

	mv "${tmpdir}/${outfilename}.gz" "$(dirname "${1}")"

	rm -rf "${tmpdir}"
	rm -f "${1}"
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
	printf "\n> Removing ${HOMEBREW_PREFIX} directory.\n"

	# Clear out our local system directory.
	if [ -d "${HOMEBREW_PREFIX}" ]; then
		rm -fr "${HOMEBREW_PREFIX}" &> /dev/null
	fi

	# Setup Brew.
	setupHomeBrew
	installBrewPackages

	# Execute `nvm` script to configure our local environment to work with `nvm`.
	source "$(brew --prefix nvm)/nvm.sh"

	# Install additional tools.
	installNodePackages
	installPythonPackages
	installNerdFonts

	# Configure our desktop environment.
	setupTilingWindowManager
}

#! Update environment.
# Update our development environment by installing the latest version of our desired tools.
updateEnvironment ()
{
	# Update Brew.
	brew update

	# Upgrade all Brew-installed packages.
	brew upgrade

	# Cleanup Brew installation.
	brew cleanup -s

	# Update general tools.
	installNodePackages
	installPythonPackages
	installNerdFonts

	# Configure our desktop environment.
	setupTilingWindowManager
}

#! Setup HomeBrew.
# Install HomeBrew locally so that we can download, build, and install tools from source.
setupHomeBrew ()
{
	printf "\n> Installing HomeBrew.\n"

	# Create a local binary directory before any setup steps require its existence. It must exist for the tar extraction process to extract the contents of Brew into the `.local/` directory.
	mkdir -p "${HOMEBREW_PREFIX}/Homebrew"

	# Download an archive version of the #master branch of Brew to the local system for future extraction. We download an archive version of Brew, rather than cloning the #master branch, because we must assume that the local system does not have the `git` tool available (A tool that will be installed later using Brew).
	curl -L https://github.com/Homebrew/brew/archive/master.tar.gz -o "/tmp/homebrew.tar.gz"

	# Extract archive file into local system directory.
	tar -xf "/tmp/homebrew.tar.gz" -C "${HOMEBREW_PREFIX}/Homebrew/" --strip-components=1

	# Symlink the dedicated brew binary into our Homebrew binary directory.
	mkdir -p "${HOMEBREW_PREFIX}/bin/"
	ln -s "${HOMEBREW_PREFIX}/Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin/"

	# Cleanup.
	rm -f "/tmp/homebrew.tar.gz"
}

#! Install packages via Brew.
# Install packages via Brew's `brew` CLI tool.
installBrewPackages()
{
	if command -v brew &> /dev/null; then
		printf "\n> Installing Brew packages.\n"

		# Install the latest Bash shell environment. This will give us access to the latest features in our primary work environment.
		brew install bash

		# Install bash-completion. This allows us to leverage bash completion scripts installed by our brew installed packages. Version @2 is required for Bash > 2.
		brew install bash-completion@2

		# Install python version 3, which `pip` is also included, as the header files are required by natively-built pip packages.
		brew install python

		# Install Go compiler and development stack.
		brew install go

		# Install nvm, a CLI tool for managing Node interpreter versions within the current shell environment.
		brew install nvm

		# Install htop, a human-readable version of top.
		brew install htop

		# Install git, a distributed source code management tool.
		brew install git

		# Install the Large File Storage (LFS) git extension. The Large File Storage extension replaces large files that would normally be committed into the git repository, with a text pointer. Each revision of a file managed by the Large File Storage extension is stored server-side. Requires a remote git server with support for the Large File Storage extension.
		brew install git-lfs

		# Install ncdu, a command line tool for displaying disk usage information.
		brew install ncdu

		# Static site generator and build tool.
		brew install hugo

		# Install resource orchestration tool.
		brew install terraform

		# Install terminal multiplexer.
		brew install tmux

		# Install command line text editor.
		brew install neovim

		# Install network traffic inspection tool.
		brew install tcpdump

		if [ "$(uname)" == "Darwin" ]; then
			# Latest GNU core utilities, such as `rm`, `ls`, etc.
			brew install coreutils

			# Store Docker Hub credentials in the OSX Keychain for improved security.
			brew install docker-credential-helper

			# Cloud tools
			brew install svn awscli
			brew install aws-iam-authenticator

			brew install wget
			brew install pinentry-mac

			brew install --cask firefox
			brew install --cask visual-studio-code
			brew install --cask keepassxc
			brew install --cask gpg-suite
			brew install --cask joplin # For taking and organizing notes.
			brew install --cask iterm2
			brew install --cask slack
			brew install --cask wireshark # For network debugging.
		fi

		if [ "$(uname -n)" == "startopia" ]; then
			# Install shell script linter.
			# NOTE: We force the installation of `shellcheck` from the pre-compiled bottle as installing `shellcheck` from
			# source requires `ghc` to be installed from source, and that build appears to never complete.
			brew install shellcheck --force-bottle

			# Install flac, a command line tool for re-encoding audio files into Flac format.
			brew install flac

			# GNU data recovery tool.
			brew install ddrescue

			# Tool for ripping DVD's from the command line.
			brew install dvdbackup

			# Tool to create backups of online video files and streams.
			brew install youtube-dl
		fi
	else
		echo "ERROR: `brew` is required for building and installing tools from source, but it's not available in your PATH. Please install `brew` and ensure it's in your PATH. Then re-run `installBrewPackages`."
	fi
}

#! Install NodeJS packages.
# Install NodeJS packages via `yarn`.
installNodePackages ()
{
	if command -v npm &> /dev/null; then
		printf "\n> Installing Node packages.\n"

		# Install latest LTS release of NodeJS.
		nvm install --lts

		# Globally install the Yarn package manager so that we can use that package manager in subsequent tool installation steps.
		npm install -g yarn

		# Tool to update a markdown file, such as a `README.md` file, with a Table of Contents.
		yarn global add doctoc
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

		# Using `pip3` to install other packages is necessary to avoid errors like `pkg_resources.VersionConflict: (pip 19.0.3 (~.local/lib/python3.7/site-packages), Requirement.parse('pip==19.0.2'))`

		# Package and virtual environment manager for Python.
		pip3 install pipenv --user --upgrade

		# Shell prompt configuration and theming tool.
		pip3 install powerline-status --user --upgrade
		installPowerlineFonts
	else
		echo "ERROR: `pip` is required for installing Python packages, but it's not available in your PATH. Please install `pip` and ensure it's in your PATH. Then re-run `installPythonPackages`."
	fi
}

#! Install Powerline fonts.
# Install Powerline fonts into our fontconfig directory so apply to our current chosen font.
installPowerlineFonts ()
{
    mkdir -p "${XDG_DATA_HOME}/fonts/"
    curl -L https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -o "${XDG_DATA_HOME}/fonts/PowerlineSymbols.otf"

    mkdir -p "${XDG_CONFIG_HOME}/fontconfig/conf.d/"
    curl -L https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -o "${XDG_CONFIG_HOME}/fontconfig/conf.d/10-powerline-symbols.conf"

    fc-cache -vf "${XDG_DATA_HOME}/fonts/"
}

#! Install Nerd fonts.
# Install Nerd fonts into our fontconfig directory so apply to our current chosen font and leverage in Neovim.
installNerdFonts ()
{
	local tmpdir="$(mktemp -d)"

	# Always download the latest release.
	curl https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*Hack.zip" | cut -d '"' -f 4 | wget -qi - -P "${tmpdir}"

	# Extract Hack glyps into our `fonts` directory by updating existing files and adding new files.
	unzip -u -q "${tmpdir}/Hack.zip" -d "${XDG_DATA_HOME}/fonts/"

	# Update our font cache so fonts takes effect immediately
	fc-cache -vf "${XDG_DATA_HOME}/fonts/"
}

#! Find all file types in use and convert to standard types.
# Find all file types in use within a given directory and offer to convert files to a known set of standard file types, such as WAV to FLAC, using appropriate permissions (not globally readable).
checkAndConvert ()
{
	# TODO: Prompt user whether global permissions should be revoked from listed files.
	printf "\n> List of globally accessible files.\n"
	find . \( -perm -o+r -or -perm -o+w -or -perm -o+x \) | xargs ls -l

	## TODO: Rename all files to be all lower-case.
	# for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`; done
	# ls | sed -n 's/.*/mv "&" $(tr "[A-Z]" "[a-z]" <<< "&")/p' | bash

	# TODO: Convert some known file formats to an alternative, "open", file format.
	# To convert Office documents to ODF formats such as `.ods`.
	# lowriter --headless --convert-to ods *.xlsx
}

#! Setup tiling window manager on KDE.
# Setup a tiling window manager on a KDE desktop by extending KDE's existing KWin window manager using KDE's ability to load arbitrary scripts as plugins.
setupTilingWindowManager () {
	# Only install the tiling window manager on KDE.
	if command -v plasmapkg2 &> /dev/null; then
		local dirPriorToExe=`pwd`
		local tmpdir="$(mktemp -d)"

		git clone https://github.com/kwin-scripts/kwin-tiling.git "${tmpdir}"

		cd "${tmpdir}"

		# Download a fixed commit to install as our tiling window management script to minimize the chance of breaking changes.
		git checkout 51e51f4bb129dce6ab876d07cfd8bdb3506390e1

		plasmapkg2 --type kwinscript -u .

		# Fix documented here - https://github.com/kwin-scripts/kwin-tiling/issues/79#issuecomment-311465357
		# Upstream KDE bug report - https://bugs.kde.org/show_bug.cgi?id=386509
		mkdir --parent "${HOMEBREW_PREFIX}/share/kservices5"
		ln --force --symbolic "${HOMEBREW_PREFIX}/share/kwin/scripts/kwin-script-tiling/metadata.desktop" "${HOMEBREW_PREFIX}/share/kservices5/kwin-script-tiling.desktop"

		cd "${dirPriorToExe}"

		echo "Navigate to the KWin scripts manager to enable the 'kwinscript' script."
	fi
}
