# macOS on Thinkpad X1 Carbon 6th Generation, Model 20KH\*

[![macOS](https://img.shields.io/badge/macOS-Catalina-yellow.svg)](https://www.apple.com/macos/catalina/)
[![version](https://img.shields.io/badge/10.15.6-yellow)](https://support.apple.com/en-us/HT210642)
[![BIOS](https://img.shields.io/badge/BIOS-1.45-blue)](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads/driver-list/component?name=BIOS%2FUEFI)
[![MODEL](https://img.shields.io/badge/Model-20KH*-blue)](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/references/x1c6-Platform_Specifications.pdf)
[![OpenCore](https://img.shields.io/badge/OpenCore-0.5.9-green)](https://github.com/acidanthera/OpenCorePkg)
[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

<img align="right" src="https://i.imgur.com/I3yUS4Q.png" alt="Critter" width="300">

### Check out my blog [tylerspaper.com](https://tylerspaper.com/)

#### READ THE ENTIRE README.MD BEFORE YOU START.

#### I am not responsible for any damages you may cause.

### Should you find an error, or improve anything, be it in the config itself or in the my documentation, please consider opening an issue or a pull request to contribute.

`I AM A ONE MAN TEAM, AND A FULL TIME STUDENT. SO, I MIGHT NOT BE ABLE TO RESPOND OR HELP YOU IN A TIMELY MANNER. BUT, I PROMISE I WILL GET TO YOU EVENTUALLY. PLEASE UNDERSTAND.`

`Lastly, if my work here helped you. Please consider donating, it would mean a lot to me.`

> ## Update

##### Recent | [Changelog Archive](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/CHANGELOG.md)

> ### 2020-8-3

#### Added

- Added macOS Boot chime support. Disabled by default, `PlayChime` to `Yes` if you want it.
  - Boot chime was upsampled by me using Audacity, will use this upsampled file until `AudioDxe.efi` can upsample audio on the fly.

#### Changed

- OC to 0.6 and upgraded various acidanthera kexts.
- [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md):
  - BIOS modding instructions, confirmed working on `BIOS-v1.45`. Thanks @benbender for bringing this to my attention.
  - CPU Performance/Battery configuration guidelines. A year and a half after [Issue #28](https://github.com/tylernguyen/x1c6-hackintosh/issues/28) is opened. Thank you to everyone in that issue.
- Upgraded `VoodooRMI`, this kext is now stable.
- Offloaded universally applicable parts of this guide to `dortania` as referring to their often updated content should be better.
- `config.plist` is now defaulted to users with a BIOS mod, those without a BIOS mod will need to add `config_unmoddedBIOS.plist` to `config.plist` 
- Enforces modeset to fix [Issue #69](https://github.com/tylernguyen/x1c6-hackintosh/issues/69)

> # table of contents
 - [summary](#summary)
 - [before you start](#references)
 - [needed](#needed)
 - [my specs for comparison and ref](#specifications)
 - [getting started ](#start)
 - [other x1c6 repos](#other)
 - [contact](#contact)
 - [donate and support](#support)
 - [credits and thank you](#credits)

> ## SUMMARY

**`In short, x1c6-hackintosh is very stable and is currently my daily driver. I fully recommend this project to anyone looking for a MacBook alternative.`**

| Fully functional                                                                                                                                                                                                               | Non-functional                                                                                               | Semi-functional. Additional pulls needed and welcomed.                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Native Power Mangemenet ✅ \*need BIOS mod, see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) | Hibernation mode 25 ❌ CMOS error, see [Issue #44](https://github.com/tylernguyen/x1c6-hackintosh/issues/44) | Thunderbolt 3 hotplug *with some caveats. See [docs/5_README-other.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/5_README-other.md) and [Issue #24](https://github.com/tylernguyen/x1c6-hackintosh/issues/24#issuecomment-603183002) ⚠️ |
| WiFi, Bluetooth, Apple Continuity, iCloud suite: App Store, iMessage, FaceTime, iCloud Drive, etc...  ✅ \*need [network card replacement](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)                                                            | Fingerprint Reader ❌ (not needed, DISABLED at BIOS)                                                          |                              |
| USB A, USB C, Webcam, Audio Playback/Recording Sleep, Ethernet, Intel Graphics, TrackPoint and Trackpad, MicroSD card reader ✅                                                                                                | Wireless WAN ❌ (DISABLED at BIOS)                                |  |
| BIOS Mod, giving access to `Advance` menu.✅ See [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) and [Issue #68](https://github.com/tylernguyen/x1c6-hackintosh/issues/68)                                                                                                                                                            |  |                                                                                                                                              |
| Multimedia Fn keys ✅ \*need [ThinkpadAssistant](https://github.com/MSzturc/ThinkpadAssistant)                                                                                                                                 |                                                                                                              |                                                                                                                                              |
| PM981 installation. ✅ See [Issue #43](https://github.com/tylernguyen/x1c6-hackintosh/issues/43)                                                                                                                               |                                                                                                              |                                                                                                                                              |
| 4K UHD via HDMI/DisplayPort. ✅ Install `patches/OpenCore patches/4K-Output.plist` if your BIOS is unmodded (follow [Issue #40](https://github.com/tylernguyen/x1c6-hackintosh/issues/40#issuecomment-659370165) when upgrading macOS with this patch enabled). If you have a modded BIOS, simply set `DMVT Pre-Allocated` to `64M` (Refer to [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md))|                                                                                                              |                                                                                                                                              |
| HDMI hotplug(requires a custom EDID override). ✅ See `patches/Internal Displays/` for pre-made ones and [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) if one does not exist already for your display.|                                                                                                              |

**For more information regarding certain features, please refer to [`docs/3_README-POSTinstallation.md`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-POSTinstallation.md)**

> ## REFERENCES
* Read these before you start:
- [dortania's Hackintosh guides](https://github.com/dortania)
- [dortania/ Getting Started with ACPI](https://dortania.github.io/Getting-Started-With-ACPI/)
- [dortania/ opencore `laptop` guide](https://dortania.github.io/oc-laptop-guide/)
- [dortania/ opencore `desktop` guide](https://dortania.github.io/OpenCore-Desktop-Guide/)
- [dortania/ opencore `multiboot`](https://github.com/dortania/OpenCore-Multiboot)
- [dortania/ `USB map` guide](https://github.com/dortania/USB-Map-Guide)
- [WhateverGreen Intel HD Manual](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)

* ### No seriously, please read those.  

> ## NEEDED

A macOS machine would be VERY useful: to create install drives, and for when your ThinkPad cannot boot. Though it is not completely necessary.  
Flash drive, 12GB or more.  
Xcode works fine for editing plist files on macOS, but I prefer [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/).  
[ProperTree](https://github.com/corpnewt/ProperTree) if you need to edit plist files on Windows.  
[MaciASL](https://github.com/acidanthera/MaciASL), for patching ACPI tables.  
[MountEFI](https://github.com/corpnewt/MountEFI) to quickly mount EFI partitions.  
[IOJones](https://github.com/acidanthera/IOJones), for diagnosis.  
[Hackintool](https://www.insanelymac.com/forum/topic/335018-hackintool-v286/), for diagnostic ONLY, Hackintool should not be used for patching, it is outdated.

> ## SPECIFICATIONS

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

> ## START

Explore links included this README, especially those in references and other x1c6-hackintosh repos.

Once you are ready, follow the series of README files included `docs/`.  
[**1_README-HARDWAREandBIOS**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md): Requirements before starting.  
[**2_README-installMEDIA**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/2_README-installMEDIA.md): Creating the macOS install drive.  
[**3_README-POSTinstallation**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-POSTinstallation.md): Settings and tweaks post installation.  
[**4_README-ACPIpatching**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/4_README-ACPIpatching.md): The hardest and most time consuming part, patching the system ACPI table for battery status, brightness, sleep, thunderbolt, thunderbolt hotplugging, etc...  
[**5_README-other.md**](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/5_README-other.md): for other notices

- While you can plug-and-play most of my hotpatches if you have an x1c6, I still suggest that you dump and disassemble your own DSDT. This is imprortant as your DSDT maybe different from mine. And furthermore, you get to learn more about what's actually going on.

> ## OTHER

[zhtengw/EFI-for-X1C6-hackintosh](https://github.com/zhtengw/EFI-for-X1C6-hackintosh)  
[Colton-Ko/macOS-ThinkPad-X1C6](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6)  
Create a pull request if you like to be added, final decision at my discreation.

> ## CONTACT

https://tylerspaper.com/contact  
Signal: +1 (202)-644-9951 \*This is a Signal ONLY number. You will not get a reply of you text me at this number.

> ## SUPPORT

https://tylerspaper.com/support/

> ## CREDITS

[@Colton-Ko](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6) for the great features template.  
[@stevezhengshiqi](https://github.com/stevezhengshiqi) for the one-key-cpufriend script.  
[@corpnewt](https://github.com/corpnewt) for GibMacOS, EFIMount, and USBMap.  
[@Sniki](https://github.com/Sniki) and [@goodwin](https://github.com/goodwin) for ALCPlugFix.  
[@xzhih](https://github.com/xzhih) for one-key-hidpi.  
[@daliansky](https://github.com/daliansky) for various hotpatches.  
[@velaar](https://github.com/velaar) for your continual support and contributions.  
[@benbender](https://github.com/benbender) for your various issue contributions.   
[@Porco-Rosso](https://github.com/Porco-Rosso) putting up with my requests to test repo changes.  
[@MSzturc](https://github.com/MSzturc) for adding my requested features to ThinkpadAssistant.  
paranoidbashthot and \x for the BIOS mod to unlocked Intel Advance Menu.


The greatest thank you and appreciation to [@Acidanthera](https://github.com/acidanthera), without whom's work, none of this would be possible.

And to everyone else who supports and uses my project.

Please let me know if I missed you.
