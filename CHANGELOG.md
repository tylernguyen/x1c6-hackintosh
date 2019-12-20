# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

> ## [Unreleased]

> ## 2019-12-22
### Added
Project website: https://tylernguyen.github.io/x1c6-hackintosh/  
ACPI dump for `BIOS-v1.43`.  
CHANGELOG.md to keep track of the project's developments.  
OpenCore bootloader, version `0.5.3`.  
Better SSDT patching with hotpatches under `patches`. Making sure to read `patches/README`.  
### Changed
Switched completely to hotpatching through OpenCore. Credits to [daliansky](https://github.com/daliansky) and [jsassu20](https://github.com/jsassu20).  
Updated main README, made it look more visually appealing and organized.
### Deprecated
Clover bootloader. Clover r5100 is the last version I used on this machine. Moving forward, OpenCore is my preferred bootloader. See `EFI-Clover/README.md`.  
Reorganized folder/project structure. Setup instructions and references now under `docs`.  
### Removed
Old static patches.  
Old IORegistryExplorer dump.