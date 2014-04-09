#!/usr/bin/env bash

#====================================================
# Deploy Git Hooks
#
# This script will deploy all Git hooks into the hidden Git hook directory.
#====================================================

GIT_DIRECTORY=$(git rev-parse --show-toplevel)

echo "Deploying Git hooks..."

# Symlink Git hooks to the project's hidden Git hook directory.
echo "> Symlinking files into the hidden Git hooks directory."
for file in `find ${GIT_DIRECTORY}/hooks -type f -not -iname '*.*' -printf "%f\n"`; do
	rm ${GIT_DIRECTORY}/.git/hooks/${file} &> /dev/null
	ln -s ${GIT_DIRECTORY}/hooks/${file} ${GIT_DIRECTORY}/.git/hooks/${file}
done

echo "Finished deploying Git hooks."
