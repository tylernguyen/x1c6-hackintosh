# Configurating OpenCore for your x1c6
<img align="right" src="https://i.imgur.com/u2Nukp7.png" alt="Critter" width="200">

## OpenCore is better than Clover in [many ways](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/). But since it is still in its infancy, OpenCore still requires a lot of time and personal confgurations to work. So even though I have posted my EFI-OpenCore folder, there are still some work which you have to do before you are able to get it working on your machine.

### Fortunately, acidanthera has done a great job documenting OpenCore. And while it can be greatly time consuming, I really recommend taking a look at it because it helps so much in: creating, configurating, dianosing, personalizing, and understanding OpenCore configurations. 

I do, however, understand if you are strapped for time. So here are the necessary changes to my uploaded configs that would get your machine working. In most cases, your machine should boot with OpenCore after these changes. However, if it does not. please refer to acidanthera's OpenCore documentation.


SystemUUID: Can be generated with MacSerial or use pervious from Clover's config.plist.  
MLB: Can be generated with MacSerial or use pervious from Clover's config.plist.  
ROM: ROM must either be Apple ROM (dumped from a real Mac), or your NIC MAC address, or any random MAC address (could be just 6 random bytes) - Vit9696  
SystemSerialNumber: Can be generated with MacSerial or use pervious from Clover's config.plist.  

CPUFriendDataProvider: Can be generated with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_ or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). Even if you have the same CPU as me, you may prefer a different Energy Performance Preference (EPP) so do generate your own CPUFriendDataProvider. This is furhtermore important if you have a different CPU than me.  

## Important Note:
Unlike Clover, where SSDT patches are only being applied when booting macOS. OpenCore will apply SSDT patches regardless of the operating system. This is critical when multi-booting, since Windows and Linux do not need the additional patches that macOS does. In many cases, if Windows/Linux fails to boot under OpenCore, it is likely that your macOS intended SSDT patch(s) is being applied universally. To prevent OpenCore from doing this, it is important that your SSDT patches specify its intended OS, which in our case is "Darwin."  
See highlighted example: 
![OpenCore SSDT patching notice](https://raw.githubusercontent.com/tylernguyen/x1c6-hackintosh/master/assets/img/OpenCore%20SSDT%20patching%20notice.png)

## Checking your OpenCore config.plist
It is important to keep your OpenCore config.plist properly up-to-spec, as OpenCore configurations tend to change accordingly with OpenCore versions. A good resource to check your config plist is https://opencore.slowgeek.com/.