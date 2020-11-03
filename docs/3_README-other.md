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

> ## Thunderbolt 3 Hotplug a.k.a The Big Boss (Work in Progress):

Summary, TB3 hotplug works perfectly, but with some caveats:
- Firstly, refer to [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) for BIOS configurations having to do with TB3 hotplug.
- `Thunderbolt BIOS Assist` needs to be disabled which raises idle CPU power consumption to 2W as opposed to ~0.8W with the option enabled.
- See the ongoing issue/discussion [Issue #24](https://github.com/tylernguyen/x1c6-hackintosh/issues/24)

With those done, there are two scenarios:
- You want to use TB3 hotplug on both macOS and another OS, such as Linux or Windows. In this case, stick with the current TB3 hotplug setup in this repo. As my repo is currently designed around compatibility with other OSes as I need Windows for work.
- You only need TB3 hotplug on macOS. In this case, it is possible to reflash the Thunderbolt controller chip on the machine with a modded firmware designed to allow native Thunderbolt interfacing with macOS. See [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md).

With Thunderbolt 3 Hotplug, these are the possible scenarios:
- **Modded Controller and BIOS:**
  - No additional kexts or drivers needed. (You can remove TB3 related kexts and drivers from your EFI)
  - TB3 Hotplug will work natively in macOS.
  - TB3 Hotplug will NOT work in Windows or other OS'es.
- **Modded Controller and Vanilla BIOS:**
  - No additional kexts or drivers needed. (You can remove TB3 related kexts and drivers from your EFI)
  - TB3 Hotplug will work natively in macOS.
  - TB3 Hotplug will NOT work in Windows or other OS'es.
- **Vanilla Controller and Modded BIOS:**
  - Use `ThunderboltReset.kext`
  - Use modded BIOS to force power on `PR09` and `PR05`
- **Vanilla Controller and BIOS:**
  - Use `ThunderboltReset.kext` and `TbtForcePower.efi`
  - Hotplug will not work on Power port (`PR05`)

- Regardless, current TB3 hotplug implementations are not perfect. Current conflicts include getting USB 3.1 gen2, pm, tb - in osx + win all working at the same time.
For a more detailed, and better explaination, refer to [osy86's Thunderbolt Hotplug Docs](https://github.com/osy86/HaC-Mini/tree/master/details)

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
- Mod the BIOS the unlock Intel Advance Menu, see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)
