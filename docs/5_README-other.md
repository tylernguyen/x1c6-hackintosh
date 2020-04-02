> ## Dual Booting:
* I recommend that you dual boot using another drive in the WAN slot.
* I've found that dual booting with OpenCore can be quite troulesome. Instead, what I recommend is to use rEFInd Boot Manager should you need to dual boot Windows or Linux.

## Modifier Key Patching:
By default, Windows, Left Alt, and Right Alt are mismapped. An easy fix for this is to install [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and configure it as:  
![karabiner_modifier](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/karabiner_modifier.png)

## Multimedia Fn Key Patching:
Since macOS doesn't not natively support some multimedia Fn key actions. BetterTouchTool is required to program these actions. Keyboard Mastero is also an alternative but I've found that BetterTouchTool is a simpler and easier option.  
Simply import `patches/BetterTouchTool/x1c6-functions.bttpreset`. My settings are as followed:  
* F7 = Screen Mirroring On/Off
* F9 = Open System Preferences
* F10 = Toggle Bluetooth On/Off
* F11 = Switch Keyboard Input Language (Set in System `Preferences/Keyboard`)
* F12 = Open Terminal
* PrtSc = Window Screen Capture  
Of course, feel free to change this to your preference in BetterTouchTool.  


## Touchpad Settings in macOS:
* Force Click is enabled by default, which turns any click on the trackpad into a force touch. I suggest you turn this off.  
* In addition, I prefer to have tap to click on.  
See my touchpad settings:  
![touchpad](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/assets/img/macOS%20Settings/touchpad.png)

## Headphone Patch:
* Installing ALCPlugFix addresses the following:  
    * Change output to headphones after being plugged in, and to change it back to speakers after being unplugged.  
    * Fix the rare condition that audio is messed up after waking from sleep.  

See `patches/ALCPlugFix/README.md` for more details.  