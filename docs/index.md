# FAQ

#### "Does everything work?"
Not everything, some features will inherently never work under macOS. The most needed, day-to-day features, however, work as they do in a real Mac. See [Summary](https://tylernguyen.github.io/x1c6-hackintosh/Summary/).

#### "Is this project maintained?"
Yes, until eventually my x1c6 dies or macOS phases out update (even then, it'll likely last a few more years).

#### "Can this brick my laptop?"
Not very likely, expect drive wipes and lost time, however.

#### "Can you port this for X machine?"
No.

#### "How do I keep my Hackitnosh setup updated?"
Currently, there is no automatic solution available. For now, I recommend you create a GitHub watch alert.

# References

!!! warning
    Please read, or at the least, browse through these great resources to get an idea of what's going on before proceeding. This is especially important if this is your first time (OpenCore) Hackintosh-ing.

- [dortania's Hackintosh guides](https://github.com/dortania)
- [dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
- [dortania's OpenCore Post Install Guide](https://dortania.github.io/OpenCore-Post-Install/)
- [dortania/ Getting Started with ACPI](https://dortania.github.io/Getting-Started-With-ACPI/)
- [dortania/ opencore `multiboot`](https://dortania.github.io/OpenCore-Multiboot/)
- [dortania/ `USB map` guide](https://dortania.github.io/OpenCore-Post-Install/usb/)
- `Configuration.pdf` and `Differences.pdf` in each `OpenCore` releases.

!!! tip
    If I missed something here, refer to the official OpenCore docs first, then Dortania's docs. Only then, if you still haven't found what you're looking for, seek Google or forum help.

- Additionally, references specific to the x1c6 are located in `docs/references/`

# Requirements

## Strict requirements
- Flash drive, 12GB or more.
- Patience and time, especially if this is your first time Hackintosh-ing.

## Optional
- A macOS machine to create an offline macOS installer.
- [SPI Programmer CH341a and SOIC8 connector](https://www.amazon.com/Organizer-Socket-Adpter-Programmer-CH341A/dp/B07R5LPTYM) are needed if you are going to mod your BIOS.
- Xcode works fine for editing plist files on macOS, but I prefer [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/).  
- [ProperTree](https://github.com/corpnewt/ProperTree) if you need to edit plist files on Windows.  
- [MaciASL](https://github.com/acidanthera/MaciASL), for patching ACPI tables and editing ACPI patches.
- [MountEFI](https://github.com/corpnewt/MountEFI) to quickly mount EFI partitions.  
- [IORegistryExplorer](https://developer.apple.com/downloads), for diagnosis.  
- [Hackintool](https://www.insanelymac.com/forum/topic/335018-hackintool-v286/), for diagnostic ONLY, Hackintool should not be used for patching, it is outdated.
