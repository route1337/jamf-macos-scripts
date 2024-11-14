#!/bin/bash
#
# Script Name: configureARD.sh
# Function: Configure Apple Remote Desktop using the new mandatory API-first method Apple requires
# Requirements: DEP, Jamf, Homebrew
#
# Copyright 2020, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# Contributors:
# - Jamf API Functions: "junjishimazaki" (https://u.route1337.net/l7Tyq3L5)
#
# See LICENSE
#

# Get variables passed in from Jamf
JAMF_API_USER="$4"
JAMF_API_PASSWORD="$5"

# Check if Apple Silicon
if [ "$(uname -m)" == "arm64" ]; then
  IS_ARM=1
  BREW_BIN_PATH="/opt/homebrew/bin"
  ConsoleUser="$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"
else
  IS_ARM=0
  BREW_BIN_PATH="/usr/local/bin"
  ConsoleUser="$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"
  #ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
fi

### Run through the new Jamf API flow (mandatory as of Monterey) ###

# Get the URL of the Jamf API
JAMF_API_URL=$( /usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url )
# Encode the API Creds
ENCODED_CREDS=$(printf "$JAMF_API_USER:$JAMF_API_PASSWORD" | iconv -t ISO-8859-1 | base64 -i -)
# Get an auth token
AUTH_TOKEN=$( /usr/bin/curl -s "${JAMF_API_URL}api/v1/auth/token" -H "authorization: Basic ${ENCODED_CREDS}" -X POST | tr -d "\n" )
# Remove the expiration from the token
FOREVER_TOKEN=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$AUTH_TOKEN\`).token" )
#Get the Mac's UDID
UDID=$( /usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformUUID/ { split($0, line, "\""); printf("%s\n", line[4]); }' )
# Get the Mac's Jamf ID from the computer record
MAC_RECORD=$( /usr/bin/curl -s "${JAMF_API_URL}api/v1/computers-inventory?section=USER_AND_LOCATION&filter=udid%3D%3D%22${UDID}%22" -H "authorization: Bearer ${FOREVER_TOKEN}" )
MAC_JAMF_ID=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$MAC_RECORD\`).results[0].id" )
echo "The Mac's Jamf ID is: ${MAC_JAMF_ID}"
# Send the actual MDM command to enable remote desktop
echo "Enabling ARD via MDM..."
/usr/bin/curl --header "Authorization: Bearer $FOREVER_TOKEN" "${JAMF_API_URL}JSSResource/computercommands/command/EnableRemoteDesktop/id/${MAC_JAMF_ID}" -X POST
# Expire the token now that we're done with it
/usr/bin/curl "${JAMF_API_URL}uapi/auth/invalidateToken" --silent --request POST --header "Authorization: Bearer $FOREVER_TOKEN"

### Configure typical ARD setup via kickstart ###

PRIVILEGES="-DeleteFiles -ControlObserve -TextMessages -OpenQuitApps -GenerateReports -RestartShutDown -SendFiles -ChangeSettings"
echo "Enabling ARD for all users via kickstart..."
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setmenuextra -menuextra yes

echo "Done"
