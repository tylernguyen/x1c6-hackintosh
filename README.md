# macOS on Thinkpad X1 Carbon 6th Generation, Model 20KH*
[![macOS](https://img.shields.io/badge/macOS-Catalina-yellow.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![Clover](https://img.shields.io/badge/Clover-5100-red)](https://github.com/996icu/996.ICU/blob/master/LICENSE) *Last Clover version suppported, OpenCore is now my preferred bootloader.  

[![BIOS](https://img.shields.io/badge/BIOS-1.43-blue)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![MODEL](https://img.shields.io/badge/Model-20KH*-blue)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![OpenCore](https://img.shields.io/badge/OpenCore-0.5.6-green)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

<img align="right" src="https://i.imgur.com/I3yUS4Q.png" alt="Critter" width="300">

### Check out my blog [tylerspaper.com](https://tylerspaper.com/)
#### READ THE ENTIRE README.MD BEFORE YOU START.
#### I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY CAUSE.
#### IF YOU IMRPOVE UPON ANYTHING HERE, PLEASE CONTRIBUTE BY OPENING AN ISSUE OR A PULL REQUEST.
`I AM A ONE MAN TEAM, AND A FULL TIME STUDENT. SO, I MIGHT NOT BE ABLE TO RESPOND OR HELP YOU IN A TIMELY MANNER. BUT, I PROMISE I WILL GET TO YOU EVENTUALLY. PLEASE UNDERSTAND.`  

`Lastly, if my work here helped you. Please consider donating, it would mean a lot to me.`

> ## Update

##### Recent | [Changelog Archive](https://github.com/tylernguyen/x1c6-hackintosh/docs/CHANGELOG.md)
> ### 2020-3-31
#### Added
* Further documentation regarding specific tweaks and recommmended macOS settings. 
* ADB and PS2 code reference sheet.   
#### Changed
* All Fn keys now have have an assigned key, remap as needed. 
* Keyboard map is now in markdown. 

> ## SUMMARY:
| Fully functional | Non-functional | Semi-functional. Additional pulls needed and welcomed. |
|-------------------------------------------------------------------|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| WiFi, Bluetooth, Apple Continuity \*need card replacement ⚠️| Fingerprint Reader (not needed, DISABLED at BIOS) ❌| HDMI, currently only outputs at 1080p.Though capable of 4K 4096x2150. ⚠️|
| USB A, USB C, Webcam, Audio Playback/Recording Sleep, Ethernet, Intel Graphics, TrackPoint and Trackpad ✅ | Wireless WAN (DISABLED at BIOS) *ENABLED if you have a 2nd drive connected❌ | Thunderbolt 3 Hotplug: partially working [More details](https://github.com/tylernguyen/x1c6-hackintosh/issues/24#issuecomment-603183002) ⚠️|
| iCloud suite: App Store, iMessage, FaceTime, iCloud Drive, etc... ✅ |  Hibernation ❌ | Power management and optimizations. See [Issue #28](https://github.com/tylernguyen/x1c6-hackintosh/issues/28)  ⚠️|
| Since some Fn functions, such as Mic Mute, Network Toggle do not have equivalent in macOS, these keys are assigned F14-F20 which can then be programmed to a preferred shortcut by you. ⚠️ | | USB power property injection - unsure of real values. ⚠️|
| MicroSD card reader ✅|  | |

> ## NEEDED:  
A macOS machine would be VERY useful: to create install drives, and for when your ThinkPad cannot boot. Though it is not completely necessary.  
Flash drive, 16GB or more.  
Xcode works fine, but I prefer  [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/).  
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

* While you can plug-and-play most of my hotpatches if you have an x1c6, I still suggest that you dump and disassemble your own DSDT. This is imprortant as your DSDT maybe different from mine. And furthermore, you get to learn more about what's actually going on.

> ## MY SPECIFICATIONS:
Refer to [x1c6-Platform_Specifications](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/x1c6-Platform_Specifications.pdf) for possible stock ThinkPad X1 6th Gen configurations.

| Processor Number | # of Cores | # of Threads | Base Frequency | Max Turbo Frequency | Cache | Memory Types | Graphics |
|:--|:--|:--|:--|:--|:--|:--|:--|
| [i7-8650U](https://ark.intel.com/content/www/us/en/ark/products/124968/intel-core-i7-8650u-processor-8m-cache-up-to-4-20-ghz.html) | 4 | 8 | 1.9 GHz | 4.2 GHz | 8 MB | LPDDR3-2133 | Intel UHD 620 |

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


> ## REFERENCES:
* [The Vanilla Laptop Guide](https://fewtarius.gitbook.io/laptopguide/)
* Daliansky's [Hackintool tutorial](https://translate.google.com/translate?js=n&sl=auto&tl=en&u=https://blog.daliansky.net/Intel-FB-Patcher-tutorial-and-insertion-pose.html).  
* [An iDiot's Guide To Lilu and its Plug-ins](https://www.tonymacx86.com/threads/an-idiots-guide-to-lilu-and-its-plug-ins.260063/)
* [General Framebuffer Patching Guide (HDMI Black Screen Problem)](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/)
* [Intel Framebuffer patching using WhateverGreen](https://www.tonymacx86.com/threads/guide-intel-framebuffer-patching-using-whatevergreen.256490/)

> ## OTHER x1c6-hackintosh REPOSITORIES:
[zhtengw/EFI-for-X1C6-hackintosh](https://github.com/zhtengw/EFI-for-X1C6-hackintosh)  
[Colton-Ko/macOS-ThinkPad-X1C6](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6)  
Create a pull request if you like to be added, final decision at my discreation.

> ## OPTIMIZATIONS:
* Repaste the machine with thermal [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).  
* Undervolt the machine with [Volta](https://volta.garymathews.com/).  
* If you must dual boot with Windows or Linux, I advise against paritition. What I recommend, instead, is getting a second compatible hard drive that fits in the WWAN card slot (I have the WDC PC SN520 NVMe 2242), install Windows/Linux onto that drive. Finally, boot into it with Clover or OpenCore.
* If your laptop did not come with WWAN, you can purchase additional antennas to add to your laptop. This is useful when using Wifi/Bluetooth cards that have 3 antennas.

> ## CONTACT:
https://tylerspaper.com/contact  
Signal: (202)-644-9951 *This is a Signal ONLY number. You will not get a reply of you text me at  this number.

> ## DONATE AND SUPPORT:
https://tylerspaper.com/support/

> ## Credits and Thank You:
[@Colton-Ko](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6) for the great features template.  
[@stevezhengshiqi](https://github.com/stevezhengshiqi) for the one-key-cpufriend script.  
[@corpnewt](https://github.com/corpnewt) for CPUFriendFriend.  
[@xzhih](https://github.com/xzhih) for one-key-hidpi.  
[@daliansky](https://github.com/daliansky) for all the hotpatches.  
[@jsassu20](https://github.com/jsassu20) for translating daliansky's documentations.  
[@velaar](https://github.com/velaar) for your continual support and contributions.

And the greatest thank you and appreciation to [@Acidanthera](https://github.com/acidanthera), without whom's work, none of this would be possible. 

Please let me know if I missed you.  