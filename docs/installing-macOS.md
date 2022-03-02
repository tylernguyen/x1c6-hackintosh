---
hide:
  - navigation
---

## Creating the macOS Installer

Start by creating a vanilla macOS installer, refer to [Dortania's Creating the USB](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/).

You may also use [`createinstallmedia`](createinstallmedia) if you already have a Mac.

!!! tip
    Often as above, the project will defer universal steps to Dortania links. Hence, this repository is meant to be used in conjunction with their guides.  

## EFI Partition

1. Make the following changes to `config.plist` within the `EFI` folder.
    
    - `ShowPicker` to `YES`
    - If your machine has a vanilla (unmodded) BIOS, merge `/patches/ OpenCore Patches/ Vanilla BIOS.plist` with `config.plist`

!!! note
    It is generally a good idea to keep the install media around. As you tweak your own OpenCore `config.plist`, things may break and you will not be able to get back into macOS using the system's OpenCore. In those times, you can use the install drive to boot into macOS.

2. Mount the installer media's EFI parition. You may do this via the command line with `diskutil` or via a utility like [corpnewt/MountEFI](https://github.com/corpnewt/MountEFI).

3. Copy the EFI folder into the installer media's EFI partition. Remember that the top directory level should be `EFI`.

4. Boot into the macOS installer envrionemnt using the media. Format target disk as `APFS` using `Disk Utility` and complete installation.

5. Once macOS has been installed, boot the installed macOS paritition with the existing installer USB and complete new user setup.

6. Copy `EFI` onto the macOS drive's EFI partition. Set `ShowPicker` to `NO` for a cleaner boot experience. You can still access the boot picker by pressing `ESC` during boot time.

!!! success
    At this point, your machine should boot into macOS without anything attached.
