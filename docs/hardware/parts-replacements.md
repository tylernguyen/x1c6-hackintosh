## Storage

!!! Warning
    The factory PM981 NVMe drive does not play well with macOS.

For installation on the factory drive `PM981`, please refer to [Issue #43](https://github.com/tylernguyen/x1c6-hackintosh/issues/43). I do, however, recommend against this. 


!!! Note
    Replace the PM981 with an aftermarket NVMe for a much smoother experience.

Consult the [dortania/Anti-Hackintosh-Buyers-Guide](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/Storage.html) for up-to-date storage recommendations.

!!! Tip
    You can install an additional M.2 2242 NVMe drive in the WWAN card slot.

This is very useful if you intend to also use Windows/Linux, as partitioning a single drive for dual booting can be troublesome.

## WiFi and Bluetooth

!!! Tip
    If your laptop did not come with WWAN, you can purchase additional antennas to add to your laptop. This is useful when using WiFi/Bluetooth cards that have 3 antennas.

- The laptop's default wireless card should work via the [OpenIntelWireless](https://github.com/OpenIntelWireless) kexts.
- For a vanilla and native experience, you may wish to buy a BCM94360CS2 card, along with a M.2 NGFF adapter. 
- For future proofing and the fastest wireless/bluetooth speed, I recommend the AX200 (the card I am using). This card will also require the various [OpenIntelWireless](https://github.com/OpenIntelWireless) kexts.

!!! Note
    See `patches/Network Patches/` for OpenCore patches for custom wireless cards.

- You should also see [`dortania/Wireless-Buyers-Guide`](https://dortania.github.io/Wireless-Buyers-Guide/).  