Jamf Pro Scripts for macOS Management - Configure Terminal
==============
This script runs during the post-DEP Setup-Your-Mac run and Configures the first user's Terminal with some custom settings

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

1. Deploy a custom `.zshrc` to the initial user during DEP enrollment.
2. Configure `gpg-agent` for SSH authentication with a Yubikey, per Step 5 of the [Route 1337 Yubikey guide](https://www.route1337.com/tutorials/using-a-yubikey-4-and-gpg-for-ssh-on-a-mac/)

Limitations
------------

1. This script requires access to a [specific GitHub repo](https://github.com/ahrenstein/noodling)
2. The GPG Suite install script must run first so `pinentry-mac` exists

Known Issues
------------
1. None so far :)

Use Cases
------------
Configure Terminal with some custom engineering configurations

[Back to main README](../README.md)
