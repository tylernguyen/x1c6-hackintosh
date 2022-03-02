- Native-like integration with macOS in System Report without the need of flashing a modded firmware. Thank you @benbender
- NOTE: If you do have a modded BIOS firmware, please reset all settings relating to Thunderbolt 3 to default, all that's needed are settings detailed below or in [1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/1_README-HARDWAREandBIOS.md)  
- Please make sure of these settings in BIOS:  

| Main Menu | Sub 1       | Sub 2                                         | Sub 3                                                              |
| --------- | ----------- | --------------------------------------------- | ------------------------------------------------------------------ |
|           | >> Config   | >> Thunderbolt (TM) 3                         | Thunderbolt BIOS Assist Mode `Disabled`                            |
|           |             |                                               | Security Level `No Security`                                       |
|           |             |                                               | Support in Pre Boot Environment: Thunderbolt(TM) Device `Disabled` |

- Note: USB 3.1 Gen2 hotplug still Work-in-progress.