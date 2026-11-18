#!/bin/bash
#
# Script Name: installHomebrew.sh
# Function: Deploy Homebrew (brew.sh) to the first user added to a new Mac during the post-DEP enrollment Setup-Your-Mac run
# Requirements: DEP, Jamf
#
# Copyright 2020, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
#
# Contributors:
# - "Dakr-xv": https://github.com/Dakr-xv
#
# Using MIT Licensed Code From:
# - "rtrouton": https://github.com/rtrouton
#
# See LICENSE
#

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

### Script from rtrouton ###
# Source: https://github.com/ryangball/rtrouton_scripts/blob/main/rtrouton_scripts/install_xcode_command_line_tools/install_xcode_command_line_tools.sh

# Installing the latest Xcode command line tools on 10.9.x or higher
ignoreBeta="true"	# Setting to true will ignore beta. However, setting to false does not guarantee a beta is available.
# Save current IFS state
OLDIFS=$IFS
IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"
# restore IFS to previous state
IFS=$OLDIFS
cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 9 ) || ( ${osvers_major} -ge 11 && ${osvers_minor} -ge 0 ) ]]; then

	# Create the placeholder file which is checked by the softwareupdate tool
	# before allowing the installation of the Xcode command line tools.

	touch "$cmd_line_tools_temp_file"

	# Identify the correct update in the Software Update feed with "Command Line Tools" in the name for the OS version in question.

	if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 15 ) || ( ${osvers_major} -ge 11 && ${osvers_minor} -ge 0 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -gt 9 ) ]] && [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -lt 15 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$osvers_minor" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 9 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	fi

	# Check to see if the softwareupdate tool has returned more than one Xcode
	# command line tool installation option. If it has, use the one with the
	# largest detected version number

	if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
	   version_check=$(echo "$cmd_line_tools" | awk -F'-' '{print $2}' | sort -V | tail -n1)
	   newest_version=$(echo "$cmd_line_tools" | grep -F "Xcode-$version_check")
	   cmd_line_tools=$newest_version
	fi
	#Install the command line tools
	softwareupdate -i "$cmd_line_tools" --verbose
	# Remove the temp file
	if [[ -f "$cmd_line_tools_temp_file" ]]; then
	  rm "$cmd_line_tools_temp_file"
	fi
fi
### Script from rtrouton ###

# Test if Homebrew is installed and install it if it is not
### INSTALL HOMEBREW ###
# Homebrew is installed as a git checkout of the main branch so `brew update` works.
# (The old tarball/master download is a frozen snapshot that current Homebrew refuses to run.)
if [[ "$IS_ARM" == 1 ]]; then
  BREW_PREFIX="/opt/homebrew"
  BREW_REPO="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
  BREW_REPO="/usr/local/Homebrew"
fi
BREW_GIT_URL="https://github.com/Homebrew/brew"
GIT_BIN="/usr/bin/git"

if [[ -z "${ConsoleUser}" ]]; then
  echo "No console user is logged in. Exiting."
  exit 1
fi

# If full Xcode is installed and selected, /usr/bin/git refuses to run until Xcode's license
# is accepted, which also breaks brew. Accept it non-interactively and finish first-launch setup.
developer_dir="$(/usr/bin/xcode-select -p 2>/dev/null)"
if [[ "${developer_dir}" == *".app/Contents/Developer" ]]; then
  echo "Xcode is the active developer directory (${developer_dir}). Accepting the Xcode license..."
  /usr/bin/xcodebuild -license accept
  /usr/bin/xcodebuild -runFirstLaunch
fi

if ! "${GIT_BIN}" --version >/dev/null 2>&1; then
  echo "git is not available. The Xcode Command Line Tools install likely failed. Exiting."
  exit 1
fi

# Run a command as the console user from a directory they can read
as_user() {
  cd /tmp/ || exit 1
  sudo -H -u "${ConsoleUser}" "$@" </dev/null
}

# Turn BREW_REPO into a git checkout of Homebrew's main branch.
# Works on an empty directory or on top of an old tarball install (Cellar etc. are git-ignored).
setup_brew_repo() {
  /bin/mkdir -p "${BREW_REPO}"
  /usr/sbin/chown "${ConsoleUser}":admin "${BREW_REPO}"
  as_user "${GIT_BIN}" -C "${BREW_REPO}" init -q || return 1
  as_user "${GIT_BIN}" -C "${BREW_REPO}" config remote.origin.url "${BREW_GIT_URL}" || return 1
  as_user "${GIT_BIN}" -C "${BREW_REPO}" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" || return 1
  as_user "${GIT_BIN}" -C "${BREW_REPO}" fetch --force --tags origin || return 1
  as_user "${GIT_BIN}" -C "${BREW_REPO}" checkout -q -f -B main origin/main || return 1
  as_user "${GIT_BIN}" -C "${BREW_REPO}" branch -q -u origin/main main || return 1
}

# Create the standard Homebrew directories and give them to the console user
setup_brew_dirs() {
  /bin/mkdir -p "${BREW_PREFIX}"/{Cellar,Frameworks,bin,etc,Caskroom,include,lib,opt,sbin,var/homebrew/linked}
  /bin/mkdir -p "${BREW_PREFIX}"/share/zsh/site-functions "${BREW_PREFIX}"/share/doc "${BREW_PREFIX}"/share/man/man1 "${BREW_PREFIX}"/man/man1
  if [[ "$IS_ARM" == 1 ]]; then
    /usr/sbin/chown -R "${ConsoleUser}":admin "${BREW_PREFIX}"
    /bin/chmod -R u+rwx,g+rwx "${BREW_PREFIX}"
  else
    for dir in Homebrew Cellar Frameworks bin etc Caskroom include lib opt sbin var share man; do
      /usr/sbin/chown -R "${ConsoleUser}":admin "${BREW_PREFIX}/${dir}"
      /bin/chmod -R g+rwx "${BREW_PREFIX}/${dir}"
    done
    # Symlink Homebrew to the usual place
    ln -sf "${BREW_REPO}/bin/brew" "${BREW_PREFIX}/bin/brew"
  fi
  /bin/chmod 755 "${BREW_PREFIX}/share/zsh" "${BREW_PREFIX}/share/zsh/site-functions"

  # System wide cache folder
  /bin/mkdir -p /Library/Caches/Homebrew
  /bin/chmod g+rwx /Library/Caches/Homebrew
  /usr/sbin/chown "${ConsoleUser}":staff /Library/Caches/Homebrew
}

echo "Checking if Homebrew is installed..."
if [[ -x "${BREW_REPO}/bin/brew" && -d "${BREW_REPO}/.git" ]]; then
  echo "Homebrew already installed."
else
  if [[ -x "${BREW_REPO}/bin/brew" ]]; then
    echo "Found a Homebrew install that is not a git checkout. Converting it to a git checkout of main..."
  else
    echo "Installing Homebrew for ${ConsoleUser} into ${BREW_REPO}..."
  fi
  if ! setup_brew_repo; then
    echo "Failed to clone Homebrew from ${BREW_GIT_URL}. Exiting."
    exit 1
  fi
  setup_brew_dirs
fi

# Run an update and make sure brew actually works
if ! sudo -H -iu "${ConsoleUser}" "${BREW_BIN_PATH}/brew" update </dev/null; then
  echo "brew update failed. Exiting."
  exit 1
fi
# Disable Homebrew analytics
sudo -H -iu "${ConsoleUser}" "${BREW_BIN_PATH}/brew" analytics off </dev/null
echo "Homebrew is installed and up to date."
exit 0
### END INSTALL HOMEBREW ###
