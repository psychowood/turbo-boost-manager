# Turbo Boost manager

## About this project

This tool is **a shell wrapper** for the functionality of [Turbo Boost Switcher (TBS)](https://github.com/rugarciap/Turbo-Boost-Switcher) in the command line. To be honest, you're probably better off using the official [TBS GUI](http://tbswitcher.rugarciap.com/).

This tool prioritizes security therefore, you do have to enter password everytime you run the script. If you do not want to enter the password, run it with sudo, but please be advised of the consequences since it'll leave a sudoed script running in a open terminal.

As a side tip, if you want to enable sudo with TouchId on your mac, you can insert the line `auth       sufficient     pam_tid.so`  first in `/etc/pam.d/sudo` then restart your terminal.

## Why this Fork²?

+ I like menus, and color-coded information.
+ [@rugarciap](https://github.com/rugarciap) gave his blessings in [this issue](https://github.com/rugarciap/Turbo-Boost-Switcher/issues/115) to use `kexutil` to load his kexts.
+ I do not like having to load up the TBS GUI.
+ I personally do not use any of the PRO features TBS offers.
+ I didn't want to download TBS manually :)
+ I didn't want to run sleepwatcher as a service, but I wanted to re-disable Turbo Boost after wake nonetheless, and I'm good with having a terminal open instead of a service running

# Install

This is a shell script that uses Apple's CLI kext management tools (`kextunload` and `kextutil`) to disable/enable Turbo Boost on 64-bit macOS, by loading/unloading the kext from [TBS](https://github.com/rugarciap/Turbo-Boost-Switcher).

When you run TurboBoostManager.sh, if you don't already have installed TBS separately, it will automatically:
- download the official Turbo_Boost_Switcher_v2.10.2.dmg binary package
- extract the kext files locally in 'tbswitcher_resources'
- remove temporary files

Since kexts must be root-owned, you need to sudo chown them once, after downloading.

> Consider buying TBS Pro to support the original developer  [@rugarciap](https://github.com/rugarciap).

# How to use

Run TurboBoostManager.sh and enjoy your cooler mac.

  ```sh
  ./TurboBoostManager.sh
  ```
  The CLI presents you the following options. Pick one to do what you want.

  ```sh
 -- Turbo Boost Manager --
	0) Monitor wake events and re-disable on wake
	1) Disable Turbo Boost
	2) Enable Turbo Boost
	3) Re-Disable
	4) Check status
	5) Exit
  ```
  
  ![example](assets/example.png)
  
  **N.B.**
- option #3, unloads the kext and loads it back again, to ensure that the kext is loaded. It is probably more useful after waking system from sleep when the kext is automatically unloaded.
- option #0 uses [sleepwatcher](https://www.bernhard-baehr.de/) to run option #3 each time your Mac wakes up from sleep. You can install it as [Homebrew formula](https://formulae.brew.sh/formula/sleepwatcher) too.
  


## Licence
This software fundamentally relies on the TBS kernel extension (kext).
This repository is distributed under the GNU General Public Licence v2.0, of which the terms are:

```
Turbo Boost disabler / enable app for Mac OS X
Copyright (C) 2013  rugarciap

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
```

In accordance with the terms of the licence, I am distibuting this software under the same licence.
