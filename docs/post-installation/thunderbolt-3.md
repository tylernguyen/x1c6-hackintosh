- Native-like integration with macOS in System Report without the need of flashing a modded firmware. Thank you [@benbender](https://github.com/benbender)
- NOTE: If you do have a modded BIOS firmware, please reset all settings relating to Thunderbolt 3 to default, all that's needed are settings detailed below or in [Settings for Vanilla BIOS](https://tylernguyen.github.io/x1c6-hackintosh/BIOS/settings-for-vanilla-BIOS/)  
- Please make sure of these settings in BIOS:  

| Main Menu | Sub 1       | Sub 2                                         | Sub 3                                                              |
| --------- | ----------- | --------------------------------------------- | ------------------------------------------------------------------ |
|           | >> Config   | >> Thunderbolt (TM) 3                         | Thunderbolt BIOS Assist Mode `Disabled`                            |
|           |             |                                               | Security Level `No Security`                                       |
|           |             |                                               | Support in Pre Boot Environment: Thunderbolt(TM) Device `Disabled` |

!!! warning

    USB 3.1 Gen2 hotplug will likely never work. It is also neither planned nor currently worked on. If you need USB 3.1 Gen2, coldboot the machine with the device attached.