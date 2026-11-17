Jamf Pro Scripts for macOS Management - Install Common Homebrew Packages
==============
This script runs during the post-DEP Setup-Your-Mac run and installs some common [Homebrew](https://brew.sh) brews and casks for the initially created user

Requirements
------------
1. DEP: Yes 
2. [Jamf](https://www.jamf.com/products/jamf-pro/): Yes

macOS Compatibility Matrix
------------
This script has been tested on the following macOS versions

| Tested macOS Major Version | Expected Working Minor Versions | DEP Required |
|----------------------------|---------------------------------|--------------|
| Sequoia                    | 15.0                            | Yes          |

Script Operations
------------
This script will perform the following operations

1. Check for Homebrew and fail if it's not found
2. Check if each brew or cask is already installed, and attempt to install it if it is not

Packages Installed
------------
The following brews and casks are installed

| Package                        | Package Type  | Purpose                                                                       |
|--------------------------------|---------------|-------------------------------------------------------------------------------|
| ahrenstein/taps                | tap           | A custom tap that has Duo Support for JumpCLoud in saml2aws                   |
| cloudflare/cloudflare          | tap           | Cloudflare's official tap                                                     |
| hashicorp/tap                  | tap           | HashiCorp's official tap (Terraform, Vault, Packer, etc.)                     |
| parera10/csshx                 | tap           | Tap for csshX (cluster SSH); only the csshx formula is trusted                |
| scienceguns/taps               | tap           | ScienceGuns' custom tap                                                       |
| dockutil                       | brew          | Dock layout management utility (for use in other scripts)                     |
| fzf                            | brew          | Command-line fuzzy finder                                                     |
| git                            | brew          | A more up to date version of git                                              |
| git-crypt                      | brew          | git extension for encrypting secrets in repos                                 |
| git-lfs                        | brew          | git's LFS add-on                                                              |
| gnu-sed                        | brew          | GNU version of sed                                                            |
| jq                             | brew          | Command-line JSON processor                                                   |
| openssl                        | brew          | Current OpenSSL toolkit                                                       |
| pyenv                          | brew          | Python version manager                                                        |
| readline                       | brew          | GNU readline library (used when pyenv builds Python)                          |
| ripgrep                        | brew          | Fast recursive search tool (rg)                                               |
| saml2aws                       | brew          | AWS CLI login through a SAML identity provider                                |
| telnet                         | brew          | Common network testing tool                                                   |
| thefuck                        | brew          | bash typo correction tool                                                     |
| watch                          | brew          | Linux-style watch command                                                     |
| wget                           | brew          | Linux-style wget command                                                      |
| yq                             | brew          | Command-line YAML, JSON and XML processor                                     |
| yt-dlp                         | brew          | Video downloader                                                              |
| zlib                           | brew          | Compression library (used when pyenv builds Python)                           |

Limitations
------------

1. This script requires that Homebrew be installed prior to running
2. This script requires access to brew.sh and github.com for Homebrew installation
3. This script requires an initial user to be created by the end user during the macOS OOBE
4. Casks that ask for sudo will cause the script to hang and then fail

Known Issues
------------
1. None so far :)

Use Cases
------------
Installing the most common brews and/or casks in use by your organization

[Back to main README](../README.md)
