# Getting Started

# Creating the macOS Installer

Please refer to [Dortania's Creating the USB](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/).

!!! tip
    Often as above, the project will defer universal steps to Dortania links. Hence, this repository is meant to be used in conjunction with their guides.  

# Using the Respository

1. With the macOS installer has been created, you can use the `EFI` inside `install EFI` to install macOS onto your drive.

!!! note
    It is generally a good idea to keep the install drive with OpenCore around. As you tweak your own `opencore.plist`, things may break and you will not be able to get back into macOS using the system's OpenCore. In those times, you can use the install drive to boot into macOS.

2. Once macOS has been installed, boot the installed macOS paritition with the existing installer USB and complete new user setup.
3. Use the `EFI` inside `EFI-OpenCore` for the macOS drive's EFI partition. If your BIOS is unmodded, add the contents of `config_unmoddedBIOS.plist` to the main `config.plist`.

!!! success
    At this point, your machine should boot into macOS without anything attached.

1. There are a few other things to review and add on before your Hackintosh can be complete. Please proceed to Post Installation.

!!! tip
    Actively refer to Summary to get an idea of each functioning parts.