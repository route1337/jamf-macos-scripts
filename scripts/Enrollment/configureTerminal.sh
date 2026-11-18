#!/bin/bash
#
# Script Name: configureTerminal.sh
# Function: Configure Terminal for the first user added to a new Mac during the post-DEP enrollment Setup-Your-Mac run
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

# Path to a zsh configuration file
zsh_config="https://raw.githubusercontent.com/ahrenstein/noodling/main/zsh/mac-zshrc"

# GPG Suite's pinentry (installed by the Install GPG Suite script, which runs before this one)
pinentry_path="/usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac"

if [[ -z "${ConsoleUser}" ]]; then
    echo "No console user is logged in. Exiting."
    exit 1
fi
user_home="$(/usr/bin/dscl . -read "/Users/${ConsoleUser}" NFSHomeDirectory | awk '{print $2}')"
if [[ -z "${user_home}" || ! -d "${user_home}" ]]; then
    echo "Could not find the home folder for ${ConsoleUser}. Exiting."
    exit 1
fi

### ZSH CONFIGURATION ###
# Download a zsh configuration for the current user (only replace .zshrc if the download succeeds)
tmp_zshrc="$(/usr/bin/mktemp)"
if /usr/bin/curl -fsSL "${zsh_config}" -o "${tmp_zshrc}" && [[ -s "${tmp_zshrc}" ]]; then
    /bin/mv "${tmp_zshrc}" "${user_home}/.zshrc"
    echo "Installed .zshrc from ${zsh_config}"
else
    /bin/rm -f "${tmp_zshrc}"
    echo "Failed to download ${zsh_config}. Exiting."
    exit 1
fi

### GPG AGENT FOR SSH (Yubikey) ###
# Per Step 5 of https://www.route1337.com/tutorials/using-a-yubikey-4-and-gpg-for-ssh-on-a-mac/
gnupg_dir="${user_home}/.gnupg"
agent_conf="${gnupg_dir}/gpg-agent.conf"
/bin/mkdir -p "${gnupg_dir}"
/bin/chmod 700 "${gnupg_dir}"
/usr/bin/touch "${agent_conf}"

# Add each gpg-agent.conf setting only if that option isn't already set, so existing values are kept
add_agent_option() {
    local option="$1" line="$2"
    if ! /usr/bin/grep -qE "^[[:space:]]*${option}([[:space:]]|$)" "${agent_conf}"; then
        echo "${line}" >> "${agent_conf}"
    fi
}
add_agent_option "default-cache-ttl" "default-cache-ttl 600"
add_agent_option "max-cache-ttl" "max-cache-ttl 7200"
add_agent_option "pinentry-program" "pinentry-program ${pinentry_path}"
add_agent_option "enable-ssh-support" "enable-ssh-support"
if [[ ! -x "${pinentry_path}" ]]; then
    echo "Warning: ${pinentry_path} not found. Is GPG Suite installed?"
fi

# Point SSH at gpg-agent's socket
echo 'SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh' > "${user_home}/.gpg-agent-info"

# The .zshrc downloaded above already loads ~/.gpg-agent-info, so it is not modified here

# Everything written above belongs to the user
/usr/sbin/chown "${ConsoleUser}":staff "${user_home}/.zshrc" "${user_home}/.gpg-agent-info"
/usr/sbin/chown -R "${ConsoleUser}":staff "${gnupg_dir}"
/bin/chmod 600 "${agent_conf}"

echo "Terminal configured for ${ConsoleUser}."
exit 0
