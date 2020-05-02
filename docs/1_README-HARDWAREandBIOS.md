# Hardware and BIOS:

> ## WiFi and Bluetooth:

Replace factory Intel WiFi module with a macOS compatible one. Make sure that the card is of M.2 form factor. I replaced it with the BCM94360CS2 card. This works out of the box without additional kexts and has been stable for me thus far.

**If your laptop did not come with WWAN, you can purchase additional antennas to add to your laptop. This is useful when using WiFi/Bluetooth cards that have 3 antennas.**

- The BCM94360CS2 module comes from the 2013 MacBook Air, supports BT 4.0 and 802.11a/g/n/ac. They run on eBay for <\$15.
- For the BCM94360CS2 to work with the x1c6, you would also need a M.2 NGFF adapter. They run for <\$10 on eBay under "BCM94360CS2 m2 adapter"
- Above is my current setup.    

However, there exists other alternatives with better WiFi and Bluetooth standards, but additional kexts are required. See [`dortania/Wireless-Buyers-Guide`](https://dortania.github.io/Wireless-Buyers-Guide/).  

> ## BIOS Settings:

At the minimum, these BIOS settings must be made to install and run macOS without any problems:

| Main Menu | Sub 1       | Sub 2                                         | Sub 3                                                              |
| --------- | ----------- | --------------------------------------------- | ------------------------------------------------------------------ |
| Config    | >> Security | >> Security Chip                              | Security Chip `DISABLED`                                           |
|           |             | >> Fingerprint                                | Predesktop Authentication `DISABLED`                               |
|           |             | >> I/O Port Access                            | Wireless WAN `DISABLED` \*ENABLED if you have a 2nd drive attached |
|           |             |                                               | Fingerprint Reader `DISABLED`                                      |
|           |             | >> Secure Boot Configuration                  | Secure Boot `DISABLED`                                             |
|           |             |                                               | Press `Clear All Secure Boot Keys`                                 |
|           |             | >> Intel SGX                                  | Intel SGX Control `DISABLED`                                       |
|           | >> Startup  | UEFI/Legacy Boot `UEFI Only`                  |                                                                    |
|           |             | CSM Support `No` (per OpenCore Documentation) |                                                                    |
