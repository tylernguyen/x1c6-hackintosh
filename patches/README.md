# Hotpatching Notes

## **Credits and a huge thank you to [daliansky](https://github.com/daliansky) for  the great work and documentation, as well as to [jsassu20](https://github.com/jsassu20) for the excellent translations.**

## Some Thinkpad machines are `LPC` and some are` LPCB`. Please examine your own DSDT and modify patches as needed.

> ### SSDT-OCBAT0-TP_re80_tx70-80_x1c5th-6th_s12017_p51
**Need `OpenCore Patches/ TP Battery Basic Rename.plist`** if OpenCore. `preferred`  
**Need `OpenCore Patches/ TP battery Mutex is set to 0 and renamed.plist`** if OpenCore. `preferred`

- Single battery system: only `BAT0` in ACPI, no` BAT1`.
  
> ### SSDT-PLUG-_PR.PR00
Why?: `Processor` in DSDT
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

> ### SSDT-PNLF-SKL_KBL
Why?: `Skylake/ KabyLake/ KabyLake-R`.  
Used in conjufction with `WhateverGreen.kext`

> ### SSDT-BKeyQ14Q15-TP-LPCB
- Rename 1: `_Q14` to` XQ14` (TP- up).  
- Rename 2: `_Q15` to` XQ15` (TP- down).

> ### SSDT-HPET_RTC_TIMR-fix
- This patch cannot be used with the following patches:  
   - ***SSDT-RTC_Y-AWAC_N*** of the "Preset Variable Method"  
   - OC official ***SSDT-AWAC***  
   - "Counterfeit Device" or OC official ***SSDT-RTC0***  
   - ***SSDT-RTC0-NoFlags for CMOS Reset Patch***  
   
> ### SSDT-RMCF-PS2Map-LenovoIWL
Keyboard path is `\ _SB.PCI0.LPCB.KBD`.   

> ### SSDT-PTSWAK
### SSDT-EXT3-LedReset-TP
### SSDT-EXT4-WakeScreen
**Need `OpenCore Patches/ Comprehensive Patch Changed Its Name To.plist`** if OpenCore. `preferred`  
**Need `Clover Patches/ Comprehensive Patch Changed Its Name To.plist`** if Clover.  
Look up `_PTS` and `_WAK` and only apply the corresponding patches:  
`_PTS` is `NotSerialized` in my DSDT  
`_WAK` is `Serialized` in my DSDT  

- ***SSDT-PTSWAK*** —— Comprehensive Patch。

- ***SSDT-EXT3-LedReset-TP*** — `EXT3` extension patch. Solve the problem that the breathing light does not return to normal after the TP machine wakes up。

- ***SSDT-EXT4-WakeScreen*** — `EXT4` extension patch. Solve the problem that some machines need to press any key to light up the screen after waking up. When using, you should inquire whether the `PNP0C0D` device name and path already exist in the patch file, such as` _SB.PCI0.LPCB.LID0`. If not, add it yourself.

> ### SSDT-SBUS
Why?: `0x001F0004` under Device (SBUS).

> ### SSDT-DMAC
Why?: `PNP0200` is missing in DSDT.
 
> ### SSDT-MCHC
Why?:  `MCHC` is missing in DSDT.
 
> ### SSDT-PMCR
Why?: `PMCR`,` APP9876` missing in DSDT.

> ### SSDT-PWRB
Why?: `PNP0C0C` missing in DSDT.
