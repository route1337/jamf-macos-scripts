Jamf Pro Scripts for macOS Management - Changelog
==============
A list of all the changes made to this repo

Version 0.1.5
-------------

1. Common Brews script reduced the list of taps and brews in favor of this [optional repo](https://github.com/route1337/devops-mac)
2. Initial support for Apple Silicon machines

Version 0.1.4
-------------

1. Install Homebrew script fixed for Big Sur (Intel) and latest HomeBrew
2. Common Brews script updated with new list of brews
3. Fixed some documentation
4. Dropping support for installs below Big Sur 11.0.1
5. Fixed Terminal script due to a public URL change
6. GPG Suite installer now kills GPG Mail Upgrader processes so DEPNotify can complete

Version 0.1.3
-------------

1. Testing against DEPNotify now instead of SplashBuddy
2. Install Homebrew script fixed for Catalina and latest HomeBrew
3. Common Brews script updated with new list of brews
4. Updated Copyright year for all files
5. All files have a proper blank line at the end
6. Adding basic Terminal configuration

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
