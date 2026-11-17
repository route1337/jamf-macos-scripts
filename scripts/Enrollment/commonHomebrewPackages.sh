#!/bin/bash
#
# Script Name: commonHomebrewPackages.sh
# Function: Install some common Homebrew (brew.sh) brews and casks to the first user added to a new Mac during the post-DEP enrollment Setup-Your-Mac run
# Requirements: DEP, Jamf, Homebrew
#
# Copyright 2020, Route 1337 LLC, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: matthew@route1337.com
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

# Define the taps, brews, and casks we want to install
taps=("ahrenstein/taps" "cloudflare/cloudflare" "hashicorp/tap" "parera10/csshx" "scienceguns/taps")
brews=(dockutil fzf git git-crypt git-lfs gnu-sed jq openssl pyenv readline ripgrep saml2aws telnet thefuck watch wget yq yt-dlp zlib)
#casks=(aerial) # Be careful not to install casks that require prompting for sudo. This will not work in an automated fashion and will break the script.

if [[ -z "${ConsoleUser}" ]]; then
    echo "No console user is logged in. Exiting."
    exit 1
fi

# Run brew as the console user. cd is required to use sudo as another user or you get a getcwd error
brew_as_user() {
    cd /tmp/ || exit 1
    sudo -H -iu "${ConsoleUser}" "${BREW_BIN_PATH}/brew" "$@" </dev/null
}

# Fail early if Homebrew is missing or broken, instead of reporting success to Jamf
if [[ ! -x "${BREW_BIN_PATH}/brew" ]]; then
    echo "Homebrew was not found at ${BREW_BIN_PATH}/brew. Exiting."
    exit 1
fi
if ! brew_as_user list --formula >/dev/null; then
    echo "Homebrew is installed but not working. Run the Install Homebrew script first. Exiting."
    exit 1
fi

failures=0

# Check if the tap is already tapped. If not, tap it
for tap in "${taps[@]}"; do
    if brew_as_user tap | grep -qx "${tap}"; then
        echo "${tap} is tapped already. Skipping tapping"
    else
        echo "${tap} is not tapped. Tapping..."
        if ! brew_as_user tap "${tap}"; then
            echo "Failed to tap ${tap}"
            failures=$((failures + 1))
            continue
        fi
    fi
    # Homebrew ignores formulae and casks from untrusted taps, so trust each tap.
    # Third-party taps can be limited to specific formulae instead of trusting the whole tap.
    case "${tap}" in
        parera10/csshx) trust_args=(--formula parera10/csshx/csshx) ;;
        *) trust_args=("${tap}") ;;
    esac
    if ! brew_as_user trust "${trust_args[@]}"; then
        echo "Failed to trust ${tap}"
        failures=$((failures + 1))
    fi
done

# Check if the brew is already installed. If not, install it
for brew in "${brews[@]}"; do
    if brew_as_user list --formula "${brew}" >/dev/null 2>&1; then
        echo "${brew} is installed already. Skipping installation"
    else
        echo "${brew} is not installed. Installing..."
        if ! brew_as_user install "${brew}"; then
            echo "Failed to install ${brew}"
            failures=$((failures + 1))
        fi
    fi
done

# Check if the cask is already installed. If not, install it
#for cask in "${casks[@]}"; do
#    if brew_as_user list --cask "${cask}" >/dev/null 2>&1; then
#        echo "${cask} is installed already. Skipping installation"
#    else
#        echo "${cask} is not installed. Installing..."
#        if ! brew_as_user install --cask "${cask}"; then
#            echo "Failed to install ${cask}"
#            failures=$((failures + 1))
#        fi
#    fi
#done

if [[ ${failures} -gt 0 ]]; then
    echo "${failures} tap(s)/package(s) failed to install."
    exit 1
fi
echo "All taps and packages are installed."
exit 0
