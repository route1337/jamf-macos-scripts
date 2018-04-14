Jamf Pro Scripts for macOS Management
==================================
This repository contains various scripts for managing macOS devices through the Jamf Pro MDM system. 

Scripts
------------
The following scripts are available in this repo

| Script                                           | Short Description                                | DEP Required | macOS Versions Tested   | Deployment Methods Supported                                         |
|------------------------------------------------- |--------------------------------------------------|--------------|-------------------------|----------------------------------------------------------------------|
| [Homebrew](documentation/homebrew.md)            | Install Homebrew for the initial user            | Yes          | 10.13.4                 | [SplashBuddy](https://github.com/Shufflepuck/SplashBuddy)            |

Extension Attributes
------------
The following extension attributes are available in this repo

| Extension Attribute                              | Short Description                                                  | Recommended Inventory Display Location | macOS Versions Tested   |
|------------------------------------------------- |--------------------------------------------------------------------|----------------------------------------|-------------------------|
| HomebrewInstalled.sh                             | Check if Homebrew is installed                                     | Hardware                               | 10.13.4                 |
| FusionSerialsNumbers.sh                          | Return the serial numbers detected for VMware Fusion 10+           | Extension Attributes                   | 10.13.4                 |
| FirmwarePasswordCheck.sh                         | Check if the firmware password has been set                        | Extension Attributes                   | 10.13.4                 |
| ARDStatus.sh                                     | Return the current status of Apple Remote Desktop                  | Operating System                       | 10.13.4                 |

Donate To Support These Scripts
------------
Route 1337, LLC operates entirely on donations. If you find these scripts useful, please consider donating via one of these methods.

1. Bitcoin: 1CnzzrPh3iirEkLRLiWFKXDV9i5TXHQjE2
2. Bitcoin Cash: qzcq645swgd87s7t5mmmjcumf4armhtjt5euww5c29
3. Litecoin: LWYbc9hf5ErJsF874Q3wwmMiASHRWgwrjR
4. Ethereum: 0x117543aa7a4D704849171cA06568Ece71B111D18

Thank you for your support!