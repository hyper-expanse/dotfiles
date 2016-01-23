#!/usr/bin/env bash

# Convert uncompressed WAV-formatted audio files to compressed FLAC-formatted files whenin the current directory Converting to FLAC provides smaller file sizes, while retaining all audio information.

for file in *.wav; do
	# Extract the file name, minus the file extension.
	fileName="${file%.wav}"

	# Re-compress using FLAC.
	flac --verify --best "$file" "$fileName.flac" < /dev/null
done
