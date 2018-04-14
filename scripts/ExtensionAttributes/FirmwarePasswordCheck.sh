#!/bin/sh
#
# Script Name: FirmwarePasswordCheck.sh
# Function: Check if the firmware password has been set on the host
# Requirements: None
#
# Copyright 2018, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

FWPassCheck=$(/usr/sbin/firmwarepasswd -check)

if [[ "$FWPassCheck" =~ "Yes" ]]; then
    echo "<result>Set</result>"
elif [[ "$FWPassCheck" =~ "No" ]]; then
    echo "<result>Not Set</result>"
fi