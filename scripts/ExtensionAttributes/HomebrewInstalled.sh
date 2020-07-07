#!/bin/sh
#
# Script Name: HomebrewInstalled.sh
# Function: Check if Homebrew's "brew" binary exists on the local machine
# Requirements: None
#
# Copyright 2020, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

if [ -f "/usr/local/bin/brew" ] ; then
    RESULT="Yes"
else
    RESULT="No"
fi

echo "<result>$RESULT</result>"
