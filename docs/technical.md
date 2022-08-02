---
hide:
  - navigation
---

## Internal Technical Details on the X1C6

!!! note

    While inernal docs are written specifically for my X1C6, some of it are applicable to KabyLake ThinkPads. And to a lesser extent, different generation Carbon ThinkPads.

1. Explainations of config choices in `config.plist`: [technical.config.plist.md](https://tylernguyen.github.io/x1c6-hackintosh/technical/config.plist/)

2. Explaination of ACPI patches: [technical/patches.md](https://tylernguyen.github.io/x1c6-hackintosh/technical/patches/)

3. Keyboard Query Map: [technical/keyboard-queries.md](https://tylernguyen.github.io/x1c6-hackintosh/technical/patches/keyboard-queries.md)

4. Debug EC Queries: [technical/EC-queries.md](https://tylernguyen.github.io/x1c6-hackintosh/technical/patches/EC-queries.md)

5. ALC285 Audio Codec Dump: [technical/ALC285.md](https://raw.githubusercontent.com/tylernguyen/x1c6-hackintosh/main/docs/technical/ALC285.md)

6. JackSense, EAPD, and AppleALC Patch Explaination: [Issue #75/ comment by ghost](https://github.com/tylernguyen/x1c6-hackintosh/issues/75#issuecomment-705889447)

## External Technical Details

### ACPI, ASL, and Patches

1. The patches written for this project are in ASL. Consder reading the [ACPI Source Language (ASL) Tutorial v20190625](https://acpica.org/sites/acpica/files/asl_tutorial_v20190625.pdf) to get a basic understanding of the patches' code.

!!! info
    
    The Ubuntu Wiki also has an [ACPI Tricks and Tips](https://wiki.ubuntu.com/Kernel/Reference/ACPITricksAndTips) section.

2. [5T33Z0/OC-Little-Translated](https://github.com/5T33Z0/OC-Little-Translated) is the English docs translation of [daliansky/OC-little](https://github.com/daliansky/OC-little). It is helpful to refer to existing patches when Hackintoshing.

!!! warning

    Some patches within OC-Little can be oudated, badly done, or fragmented because of different patch authors. Consider using this resource only as a reference and basic guide, not a patch repository.

3. Consider referencing the [MacbookPro14,1 ACPI Dump](https://github.com/khronokernel/DarwinDumped/tree/master/MacBookPro/MacBookPro14%2C1) when understanding certain functions within macOS.

### Acidanthera Official Docs


### UEFI Secure Boot

It is possible to enable Secure Boot with macOS. Doing so will require custom secure boot keys and signing OpenCore binaries each update. See [profzei/Matebook-X-Pro-2018/wiki](https://github.com/profzei/Matebook-X-Pro-2018/wiki/Enable-BIOS-Secure-Boot-with-OpenCore) for a basic getting started guide.

!!! info

    UEFI Secure Boot Explaination: [hac-mini-guide/details/secure-boot](https://osy.gitbook.io/hac-mini-guide/details/secure-boot)

### Thunderbolt 3

[osy](https://github.com/osy) has a great write-up of patching Thunderbolt 3 hotplug under macOS. See [Part 1](https://osy.gitbook.io/hac-mini-guide/details/thunderbolt-3-fix), [Part 2]( https://osy.gitbook.io/hac-mini-guide/details/thunderbolt-3-fix-part-2), and [Part 3](https://osy.gitbook.io/hac-mini-guide/details/thunderbolt-3-fix-part-3).