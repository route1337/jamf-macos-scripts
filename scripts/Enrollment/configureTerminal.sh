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

# Apple approved way to get the currently logged in user (Thanks to Froger from macadmins.org and https://developer.apple.com/library/content/qa/qa1133/_index.html)
ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
# Path to a zsh configuration file
zsh_config="https://raw.githubusercontent.com/ahrenstein/noodling/main/zsh/mac-zshrc"

# Download a zsh configuration for the current user
sudo -H -iu ${ConsoleUser} /usr/bin/curl https://raw.githubusercontent.com/ahrenstein/noodling/main/zsh/mac-zshrc > /Users/${ConsoleUser}/.zshrc
