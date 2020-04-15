# Configurating OpenCore for your x1c6

<img align="right" src="https://i.imgur.com/u2Nukp7.png" alt="Critter" width="200">

## OpenCore is better than Clover in [many ways](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/). But since it is still in its infancy, OpenCore still requires a lot of time and personal confgurations to work. So even though I have posted my EFI-OpenCore folder, there are still some work which you have to do before you are able to get it working on your machine.

### Fortunately, [acidanthera](https://github.com/acidanthera) has done a great job documenting OpenCore. And while it can be greatly time consuming, I really recommend taking a look at it and starting a `config.plist` from scratch. Doing so will allow you to personalize and understand OpenCore configurations. More importantly, by starting an `config.plist` from scratch, you may catch a mistake in my own config.plist or find a better setting variable.  

I do, however, understand if you are strapped for time. So here are the necessary changes to my uploaded configs that would get your machine working. In most cases, your machine should boot with OpenCore after these changes. However, if it does not. please refer to acidanthera's OpenCore documentation.

```
* SystemUUID: Can be generated with MacSerial or use pervious from Clover's config.plist.
* MLB: Can be generated with MacSerial or use pervious from Clover's config.plist.
* ROM: ROM must either be Apple ROM (dumped from a real Mac), or your NIC MAC address, or any random MAC address (could be just 6 random bytes) - Vit9696
* SystemSerialNumber: Can be generated with MacSerial or use pervious from Clover's config.plist.
```

See [`docs/5_README-other`](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/5_README-other.md) for more details regarding PlatformInfo settings.

`CPUFriendDataProvider` can be generated with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend_) or [one-key-cpufriend](https://github.com/stevezhengshiqi/one-key-cpufriend). This is especially important if you have a different CPU than mine. Even if you have the same CPU as me, you may prefer a different Energy Performance Preference (EPP) so do generate your own CPUFriendDataProvider.  

> ## Important Note:

Unlike Clover, where SSDT patches are only being applied when booting macOS. OpenCore will apply SSDT patches regardless of the operating system. This is critical when multi-booting, since Windows and Linux do not need the additional patches that macOS does. In many cases, if Windows/Linux fails to boot under OpenCore, it is likely that your macOS intended SSDT patch(s) is being applied universally. To prevent OpenCore from doing this, it is important that your SSDT patches specify its intended OS, which in our case is "Darwin."  
See highlighted example:

![OpenCore SSDT patching notice](https://raw.githubusercontent.com/tylernguyen/x1c6-hackintosh/master/docs/assets/img/OpenCore%20SSDT%20patching%20notice.png)

> ## Checking your OpenCore config.plist

It is important to keep your OpenCore config.plist properly up-to-spec, as OpenCore configurations tend to change accordingly with OpenCore versions. A good resource to check your config plist is https://opencore.slowgeek.com/.

> ## Updating:

To update your OpenCore folder to my current version, simply backup your `PlatformInfo` information and move it to the new OpenCore config. Keep in mind that, depending on your setup, you may wish to keep other settings you've made so make sure to note your OpenCore `config.plist` changes as you make them.
