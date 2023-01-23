#!/bin/sh
#
# Script Name: installBraveBrowser.sh
# Function: This script grabs and installs the latest Brave Browser so you don't have to maintain packages
# Requirements: DEP, DEPNotify
#
# Copyright 2023, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

# Vendor supplied DMG file
VendorDMG="Brave-Browser.dmg"

# Download vendor supplied DMG file into /tmp/
curl https://referrals.brave.com/latest/$VendorDMG -o /tmp/$VendorDMG

# Mount vendor supplied DMG File
hdiutil attach /tmp/$VendorDMG -nobrowse

# Copy contents of vendor supplied DMG file to /Applications/
# Preserve all file attributes and ACLs
cp -pPR /Volumes/Brave\ Browser/Brave\ Browser.app /Applications/

# Identify the correct mount point for the vendor supplied DMG file 
BraveBrowserDMG="$(hdiutil info | grep "/Volumes/Brave Browser" | awk '{ print $1 }')"

# Unmount the vendor supplied DMG file
hdiutil detach $BraveBrowserDMG

# Remove the downloaded vendor supplied DMG file
rm -f /tmp/$VendorDMG
