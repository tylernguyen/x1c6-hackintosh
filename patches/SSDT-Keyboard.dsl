/*
 * For use with BrightnessKeys.kext, YogaSMC, and VoodooRMI
 * https://github.com/zhen-zen/YogaSMC
 *
 * For more customizations, refer to YogaSMCPrefPane, VoodooRMI's info.plist
 * and/or third party software such as BetterTouchTool or Karabiner-Elements.
 */

DefinitionBlock("", "SSDT", 2, "tyler", "_KBD", 0)
{
    External (_SB.PCI0.LPCB.KBD, DeviceObj)
        
    Scope (_SB.PCI0.LPCB.KBD)
    {
        Name(RMCF, Package()
        {
            "Keyboard", Package()
            {
                "Custom PS2 Map", Package()
                {
                    Package() { },
                    "e037=64", // PrtSc = F13
                    "46=80",   // Fn + K = Deadkey
                    "e045=80", // Fn + P = Deadkey
                    // (Dep. by YogaSMC) "38=e05b", // Left Alt (mismapped to Left GUI by default) = Left Alt
                    // (Dep. by YogaSMC) "e038=e05c", // Right Alt (mismapped to Right GUI by default) = Right Alt
                    // (Dep. by YogaSMC) "e05b=38", // Windows (mismapped to Left Alt by default) = Left GUI
                    // "1d=80", // Fn + B = Deadkey
                    // "54=80", // Fn + S = Deadkey
                },
            },
        })
    }
}
//EOF