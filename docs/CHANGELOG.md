# CHANGELOG

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

> ### 2020-10-6

#### Notice

- Just getting back to my rountine and maintaining this project. There has been many developments lately, especially with Thunderbolt 3 ACPI patches and [YogaSMC](https://github.com/zhen-zen/YogaSMC). It will take some time for me to review all these developments and understand them. Meanwhile, it seems @benbender has taken matters to his own hand while I was away :)
- His experimental fork: https://github.com/benbender/x1c6-hackintosh
- I will create an issue to specfically to discuss YogaSMC usage and config on this machine.
- Looking forward, Big Sur is almost here so I want to get this project back onto the latest stable build before it comes out.

#### Changed

- Support for Hibernation Mode 25. As with normal macOS machines, mode 3 is default, but if you want, mode 25 is now also an option.
- There seems to be a bug with the GitHub release version of `ThunderboltReset.kext` so I replaced it one built by @benbender. You can monitor the issue here [osy86/ThunderboltReset/issues/7](https://github.com/osy86/ThunderboltReset/issues/7). Thank you @benbender for noticing this.
- OC to 0.6.2
- Upgraded various Acidanthera kexts as well as `VoodooRMI`

#### Added

- Added `RTCMemoryFixUp` for support of Hibernation Mode 25.
- OpenCore config patch for FHD Touchscreen.
- OpenCore config patch for Intel wireless.

#### Removed

- ALCPlugFix is now deprecated and is replaced by new AppleALC (per issue #75). Please run `uninstall.sh` from the previous commit to remove ALCPlugFix. 
- Delete legacy DiskImage voice from OC `Resources`
- `GPRW` ACPI patch to fix Bluetooth wake. Make sure that your Wake-on-LAN is disabled in BIOS to prevent sleep problems.
- Removed advice to disable DPTF in modded BIOS as it can break methods in ACPI. Thanks @benbender
- `SMCSuperIO` as it was unnecessary.

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

> ### 2020-7-18

#### Added

- EDID Override patch for FHD screen. Thanks [@Paolo97Gll](https://github.com/Paolo97Gll)

#### Changed

- By default, `OpenCore-EFI` now has the 4K output patch disabled for easier system upgrades. Install `OpenCore patches/4K-Output` if you need it.
- Upgraded `VoodooRMI`
- Documentation changes for readability. 

> ### 2020-6-29

#### Added

- X1 6th Gen Hardware Maintenance Guide pdf.
- Display Patches in `patches/Internal Displays/` for the WQHD HDR Screen:
- Color profile as calibrated by notebookcheck
- EDID override to patch HDMI hotplug and overclock refresh rate. Thank you @veelar
- Please follow instructions on [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create an EDID override for your own display. Make sure to create a pull request!
- Repo issue template to deter low effort issues and better diagnosing and support.
- More documentation in `EFI-OpenCore/README.md` about decisions on `config.plist`

#### Changed

- Reverted to previous, simpler iGPU framebuffer patches.

> ### 2020-6-26

#### Added

- `VoodooRMI` as alternative trackpad option. **Enabled by default, feel free to revert back to `VoodooPS2Mouse` and `VoodooPS2Trackpad` if you prefer**. *Note, there's currently a bug with RMI where the touchpad would not load once in a while. The RMI kext uploaded in this repo has a temp fix by me (See [VoodooSMBUS/PR](https://github.com/VoodooSMBus/VoodooSMBus/pull/41)). However, the issue is still ongoing and the dev team is aware of it. I'm switching this repo to VoodooRMI because I believe it's the future and I want to possible bugs to be reported to be fixed for the kext's first stable release.  
- Kernel patches to enable 4K external graphics, thank you so much [@benbender](https://github.com/benbender)
- `XQ74` patch in `SSDT-Keyboard` to support `FnLock` HUD per ThinkpadAssistant 1.8.0
- In [EFI-OpenCore/README.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/EFI-OpenCore/README.md), I've added a short section explaining why certain variables are the way they are in my `config.plist`. I will continue to update this section with more details as time goes on.  

#### Changed

- iGPU Framebuffer patching for HDMI issue in Catalina. 
    - In Catalina/WhateverGreen version, for some reasons my previous framebuffer patches for HDMI no longer worked. So I re-did the patch in mode details but eventually the property that fixed it was `disable-external-gpu` or `-wegnoegpu`. For some strange reasons, that variable activated on-board HDMI. See [similar reports here](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/page-123). I'm going to create an issue on acidanthera/bugtracker soon to report to the dev team. In the mean time, keep this property if you rely on HDMI and do not have an eGPU. Delete this property if you have an eGPU (You're likely using the HDMI on the eGPU anyway).
- Fixed `VoodooPS2` kexts loading order.
- Various reference docs to dortania.
- `HibernateMode` to `Auto`

#### Removed

- Unnecessary Mutex OpenCore patches, all Mutex are already 0 in stock `DSDT`.
- `SSDT-MCHC` and `SSDT-SBUS` for `VoodooRMI` compatibility.

> ### 2020-6-1

#### Changed

- OpenCore to 0.5.9
- Upgraded various Acidanthera kexts.
- Recompiled various SSDT with new iasl libraries.
- Replaced `SSDT-EXT3` with `SSDT-LED`
- Change SSDT OEM ID to `tyler` to somewhat track distributions and usage across various projects

> ### 2020-5-27

#### Changed

- Keyboard backlight is now supported by [ThinkpadAssistant 1.7](https://github.com/MSzturc/ThinkpadAssistant), thank so much [@MSzturc](https://github.com/MSzturc)
- SSDT-keyboard to support ThinkpadAssistant 1.7.0
- Honestly, what's even left to improve on the keyboard? Open an issue.

> ### 2020-5-24

#### Added
- Setting instructions better sleep in 5_README-other.md

#### Changed

- Bluetooth Toggle is now supported by [ThinkpadAssistant 1.6](https://github.com/MSzturc/ThinkpadAssistant), thank so much [@MSzturc](https://github.com/MSzturc)
- SSDT-keyboard to support ThinkpadAssistant 1.6.0

#### Removed
- BetterTouchTool is no longer needed for Fn key functions and has been removed.
- `SMCLightSensor.kext` has been removed as the x1c6 has no ambient light sensor.

> ### 2020-5-22

- Further SSDT-Keyboard tweaks:
    - Windows (mismapped to Left Alt by default) is now properly mapped to Left GUI
    - Left Alt (mismapped to Left GUI by default) is now properly mapped to Left Alt
    - Right Alt (mismapped to Right GUI by default) is now properly mapped to Right Alt
- This means that Karabiner-Elements is no longer a necessary for this project. Once less program! unless you need it for other purposes (like a hyper key). 
- *Similarly, once Bluetooth toggle is implemented in ThinkpadAssistant, BetterTouchTool can also go away.

> ### 2020-5-21

#### Changed

Keyboard Perfection is almost here!
- Modified SSDT-Keyboard patch to be compatible with [ThinkpadAssistant](https://github.com/MSzturc/ThinkpadAssistant).
    - Mute/unMute Microphone with F4, with LED!
    - Disable WiFi with F8
    - Mirror with F7
    - Bluetooth, F10 still has to be handled by BetterTouchTool, but hopefully supported will be added soon. See my [request](https://github.com/MSzturc/ThinkpadAssistant/issues/9)

> ### 2020-5-9

#### Changed

- Upgraded OpenCore to 0.5.8
- Upgraded various acidanthera kexts.
- Fixed various dortania broken guide links.
- Removed `TbtForcePower.efi` from LiveUSB OpenCore `config.plist`
- Added PM981 install suggestions per [Issue #43](https://github.com/tylernguyen/x1c6-hackintosh/issues/43)
- Changed ScanPolicy of `install_USB` to 0. 

> ### 2020-4-6 (#2)

#### Added

- Added OpenCanopy to EFI for Picker GUI support.  
- NVMeFix kext to EFI-installUSB for PM981 support.  

#### Changed
- Upgraded OpenCore to 0.5.7  
- Upgraded various kexts.  


> ### 2020-4-6 (#1)

#### Added

- SSDT-EXT1-FixShutdown to fix the rare issue that sometimes a shutdown would result in a restart instead.  
- SSDT-HPET to patch out legacy IRQ conflicts.  

#### Changed
- Better notes and documentation with `config.plist`  
- Modularized each needed OpenCore config patches.  


> ### 2020-4-1

#### Added

- ALCPlugFix to automatically change output to headphones after being plugged in, and to change it back to speakers after being unplugged.
- ALCPlugFix to fix the rare condition that audio is messed up after waking from sleep.

#### Changed

- More documentation about recommended macOS settings.

> ### 2020-3-31

#### Added

- Further documentation regarding specific tweaks and recommmended macOS settings.
- ADB and PS2 code reference sheet.

#### Changed

- All Fn keys now have have an assigned key, remap as needed.
- Keyboard map is now in markdown.

> ### 2020-3-30

#### Added

- OpenCore configuration folder intended for install media usage.
- Configuration, patches and documentation for alternative network cards, specifically the DW1560 and DW1820A.

#### Changed

- Moved `assets` folder into `docs/`.

#### Deprecated

- All things Clover. OpenCore is now my only friend.

#### Removed

- Removed EC related patches from `config.plist` as they are unnecessary.

> ### 2020-3-29

#### Added

- SSDT-ALS0 hotpatch for faking ambient light sensor ALS0 per Catalina's brightness preservation.
- SSDT-GPRW hotpatching for fixing instant wake (0D/6D patch).

#### Changed

- SSDT-Keyboard with the exception of F7 and F12, now maps all hotkeys to a Fn value that can be remapped within macOS. In addition, PrtSc is now remapped to F13.
- SSDT-PLNF to a cleaner version.
- Similarly, battery patch has been simplified.

#### Removed

- Some unused patches within OpenCore config.plist has now been removed.

> ### 2020-3-26

#### Changed

- Switched to AppleALC layout 21.

> ### 2020-3-23

#### Changed

- Upgraded OpenCore to 0.5.6

> ### 2020-2-04

#### Changed

- Upgraded OpenCore to 0.5.5
- Upgraded kexts.

> ### 2020-1-18

#### Changed

- Upgraded OpenCore to 0.5.4
- Upgraded kexts.

> ### 2019-12-22

#### Added

- Project website: https://tylernguyen.github.io/x1c6-hackintosh/
- ACPI dump for `BIOS-v1.43`.
- CHANGELOG.md to keep track of the project's developments.
- OpenCore bootloader, version `0.5.3`.
- Better SSDT patching with hotpatches under `patches`. Making sure to read `patches/README`.

#### Changed

- Switched completely to hotpatching through OpenCore. Credits to [daliansky](https://github.com/daliansky) and [jsassu20](https://github.com/jsassu20).
- Updated main README, made it look more visually appealing and organized.

#### Deprecated

- Clover bootloader. Clover r5100 is the last version I used on this machine. Moving forward, OpenCore is my preferred bootloader. See `EFI-Clover/README.md`.
- Reorganized folder/project structure. Setup instructions and references now under `docs`.

#### Removed

- Old static patches.
- Old IORegistryExplorer dump.
