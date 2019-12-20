# Configurating OpenCore for your x1c6
<img align="right" src="https://i.imgur.com/u2Nukp7.png" alt="Critter" width="200">

## OpenCore is designed for the future of macOS, thus making it the future of Hackintosh. It's just simply better in [many ways](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/). But since it is still in its infancy, OpenCore still requires a lot of time and personal confgurations to work. So even though I have posted my EFI-OpenCore folder, there are still some work which you have to do before you are able to get it working on your machine.

### Fortunately, acidanthera has done a great job documenting OpenCore. And while it can be greatly time consuming, I really recommend taking a look at it because it helps so much in: creating, configurating, dianosing, personalizing, and understanding OpenCore configurations. 

I do, however, understand if you are strapped for time. So here are the necessary changes to my uploaded configs that would get your machine working. In most cases, your machine should boot with OpenCore after these changes. However, if it does not. please refer to acidanthera's OpenCore documentation.


SystemUUID: Can be generated with MacSerial or use pervious from Clover's config.plist.  
MLB: Can be generated with MacSerial or use pervious from Clover's config.plist.  
ROM: ROM must either be Apple ROM (dumped from a real Mac), or your NIC MAC address, or any random MAC address (could be just 6 random bytes) - Vit9696  
SystemSerialNumber: Can be generated with MacSerial or use pervious from Clover's config.plist.  

CPUFriendDataProvider: Can be generated with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_ or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). Even if you have the same CPU as me, you may prefer a different Energy Performance Preference (EPP) so do generate your own CPUFriendDataProvider. This is furhtermore important if you have a different CPU than me.  