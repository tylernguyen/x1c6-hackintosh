> ## Upgrading and other Major Changes:

- macOS minor version upgrade works just as any Mac would.
- It is generally a good idea to hold off on new major macOS releases until kexts and other dependencies have been tested.
- Upon upgrading macOS, even minor releases, it is recommended to clear NVRAM to reduce problems.
- Upon changing SSDT patches and/or changing BIOS settings, it is also recommended to clear NVRAM variables.

> ## Dual Booting:

- I recommend that you dual boot using another drive in the WAN slot (I have the WDC PC SN520 NVMe 2242).
- I've found that dual booting with OpenCore can be quite troublesome. Instead, what I recommend is to use rEFInd Boot Manager should you need to dual boot Windows or Linux.
- It is possible to share Bluetooth pairing keys between Windows and macOS when dual booting. See [oc-laptop-guide](https://dortania.github.io/oc-laptop-guide/extras/dual-booting-with-bluetooth-devices.html).

> ## Modifier Key Patching:

By default, Windows, Left Alt, and Right Alt are mismapped. An easy fix for this is to install [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and configure it as:  
![karabiner_modifier](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/karabiner_modifier.png)

> ## Multimedia Fn Key Patching:

Since macOS doesn't not natively support some multimedia Fn key actions. BetterTouchTool is required to program these actions. Keyboard Mastero is also an alternative but I've found that BetterTouchTool is a simpler and easier option.  
Simply import `patches/BetterTouchTool/x1c6-functions.bttpreset`. My settings are as followed:

- F7 = Screen Mirroring On/Off
- F9 = Open System Preferences
- F10 = Toggle Bluetooth On/Off
- F11 = Switch Keyboard Input Language (Set in System `Preferences/Keyboard`)
- F12 = Open Terminal
- PrtSc = Window Screen Capture  
  Of course, feel free to change this to your preference in BetterTouchTool.

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

> ## OPTIMIZATIONS:

- Repaste the machine with thermal [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- For those willing to risk permanently damaging your machine for the best thermal, repaste the machine with liquid metal [Grizzly Conductonaut](https://www.thermal-grizzly.com/produkte/25-conductonaut). For the majority however, I recommend using [Grizzly Kryonaut](https://www.thermal-grizzly.com/en/products/16-kryonaut-en).
- Undervolt the machine with [VoltageShift](https://github.com/sicreative/VoltageShift).

> ## Configuring PlatformInfo for iMessage/iCloud/FaceTime:

ATTEMPT THIS SECTION AT YOUR OWN RISK - It may result in your Apple ID being blacklisted. You can have a perfectly adequate hackintosh without iMessage/FaceTime.

- To get iCloud related services we will follow the instructions on [this page](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/iservices.html) that are suited to an OC EFI.

  - Download [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), install MacSerial by selecting option 1
  - With GenSMBIOS select option 3 and enter `MacBookPro14,1 10` to generate 10 potential Serials/Board Serial/SmUUID combinations.
  - Next we want to see if any of these are properly identified and **NOT** being used.
  - Enter the first serial into [this site](http://www.appleserialnumberinfo.com/Desktop/index.php) to check that the serial code is a valid serial in terms of formatting. You should see information regarding a MacBook Pro (13-inch, 2017)
  - Next, enter the same serial into the [Apple Check Coverage Page](https://checkcoverage.apple.com/gb/en/). We want the following result: `"We’re sorry, but this serial number isn’t valid. Please check your information and try again."`
    ![Correct Serial but not covered](https://i.imgur.com/dvYcpHB.png)
  - If your serial works on the first page, and _shows the error above on apple's site_, you have a **valid** serial to use, it is not in use by anyone else.
  - If the serial does not show properly on appleserialnumberinfo OR is already in use, try the next serial until you have one that passes the formatting check, and is not in use according to Apple.
  - Next, you want to enter the serial info into your config.plist. Find the PlatformInfo->Generic section in your config.plist, and add SystemProductName (serial) and SystemUUID (SmUUID). Your section in the config.plist should look like the following (note these values will not work, generate your own):

  ```
  <key>PlatformInfo</key>
  	<dict>
  		<key>Automatic</key>
  		<true/>
  		<key>Generic</key>
  		<dict>
  			<key>AdviseWindows</key>
  			<false/>
  			<key>SpoofVendor</key>
  			<true/>
  			<key>SystemProductName</key>
  			<string>MacBookPro14,1</string>
  			<key>SystemSerialNumber</key>
  			<string>C02XXXXXXXXX</string>
  			<key>SystemUUID</key>
  			<string>37AA17F9-8C9A-430C-815C-XXXXXXXXXXX</string>
  		</dict>
  ```

- NOTES
  - It is assumed you have not tried to set up iMessage etc before this guide, otherwise you should clear existing caches as the linked guide indicates and reboot before starting this guide.
  - Contrary to what the guide linked indicates, we **do not need** the following result on apple's coverage check, it is fine to have the error shown earlier in this guide.
    ![misleading](https://i.imgur.com/oSLMqWa.png)
  - You do **NOT want** the device to already be purchased. You will mess up your own device and some poor person's legitimate Mac.
    ![Already purchased/registered](https://i.imgur.com/rh0r28T.png)
  - If you try to verify too many serials you will be blocked, just reopen the page in an incognito window to bypass the block.
  - You may need to follow the other fixes on the guide, such as [setting the Network card MAC address](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/iservices.html#fixing-rom) in the config.plist
  - **Try not to attempt too many serial codes, or messing around too much as you may end up blacklisting your apple ID!** In which case you will get the following error:
    ![blacklist](https://i.imgur.com/ypDy99L.png)
