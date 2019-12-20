> ## ACPI Patching:
1. Download and install [MaciASL](https://github.com/acidanthera/MaciASL/releases) if you do not have it already.  
2. During CLOVER boot screen, press Fn+F4, or just F4 to dump original ACPI tables to EFI/CLOVER/ACPI/origin/  
3. Copy files that begin with DSDT and SSDT to Desktop.  
4. Open the contents of MaciASL and look for iasl-stable, copy it to the same directory as the dumped ACPI files. In Terminal, disassemble the copied ACPI tables with "iasl-stable -dl DSDT.aml SSDT*.aml".  
5. Refer to `patches` and `patches/README.md`, most of my compiled hotpatches and can be copied straight to your setup. However, some patches may require certain directories or variables to be changed depending on your hardware (examine your own disasemebled DSDT). For these, edit the .dsl patch files. Also, note that some SSDT patches also require accompanying OpenCore/ Clover ACPI patches to work.    

Special thanks to [daliansky](https://github.com/daliansky) and [jsassu20](https://github.com/jsassu20) for their work.