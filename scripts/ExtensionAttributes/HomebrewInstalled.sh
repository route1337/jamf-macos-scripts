#!/bin/sh
#
# Script Name: HomebrewInstalled.sh
# Function: Check if Homebrew's "brew" binary exists on the local machine
# Requirements: None
#
# Copyright 2022, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

# Check if Apple Silicon
if [ "$(uname -m)" == "arm64" ]; then
	IS_ARM=1
	BREW_BIN_PATH="/opt/homebrew/bin"
else
	IS_ARM=0
	BREW_BIN_PATH="/usr/local/bin"
fi

if [ -f "${BREW_BIN_PATH}/brew" ] ; then
    RESULT="Yes"
else
    RESULT="No"
fi

echo "<result>$RESULT</result>"
