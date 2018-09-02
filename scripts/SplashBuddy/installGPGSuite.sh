#!/bin/bash
#
# Script Name: installGPGSuite.sh
# Function: This script grabs and installs the latest GPG Suite so you don't have to maintain packages
# Requirements: DEP, SplashBuddy
#
# Copyright 2018, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# Contributors:
# - URL grabbing method: "Dakr-xv" (https://github.com/Dakr-xv)
#
# See LICENSE
#

### Variables ###

# Get the link for latest GPGSuite download link
GPGSuite_URL=$(curl -L https://GPGSuite.org/gpgsuite.html | grep "Download" | awk '{print $2}' | grep 'http' | cut -f2 -d'"')

# Name of the DMG file that will be downloaded
GPGSuite_DMG=$(echo "${GPGSuite_URL}" | cut -f4 -d"/")

# Path where the DMG will be stored locally
GPGSuite_LocalDMG=/tmp/${GPGSuite_DMG}

### Download and install process ###

# Download the latest version of GPGSuite
curl -o ${GPGSuite_LocalDMG} $GPGSuite_URL

# Mount the locally saved DMG
sudo hdiutil attach ${GPGSuite_LocalDMG}

# Install the package inside the mounted DMG
sudo installer -package /Volumes/GPG\ Suite/Install.pkg -target /

# Unmount the locally saved DMG
sudo hdiutil detach /Volumes/GPG\ Suite

# Delete the locally saved DMG
sudo rm -rf ${GPGSuite_LocalDMG}