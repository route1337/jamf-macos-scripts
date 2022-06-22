#!/bin/bash
#
# Script Name: commonHomebrewPackages.sh
# Function: Install some common Homebrew (brew.sh) brews and casks to the first user added to a new Mac during the post-DEP enrollment DEPNotify run
# Requirements: DEP, Jamf, Homebrew
#
# Copyright 2020-2022, Route 1337 LLC, All Rights Reserved.
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

# Apple approved way to get the currently logged in user (Thanks to Froger from macadmins.org and https://developer.apple.com/library/content/qa/qa1133/_index.html)
# Define the taps, brews, and casks we want to install
taps=("ahrenstein/taps")
brews=(dockutil git git-crypt git-flow git-lfs gnu-sed telnet thefuck unrar watch wget)
#casks=(aerial) # Be careful not to install casks that require prompting for sudo. This will not work in an automated fashion and will break the script.

# Check if the tap is already tapped. If not, tap it
for tap in ${taps[@]}; do
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
    if sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew tap | grep "${tap}"; then
        echo "${tap} is tapped already. Skipping tapping"
    else
        echo "${tap} is either not tapped or not available. Attempting tapping..."
        sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew tap "${tap}"
    fi
done

# Check if the brew is already installed. If not, install it
for brew in ${brews[@]}; do
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
    if [[ $(sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew info ${brew}) != *Not\ installed* ]]; then
        echo "${brew} is installed already. Skipping installation"
    else
        echo "${brew} is either not installed or not available. Attempting installation..."
        sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew install ${brew}
    fi
done

# Check if the cask is already installed. If not, install it
#for cask in ${casks[@]}; do
#    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
#    if [[ $(sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew cask info ${cask}) != *Not\ installed* ]]; then
#        echo "${cask} is installed already. Skipping installation"
#    else
#        echo "${cask} is either not installed or not available. Attempting installation..."
#        sudo -H -iu ${ConsoleUser} ${BREW_BIN_PATH}/brew cask install ${cask}
#    fi
#done
