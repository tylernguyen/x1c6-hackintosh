# x1c6-hackintosh
# MacOS on Thinkpad X1 Carbon 6th Generation

## What doesn't work:
MicroSD Card Reader [DISABLED at BIOS Level] - not needed  
Fingerprint Reader [DISABLED at BIOS Level] - not needed  
Wireless WAN [DISABLED at BIOS Level] - not needed  
TrackPoint nub is unstable [DISABLED at BIOS Level] - tluck's fork of VoodooPS2Controller may fix this problem, but I have yet to try it.  
Hand-off is unstable - not needed  

## Underlying minor issues that needs to be examined in the future:
USB Power Property Injection - unsure of real values  
Battery life optimization - currently average 4-6 hours of regular usage  
With the exeption of volume and brightness, function keys do not properly work - DSDT patches and testing in progress  
Keymapping is not perfect, need to do a complete ADB map  
Performance optimization - proper SMBIOS with the 2018 Macbook  

## Hardware Replacements:
### WiFi and Bluetooth:
Replace factory Intel wifi module with a MacOS compatible one. Make sure that the card is of M.2 form factor. I replaced it with a Broadcom BCM94352Z.   

### M.2 Hard Drive Replacements:
Replace factory Samsung PM981 with preferably a SATA M.2 SSD, as it is more power efficient and plays nicer with APFS than an NVMe M.2 SSD. 

## Contacts:  
https://tyler-nguyen.com/contact/  

## Donate and Support:
https://tyler-nguyen.com/support/
