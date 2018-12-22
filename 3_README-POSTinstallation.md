1. Install CLOVER on the main boot EFI paritition to enable boot without the installation media.
2. Install the following kexts in EFI/CLOVER/kexts/Other/  
            FakeSMC  - system support  
            VoodooPS2Controller  - enable support for keyboard and touchpad  
3. Using KextBeast or another kext installer, install the following kexts in L/E/ or EFI/Clover/kexts/Other/.  
L/E/ makes it easy to differentiate between custom kexts and default Apple kexts.
EFI/Clover/kexts/Other makes it easy to backup or troubleshoot kexts.    
*Refer to my uploaded EFI folder for my current kext list.  
4. Rebuild the kextcache with "sudo kextcache -i /"   
5. Configure system to enable iMessage, follow this [Guide](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/). Make sure to pick system definition MacBookPro 14,1 as it supports HWP for better power management. 
6. Reboot and proceed to 5_README-ACPIpatching.md  
