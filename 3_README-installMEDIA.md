1. Download macOS installer from the App Store.  
2. Erase the installation media as HFS, named "Install macOS (MacOS version)" - Example: Install macOS High Sierra.  
3. Use 'createinstallermedia' command to copy installer to install media. [guide](https://support.apple.com/en-us/ht201372)  
4. Install CLOVER onto the installation media, use tonymacx86 UEFI Clover Builds. [Download](https://www.tonymacx86.com/resources/categories/clover-builds.12/)  
5. Rename "config_HD615_620_630_640_650.plist" to "config.plist" and replace the stock "config.plist"
6. Place [FakeSMC.kext](https://bitbucket.org/RehabMan/os-x-fakesmc-kozlek/downloads/) and [VoodooPS2Controller.kext](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/) in 'EFI/CLOVER/kexts/Other/'
7. Proceed to boot using the installation media and go through the process.  
8. Complete the installation.  
9. Once installation has completed, boot into the Hackintosh paritition using the installation media and proceed with post installation configurations.  
