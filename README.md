Jamf Pro Scripts for macOS Management
==================================
This repository contains various scripts for managing macOS devices through the Jamf Pro MDM system. 

Scripts
------------
The following scripts are available in this repo

| Script                                                                | Short Description                                                  | DEP Required | macOS Versions Tested   | Deployment Methods Supported                                         |
|---------------------------------------------------------------------- |--------------------------------------------------------------------|--------------|-------------------------|----------------------------------------------------------------------|
| [Install Homebrew](documentation/installHomebrew.md)                  | Install Homebrew for the initial user                              | Yes          | 10.15.0, 10.15.5        | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify)                   |
| [Common Homebrew Packages](documentation/commonHomebrewPackages.md)   | Install common Homebrew brews and casks for the initial user       | Yes          | 10.15.0, 10.15.5        | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify)                   |
| [Install GPG Suite](documentation/installGPGSuite.md)                 | Install GPG Suite for the initial user                             | Yes          | 10.15.0, 10.15.5        | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify)                   |

Extension Attributes
------------
The following extension attributes are available in this repo

| Extension Attribute                              | Short Description                                                  | Recommended Inventory Display Location | macOS Versions Tested   |
|------------------------------------------------- |--------------------------------------------------------------------|----------------------------------------|-------------------------|
| HomebrewInstalled.sh                             | Check if Homebrew is installed                                     | Hardware                               | 10.15.0, 10.15.5        |
| FusionSerialsNumbers.sh                          | Return the serial numbers detected for VMware Fusion 10+           | Extension Attributes                   | 10.15.0, 10.15.5        |
| FirmwarePasswordCheck.sh                         | Check if the firmware password has been set                        | Extension Attributes                   | 10.15.0, 10.15.5        |
| ARDStatus.sh                                     | Return the current status of Apple Remote Desktop                  | Operating System                       | 10.15.0, 10.15.5        |

Donate To Support These Scripts
------------
Route 1337, LLC operates entirely on donations. If you find these scripts useful, please consider using the GitHub Sponsors button to donate to the people who contributed to this project.

Thank you for your support!
