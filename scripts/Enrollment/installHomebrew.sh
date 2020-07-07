#!/bin/bash
#
# Script Name: installHomebrew.sh
# Function: Deploy Homebrew (brew.sh) to the first user added to a new Mac during the post-DEP enrollment DEPNotify run
# Requirements: DEP, Jamf
#
# Copyright 2020, Route 1337, LLC, All Rights Reserved.
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
if [[ "$checkForXcode" != 1 ]]; then
  macos_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  # Verify softwareupdate installs only the latest XCode (Original code from https://github.com/rtrouton/rtrouton_scripts)
  if [[ "$macos_vers" -ge 15 ]]; then
     cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)
  elif [[ "$macos_vers" -gt 9 ]] && [[ "$macos_vers" -lt 14 ]]; then
     cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$macos_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
  elif [[ "$macos_vers" -eq 9 ]]; then
     cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
  fi
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

  # Manually install the initial Homebrew
  /bin/mkdir -p /usr/local/Homebrew
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /usr/local/Homebrew

  # Core directories
  /bin/mkdir -p /usr/local/Cellar /usr/local/Homebrew /usr/local/Frameworks /usr/local/bin /usr/local/etc /usr/local/Caskroom
  /bin/mkdir -p /usr/local/include /usr/local/lib /usr/local/opt /usr/local/sbin /usr/local/var/homebrew/linked
  /bin/mkdir -p /usr/local/share/zsh/site-functions /usr/local/var
  /bin/mkdir -p /usr/local/share/doc /usr/local/man/man1 /usr/local/share/man/man1
  /usr/sbin/chown -R $ConsoleUser:admin /usr/local/*
  /bin/chmod -Rf g+rwx /usr/local/*
  /bin/chmod 755 /usr/local/share/zsh /usr/local/share/zsh/site-functions

  # Cache directories
  mkdir -p /Library/Caches/Homebrew
  chmod g+rwx /Library/Caches/Homebrew
  chown $ConsoleUser:staff /Library/Caches/Homebrew

  # Create a system wide cache folder
  mkdir -p /Library/Caches/Homebrew
  chmod g+rwx /Library/Caches/Homebrew
  chown $ConsoleUser:staff /Library/Caches/Homebrew

  # Symlink Homebrew to the usual place
  ln -s /usr/local/Homebrew/bin/brew /usr/local/bin/brew

  # Run an initial update
  sudo -H -iu ${ConsoleUser} /usr/local/bin/brew update  </dev/null

  # Disable Homebrew analytics
  sudo -H -iu ${ConsoleUser} /usr/local/bin/brew analytics off  </dev/null

# If Homebrew is already installed then just echo that it is already installed
else
  echo "Homebrew is already installed"
fi
