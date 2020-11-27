Jamf Pro Scripts for macOS Management - Configure Terminal
==============
This script runs during the post-DEP DEPNotify run and Configures the first user's Terminal with some custom settings

Requirements
------------
1. DEP: Yes 
2. [Jamf](https://www.jamf.com/products/jamf-pro/): Yes

macOS Compatibility Matrix
------------
This script has been tested on the following macOS versions

| Tested macOS Major Version               | Expected Working Minor Versions     | DEP Required |
|------------------------------------------|-------------------------------------|--------------|
| Catalina                                 | 11.0.1(I)                           | Yes          |

Script Operations
------------
This script will perform the following operations

1. Deploy a custom `.zshrc` to the initial user during DEP enrollment.

Limitations
------------

1. This script requires access to a [specific GitHub repo](https://github.com/ahrenstein/noodling)

Known Issues
------------
1. None so far :)

Use Cases
------------
Configure Terminal with some custom engineering configurations

[Back to main README](../README.md)
