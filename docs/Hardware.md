# Hardware

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
    If your laptop did not come with WWAN, you can purchase additional antennas to add to your laptop. This is useful when using WiFi/Bluetooth cards that have 3 antennas.**

- The laptop's default wireless card should work via the [OpenIntelWireless](https://github.com/OpenIntelWireless) kexts.
- For a vanilla and native experience, you may wish to buy a BCM94360CS2 card, along with a M.2 NGFF adapter. 
- For future proofing and the fastest wireless/bluetooth speed, I recommend the AX200 (the card I am using). This card will also require the various [OpenIntelWireless](https://github.com/OpenIntelWireless) kexts.

!!! Note
    See `patches/Network Patches/` for OpenCore patches for custom wireless cards.

- You should also see [`dortania/Wireless-Buyers-Guide`](https://dortania.github.io/Wireless-Buyers-Guide/).  

## Optimizations (Optional):

- Repaste the machine with thermal [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- If you're experienced or would to try liquid metal, use [Grizzly Conductonaut](https://www.thermal-grizzly.com/produkte/25-conductonaut). Though I've found that in my expereience, [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en) is enough.
- Replace your machine's fan (if applicable). See https://www.reddit.com/r/thinkpad/comments/c7zpah/x1_carbon_6th_gen_horrible_cooling_fan_design/
- Mod the BIOS the unlock Intel Advance Menu. see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/1_README-HARDWAREandBIOS.md)

## Differing Models

- These are relevant components on my machine which may differ from yours, keep these in mind as you will need to adjust accordingly, depending on your machine's configuration.

| Category  | Component                            | Remarks |
| --------- | ------------------------------------ | ------------ |
| CPU       | [i7-8650U](https://ark.intel.com/content/www/us/en/ark/products/124968/intel-core-i7-8650u-processor-8m-cache-up-to-4-20-ghz.html) | Generate your own `CPUFriendDataProvider.kext`. See `SUMMARY`
| SSD       | Seagate Firecuda 520 500GB           | [Dortania's Anti Hackintosh Buyers Guide](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/Storage.html) 
| Display   | 14.0" (355mm) HDR WQHD (2560x1440)   | `/patches/ Internal Displays/` and [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)
| WiFi & BT | BCM94360CS2                          | `/patches/ Network Patches/` if non-native.
| WWAN      | None | Unless needed in other OSes, disable at BIOS to save power

- Refer to [/docs/references/x1c6-Platform_Specifications](https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/references/x1c6-Platform_Specifications.pdf) for possible stock ThinkPad X1 6th Gen configurations.

