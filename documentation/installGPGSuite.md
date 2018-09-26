Jamf Pro Scripts for macOS Management - Install GPG Suite
==============
This script runs during the post-DEP SplashBuddy run and installs [GPG Suite](https://gpgtools.org/) for the initially created user

Requirements
------------
1. DEP: Yes 
2. [SplashBuddy](https://github.com/Shufflepuck/SplashBuddy): Yes

macOS Compatibility Matrix
------------
This script has been tested on the following macOS versions

| Tested macOS Major Version               | Tested Minor Versions                          | Expected Working Minor Versions     | DEP Required |
|------------------------------------------|------------------------------------------------|-------------------------------------|--------------|
| Mojave                                   | 10.14                                          | 10.13.0-10.14.0                     | Yes          |

Script Operations
------------
This script will perform the following operations

1. Download and install the latest GPG Suite from https://gpgtools.org/

Limitations
------------

1. This script requires access to the internet
2. This script relies on https://gpgtools.org/ not changing their download link format
3. This script requires an initial user to be created by the end user during the macOS OOBE 

Known Issues
------------
1. None so far :)

Use Cases
------------
Installing GPG Suite for use by the end user

[Back to main README](../README.md)