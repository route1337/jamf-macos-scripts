Jamf Pro Scripts for macOS Management - Install Common Homebrew Packages
==============
This script runs during the post-DEP DEPNotify run and installs some common [Homebrew](https://brew.sh) brews and casks for the initially created user

Requirements
------------
1. DEP: Yes 
2. [Jamf](https://www.jamf.com/products/jamf-pro/): Yes

macOS Compatibility Matrix
------------
This script has been tested on the following macOS versions

| Tested macOS Major Version               | Expected Working Minor Versions     | DEP Required |
|------------------------------------------|-------------------------------------|--------------|
| Catalina                                 | 10.15.0-10.15.5                     | Yes          |

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
| parera10/csshx                 | tap           | A custom tap that has a fixed csshx package                                   |
| aerial                         | cask          | Screensaver that uses the same Aerial footage as AppleTV's Aerials            |
| ansible                        | brew          | Configuration management tool commonly used by admins                         |
| ansible-lint                   | brew          | A linting tool for Ansible code                                               |
| awscli                         | brew          | AWS commandline tools                                                         |
| parera10/csshx/csshx           | brew          | Cluster SSH tool (Custom fixed version)                                       |
| dc3dd                          | brew          | Forensic dd command                                                           |
| docker                         | brew          | Docker command line tool (Requires docker cask to be installed separately)    |
| docker-compose                 | brew          | Docker command line tool (Requires docker cask to be installed separately)    |
| docker-machine-driver-vmware   | brew          | Docker integration with VMware Fusion                                         |
| dockutil                       | brew          | Dock layout management utility (for use in other scripts)                     |
| git                            | brew          | A more up to date version of git                                              |
| git-crypt                      | brew          | git extension for encrypting secrets in repos                                 |
| git-flow                       | brew          | A tool to make git-flow usage simple                                          |
| git-lfs                        | brew          | git's LFS add-on                                                              |
| gnu-sed                        | brew          | GNU version of sed                                                            |
| jq                             | brew          | Simple tool to make pretty JSON output                                        |
| kubernetes-cli                 | brew          | The Kubernetes command line tool                                              |
| minikube                       | brew          | A local Kubernetes development environment                                    |
| openssh                        | brew          | An up to date version of OpenSSH                                              |
| p7zip                          | brew          | A simple 7zip tool                                                            |
| packer                         | brew          | virtual machine image creation tool                                           |
| pipenv                         | brew          | Python pip environments tool                                                  |
| pyenv                          | brew          | Python virtual environments tool                                              |
| qemu                           | brew          | Virtual machine packaging tools                                               |
| rbenv                          | brew          | Ruby environment manager                                                      |
| ruby-build                     | brew          | Ruby build tool                                                               |
| saml2aws-duo                   | brew          | A tool for authentication to JumpCloud+Duo for AWS credentials                |
| telnet                         | brew          | Common network testing tool                                                   |
| terraform                      | brew          | Infrastructure as code tool                                                   |
| thefuck                        | brew          | bash typo correction tool                                                     |
| unrar                          | brew          | A simple tool to expand .rar archives                                         |
| vfuse                          | brew          | A simple tool to convert bootable DMG files to virtual machines               |
| watch                          | brew          | Linux-style watch command                                                     |
| wget                           | brew          | Linux-style wget command                                                      |
| ykman                          | brew          | A command line tool for managing Yubikeys                                     |
| youtube-dl                     | brew          | Youtube video downloading tool                                                |

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
