# macOS on Thinkpad X1 Carbon 6th Generation, Model 20KH\*

[![macOS](https://img.shields.io/badge/macOS-Catalina-yellow.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![version](https://img.shields.io/badge/10.15.4-yellow)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![BIOS](https://img.shields.io/badge/BIOS-1.45-blue)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![MODEL](https://img.shields.io/badge/Model-20KH*-blue)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![OpenCore](https://img.shields.io/badge/OpenCore-0.5.8-green)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

<img align="right" src="https://i.imgur.com/I3yUS4Q.png" alt="Critter" width="300">

### Check out my blog [tylerspaper.com](https://tylerspaper.com/)

#### READ THE ENTIRE README.MD BEFORE YOU START.

#### I am not responsible for any damages you may cause.

### Should you find an error, or improve anything, be it in the config itself or in the my documentation, please consider opening an issue or a pull request to contribute.  

`I AM A ONE MAN TEAM, AND A FULL TIME STUDENT. SO, I MIGHT NOT BE ABLE TO RESPOND OR HELP YOU IN A TIMELY MANNER. BUT, I PROMISE I WILL GET TO YOU EVENTUALLY. PLEASE UNDERSTAND.`

`Lastly, if my work here helped you. Please consider donating, it would mean a lot to me.`

> ## Update

##### Recent | [Changelog Archive](https://github.com/tylernguyen/x1c6-hackintosh/docs/CHANGELOG.md)

> ### 2020-5-9

#### Changed

- Upgraded OpenCore to 0.5.8
- Upgraded various acidanthera kexts.
- Fixed various dortania broken guide links.
- Removed `TbtForcePower.efi` from LiveUSB OpenCore `config.plist`
- Added PM981 install suggestions per [Issue #43](https://github.com/tylernguyen/x1c6-hackintosh/issues/43)
- Changed ScanPolicy of `install_USB` to 0. 

> ## SUMMARY:

**`In short, x1c6-hackintosh is very stable and is currently my daily driver. I fully recommend this project to anyone looking for a MacBook alternative.`**

| Fully functional                                                                                                                                                    | Non-functional                                                                | Semi-functional. Additional pulls needed and welcomed.                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| WiFi, Bluetooth, Apple Continuity ✅ \*need [network card replacement](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) | Fingerprint Reader (not needed, DISABLED at BIOS) ❌                          | Video Output: Currently only output `2560x1440`. Though capable of 4K `4096x2150`. See [Issue #40](https://github.com/tylernguyen/x1c6-hackintosh/issues/40) ⚠️ |
| USB A, USB C, Webcam, Audio Playback/Recording Sleep, Ethernet, Intel Graphics, TrackPoint and Trackpad, MicroSD card reader  ✅                                                          | Wireless WAN (DISABLED at BIOS) \*ENABLED if you have a 2nd drive connected❌ | Thunderbolt 3 hotplug partially working. See [Issue #24](https://github.com/tylernguyen/x1c6-hackintosh/issues/24#issuecomment-603183002) ⚠️                    |
| iCloud suite: App Store, iMessage, FaceTime, iCloud Drive, etc... ✅                                                                                                | Hibernation ❌                                                                | Power management and optimizations. See [Issue #28](https://github.com/tylernguyen/x1c6-hackintosh/issues/28) ⚠️                                                |
| Multimedia Fn keys ✅ \*need [Karabiner Elements](https://ke-complex-modifications.pqrs.org/) and [BetterTouchTool](https://folivora.ai/)                           |                                                                               |                                                                                                                                                                 |
| PM981 installation. ✅ See [Issue #43](https://github.com/tylernguyen/x1c6-hackintosh/issues/43)                                                                                                                                              |                                                                               |                                                                                                                                                                 |

**For more information regarding certain features, please refer to [`docs/3_README-POSTinstallation.md`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-POSTinstallation.md)**

> ## NEEDED:

A macOS machine would be VERY useful: to create install drives, and for when your ThinkPad cannot boot. Though it is not completely necessary.  
Flash drive, 16GB or more.  
Xcode works fine for editing plist files, but I prefer [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/).  
[MaciASL](https://github.com/acidanthera/MaciASL), for patching ACPI tables.  
[IOJones](https://github.com/acidanthera/IOJones), for diagnosis.  
[Hackintool](https://www.insanelymac.com/forum/topic/335018-hackintool-v286/), for diagnosis.

> ## WHERE TO START:

Explore links included this README, especially those in references and other x1c6-hackintosh repos.

Once you are ready, follow the series of README files included `docs/`.  
[**1_README-HARDWAREandBIOS**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md): Requirements before starting.  
[**2_README-installMEDIA**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/2_README-installMEDIA.md): Creating the macOS install drive.  
[**3_README-POSTinstallation**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-POSTinstallation.md): Settings and tweaks post installation.  
[**4_README-ACPIpatching**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/4_README-ACPIpatching.md): The hardest and most time consuming part, patching the system ACPI table for battery status, brightness, sleep, thunderbolt, thunderbolt hotplugging, etc...  
[**5_README-other.md**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/5_README-other.md): for other notices

- While you can plug-and-play most of my hotpatches if you have an x1c6, I still suggest that you dump and disassemble your own DSDT. This is imprortant as your DSDT maybe different from mine. And furthermore, you get to learn more about what's actually going on.

> ## MY SPECIFICATIONS:

Refer to [x1c6-Platform_Specifications](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/references/x1c6-Platform_Specifications.pdf) for possible stock ThinkPad X1 6th Gen configurations.

| Processor Number                                                                                                                   | # of Cores | # of Threads | Base Frequency | Max Turbo Frequency | Cache | Memory Types | Graphics      |
| :--------------------------------------------------------------------------------------------------------------------------------- | :--------- | :----------- | :------------- | :------------------ | :---- | :----------- | :------------ |
| [i7-8650U](https://ark.intel.com/content/www/us/en/ark/products/124968/intel-core-i7-8650u-processor-8m-cache-up-to-4-20-ghz.html) | 4          | 8            | 1.9 GHz        | 4.2 GHz             | 8 MB  | LPDDR3-2133  | Intel UHD 620 |

**Peripherals:**

```
Two USB 3.1 Gen 1 (Right USB Always On)
Two USB 3.1 Type-C Gen 2 / Thunderbolt 3 (Max 5120x2880 @60Hz)
HDMI 1.4b (Max 4096x2160 @30Hz)
Ethernet via ThinkPad Ethernet Extension Cable Gen 2: I219-LM Ethernet (vPro)
No WWAN
TrackPoint: PS/2
TrackPad: PS/2
```

**Display:**  
`14.0" (355mm) HDR WQHD (2560x1440)`  
**Audio:**  
`ALC285 Audio Codec`  
**Thunderbolt:**  
`Intel JHL6540 (Alpine Ridge 4C) Thunderbolt 3 Bridge`

> ## Read These (References):

- [dortania Hackintosh guides](https://github.com/dortania)
- [The Vanilla Laptop Guide](https://fewtarius.gitbook.io/laptopguide/)
- Daliansky's [Hackintool tutorial](https://translate.google.com/translate?js=n&sl=auto&tl=en&u=https://blog.daliansky.net/Intel-FB-Patcher-tutorial-and-insertion-pose.html).
- [Getting Started with ACPI](https://khronokernel.github.io/Getting-Started-With-ACPI/)
- [WhateverGreen Intel HD Manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)

> ## OTHER x1c6-hackintosh REPOSITORIES:

[zhtengw/EFI-for-X1C6-hackintosh](https://github.com/zhtengw/EFI-for-X1C6-hackintosh)  
[Colton-Ko/macOS-ThinkPad-X1C6](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6)  
Create a pull request if you like to be added, final decision at my discreation.

> ## CONTACT:

https://tylerspaper.com/contact  
Signal: (202)-644-9951 \*This is a Signal ONLY number. You will not get a reply of you text me at this number.

> ## DONATE AND SUPPORT:

https://tylerspaper.com/support/

> ## Credits and Thank You:

[@Colton-Ko](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6) for the great features template.  
[@stevezhengshiqi](https://github.com/stevezhengshiqi) for the one-key-cpufriend script.  
[@corpnewt](https://github.com/corpnewt) for CPUFriendFriend.  
[@Sniki](https://github.com/Sniki) and [@goodwin](https://github.com/goodwin) for ALCPlugFix.  
[@xzhih](https://github.com/xzhih) for one-key-hidpi.  
[@daliansky](https://github.com/daliansky) for all the hotpatches.  
[@velaar](https://github.com/velaar) for your continual support and contributions.

The greatest thank you and appreciation to [@Acidanthera](https://github.com/acidanthera), without whom's work, none of this would be possible.

And to everyone else who supports and uses my project.

Please let me know if I missed you.
