# Configurating OpenCore for your x1c6

<img align="right" src="https://i.imgur.com/u2Nukp7.png" alt="Critter" width="200">

## OpenCore is better than Clover in [many ways](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/). But since it is still in its infancy, OpenCore still requires a lot of time and personal confgurations to work. So even though I have posted my EFI-OpenCore folder, there are still some work which you have to do before you are able to get it working on your machine.

### Fortunately, [acidanthera](https://github.com/acidanthera) has done a great job documenting OpenCore. And while it can be greatly time consuming, I really recommend taking a look at it and starting a `config.plist` from scratch. Doing so will allow you to personalize and understand OpenCore configurations. More importantly, by starting an `config.plist` from scratch, you may catch a mistake in my own config.plist or find a better setting variable.  

I do, however, understand if you are strapped for time. So here are the necessary changes to my uploaded configs that would get your machine working. In most cases, your machine should boot with OpenCore after these changes. However, if it does not. please refer to acidanthera's OpenCore documentation.

```
* SystemUUID: Can be generated with MacSerial or use pervious from Clover's config.plist.
* MLB: Can be generated with MacSerial or use pervious from Clover's config.plist.
* ROM: ROM must either be Apple ROM (dumped from a real Mac), or your NIC MAC address, or any random MAC address (could be just 6 random bytes) - Vit9696
* SystemSerialNumber: Can be generated with MacSerial or use pervious from Clover's config.plist.
```

See [`docs/5_README-other`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/5_README-other.md) for more details regarding PlatformInfo settings.

`CPUFriendDataProvider` can be generated with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_) or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). This is especially important if you have a different CPU than mine. Even if you have the same CPU as me, you may prefer a different Energy Performance Preference (EPP) so do generate your own CPUFriendDataProvider.  

> ## Checking your OpenCore config.plist

It is important to keep your OpenCore config.plist properly up-to-spec, as OpenCore configurations tend to change accordingly with OpenCore versions. A good resource to check your config plist is https://opencore.slowgeek.com/.

> ## `config.plist` Comments:
* Notes on kexts and ACPI patches are on the respective Add OpenCore entry.
* Injects AppleALC layout-id `21`:   
`Device Properties` > `PciRoot(0x0)/Pci(0x1f,0x3)` > `layout-id`:
* Intel iGPU and HDMI patches:
`Device Properties` > `PciRoot(0x0)/Pci(0x2,0x0)` >  
    * `device-id` = `16590000` per [WhateverGreen/IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)
    * `AAPL,ig-platform-id` = This is negotiable. In the future, I will test different variables for optimization. For now, `04002759` works well enough. 
    * `framebuffer-con1-enable` to enable framebuffer patching by WEG on connector 1.
    * `framebuffer-con1-type` to set connector 1 type to HDMI (per IOReg)
    * `framebuffer-patch-enable` tells WEG to patch framebuffer.
    * `AAPL00,override-no-connect` to override EDID (dependent on display models). See `patches/Internal Displays/`. This is necessary to fix HDMI hotplug. To create your own, see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)
* FileVault compatibility:
    * Misc -> Boot
        * `PollAppleHotKeys` set to YES(While not needed can be helpful)
    * Misc -> Security
        * `AuthRestart` set to YES(Enables Authenticated restart for FileVault 2 so password is not required on reboot. Can be considered a security risk so optional)
    * NVRAM -> Add -> 4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14
        * `UIScale` set to `02` for high resolution small displays
    * UEFI -> Input
        * `KeySupport` set to YES(Only when using OpenCore's builtin input, users of OpenUsbKbDxe should avoid)
    * UEFI -> Output
        * `ProvideConsoleGop` to YES
    * UEFI -> ProtocolOverrides
        * `FirmwareVolume` set to YES
        * `AppleSmcIo` set to YES(this replaces VirtualSMC.efi)
    * UEFI -> Quirks
        * `RequestBootVarRouting` set to YES

* OpenCanopy Support:  
I prefer OpenCanopy for its looks. However, it is completely optional and can take up space in your EFI. If you would rather use OpenCore's built in picker. Change `PickerMode` to `Builtin` and remove `OpenCanopy.efi` from `UEFI` > `Drivers`.

* OpenCore tools and utilities are removed for a clean setup and can be added when needed.

> ## Updating:

To update your OpenCore folder to my current version, simply backup your `PlatformInfo` information and move it to the new OpenCore config. Keep in mind that, depending on your setup, you may wish to keep other settings you've made so make sure to note your OpenCore `config.plist` changes as you make them.
