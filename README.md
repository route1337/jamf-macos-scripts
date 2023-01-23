Jamf Pro Scripts for macOS Management
=====================================
This repository contains various scripts for managing macOS devices through the Jamf Pro MDM system. 

Scripts
-------
The following scripts are available in this repo

| Script                                                              | Short Description                                               | DEP Required | macOS Versions Tested | Deployment Methods Supported                       |
|---------------------------------------------------------------------|-----------------------------------------------------------------|--------------|-----------------------|----------------------------------------------------|
| [Install Brave Browser](documentation/installBraveBrowser.md)       | Install The Brave Browser for the initial user                  | Yes          | 13.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |
| [Install Homebrew](documentation/installHomebrew.md)                | Install Homebrew for the initial user                           | Yes          | 12.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |
| [Common Homebrew Packages](documentation/commonHomebrewPackages.md) | Install common Homebrew brews and casks for the initial user    | Yes          | 12.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |
| [Install GPG Suite](documentation/installGPGSuite.md)               | Install GPG Suite for the initial user                          | Yes          | 12.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |
| [Configure Terminal](documentation/configureTerminal.md)            | Configure a custom zsh shell for the initial user               | Yes          | 12.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |
| [Configure ARD](documentation/configureARD.md)                      | Configure Apple Remote Desktop via Jamf API and local kickstart | Yes          | 12.1(AS)              | [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) |

Extension Attributes
--------------------
The following extension attributes are available in this repo

| Extension Attribute      | Short Description                                        | Recommended Inventory Display Location | macOS Versions Tested |
|--------------------------|----------------------------------------------------------|----------------------------------------|-----------------------|
| HomebrewInstalled.sh     | Check if Homebrew is installed                           | Hardware                               | 12.1(AS)              |
| FusionSerialsNumbers.sh  | Return the serial numbers detected for VMware Fusion 10+ | Extension Attributes                   | 12.1(AS)              |
| FirmwarePasswordCheck.sh | Check if the firmware password has been set              | Extension Attributes                   | 12.1(AS)              |
| ARDStatus.sh             | Return the current status of Apple Remote Desktop        | Operating System                       | 12.1(AS)              |

Fixes
-----
The following scripts are used to perform various end user fixes that normally require IT support

| Extension Attribute | Short Description                                     | Recommended Inventory Display Location | macOS Versions Tested |
|---------------------|-------------------------------------------------------|----------------------------------------|-----------------------|
| fixSpotlight.sh     | Disable Spotlight, delete the index, and re-enable it | Quick Fixes                            | 12.4(AS)              |


Donate To Support These Scripts
------------
Route 1337 LLC's open source code heavily relies on donations. If you find these scripts useful, please consider using the GitHub Sponsors button to donate to the people who contributed to this project.

Thank you for your support!
