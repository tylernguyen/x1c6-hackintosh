## README 

In the current directory are ACPI source files of patches in-use. 

Please refer to [docs/2_README-ACPIpatching.md](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/2_README-ACPIpatching.md) for each of their specific usage and purposes. In addition, each patch have insightful comments in them, please read throughly read their source code.

## OpenCore Patches
By default, the repo `config.plist` should have already have these patches included. These patches are mostly dependencies of various ACPI patches. They are here for reference patches.

## Display Patches
By default, the repo setup is display-agnostic. At the minimum, an EDID override is required for functioning HDMI hotplug. In addition, there are other things in this patch folder: calibrated color profiled, touchscreen patch.

If the EDID profile for your display is not included in here, please refer to [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)

## Network Patches
By default, the repo is setup for the macOS native Broadcom card. If your config includes other wireless cards, please refer to this folder.

## Debug Patches
By default, debug information is very limited. These patches will you much more information when diagnosing issues.

## update.sh
Run this script to compile `.dsl` patches into `.aml` and place them into the ACPI folder.