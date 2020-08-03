> ## Upgrading and other Major Changes:

- macOS minor version upgrade works just as any Mac would.
- It is generally a good idea to hold off on new major macOS releases until kexts and other dependencies have been tested.
- Upon upgrading macOS, even minor releases, it is recommended to clear NVRAM to reduce problems.
- Upon changing SSDT patches and/or changing BIOS settings, it is also recommended to clear NVRAM variables.

> ## Configuring PlatformInfo for iMessage/iCloud/FaceTime:

- Refer to [dortania /OpenCore-Install-Guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html)
- NOTE: `We’re sorry, but this serial number isn’t valid` is fine and has personally worked and working for me and many others. `Purchase Date not Validated` can be a problem down the line if a legitimate machine with that PlatformInfo is activated.

> ## Dual Booting:

- I recommend that you dual boot using another drive in the WAN slot (I have the WDC PC SN520 NVMe 2242). This makes installation much easier, and lets the BIOS F12 option act as your boot manager.
- I've found that dual booting with OpenCore on a single can be quite troublesome. Instead, what I recommend is to use rEFInd Boot Manager should you need to dual boot Windows or Linux.
- It is possible to share Bluetooth pairing keys between Windows and macOS when dual booting. See [oc-laptop-guide](https://dortania.github.io/oc-laptop-guide/extras/dual-booting-with-bluetooth-devices.html). Addtonally, the `.reg` for macOS connected devices can be exported using Hackintool's Utilities section. This key can then be imported to Windows.

> ## Sleep:

- Make sure that sleep mode is set to `Linux` within BIOS.
- Disable Power Nap for both [`Battery`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Battery_powernap.png) and [`Power Adapter`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Poweradt_powernap.png).
- Disable [`Wake for Network Access`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Poweradt_powernap.png) in `Power Adapter`.
- Uncheck [`Allow Bluetooth devices to wake this computer`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/Bluetooth_wake.png) if you do not need it.
- Do not disable `hibernatefile`.
- `sudo pmset -a tcpkeepalive 0` to disable Network while sleeping.
- `sudo pmset -a proximitywake 0` to disable peripheral wake agent.

> ## EDID Override:

- This is necessary to fix HDMI hotplug.
- See current available patches in `patches/Internal Displays/`
- If a patch is not yet created for your display model. Please see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create your own EDID override. Please create a pull request to add your EDID override for different displays.

> ## Thunderbolt 3 Hotplug a.k.a The Big Boss:

Summary, TB3 hotplug works perfectly, but with some caveats:
- Firstly, refer to [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md) for BIOS configurations having to do with TB3 hotplug.
- If you want to hotplug TB3 on the power port, you need an unlocked BIOS to force power to `PR05` (`TbtForcePower.efi` only forces power on `PR09` which is the Ethernet TB3 port.)
- `Thunderbolt BIOS Assist` needs to be disabled which rises idle CPU power consumption to 2W as opposed to ~0.8W with the option enabled.
- See the ongoing issue/discussion [Issue #24](https://github.com/tylernguyen/x1c6-hackintosh/issues/24)

> ## Multimedia Fn Keys:

Since macOS doesn't not natively support some multimedia Fn key actions. [ThinkpadAssistant](https://github.com/MSzturc/ThinkpadAssistant) is required for the Fn actions to be implemented. Additionally, my settings are:

- F11 = Switch Keyboard Input Language (Set in System `Preferences/Keyboard`)
- PrtSc = Screen Capture (Set in System `Preferences/Keyboard`)

> ## Touchpad:

- By default, this repo is using `VoodoRMI`and `VoodooSMBus` to handle the touchpad. These kexts are still infants and can be buggy. Feel free to change to `VoodooPS2` should you prefer its stability. I, however, prefer the better feel and experience of `VoodooRMI`.

> ## Touchpad Settings in macOS:

- Force Click is enabled by default, which turns any click on the trackpad into a force touch. I suggest you turn this off.
- In addition, I prefer to have tap to click on.  
  See my touchpad settings:  
  ![touchpad](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/touchpad.png)

> ## Headphone Patch:

- Installing ALCPlugFix addresses the following:
  - Change output to headphones after being plugged in, and to change it back to speakers after being unplugged.
  - Fix the rare condition that audio is messed up after waking from sleep.

See `patches/ALCPlugFix/README.md` for more details.

> ## Optimizations:

- Repaste the machine with thermal [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- For those willing to risk permanently damaging your machine for the best thermal, repaste the machine with liquid metal [Grizzly Conductonaut](https://www.thermal-grizzly.com/produkte/25-conductonaut). For the majority however, I recommend using [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- Mod the BIOS the unlock Intel Advance Menu, see [docs/1_README-HARDWAREandBIOS.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/1_README-HARDWAREandBIOS.md)
