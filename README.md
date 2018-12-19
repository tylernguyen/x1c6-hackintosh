# MacOS on Thinkpad X1 Carbon 6th Generation, 20KH Model

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

## Pull Needed:
Anything that partially/fully fixes "What doesn't work".  
Proper DisplayOverride for HiDPI support and general screen profile correction.  

### You can use my patched ACPI files on your machine ONLY when it has the exact same specifications as mine! 
Please dump and patch your own otherwise, for safety and stability purposes.  
## My Specifications:
| Processor Number | # of Cores | # of Threads | Base Frequency | Max Turbo Frequency | Cache | Memory Types | Graphics |
|:--|:--|:--|:--|:--|:--|:--|:--|
| i7-8650U | 4 | 8 | 1.9 GHz | 4.2 GHz | 8 MB | LPDDR3-2133 | Intel UHD 620 |

Peripherals:  
Two USB 3.1 Gen 1 (Right USB Always On)  
Two USB 3.1 Type-C Gen 2 / Thunderbolt 3 (Max 5120x2880 @60Hz)  
HDMI 1.4b (Max 4096x2160 @30Hz)  
Ethernet via ThinkPad Ethernet Extension Cable Gen 2: I219-V (Non-vPro) or I219-LM (vPro)  
No WWAN

Display:  
14.0" (355mm) HDR WQHD (2560x1440)  

Audio:
ALC285 Audio Codec  

## Hardware Replacements:
### WiFi and Bluetooth:
Replace factory Intel wifi module with a MacOS compatible one. Make sure that the card is of M.2 form factor. I replaced it with a Broadcom BCM94352Z.   

### M.2 Hard Drive Replacements:
Replace factory Samsung PM981 with preferably a SATA M.2 SSD, as it is more power efficient and plays nicer with APFS than an NVMe M.2 SSD. 

## Contacts:  
https://www.reddit.com/user/tylernguyen_

## Donate and Support:
https://tyler-nguyen.com/support/
