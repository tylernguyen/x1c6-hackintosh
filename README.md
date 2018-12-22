# MacOS on Thinkpad X1 Carbon 6th Generation, Model 20KH*

## Summary:

| Fully functional                                                              | Non-functional                                     | Semi-functional. Additional pulls needed and welcomed.                                                                |
|-------------------------------------------------------------------------------|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| Stable, macOS work machine.                                                   | MicroSD Card Reader (not needed, DISABLED at BIOS) | HDMI, currently only outputs at 1080p.Though capable of 4K 4096x2150.                                                 |
| USB A, USB C, Thunderbolt 3, Audio, Sleep, Ethernet, Integrated Intel Graphics | Fingerprint Reader (not needed, DISABLED at BIOS)  | Function keys, F1-F6 work. The rest need to be mapped and patched via DSDT/SSDTs.                                     |
| iCloud suite: App Store, iMessage, FaceTime, iCloud Drive, etc...             | Wireless WAN (not needed, DISABLED at BIOS)        | TrackPoint is unstable: skipping and jumping.                                                                         |
| Wifi and Bluetooth *need card replacement                                     |                                                    | USB power property injection - unsure of real values.                                                                 |
|                                                                               |                                                    | Power management, currently 5-6 hours with average usage. Maybe a custom injection with CPUFriend will optimize this? |

## Where to start:
Follow the series of README files included in the repository.  
**1_README-HARDWAREandBIOS**: Replace Wifi/Bluetooth card and M.2 drive. Then change laptop's BIOS settings as detailed.    
**2_README-installMEDIA**: Creating the macOS install drive.  
**3_README-POSTinstallation**: Settings and tweaks post installation.  
**4_README-ACPIpatching**: Patching the system ACPI table for battery status, brightness, sleep, etc...  
*You can use my patched ACPI files on your machine ONLY when it has the exact same specifications as mine! 
Please dump and patch your own otherwise, for safety and stability purposes.  

**Utilities and software needed:**  
KextBeast, for kext installation.
Clover Configurator and/or PlistEdit Pro (Interchangeable with Xcode).    
MaciASL, for patching ACPI tables.
IORegistryExplorer, for reference and diagnosis.


## My specifications:
| Processor Number | # of Cores | # of Threads | Base Frequency | Max Turbo Frequency | Cache | Memory Types | Graphics |
|:--|:--|:--|:--|:--|:--|:--|:--|
| i7-8650U | 4 | 8 | 1.9 GHz | 4.2 GHz | 8 MB | LPDDR3-2133 | Intel UHD 620 |

Peripherals:  
Two USB 3.1 Gen 1 (Right USB Always On)  
Two USB 3.1 Type-C Gen 2 / Thunderbolt 3 (Max 5120x2880 @60Hz)  
HDMI 1.4b (Max 4096x2160 @30Hz)  
Ethernet via ThinkPad Ethernet Extension Cable Gen 2: I219-V (Non-vPro) or I219-LM (vPro)  
No WWAN

Display:  
14.0" (355mm) HDR WQHD (2560x1440)  

Audio:
ALC285 Audio Codec  

## References:
[FAQ READ FIRST! Laptop Frequent Questions](https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/)  
[(99% perfect) Sierra 10.12.6 on Thinkpad x1 carbon 5th-gen with dual-boot unchanged Win7](https://www.tonymacx86.com/threads/99-perfect-sierra-10-12-6-on-thinkpad-x1-carbon-5th-gen-with-dual-boot-unchanged-win7.237922/)  
[An idiot's guide to iMessage](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/)
[Native power management guide for laptop](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/)
[Custom SSDT for USBinjectall](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
[Laptop screen goes blank when plugging in external monitor](https://www.tonymacx86.com/threads/laptop-screen-goes-blank-when-plugging-in-external-monitor.226226/)
[Override EDID for display problem](https://www.tonymacx86.com/threads/override-edid-for-display-problem.47200/)


## Contacts, in order of convenience:  
**Signal**: 469-480-7748
*This is Signal ONLY number. You will not get a reply if you text me using this number.  
**Reddit DM**: https://www.reddit.com/user/tylernguyen_


## Donate and Support:
https://tylerspaper.com/support/
