#!/bin/sh
#
# Script Name: FusionSerialsNumbers.sh
# Function: Check if VMware Fusion is installed, and gather the serial numbers associated with it
# Requirements: None
#
# Copyright 2018, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

if [ -d "/Library/Preferences/VMware Fusion" ]; then
    result=`cat /Library/Preferences/VMware\ Fusion/license* | grep Serial | awk '{print $3}' | sed 's/"//g'`
fi

echo "<result>$result</result>"