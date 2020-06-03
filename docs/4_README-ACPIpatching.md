> ## ACPI Patching:

1. Download and install [MaciASL](https://github.com/acidanthera/MaciASL/releases) if you do not have it already.
2. Dump your original ACPI tables. There are a number of ways to do this, using Clover, Hackintool, Linux. See [here](https://khronokernel.github.io/Getting-Started-With-ACPI/Manual/dump.html).  
3. In Terminal, disassemble the copied ACPI tables with "iasl -dl DSDT.aml". For our purpose, the only file that really matters is DSDT.dsl

- Your DSDT file will be used as a reference table in determining that needs to be patched and what patches need to be added.

4. Source SSDT\*.dsl patch files are located in `patches` folder.
5. Refer to my `EFI-OpenCore` folder to see which patches are currently being used by me.
6. If your x1c6's model is 20KH*, most of my compiled hotpatches and can likely be copied straight to your setup. However, some patches may require certain directories or variables to be changed depending on your hardware (examine your own disasemebled DSDT). For these, edit the .dsl patch files. Also, note that some SSDT patches also require accompanying OpenCore/ Clover ACPI patches to work.

A good way to see if you need to edit and compile your own SSDT patches is to compare your DSDT.dsl with mine of the same BIOS version. You can find my disasemebled DSDT file in `ACPI/Disassembled ACPI/BIOS-v*`.

Should your source DSDT be similar enough (in regards to certain items in these ACPI patches)to mine. Congrats! You can simply try my compiled patches. Should it differ however, please carefully examine these notes and create your own SSDT patches.  

7. Once you have the compiled ACPI patches, place them in `EFI/OC/ACPI/` and make sure to create matching entries within OpenCore's `config.plist`'s `ACPI/Add/` section.

# Hotpatching Notes

- Source ACPI patches are `.dsl` Edit these as needed.
- Compiled ACPI patches are `.aml` Once compiled, these belong to `EFI/OC/ACPI`.
- OpenCore Patches are patches for `config.plist` in their respective level.

## Some patches here may be unused. Refer to the current OpenCore-EFI folder to see which one I am currently using. While other patches may be needed case-by-case, such as the WiFi/Bluetooth patches.

## Some Thinkpad machines are `LPC` and some are`LPCB`. Please examine your own DSDT and modify patches as needed.

> ### Non-native WiFi and Bluetooth

`OpenCore Patches/ Config-DW1560.plist` for DW1560 model cards.  
`OpenCore Patches/ Config-DW1820A.plist` for WD1820A model cards.

\*Notice that these patches require additional kexts to be installed. See them in `Kernel/Add/`

> ### SSDT-OCBAT0-TP_tx80_x1c6th - Enabling Battery Status in macOS

**Need `OpenCore Patches/ TPbattery.plist`**  

- Single battery system: only `BAT0` in ACPI, no `BAT1`.

> ### SSDT-PLUG-\_PR.PR00 - Enablaing Native Intel Power Managements

Why?: `Processor` search in DSDT, rename `PR` to other variables as needed.

```
    Scope (\_PR)
    {
        Processor (PR00, 0x01, 0x00001810, 0x06){}
        Processor (PR01, 0x02, 0x00001810, 0x06){}
        Processor (PR02, 0x03, 0x00001810, 0x06){}
        Processor (PR03, 0x04, 0x00001810, 0x06){}
        Processor (PR04, 0x05, 0x00001810, 0x06){}
        Processor (PR05, 0x06, 0x00001810, 0x06){}
        Processor (PR06, 0x07, 0x00001810, 0x06){}
        Processor (PR07, 0x08, 0x00001810, 0x06){}
        Processor (PR08, 0x09, 0x00001810, 0x06){}
        Processor (PR09, 0x0A, 0x00001810, 0x06){}
        Processor (PR10, 0x0B, 0x00001810, 0x06){}
        Processor (PR11, 0x0C, 0x00001810, 0x06){}
        Processor (PR12, 0x0D, 0x00001810, 0x06){}
        Processor (PR13, 0x0E, 0x00001810, 0x06){}
        Processor (PR14, 0x0F, 0x00001810, 0x06){}
        Processor (PR15, 0x10, 0x00001810, 0x06){}
    }
```

> ### SSDT-PNLF-SKL_KBL - Enabling Brightness Mangement in macOS

iGPU is `PCI0.GFX0`  
Why?: `Skylake/ KabyLake/ KabyLake-R` CPU.  
Used in conjuction with `WhateverGreen.kext`


> ### SSDT-HPET

- Patch out IRQ conflicts. Credits to [corpnewt/SSDTTime](https://github.com/corpnewt/SSDTTime).  
**Needs `OpenCore Patches/ HPET.plist`**

> ### SSDT-Keyboard - Remapping Fn and PrtSc Keys

 Keyboard path is `\ _SB.PCI0.LPCB.KBD`.    
For multimedia functions:

- Remap 1: F4 (Network) to F20 (for use with ThinkpadAssistant)
- Remap 2: F5 (Brightness Down)
- Remap 3: F6 (Brightness Up)
- Remap 4: F7 (Dual Display) to F16 (for use with ThinkpadAssistant)
- Remap 5: F8 (Network) to F17 (for use with ThinkpadAssistant)
- Remap 6: F9 (Settings) to F18 (for use with ThinkpadAssistant)
- Remap 7: F10 (Bluetooth) to [Shift+Down]
- Remap 8: F11 (Keyboard) to [Shift+Up]
- Remap 9: F12 (Star) to F19 (for use with ThinkpadAssistant)
- Remap 10: PrtSc to F13
- Remap 11: Fn + K to Deadkey
- Remap 12: Fn + P to Deadkey
  For Fn 1-12 functions, check the following option within `Preferences/Keyboard`:  
  ![Fn keys](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/fnkeys.png)

**Needs `OpenCore Patches/ x1c6-keyboard.plist`**

> ### SSDT-LED
- Fix ThinkPad `i` LED after sleep.
- Persist F4 Mute LED after sleep.

> ### SSDT-PTSWAK

- Comprehensive sleep/wake patch.  
**Needs `OpenCore Patches/ PTSWAK.plist`**

Look up `_PTS` and `_WAK` in source DSDT and confirm the following, modify if different:  
`_PTS` is `NotSerialized` in my DSDT  
`_WAK` is `Serialized` in my DSDT

### SSDT-EXT1-FixShutdown

- PTSWAK extension patch. Fixes reboot after shutdown.  

### SSDT-EXT4-WakeScreen

- PTSWAK extension patch. Solve the problem that some machines need to press any key to light up the screen after waking up. When using, you should inquire whether the `PNP0C0D` device name and path already exist in the patch file, such as`_SB.PCI0.LPCB.LID0`. If not, add it yourself.  

> ### SSDT-SBUS

Why?: `0x001F0004` under Device (SBUS).

> ### SSDT-DMAC

Why?: `PNP0200` is missing in DSDT.

> ### SSDT-MCHC

Why?: `MCHC` is missing in DSDT.

> ### SSDT-PMCR

Why?: `PMCR`,`APP9876` missing in DSDT.

> ### SSDT-PWRB

Why?: `PNP0C0C` missing in DSDT.

> ### SSDT-ALS0

Starting with Catalina, an ambient light sensor device is required for brightness preservation. This patch fakes an ambient light sensor device `ALS0` since the x1c6 does not have one.  
Why?: `ACPI0008` missing in DSDT.

> ### SSDT-GPRW

Why?: Fix instant wake by hooking GPRW (0D/6D Patch)

```
Special thanks to [daliansky](https://github.com/daliansky).
```
