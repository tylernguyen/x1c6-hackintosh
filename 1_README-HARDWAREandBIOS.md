## Hardware replacements:
### WiFi and Bluetooth:
Replace factory Intel wifi module with a MacOS compatible one. Make sure that the card is of M.2 form factor. I replaced it with a Broadcom BCM94352Z. [Broadcom Wifi/Bluetooth Guide](https://www.tonymacx86.com/threads/broadcom-wifi-bluetooth-guide.242423/#post-1664577). 

### M.2 Hard Drive Replacements:
Replace factory Samsung PM981 with preferably a SATA M.2 SSD, as it is more power efficient and plays nicer with APFS than an NVMe M.2 SSD. [Reference](https://www.tonymacx86.com/threads/solved-lenovo-x1-carbon-6th-gen-battery-life.254508/#post-1768978).   

## BIOS Settings:
| Main Menu | Sub 1 | Sub 2 | Sub 3 |
| --------- | ----- | ----- | ----- |
| Config | >> Security | >> Security Chip | Security Chip [DISABLED] |
|   |   | >> Fingerprint | Predesktop Authentication [DISABLED] |
|   |   | >> Virtualization | Intel Virtualization Technology [DISABLED] |
|   |   |   | Intel VT-d Feature [DISABLED] |
|   |   | >> I/O Port Access | Wireless WAN [DISABLED] |
|   |   |   | Memory Card Slot [DISABLED] |
|   |   |   | Fingerprint Reader [DISABLED] |
|   |   | >> Secure Boot Configuration | Secure Boot [DISABLED] |
|   |   | >> Intel SGX | Intel SGX Control [DISABLED] |
|   | >> Startup | UEFI/Legacy Boot [UEFI Only] |   |
|   |   | CSM Support [Yes] |   |
