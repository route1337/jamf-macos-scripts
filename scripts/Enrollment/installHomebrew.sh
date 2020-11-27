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
  # Save current IFS state
  OLDIFS=$IFS
  IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"
  # restore IFS to previous state
  IFS=$OLDIFS
  cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  # Installing the latest Xcode command line tools on 10.9.x or higher
  if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 9 ) || ( ${osvers_major} -eq 11 && ${osvers_minor} -ge 0 ) ]]; then
    # Create the placeholder file which is checked by the softwareupdate tool
    # before allowing the installation of the Xcode command line tools.
    touch "$cmd_line_tools_temp_file"
    # Identify the correct update in the Software Update feed with "Command Line Tools" in the name for the OS version in question.
    if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 15 ) || ( ${osvers_major} -eq 11 && ${osvers_minor} -ge 0 ) ]]; then
       cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)
    elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -gt 9 ) ]] && [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -lt 15 ) ]]; then
       cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$macos_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
    elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 9 ) ]]; then
       cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
    fi
    # Check to see if the softwareupdate tool has returned more than one Xcode
    # command line tool installation option. If it has, use the last one listed
    # as that should be the latest Xcode command line tool installer.
    if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
       cmd_line_tools_output="$cmd_line_tools"
       cmd_line_tools=$(printf "$cmd_line_tools_output" | tail -1)
    fi
    #Install the command line tools
    softwareupdate -i "$cmd_line_tools" --verbose
    # Remove the temp file
    if [[ -f "$cmd_line_tools_temp_file" ]]; then
      rm "$cmd_line_tools_temp_file"
    fi
  fi
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
