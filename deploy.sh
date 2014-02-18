#!/usr/bin/env bash

#====================================================
# Custom Aliases
#
# This script will deploy all dotfiles as symlinks to the user's home directory.
#====================================================

echo "Deploying dotfiles..."

# Symlink files to the user's home directory.
for file in `find . -type f -name '.*' -print`; do
	rm ~/${file#./} &> /dev/null
	ln -s `pwd`/${file#./} ~/${file#./}
done

# Symlink top-level directories to the user's home directory.
echo "Symlinking directories not supported yet."
for directory  in `find . -maxdepth 1 -type d -print`; do
	if [ "${directory}" == './.git' -o "${directory}" == '.' ]; then
		continue
	fi
done

echo "Finished deploying dotfiles."
