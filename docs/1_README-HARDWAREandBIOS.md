> ## Hardware:
### WiFi and Bluetooth:
Replace factory Intel wifi module with a macOS compatible one. Make sure that the card is of M.2 form factor. I replaced it with the BCM94360CS2 card. This works out of the box and has been stable for me thus far.
- The BCM94360CS2 module comes from the 2013 MacBook Air, supports BT 4.0 and 802.11a/g/n/ac. They run on eBay for <$15.
- For the BCM94360CS2 to work with the x1c6, you would also need a M.2 NGFF adapter. They run for <$10 on eBay under "BCM94360CS2 m2 adapter"

However, there exists other alternatives:  
- Dell DW1820A, the "CN-08PKF4" model is reported to have the most successes, so make sure to look for that specifically.

### M.2 Hard Drive Replacements:
macOS cannot be installed on the factory installed PM981 drive.  

Replace factory Samsung PM981 with preferably a SATA M.2 SSD, as it is [more power efficient and plays nicer with APFS than an NVMe M.2 SSD](https://www.tonymacx86.com/threads/solved-lenovo-x1-carbon-6th-gen-battery-life.254508/#post-1768978). However, if you absolute need the speed, Samsung NVMe drives are fast and are macOS compatible out of the box.   

> ## BIOS:
| Main Menu | Sub 1 | Sub 2 | Sub 3 |
| --------- | ----- | ----- | ----- |
| Config | >> Security | >> Security Chip | Security Chip `DISABLED` |
|   |   | >> Fingerprint | Predesktop Authentication `DISABLED` |] |
|   |   | >> I/O Port Access | Wireless WAN `DISABLED` *ENABLED if you have a 2nd drive attached|
|   |   |   | Fingerprint Reader `DISABLED` |
|   |   | >> Secure Boot Configuration | Secure Boot `DISABLED` |
|   |   | >> Intel SGX | Intel SGX Control `DISABLED` |
|   | >> Startup | UEFI/Legacy Boot `UEFI Only` |   |
|   |   | CSM Support `No` (per OpenCore Documentation) |   |

### My Current Settings, for Reference: