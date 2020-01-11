Jamf Pro Scripts for macOS Management - Changelog
==============
A list of all the changes made to this repo

Version 0.1.3
-------------

1. Testing against DEPNotify now instead of SplashBuddy.
2. Install Homebrew script fixed for Catalina

Version 0.1.2
------------

1. Fixed incorrect version regarding 0.1.1 changes in CHANGELOG
2. Renamed original Homebrew script to reflect the fact that it installs Homebrew itself
3. Added a Homebrew script for installing common brews and casks
4. Original Homebrew script updated to correctly add some missing directories (CONTRIBUTOR PR from "Dakr-xv")
5. Added a script to download and install the latest GPG Suite

Version 0.1.1
------------

1. Added several extension attribute scripts
    1. ARDStatus - Checks for Apple Remote Desktop status
    2. FirmwarePasswordCheck - Checks if the firmware password was set
    3. FusionSerialNumbers - Inventories the serial numbers tied to an installed VMware Fusion application
    4. HomebrewInstalled - Checks if Homebrew is installed

Version 0.1.0
------------

1. Initial Release of Homebrew script
