# Summary

### Non-Fuctional:
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| Fingerprint Reader   | ❌ | `DISABLED` in BIOS to save power if not used in other OSes.   | Linux support was only recently added    |
| Wireless WAN         | ❌ | `DISABLED` in BIOS to save power if not used in other OSes.   | Unable to investigate as I have no need and my model did not come with WWAN. |

### Video and Audio
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| Full Graphics Accleration (QE/CI)    | ✅   | `WhateverGreen.kext`                   | -   |
| Audio Recording                      | ✅   | `AppleALC.kext` with Layout ID = 21    | -   |
| Audio Playback                       | ✅   | `AppleALC.kext` with Layout ID = 21    | -   |
| Automatic Headphone Output Switching | ✅   | `AppleALC.kext` with Layout ID = 21    | -   |

### Power, Charge, Sleep and Hibernation
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| Battery Percentage Indication | ✅    | `SSDT-Battery.aml` and `/patches/OpenCore Patches/Battery.plist`             | 
| CPU Power Management (SpeedShift)    | ✅      | `XCPM` and `CPUFriend.kext`, generate your own `CPUFriendDataProvider` with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_) or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). |
| iGPU Power Management        | ✅ | `XCPM`, enabled by `SSDT-PLUG.aml`                   | 
| NVMe Drive Battery Management | ✅     | `NVMeFix.kext`  | In my experience, NVMe drives will drain more power than SATA drives.           |
| S3 Sleep/ Hibernation Mode 3 | ✅ | `SSDT-Sleep.aml` | |
| Hibernation Mode 25          | ✅ | `RTCMemoryFixup.kext` and `HibernationFixup.kext`      | Supported, macOS uses mode 3 by default. Change to mode 25 via `pmset`.     |   
| Custom Charge Threshold      | ✅ | `SSDT-EC.aml`, [YogaSMC.kext](https://github.com/zhen-zen/YogaSMC), and [YogaSMCPane](https://github.com/zhen-zen/YogaSMC)| Adjust with YogaSMCPane in System Preferences
| Fan Control                  | ✅ | `SSDT-EC.aml`, [YogaSMC.kext](https://github.com/zhen-zen/YogaSMC), and [YogaSMCPane](https://github.com/zhen-zen/YogaSMC)| Adjust with YogaSMC App.
| Battery Life                 | ✅ | Native, comparable to Windows/Linux. Biggest impact is TB3, see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)   | Will need a modded BIOS to disable `CFG Lock`


### Input/ Output
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| WiFi                                       | ✅ | Native with BCM94360CS2.  | See `/patches/ Network Patches/` otherwise.        |
| Bluetooth                                  | ✅ | Native with BCM94360CS2.  | See `/patches/ Network Patches/` otherwise.        |
| Ethernet                                   | ✅ | `IntelMausi.kext` | Needs Lenovo Ethernet adapter: [Item page](https://www.lenovo.com/us/en/accessories-and-monitors/cables-and-adapters/adapters/CABLE-BO-Ethernet-Extension-Adapter-2/p/4X90Q84427) |
| HDMI hotplug                               | ✅ | Custom EDID Override `/patches/Internal Displays/`                                                                  | Refer to [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) if one does not exist already for your display. |
| 4K UHD output via HDMI/ DisplayPort **(Modded BIOS)**  | ✅ | See `DMVT Pre-Allocated` to `64M`  | See [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) for information about modding the BIOS.           |
| 4K UHD output via HDMI/ DisplayPort **(Vanilla BIOS)** | ✅ | See `/patches/OpenCore Patches/4K-Output-wo-BIOSmod.plist`     | -           |
| USB 2.0, USB 3.0, and Micro SD Card Reader | ✅ | `SSDT-XHC1.aml`    | -     |
| USB 3.1                                    | ⚠️ | `SSDT-TB-DSB2-XHC2.aml`    | Hotplug WIP     |
| USB Power Properties in macOS              | ✅ | `SSDT-XHC1.aml`    | -     |
| Thunderbolt 3 Hotplug                      | ✅ | `SSDT-TB-*`     | Native interface within System Report   |

### Display, TrackPad, TrackPoint, and Keyboard
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| Brightness Adjustments | ✅  | `WhateverGreen.kext`, `SSDT-PNLF.aml`, `AppleBacklightSmoother.kext`, and `BrightnessKeys.kext`| `AppleBacklightSmoother.kext` is optional for smoother birghtness adjustments |
| HiDPI _(Optional)_     | ✅  | [xzhih/one-key-hidpi](https://github.com/xzhih/one-key-hidpi)   | Scaling issues post-sleep fixed with AAPL, ig-platform `BAAnWQ==`     |
| TrackPoint             | ✅  | `VoodooPS2Controller.kext`                                      | -       |
| TrackPad               | ✅  | `VoodooPS2Controller.kext` or `VoodooSMBus.kext` and `VoodooRMI.kext`     | `VoodooRMI.kext` is recommended and preferred over `VoodooPS2`. |
| Built-in Keyboard      | ✅  | `VoodooPS2Controller.kext` | Optimizations recommended, see [`docs/3_README-other.md`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-other.md) |
| Multimedia Keys        | ✅  | `BrightnessKeys.kext` and [YogaSMC](https://github.com/zhen-zen/YogaSMC) | `YogaSMC` is recommended and preferred over ThinkpadAssisstant  | 

### macOS Continuity
| Feature                              | Status | Dependency          | Remarks                      |
| :----------------------------------- | ------ | ------------------- | ---------------------------- |
| iCloud, iMessage, FaceTime | ✅ | Whitelisted Apple ID, Valid SMBIOS   | See [dortania /OpenCore-Install-Guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html)  |
| Continuty              | ✅     | Native with `BCM94360CS2`. `ExtendBTFeatureFlags` to `True` otherwise.       | See `/patches/Network Patches/` for specific network card.     |
| AirDrop                | ✅     | Native with `BCM94360CS2`. `ExtendBTFeatureFlags` to `True` otherwise.       | See `/patches/Network Patches/` for specific network card.     |
| Sidecar                | ✅     | Native with `BCM94360CS2`. `ExtendBTFeatureFlags` to `True` otherwise. iPad with >= `iPadOS 13`  | Tested with iPad Mini with iPadOS 13.1.2   |
| FileVault              | ✅ | as configured in `config.plsit` per [Dortania's Post-Install](https://dortania.github.io/OpenCore-Post-Install/universal/security/filevault.html)|  |
| Time Machine           | ✅     | Native | TimeMachine only backups your Macintosh partition. Manually backup your EFI partition using another method.  |