1. Install CLOVER on the main boot EFI paritition to enable boot without the installation media.
2. Install the following kexts in EFI/CLOVER/kexts/Other/  
            FakeSMC  - system support  
            VoodooPS2Controller  - enable support for keyboard and touchpad  
3. Using KextBeast or another kext installer, install the following kexts in L/E/ or S/L/E/. I install it in L/E/ as it allows me to differentiate between custom kexts and default Apple kexts.  
            AppleALC - also inject audio layout 11 with Clover Configurator, this enables native audio.
            USBInjectAll - make sure to create a custom SSDT patch [Guide](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/), also refer to README-patchingACPI.md  
            Lilu - support library needed by other kexts  
            IntelGraphicsFixup  - enable support for Intel Graphics.  
            IntelMausiEthernet  - enable Ethernet with the Lenovo adapter. A recommended installation even if you don't use Ethernet as it helps with battery performance.  
            BrcmFirmwareRepo  
            BrcmPatchRAM2 - along with BrcmFirmwareRepo, enables Bluetooth.  
            FakePCIID  
            FAKEPCID_Broadcom_WiFi - along with FakePCIID, enables WiFi.  
4. Rebuild the kextcache with "sudo kextcache -i /"   
5. Configure system to enable iMessage, follow this [Guide](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/). Make sure to pick system definition MacBookPro 13,1 as it supports HWP for better power management. 
6. Reboot and proceed to 5_README-ACPIpatching.md  
