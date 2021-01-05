# Configurating OpenCore for your x1c6

<img align="right" src="https://i.imgur.com/u2Nukp7.png" alt="Critter" width="200">

## Even though I have posted my OpenCore EFI folder here, there are still some work which you have to do before you are able to get it working on your machine. It is **NEVER** a good idea to use someone else's EFI without throughly examining it.

```
* SystemUUID: Can be generated with MacSerial or use pervious from Clover's config.plist.
* MLB: Can be generated with MacSerial or use pervious from Clover's config.plist.
* ROM: ROM must either be Apple ROM (dumped from a real Mac), or your NIC MAC address, or any random MAC address (could be just 6 random bytes) - Vit9696
* SystemSerialNumber: Can be generated with MacSerial or use pervious from Clover's config.plist.
```

- See [`docs/3_README-other`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/3_README-other.md) for more details regarding PlatformInfo settings.
- `CPUFriendDataProvider` can be generated with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_) or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). This is especially important if you have a different CPU than mine. Even if you have the same CPU as me, you may prefer a different Energy Performance Preference (EPP) so do generate your own CPUFriendDataProvider.  

> ## Checking your OpenCore config.plist

It is important to keep your OpenCore config.plist properly up-to-spec, as OpenCore configurations tend to change accordingly with OpenCore versions. 
- A good resource to check your config plist is https://opencore.slowgeek.com/.
- Additionally, the included `ocvalidate` binary in the `OC` folder is the official in-house utility to check your `config.plist`
If both validators give positive results, your `config.plist` should be good.

> ## `config.plist` Comments:
* There are two `plist` files. Default `config.plist` is meant who those with a modded BIOS and have made the approiate settings as detailed in [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) while `config_unmoddedBIOS.plist` is meant for those without a modded BIOS. If you have a modded BIOS and have made the adjustments detailed in my docs, `config.plist` should suffice. If your BIOS is unmodded, simply add the contents of `config_unmoddedBIOS.plist` to the main `config.plist`.
* Notes on kexts and ACPI patches are on the respective OpenCore entries. Additionally, notes on ACPI patches can be found in [docs/2_README-ACPIpatching.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/2_README-ACPIpatching.md) as well as comments inside the patch.
* Audio patches:   
`Device Properties` > `PciRoot(0x0)/Pci(0x1f,0x3)` > `layout-id`: Injects AppleALC layout-id `21`
* Intel iGPU and HDMI patches:
`Device Properties` > `PciRoot(0x0)/Pci(0x2,0x0)` >  
    * `device-id` = `16590000` per [WhateverGreen/IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
    * `AAPL,ig-platform-id` = This is negotiable. In the future, I will test different variables for optimization. For now, `04002759` works well enough. 
    * `AAPL00,override-no-connect` = EDID override to fix HDMI hotplug. Search for yours at `patches/Internal Displays/` or see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create one for your display model.
    * `framebuffer-con1-enable` to enable framebuffer patching by WEG on connector 1.
    * `framebuffer-con1-type` to set connector 1 type to HDMI (per IOReg)
    * `framebuffer-patch-enable` tells WEG to patch framebuffer.
    * `AAPL00,override-no-connect` to override EDID (dependent on display models). See `patches/Internal Displays/`. This is necessary to fix HDMI hotplug. To create your own, see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)
* FileVault compatibility:
    * Misc -> Boot
        * `PollAppleHotKeys` set to `YES`(While not needed can be helpful)
    * Misc -> Security
        * `AuthRestart` set to `YES`(Enables Authenticated restart for FileVault 2 so password is not required on reboot. Can be considered a security risk so optional)
    * NVRAM -> Add -> 4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14
        * `UIScale` set to `02` for high resolution small displays
    * UEFI -> Input
        * `KeySupport` set to `YES`(Only when using OpenCore's builtin input, users of OpenUsbKbDxe should avoid)
    * UEFI -> Output
        * `ProvideConsoleGop` to `YES`
    * UEFI -> ProtocolOverrides
        * `FirmwareVolume` set to `YES`
        * `AppleSmcIo` set to `YES`(this replaces VirtualSMC.efi)
    * UEFI -> Quirks
        * `RequestBootVarRouting` set to `YES`
* Hibernation Mode 25 support:
    * Booter -> Quirks
      * `DiscardHibernateMap` set to `YES`
    * NVRAM -> Add -> 7C436110-AB2A-4BBB-A880-FE41995C9F82
      * `boot-args` includes `-hbfx-dump-nvram rtcfx_exclude=80-AB`
    * Misc -> Boot
      * `HibernateMode` set to `NVRAM`
    * UEFI -> ReservedMemory
      * Address: `569344`
      * Size: `4096`
      * Type: `RuntimeCode`
* Personalization:
    * `ShowPicker` is `No`. Use `Esc` during boot to show picker when needed.
    * `PickerMode` is `External` to use `OpenCanopy` boot menu. If you prefer a lighter `EFI`, delete `Resources` and switch variable to `Builtin`.
    * `PlayChime` is `No`. Set this to `Yes` if you want the native chime to play upon boot.
 
* OpenCanopy Support:  
I prefer OpenCanopy for its looks. However, it is completely optional and can take up space in your EFI. If you would rather use OpenCore's built in picker. Change `PickerMode` to `Builtin` and remove `OpenCanopy.efi` from `UEFI` > `Drivers`.

* OpenCore tools and utilities are removed for a clean setup and can be added when needed.

> ## Updating:

To update your OpenCore folder to my current version, simply backup your `PlatformInfo` information and move it to the new OpenCore config. Keep in mind that, depending on your setup, you may wish to keep other settings you've made so make sure to note your OpenCore `config.plist` changes as you make them.
