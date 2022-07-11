#!/bin/bash
#
# Script Name: fixSpotlight.sh
# Function: Fix Spotlight if it fails to index apps/documents on your Mac
#
# Copyright 2022, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# See LICENSE
#

# Disable Spotlight indexing
/usr/bin/mdutil -i off /

# Delete the boot volume's Spotlight folder(s)
/bin/rm -rf /.Spotlight*

# Disable Spotlight indexing
/usr/bin/mdutil -i on /

# Force Spotlight to re-index the boot volume
/usr/bin/mdutil -E /
