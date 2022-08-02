I recommend that you dual boot using another drive in the WWAN slot (I have the WDC PC SN520 NVMe 2242). This makes installation much easier, and lets the BIOS F12 option act as your boot manager.

!!! note

    Lenovo's Boot Manager will not have an entry for the WWAN NVMe. Most OS(es) will create a bootloader entry during install. If not, use OpenCore to boot into these partitions. See [dortania / OpenCore-Multiboot](https://dortania.github.io/OpenCore-Multiboot/)


!!! tip
    
    It is possible to share Bluetooth pairing keys between Windows and macOS when dual booting. 
  
    The `.reg` for Bluetooth connected devices in macOS can be exported using Hackintool's Utilities section. This key can then be imported to Windows.