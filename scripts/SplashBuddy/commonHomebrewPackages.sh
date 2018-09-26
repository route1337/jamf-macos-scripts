#!/bin/bash
#
# Script Name: commonHomebrewPackages.sh
# Function: Install some common Homebrew (brew.sh) brews and casks to the first user added to a new Mac during the post-DEP enrollment SplashBuddy run
# Requirements: DEP, SplashBuddy, Homebrew
#
# Copyright 2018, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

# Apple approved way to get the currently logged in user (Thanks to Froger from macadmins.org and https://developer.apple.com/library/content/qa/qa1133/_index.html)
ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
# Define the brews and casks we want to install
brews=(ansible awscli csshx dc3dd dockutil git-crypt git-flow git-lfs gnu-sed jq packer rbenv ruby-build telnet terraform thefuck watch wget youtube-dl)
casks=(aerial) # Be careful not to install casks that require prompting for sudo. This will not work in an automated fashion and will break the script.

# Check if the brew is already installed. If not, install it
for brew in ${brews[@]}; do
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
    if [[ $(sudo -H -iu ${ConsoleUser} /usr/local/bin/brew info ${brew}) != *Not\ installed* ]]; then
        echo "$brew is installed already. Skipping installation"
    else
        echo "$brew is either not installed or not available. Attempting installation..."
        sudo -H -iu ${ConsoleUser} /usr/local/bin/brew install ${brew}
    fi
done

# Check if the cask is already installed. If not, install it
for cask in ${casks[@]}; do
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
    if [[ $(sudo -H -iu ${ConsoleUser} /usr/local/bin/brew cask info ${cask}) != *Not\ installed* ]]; then
        echo "$cask is installed already. Skipping installation"
    else
        echo "$cask is either not installed or not available. Attempting installation..."
        sudo -H -iu ${ConsoleUser} /usr/local/bin/brew cask install ${cask}
    fi
done
