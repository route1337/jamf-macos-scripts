#!/bin/sh
#
# Script Name: ARDStatus.sh
# Function: Return the current status of Apple Remote Desktop
# Requirements: None
#
# Copyright 2022, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

ARDAgentStatus=$(ps ax | grep -c -i "[Aa]rdagent")
if [ $ARDAgentStatus -eq 1 ]; then
    echo "<result>Running</result>"
else
    echo "<result>Not Running</result>"
fi
