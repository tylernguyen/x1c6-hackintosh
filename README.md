<h1 align="center"> Hackintosh the Thinkpad X1 Carbon 6th Generation </h1>

<p align="center">
<a href="https://www.apple.com/macos/big-sur/">
  <img src="https://img.shields.io/badge/macOS-Big_Sur_v11.4-red.svg"/> </a>
<a href="https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads/driver-list/component?name=BIOS%2FUEFI">
  <img src="https://img.shields.io/badge/BIOS-Modded_1.50-blue"/> </a>
<a href="https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/references/x1c6-Platform_Specifications.pdf">
  <img src="https://img.shields.io/badge/Model-20KH*-9cf"/> </a>
<a href="https://github.com/acidanthera/OpenCorePkg">
  <img src="https://img.shields.io/badge/OpenCore-0.7.0-12AED6"/> </a>
<a href="https://github.com/tylernguyen/x1c6-hackintosh/issues"> 
  <img src="https://img.shields.io/github/issues/tylernguyen/x1c6-hackintosh"/> </a>
<a href="https://github.com/tylernguyen/x1c6-hackintosh/commits/master"> 
  <img src="https://img.shields.io/github/last-commit/tylernguyen/x1c6-hackintosh"/> </a>
<a href="https://github.com/tylernguyen/x1c6-hackintosh/issues?q=is%3Aissue+label%3A%22help+wanted%22+is%3Aclosed">
  <img src="https://img.shields.io/badge/need%20help-2-blue"/> </a>
</p>

<p align="center">
<a href="https://github.com/tylernguyen/obsidian-horizon/blob/main/LICENSE">
   <img src="https://img.shields.io/badge/License-The%20Unlicense-informational.svg"> </a>
<a href="https://damnthattelevision.com/Contact">
   <img src="https://img.shields.io/badge/%40-Contact-FFF27D"> </a>
<a href="https://damnthattelevision.com/Support">
   <img src="https://img.shields.io/badge/%24-Support-ff69b4.svg"> </a>
<a href="">
   <img src="https://img.shields.io/badge/Contributions-Welcome-orange.svg"> </a>
</p>

<p align="center">
<img src="https://raw.githubusercontent.com/tylernguyen/x1c6-hackintosh/master/docs/assets/x1c6.png" alt="Thinkpad X1 Carbon 6th Gen" width="400">
</p>

<p align="center">
<a href="https://tylernguyen.github.io/x1c6-hackintosh/">
   <img src="https://img.shields.io/badge/-Click%20Here%20to%20Start-E95678?style=for-the-badge"> </a>
</p>

**July 16th, 2021,**  
I consider the state of this project to be **very stable**. Everything works the way it should, or at least the things I notice. There will likely never be major changes coming unless a new macOS version break something severely (which I doubt). I will continue to maintain this project with every OpenCore releases, up until it's (MacBookPro14,1) official out of service/support from Apple.

#### I am not responsible for any damages you may cause.

#### If my work here helped you. Please consider donating, it would mean a lot to me.

## Update

##### Recent | [Changelog Archive](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/CHANGELOG.md)

### 2021-6-21

#### Added
- A notice in the doc that warns: "modding the BIOS will break TPM and thus, Windows 11. Consider this before you proceed with BIOS modding."

#### Removed
- The `GitHub-pages` of this project, it was pretty useless since it's just a mirror of the `README.md`.

#### Notice
- This will likely be the last repo update until macOS Monterey is stable. At which I plan:
  - Implement AX200 as the network card with the OpenIntelWireless kexts.


# Other Respositories

- x1c6-hackintosh repositories:
  - [benbender/x1c6-hackintosh](https://github.com/benbender/x1c6-hackintosh)
  - [zhtengw/EFI-for-X1C6-hackintosh](https://github.com/zhtengw/EFI-for-X1C6-hackintosh)   
- t480-hackintosh repositories:
  - [EETagent/T480-OpenCore-Hackintosh](https://github.com/EETagent/T480-OpenCore-Hackintosh)
Create a pull request if you like to be added, final decision at my discreation.

# Credits

- [@benbender](https://github.com/benbender) for your hardwork. Much of this repo comes from your research and code. Thank you!
- [@Fewtarius](https://github.com/fewtarius) for your help with patching audio.
- [@Colton-Ko](https://github.com/Colton-Ko/macOS-ThinkPad-X1C6) for the great features template.  
- [@stevezhengshiqi](https://github.com/stevezhengshiqi) for the one-key-cpufriend script.  
- [@corpnewt](https://github.com/corpnewt) for [GibMacOS](https://github.com/corpnewt/gibMacOS) and [EFIMount](https://github.com/corpnewt/MountEFI).
- [@xzhih](https://github.com/xzhih) for one-key-hidpi.  
- [daliansky/OC-little](https://github.com/daliansky/OC-little) for various ACPI hotpatch samples.  
- [@velaar](https://github.com/velaar) for your continual support and contributions.     
- [@Porco-Rosso](https://github.com/Porco-Rosso) putting up with my requests to test repo changes.  
- [@MSzturc](https://github.com/MSzturc) for adding my requested features to ThinkpadAssistant.  
- paranoidbashthot and \x for the BIOS mod.
- [@zhen-zen](https://github.com/zhen-zen) for YogaSMC

The greatest thank you and appreciation to the [Acidanthera](https://github.com/acidanthera) team.

And to everyone else who supports and uses my project.

Please let me know if I missed you.
