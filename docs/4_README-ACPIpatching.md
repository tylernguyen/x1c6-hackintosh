> ## ACPI Patching:
1. Download and install [MaciASL](https://github.com/acidanthera/MaciASL/releases) if you do not have it already.  
2. Dump your original ACPI tables. There are a number of ways to do this, using Clover, Hackintool, Linux.
3. In Terminal, disassemble the copied ACPI tables with "iasl-stable -dl DSDT.aml". For our purpose, the only file that really matters is DSDT.dsl  
- Your DSDT file will be used as a reference table in determining that needs to be patched and what patches need to be added.
4. Refer to `PATCHES.md`, most of my compiled hotpatches and can be copied straight to your setup. However, some patches may require certain directories or variables to be changed depending on your hardware (examine your own disasemebled DSDT). For these, edit the .dsl patch files. Also, note that some SSDT patches also require accompanying OpenCore/ Clover ACPI patches to work.    

Special thanks to [daliansky](https://github.com/daliansky) and [jsassu20](https://github.com/jsassu20) for their work.