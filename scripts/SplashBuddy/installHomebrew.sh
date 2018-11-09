#!/bin/bash
#
# Script Name: installHomebrew.sh
# Function: Deploy Homebrew (brew.sh) to the first user added to a new Mac during the post-DEP enrollment SplashBuddy run
# Requirements: DEP, SplashBuddy
#
# Copyright 2018, Route 1337, LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# Contributors:
# - "Dakr-xv": https://github.com/Dakr-xv
#
# See LICENSE
#

# Apple approved way to get the currently logged in user (Thanks to Froger from macadmins.org and https://developer.apple.com/library/content/qa/qa1133/_index.html)
ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"

# Check to see if we have XCode already
checkForXcode=$( pkgutil --pkgs | grep com.apple.pkg.CLTools_Executables | wc -l | awk '{ print $1 }' )

# If XCode is missing we will install the Command Line tools only as that's all Homebrew needs
if [[ "$checkForXcode" != 1 ]];
then
    osx_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    # Verify softwareupdate installs only the latest XCode (Original code from https://github.com/rtrouton/rtrouton_scripts)
    cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$osx_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
    if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
	   cmd_line_tools_output="$cmd_line_tools"
	   cmd_line_tools=$(printf "$cmd_line_tools_output" | tail -1)
	fi
    softwareupdate -i "$cmd_line_tools"
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
fi

# Test if Homebrew is installed and install it if it is not
if test ! "$(sudo -u $ConsoleUser which brew)"; then
  # Jamf will have to execute all of the directory creation functions Homebrew normally does so we can bypass the need for sudo
  /bin/chmod u+rwx /usr/local/bin
  /bin/chmod g+rwx /usr/local/bin
  /bin/mkdir -p /usr/local/etc /usr/local/include /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/var /usr/local/opt /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var/homebrew /usr/local/var/homebrew/linked /usr/local/Cellar /usr/local/Caskroom /usr/local/Homebrew /usr/local/Frameworks
  /bin/chmod 755 /usr/local/share/zsh /usr/local/share/zsh/site-functions
  /bin/chmod g+rwx /usr/local/bin /usr/local/etc /usr/local/include /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/var /usr/local/opt /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var/homebrew /usr/local/var/homebrew/linked /usr/local/Cellar /usr/local/Caskroom /usr/local/Homebrew /usr/local/Frameworks
  /bin/chmod 755 /usr/local/share/zsh /usr/local/share/zsh/site-functions
  /usr/sbin/chown $ConsoleUser /usr/local/bin /usr/local/etc /usr/local/include /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/var /usr/local/opt /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var/homebrew /usr/local/var/homebrew/linked /usr/local/Cellar /usr/local/Caskroom /usr/local/Homebrew /usr/local/Frameworks
  /usr/bin/chgrp admin /usr/local/bin /usr/local/etc /usr/local/include /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/var /usr/local/opt /usr/local/share/zsh /usr/local/share/zsh/site-functions /usr/local/var/homebrew /usr/local/var/homebrew/linked /usr/local/Cellar /usr/local/Caskroom /usr/local/Homebrew /usr/local/Frameworks
  /bin/mkdir -p /Users/$ConsoleUser/Library/Caches/Homebrew
  /bin/chmod g+rwx /Users/$ConsoleUser/Library/Caches/Homebrew
  /usr/sbin/chown $ConsoleUser /Users/$ConsoleUser/Library/Caches/Homebrew
  /bin/mkdir -p /Library/Caches/Homebrew
  /bin/chmod g+rwx /Library/Caches/Homebrew
  /usr/sbin/chown $ConsoleUser /Library/Caches/Homebrew


  # Install Homebrew as the currently logged in user
  sudo -H -u $ConsoleUser ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  </dev/null
# If Homebrew is already installed then just echo that it is already installed
else
  echo "Homebrew is already installed"
fi
