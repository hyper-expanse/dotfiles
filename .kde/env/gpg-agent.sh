#!/usr/bin/env bash

#====================================================
# Start GPG Agent
#
# This script starts a GPG Agent in daemon mode.
#====================================================

eval "$(gpg-agent --daemon)"
