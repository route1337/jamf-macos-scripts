Jamf Pro Scripts for macOS Management - Configure ARD
==============
This script runs during the post-DEP Setup-Your-Mac run and Configures Apple Remote Desktop via both the new mandatory API method
and then via kickstart for customization

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

API Permissions
---------------
The following permissiosn are needed for the API user

| Privilege               | Object                               | CRUD |
|-------------------------|--------------------------------------|------|
| Jamf Pro Server Objects | Computers                            | CR   |
| Jamf Pro Server Actions | Send Computer Remote Desktop Command | Yes  |

Script Operations
------------
This script will perform the following operations

1. Connect to the Jamf API and enable Remote Desktop via MDM
2. Use kickstart for further customization

Limitations
------------

1. This script requires access to a [specific GitHub repo](https://github.com/ahrenstein/noodling)

Known Issues
------------
1. None so far :)

Use Cases
------------
Configure ARD for admin access to assist in troubleshooting

Security Notes
--------------
Enabling ARD on devices that may be on public networks could be a security risk.

[Back to main README](../README.md)
