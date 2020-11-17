> ## Upgrading and other Major Changes:

- macOS minor version upgrade works just as any Mac would.
- It is generally a good idea to hold off on new major macOS releases until kexts and other dependencies have been tested.
- The macOS version of my machine is displayed on a badge in `README.md`

> ## Configuring PlatformInfo for iMessage/iCloud/FaceTime:

- Refer to [dortania /OpenCore-Install-Guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html)
- NOTE: `We’re sorry, but this serial number isn’t valid` is fine and has personally worked and working for me and many others. `Purchase Date not Validated` can be a problem down the line if a legitimate machine with that PlatformInfo is activated.

> ## Dual Booting:

- I recommend that you dual boot using another drive in the WAN slot (I have the WDC PC SN520 NVMe 2242). This makes installation much easier, and lets the BIOS F12 option act as your boot manager.
- I've found that dual booting with OpenCore on a single can be quite troublesome. Instead, what I recommend is to use rEFInd Boot Manager should you need to dual boot Windows or Linux.
- It is possible to share Bluetooth pairing keys between Windows and macOS when dual booting. 
  - The `.reg` for Bluetooth connected devices in macOS can be exported using Hackintool's Utilities section. This key can then be imported to Windows.

> ## Sleep:

- Disable Power Nap for both [`Battery`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Battery_powernap.png) and [`Power Adapter`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Poweradt_powernap.png).
- Disable [`Wake for Network Access`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Poweradt_powernap.png) in `Power Adapter`.
- Uncheck [`Allow Bluetooth devices to wake this computer`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Bluetooth_wake.png) if you do not need it.
- Do not disable `hibernatefile`.
- `sudo pmset -a tcpkeepalive 0` to disable Network while sleeping.
- `sudo pmset -a proximitywake 0` to disable peripheral wake agent.

> ## HiDPI, specfically, HiDPI for the WQHD-HDR 1440p Display:

- Run [xzhih/one-key-hidpi](https://github.com/xzhih/one-key-hidpi)

> ## EDID Override:

- This is necessary to fix HDMI hotplug.
- See current available patches in `/patches/Internal Displays/`, merge them with `config.plist`
- If a patch is not yet created for your display model. Please see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create your own EDID override. Please create a pull request to add your EDID override for different displays.

> ## Thunderbolt 3 Hotplug

- Native-like integration with macOS in System Report without the need of flashing a modded firmware. Thank you @benbender
- NOTE: If you do have a modded BIOS firmware, please reset all settings relating to Thunderbolt 3 to default, all that's needed are settings detailed below or in [1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)
- Please make sure of these settings in BIOS:
| Main Menu | Sub 1       | Sub 2                                         | Sub 3                                                              |
| --------- | ----------- | --------------------------------------------- | ------------------------------------------------------------------ |
|           | >> Config   | >> Thunderbolt (TM) 3                         | Thunderbolt BIOS Assist Mode `Disabled`                            |
|           |             |                                               | Security Level `No Security`                                       |
|           |             |                                               | Support in Pre Boot Environment: Thunderbolt(TM) Device `Disabled` |
- Note: USB 3.1 Gen2 hotplug still Work-in-progress.

> ## Keyboard:

- PrtSc (remapped to F13) = I use it for Screen Capture (Set in `System Preferences/Keyboard/Shortcuts`)
- Check `Use F1, F2, etc. keys as standard function keys` in `System Preferences/Keyboard` to gain access to standard F keys:  
  ![fnkeys](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/fnkeys.png)
- Additionally, [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and [BetterTouchTool](https://folivora.ai/) are great productivty tools to remap and/or add functions to your keyboard.

> ## Touchpad:

- Force Click is enabled by default, which turns any click on the trackpad into a force touch. I suggest you turn this off.
- In addition, I prefer to have tap to click on:  
  ![touchpad](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/touchpad.png)

> ## Optimizations:

- Repaste the machine with thermal [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- For those willing to risk permanently damaging your machine for the best thermal, repaste the machine with liquid metal [Grizzly Conductonaut](https://www.thermal-grizzly.com/produkte/25-conductonaut). For the majority however, I recommend using [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- Replace your machine's fan (if applicable). See https://www.reddit.com/r/thinkpad/comments/c7zpah/x1_carbon_6th_gen_horrible_cooling_fan_design/
- Mod the BIOS the unlock Intel Advance Menu, see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)
