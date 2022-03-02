## Checking your OpenCore config.plist

When editing `config.plist`, confirm proper syntax by running `ocvalidate config.plist`.

## `config.plist` Comments:

* The default `config.plist` is meant to serve a mostly vanilla configuration. Additional `config.plist` compoments are available in [x1c6-hackintosh/patches/](https://github.com/tylernguyen/x1c6-hackintosh/tree/main/patches)


#### Audio patches:   

`Device Properties` > `PciRoot(0x0)/Pci(0x1f,0x3)` > `layout-id`: Injects AppleALC layout-id `21`

#### Intel iGPU and HDMI patches:

`Device Properties` > `PciRoot(0x0)/Pci(0x2,0x0)` >  

- `device-id` = `16590000` per [WhateverGreen/IntelHD.en.md](https://github.com/acidanthera/WhateverGreen/blob/main/Manual/FAQ.IntelHD.en.md)
- `AAPL,ig-platform-id` = This is negotiable. In the future, I will test different variables for optimization. For now, `04002759` works well enough. 
- `AAPL00,override-no-connect` = EDID override to fix HDMI hotplug. Search for yours at `patches/Internal Displays/` or see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create one for your display model.
- `framebuffer-con1-enable` to enable framebuffer patching by WEG on connector 1.
- `framebuffer-con1-type` to set connector 1 type to HDMI (per IOReg)
- `framebuffer-patch-enable` tells WEG to patch framebuffer.
- `AAPL00,override-no-connect` to override EDID (dependent on display models). See `patches/Internal Displays/`. This is necessary to fix HDMI hotplug. To create your own, see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)

#### FileVault compatibility:

- Misc -> Boot
    - `PollAppleHotKeys` set to `YES`(While not needed can be helpful)
- Misc -> Security
    - `AuthRestart` set to `YES`(Enables Authenticated restart for FileVault 2 so password is not required on reboot. Can be considered a security risk so optional)
- NVRAM -> Add -> 4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14
    - `UIScale` set to `02` for high resolution small displays
- UEFI -> Input
    - `KeySupport` set to `YES`(Only when using OpenCore's builtin input, users of OpenUsbKbDxe should avoid)
- UEFI -> Output
    - `ProvideConsoleGop` to `YES`
- UEFI -> ProtocolOverrides
    - `FirmwareVolume` set to `YES`
    - `AppleSmcIo` set to `YES`(this replaces VirtualSMC.efi)
- UEFI -> Quirks
    - `RequestBootVarRouting` set to `YES`

#### Hibernation Mode 25 support:

- Booter -> Quirks
    - `DiscardHibernateMap` set to `YES`
- NVRAM -> Add -> 7C436110-AB2A-4BBB-A880-FE41995C9F82
    - `boot-args` includes `-hbfx-dump-nvram rtcfx_exclude=80-AB`
- Misc -> Boot
    - `HibernateMode` set to `NVRAM`
- UEFI -> ReservedMemory
    - Address: `569344`
    - Size: `4096`
    - Type: `RuntimeCode`

#### Personalization:

- `ShowPicker` is `No`. Use `Esc` during boot to show picker when needed.
- `PickerMode` is `External` to use `OpenCanopy` boot menu. If you prefer a lighter `EFI`, delete `Resources` and switch variable to `Builtin`.
- `PlayChime` is `No`. Set this to `Yes` if you want the native chime to play upon boot.
 
#### OpenCanopy Support:  

I prefer OpenCanopy for its looks. However, it is completely optional and can take up space in your EFI. If you would rather use OpenCore's built in picker. Change `PickerMode` to `Builtin` and remove `OpenCanopy.efi` from `UEFI` > `Drivers`.

#### EFI Tools

* OpenCore tools and utilities are removed for a clean setup and can be added when needed.