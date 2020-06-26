> ## Partitioning to dual-boot on one drive:
Please refer to [dortania/ opencore `multiboot`](https://github.com/dortania/OpenCore-Multiboot).  
*Note that on the x1c6, it is possible, and better to dual boot off of a second drive in the WWAN slot.

> ## Creating a macOS Installation Media:

> ### If you have a macOS machine: 
1. Download macOS installer from the App Store.
2. Erase the installation media as GUID Partition Map, Mac OS Extended "Journaled". Name it "Install macOS (MacOS version)" - Example: "Install macOS Catalina".
3. Use 'createinstallermedia' command to copy installer to install media. [guide](https://support.apple.com/en-us/ht201372)
4. Install CLOVER bootloader onto the installation media. Use its latest daily build from GitHub. [Download](https://github.com/Dids/clover-builder/releases)  
   **Though we will not be using Clover, I've found that using the Clover installer is the most convinient way to create an EFI paritition on the installation drive.**
5. After Clover has been installed onto the macOS install drive, its EFI parition should be mounted. Proceed to delete the Clover EFI folder and replace with the EFI folder inside my `EFI-install_USB` folder.
6. Boot into the installation media.
7. Format the intended drive as APFS.
8. Complete the installation.
9. Boot into the newly installed Hackintosh partition using the installation media. That is to say, boot into the installtion media for OpenCore to boot into the installed Hackintosh partition.
10. Proceed with post installation configurations.

> ### If you do not have a macOS machine: 
Use [gibMacOS](https://github.com/corpnewt/gibMacOS) to create installation media on Windows/Linux. I prefer an offline installation as opposed to the recovery method.  

> ## **Refer to [Dortania](https://github.com/dortania) for more detailed documentations.**