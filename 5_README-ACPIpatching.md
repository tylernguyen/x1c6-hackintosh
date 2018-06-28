1. During CLOVER boot screen, press Fn+F4, or just F4 to dump original ACPI tables to EFI/CLOVER/ACPI/origin/  
2. Copy files that begin with DSDT and SSDT to Desktop.  
3. In Terminal, change directory into Desktop and disassemble the copied ACPI tables with "iasl -da -dl DSDT.aml SSDT*.aml".  
4. Begin with DSDT patches, open DSDT.dsl using MaciASL and apply the included patches located in 'x1c6-hackintosh/ACPI/patch-files/', make sure the follow the file name order. There should be 0 syntax errors and you will now be able to compile a new DSDT.aml file. Then place the new DSDT.aml fle into 'EFI/CLOVER/ACPI/patched/'. Reboot, the battery status should now appear.  
5. Enable native power management using XCPM, follow this [Guide](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/).  
6. Create a custom SSDT for USBInjectALL by following this [Guide](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/). The USB configuration for the Thinkpad X1C6 is:  
            HS01: USB2 Left  
            HS02: USB2 Right  
            HS03: Power USB C  
            HS04: USB C Bottom  
            HS07: Bluetooth  
            HS08: Integrated Camera  
            SS01: USB 3 Left  
            SS02: USB 3 Right  
            No FakePCIID_XHCIMux needed.  
7. Make sure native audio is working, then move on to HDMI audio configuration by following this [Guide](https://www.tonymacx86.com/threads/guide-intel-igpu-hdmi-dp-audio-sandy-ivy-haswell-broadwell-skylake.189495/) - Refer to x1c6-hackintosh/IORegistryPrints/  
            No FakePCIID needed.  
