## HiDPI

!!! warning

    Enabling HiDPI requires disabling Apple's System Integrity Protection (SIP).

!!! danger

    Users of `SecureBootModel` may end up in a RecoveryOS boot loop if the system partition has been modified. To resolve this, Reset NVRAM and set `SecureBootModel` to `Disabled`

1. Disable SIP. I prefer to use `ToggleSipEntry.efi` at Boot Picker.
2. Mount drive is writeable. See [instructions](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/extended/post-issues.html#writing-to-the-macos-system-partition)
3. Run [xzhih/one-key-hidpi](https://github.com/xzhih/one-key-hidpi)
4. Enable SIP.

## EDID Override

- This is necessary to fix HDMI hotplug.
- See current available patches in `/patches/Internal Displays/`, merge them with `config.plist`
- If a patch is not yet created for your display model. Please see [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60) to create your own EDID override. Please create a pull request to add your EDID override for different displays.
