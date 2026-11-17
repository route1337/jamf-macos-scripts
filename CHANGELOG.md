Jamf Pro Scripts for macOS Management - Changelog
==============
A list of all the changes made to this repo

Version 0.2.0
--------------

1. Install Homebrew as a git checkout of the `main` branch instead of the retired `master` tarball, which current Homebrew refuses to run
2. Convert existing tarball-based Homebrew installs to a git checkout when the install script is re-run
3. Make the Homebrew scripts exit non-zero on failure so Jamf reports them as failed
4. Fix the common packages script reporting brews as installed when `brew` itself was erroring
5. Configure Terminal now sets up gpg-agent for SSH with a Yubikey (Step 5 of the Route 1337 Yubikey guide)
6. Configure Terminal no longer overwrites `.zshrc` if the download fails
7. Install Homebrew accepts the Xcode license when full Xcode is installed, since `git` and `brew` refuse to run until it is accepted
8. Common Homebrew Packages no longer installs `unrar` (removed from Homebrew) or `git-flow` (deprecated in Homebrew)
9. Common Homebrew Packages trusts its own taps, since Homebrew now ignores formulae and casks from untrusted taps
10. Common Homebrew Packages now also installs fzf, jq, openssl, pyenv, readline, ripgrep, saml2aws, yq, yt-dlp and zlib
11. Common Homebrew Packages now also adds the cloudflare/cloudflare, hashicorp/tap, parera10/csshx and scienceguns/taps taps (only the csshx formula is trusted from parera10/csshx)

Version 0.1.12
--------------

1. Fix [configureARD.sh](scripts/Enrollment/configureARD.sh) based on Jamf API changes

Version 0.1.11
--------------

1. Remove an unused `killall` command for the GPG Suite install script
2. Remove a cask tap that's no longer needed for the Homebrew install script
3. Update documentation to reflect moving from DEPNotify to Setup-Your-Mac

Version 0.1.10
--------------

1. Fix for Sequoia Xcode CLI tools installation

Version 0.1.9
-------------

1. Migrating Intel Mac ConsoleUser detection to a modern OS method

Version 0.1.8
-------------

1. Added the `installBraveBrowser.sh` script to replace Chrome

Version 0.1.7
-------------

1. Quick script for fixing Spotlight indexing

Version 0.1.6
-------------

1. Scripts for Homebrew have been fixed to deal with changes in Monterey
2. Apple Silicon detection logic fixed

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
