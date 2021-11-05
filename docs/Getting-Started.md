# Getting Started

# Creating the macOS Installer

Please refer to [Dortania's Creating the USB](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/).

!!! tip
    Often as above, the project will defer universal steps to Dortania links. Hence, this repository is meant to be used in conjunction with their guides.  

# Using the Respository

1. Once the macOS installer has been created, copy `EFI` inside onto the installer's EFI partitition and make the following changes to `config.plist`
    
    - `ShowPicker` to `YES`
    - Add `-v` to `boot-args`
    - If your machine has a vanilla (unmodded) BIOS, merge `/patches/ OpenCore Patches/ Vanilla BIOS.plist` with `config.plist`

!!! note
    It is generally a good idea to keep the install drive with OpenCore around. As you tweak your own `opencore.plist`, things may break and you will not be able to get back into macOS using the system's OpenCore. In those times, you can use the install drive to boot into macOS.

2. Once macOS has been installed, boot the installed macOS paritition with the existing installer USB and complete new user setup.
3. Copy `EFI` onto the macOS drive's EFI partition. Similar to before, you may wish to:

    - Merge `/patches/ OpenCore Patches/ Vanilla BIOS.plist` with `config.plist` if you have an unmodded BIOS.

!!! success
    At this point, your machine should boot into macOS without anything attached.

1. There are a few other things to review and add on before your Hackintosh can be complete. Please proceed to Post Installation.

!!! tip
    Actively refer to Summary to get an idea of each functioning parts.