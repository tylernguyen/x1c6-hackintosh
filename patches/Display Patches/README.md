## README 
- By default, the repo setup is display-agnostic. **At the minimum, an EDID override is required for functioning HDMI hotplug.**
- If the EDID profile for your display is not included in here, please refer to [Issue #60](https://github.com/tylernguyen/x1c6-hackintosh/issues/60)
- Refer to [/docs/references/x1c6-Platform_Specifications](https://github.com/tylernguyen/x1c6-hackintosh/blob/master/docs/references/x1c6-Platform_Specifications.pdf) for possible stock ThinkPad X1 6th Gen configurations.

### WQHD-HDR-B140QAN02_0.icm
Calibrated color profile for the WQHD-HDR display.

### WQHD-HDR-EDID.plist
EDID override for the WQHD-HDR display, with additional overlocked refresh rates:
 - 64Hz is stable.
 - 65Hz causes minor artifacts.
 - 66Hz makes display go crazy.
 - You may be more/less lucky with your own panel.

### FHD-Non-touch_EDID.plist
EDID override for the Non-touch 1080p display.

### FHD_Touchscreen.plist
Patches for the 1080p touchscreen display.

