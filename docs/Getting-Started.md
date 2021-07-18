# Getting Started

# Creating the macOS Installer

Please refer to [Dortania's Creating the USB](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/).

!!! tip
    Often as above, the project will defer universal steps to Dortania links. Hence, this repository is meant to be used in conjunction with their guides.  

# Using the Respository

1. With the macOS installer has been created, you can use the `EFI` inside `EFI-install_USB` to install macOS onto your drive.
2. Once macOS has been installed, boot the installed macOS paritition with the existing installer USB and complete new user setup.
3. Use the `EFI` inside `EFI-OpenCore` for the macOS drive's EFI partition. If your BIOS is unmodded, add the contents of `config_unmoddedBIOS.plist` to the main `config.plist`.

!!! success
    At this point, your machine should boot into macOS without anything attached.

4. There are a few other things to review and add on before your Hackintosh can be complete. Please proceed to Post Installation.

!!! tip
    Actively refer to Summary to get an idea of each functioning parts.