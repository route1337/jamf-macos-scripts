Jamf Pro Scripts for macOS Management - Install Common Homebrew Packages
==============
This script runs during the post-DEP SplashBuddy run and installs some common [Homebrew](https://brew.sh) brews and casks for the initially created user

Requirements
------------
1. DEP: Yes 
2. [SplashBuddy](https://github.com/Shufflepuck/SplashBuddy): Yes

macOS Compatibility Matrix
------------
This script has been tested on the following macOS versions

| Tested macOS Major Version               | Tested Minor Versions                          | Expected Working Minor Versions     | DEP Required |
|------------------------------------------|------------------------------------------------|-------------------------------------|--------------|
| High Sierra                              | 10.13.6                                        | 10.13.0-10.13.6                     | Yes          |

Script Operations
------------
This script will perform the following operations

1. Check for Homebrew and fail if it's not found
2. Check if each brew or cask is already installed, and attempt to install it if it is not

Packages Installed
------------
The following brews and casks are installed

| Package               | Package Type  | Purpose                                                                  |
|-----------------------|---------------|--------------------------------------------------------------------------|
| ansible               | brew          | Configuration management tool commonly used by admins                    |
| awscli                | brew          | AWS commandline tools                                                    |
| csshx                 | brew          | Cluster SSH tool                                                         |
| dc3dd                 | brew          | Forensic dd command                                                      |
| dockutil              | brew          | Dock layout management utility (for use in other scripts)                |
| git-crypt             | brew          | git extension for encrypting secrets in repos                            |
| git-flow              | brew          | A tool to make git-flow usage simple                                     |
| git-lfs               | brew          | git's LFS add-on                                                         |
| gnu-sed               | brew          | GNU version of sed                                                       |
| jq                    | brew          | Simple tool to make pretty JSON output                                   |
| packer                | brew          | virtual machine image creation tool                                      |
| rbenv                 | brew          | Ruby environment manager                                                 |
| ruby-build            | brew          | Ruby build tool                                                          |
| telnet                | brew          | Common network testing tool                                              |
| terraform             | brew          | Infrastructure as code tool                                              |
| thefuck               | brew          | bash typo correction tool                                                |
| watch                 | brew          | Linux-style watch command                                                |
| wget                  | brew          | Linux-style wget command                                                 |
| youtube-dl            | brew          | Youtube video downloading tool                                           |

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