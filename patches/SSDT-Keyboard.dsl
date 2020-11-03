/*
 * For use with BrightnessKeys.kext and YogaSMC
 * https://github.com/zhen-zen/YogaSMC
 *
 */

DefinitionBlock("", "SSDT", 2, "tyler", "_KBD", 0)
{
    External (_SB.PCI0.LPCB.KBD, DeviceObj)
        
    Scope (_SB.PCI0.LPCB.KBD)
    {
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "RM,oem-id", "LENOVO",
                "RM,oem-table-id", "Thinkpad_ClickPad",
            })
        }
        
        // Overrides (the example data here is default in the Info.plist)
        Name(RMCF, Package()
        {
            "Synaptics TouchPad", Package()
            {
                "BogusDeltaThreshX", 800,
                "BogusDeltaThreshY", 800,
                "Clicking", ">y",
                "DragLockTempMask", 0x40004,
                "DynamicEWMode", ">n",
                "FakeMiddleButton", ">n",
                "HWResetOnStart", ">y",
                //"ForcePassThrough", ">y",
                //"SkipPassThrough", ">y",
                "PalmNoAction When Typing", ">y",
                "ScrollResolution", 800,
                "SmoothInput", ">y",
                "UnsmoothInput", ">y",
                "Thinkpad", ">y",
                "EdgeBottom", 0,
                "FingerZ", 30,
                "MaxTapTime", 100000000,
                "MouseMultiplierX", 2,
                "MouseMultiplierY", 2,
                "MouseScrollMultiplierX", 2,
                "MouseScrollMultiplierY", 2,
                //"TrackpointScrollYMultiplier", 1, //Change this value to 0xFFFF in order to inverse the vertical scroll direction of the Trackpoint when holding the middle mouse button.
                //"TrackpointScrollXMultiplier", 1, //Change this value to 0xFFFF in order to inverse the horizontal scroll direction of the Trackpoint when holding the middle mouse button.
            },
            
            "Keyboard", Package()
            {
                "Custom PS2 Map", Package()
                {
                    Package() { },
                    "e037=64", // PrtSc = F13
                    "46=80",   // Fn + K = Deadkey
                    "e045=80", // Fn + P = Deadkey
                    "38=e05b", // Left Alt (mismapped to Left GUI by default) = Left Alt
                    "e038=e05c", // Right Alt (mismapped to Right GUI by default) = Right Alt
                    "e05b=38", // Windows (mismapped to Left Alt by default) = Left GUI
                    // "1d=80", // Fn + B = Deadkey
                    // "54=80", // Fn + S = Deadkey
                },
            },
        })
    }
}
//EOF