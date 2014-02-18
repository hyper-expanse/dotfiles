#!/usr/bin/env bash

#====================================================
# Kill GPG Agent
#
# This script gets the identifier associated with the GPG agent running under the current user's session and kills it.
#====================================================

# The second substring of the GPG_AGENT_INFO variable is the process ID of the GPG agent active in the current session. We extract the process ID from the agent info file so that we can kill that, rather than all GPG agents on the system.
[ -n "${GPG_AGENT_INFO}" ] && kill `echo ${GPG_AGENT_INFO} | cut -d ':' -f 2`
