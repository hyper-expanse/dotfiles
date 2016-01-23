#!/usr/bin/env bash

# Convert Zip files to a Tar 7-Zip file. 7-Zip offers a greater level of compression.

for file in *.zip; do
	# Extract Zip files.
	unzip "$file"

	# Get just the file name, which should match the directory that the Zip file was extracted into.
	folderName="${file%.zip}"

	# Re-compress using Tar and 7-Zip.
	tar --create --preserve-permissions "${folderName}/" | 7za a -si "${folderName}.tar.7z"
done
