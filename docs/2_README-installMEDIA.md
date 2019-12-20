> ## Creating a macOS Installation Media:
1. Download macOS installer from the App Store.  
2. Erase the installation media as GUID Partition Map, Mac OS Extended "Journaled". Name it "Install macOS (MacOS version)" - Example: "Install macOS Catalina".  
3. Use 'createinstallermedia' command to copy installer to install media. [guide](https://support.apple.com/en-us/ht201372)  
4. Install CLOVER bootloader onto the installation media. Use its latest daily build from GitHub. [Download](https://github.com/Dids/clover-builder/releases)  
	* Make sure that your installation options match with my included screenshots.
![Main options](https://imgur.com/e4QT7kX.png)  
![Detailed options](https://imgur.com/Ly96jTI.png)  
![More options](https://imgur.com/iRVFUsi.png)  
5. Rename "config-Clover/config_HD615_620_630_640_650.plist" to "config.plist" and replace the stock "config.plist".
6. Place [VirtualSMC and its corresponding kexts](https://github.com/acidanthera/VirtualSMC/releases), [Lilu](https://github.com/acidanthera/Lilu/releases), [WhateverGreen](https://github.com/acidanthera/WhateverGreen/releases) and [VoodooPS2Controller.kext](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/) in 'EFI/CLOVER/kexts/Other/'
7. Proceed to boot into the installation media.
8. Format the intended drive as APFS.  
9. Complete the installation.  
10. Boot into the newly installed Hackintosh partition using the installation media. That is to say, boot into the installtion media for Clover/ OpenCore to boot into the installed Hackintosh partition. 
11. Proceed with post installation configurations.  
