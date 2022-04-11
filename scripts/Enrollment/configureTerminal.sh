#!/bin/bash
#
# Script Name: configureTerminal.sh
# Function: Configure Terminal for the first user added to a new Mac during the post-DEP enrollment DEPNotify run
# Requirements: DEP, Jamf, Homebrew
#
# Copyright 2020-2022, Route 1337, LLC, All Rights Reserved.
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
    ConsoleUser="$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"
else
	IS_ARM=0
	BREW_BIN_PATH="/usr/local/bin"
    ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
fi

# Path to a zsh configuration file
zsh_config="https://raw.githubusercontent.com/ahrenstein/noodling/main/zsh/mac-zshrc"

# Download a zsh configuration for the current user
sudo -H -iu ${ConsoleUser} /usr/bin/curl https://raw.githubusercontent.com/ahrenstein/noodling/main/zsh/mac-zshrc > /Users/${ConsoleUser}/.zshrc
chown ${ConsoleUser}:staff /Users/${ConsoleUser}/.zshrc
#TODO additional Terminal configuration such as the prompt
