1. Download macOS installer from the App Store.  
2. Erase the installation media as GUID Partition Map, Mac OS Extended "Journaled". Name it "Install macOS (MacOS version)" - Example: "Install macOS Mojave".  
3. Use 'createinstallermedia' command to copy installer to install media. [guide](https://support.apple.com/en-us/ht201372)  
4. Install CLOVER bootloader onto the installation media. Use its latest build. [Download](https://sourceforge.net/projects/cloverefiboot/)
	* Make sure that your installation options match with my included screenshots.
![Main options](https://i.imgur.com/tP3aksE.png)
![Detailed options](https://i.imgur.com/P1tiD4k.png)  
5. Rename "config_HD615_620_630_640_650.plist" to "config.plist" and replace the stock "config.plist".
6. Place [FakeSMC.kext](https://bitbucket.org/RehabMan/os-x-fakesmc-kozlek/downloads/) and [VoodooPS2Controller.kext](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/) in 'EFI/CLOVER/kexts/Other/'
7. Proceed to boot using the installation media and go through the process.  
8. Complete the installation.  
9. Once installation has completed, boot into the newly installed Hackintosh partition using the installation media and proceed with post installation configurations.  
