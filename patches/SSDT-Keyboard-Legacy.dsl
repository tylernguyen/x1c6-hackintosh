/*
 * For use with ThinkpadAssistant (would need ACPI renames: /patches/OpenCore Patches/ Keyboard-Legacy.plist)
 * https://github.com/MSzturc/ThinkpadAssistant
 *
 */

DefinitionBlock("", "SSDT", 2, "tyler", "_KBD", 0)
{
    External (OSDW, MethodObj)
    External (_SB.PCI0.LPCB.KBD, DeviceObj)
    External (_SB.PCI0.LPCB.EC, DeviceObj)
    External (_SB.PCI0.LPCB.EC.XQ74, MethodObj) // FnLock
    External (_SB.PCI0.LPCB.EC.XQ6A, MethodObj) // F4 - Mic Mute
    External (_SB.PCI0.LPCB.EC.XQ15, MethodObj) // F5
    External (_SB.PCI0.LPCB.EC.XQ14, MethodObj) // F6
    External (_SB.PCI0.LPCB.EC.XQ16, MethodObj) // F7
    External (_SB.PCI0.LPCB.EC.XQ64, MethodObj) // F8
    External (_SB.PCI0.LPCB.EC.XQ66, MethodObj) // F9
    External (_SB.PCI0.LPCB.EC.XQ60, MethodObj) // F10
    External (_SB.PCI0.LPCB.EC.XQ61, MethodObj) // F11
    External (_SB.PCI0.LPCB.EC.XQ62, MethodObj) // F12
    External (_SB.PCI0.LPCB.EC.XQ1F, MethodObj) // Keyboard Backlight (Fn+Space)
    External (_SB.PCI0.LPCB.EC.HKEY.MHKQ, MethodObj) // FnLock LED
    External (_SB.PCI0.LPCB.EC.HKEY.MMTS, MethodObj) // F4 - Mic Mute LED
    External (_SB.PCI0.LPCB.EC.HKEY.MLCS, MethodObj) // Keyboard Backlight LED
        
    Scope (_SB.PCI0.LPCB.EC)
    {
        Name (FUNL, Zero) // FnLock LED
        Method (_Q74, 0, NotSerialized) // FnLock (Fn + Esc)
        {
            If (OSDW ())
            {
                FUNL = (FUNL + 1) % 2
                Switch (FUNL)
                {
                    Case (One) 
                    {
                        // Right Shift + F18
                        Notify (KBD, 0x012A)
                        Notify (KBD, 0x0369)
                        Notify (KBD, 0x01aa)

                        // Enable LED
                        \_SB.PCI0.LPCB.EC.HKEY.MHKQ (0x02)
                    }
                    Case (Zero)
                    {
                        // Left Shift + F18
                        Notify (KBD, 0x0136)
                        Notify (KBD, 0x0369)
                        Notify (KBD, 0x01b6)

                        // Disable LED
                        \_SB.PCI0.LPCB.EC.HKEY.MHKQ (Zero)
                    }
                }
            }
            Else
            {
                // Call original _Q74 method.
                XQ74()
            }
        }
        
        Name (MICL, Zero) // F4 - Mic Mute LED   
        Method (_Q6A, 0, NotSerialized) // F4 - Microphone Mute = F20
        {
            If (OSDW ())
          	{
                MICL = (MICL + 1) % 2
                Switch (MICL)
                {
                    Case (One) 
                    {
                        // Right Shift + F20
                        Notify (KBD, 0x0136)
                        Notify (KBD, 0x036B)
                        Notify (KBD, 0x01b6)
                        
                        // Enable LED
                        \_SB.PCI0.LPCB.EC.HKEY.MMTS (0x02)
                    }
                    Case (Zero) 
                    {
                        // Left Shift + F20
                        Notify (KBD, 0x012A)
                        Notify (KBD, 0x036B)
                        Notify (KBD, 0x01aa)
                        
                        // Disable LED
                        \_SB.PCI0.LPCB.EC.HKEY.MMTS (Zero)
                    }
                }
            }
            Else
            {
                // Call original _Q6A method.
                XQ6A()
            }
        }
        
        Method (_Q15, 0, NotSerialized) // F5 - Brightness Down = F14
        {
            If (OSDW ())
            {
                Notify(KBD, 0x0405)
                Notify(KBD, 0x20) // Reserved
            }
            Else
            {
                // Call original _Q15 method.
                XQ15()
            }
        }

        Method (_Q14, 0, NotSerialized) // F6 - Brightness Up = F15
        {
            If (OSDW ())
            {
                Notify(KBD, 0x0406)
                Notify(KBD, 0x10) // Reserved
            }
            Else
            {
                // Call original _Q14 method.
                XQ14()
            }
        }
        
        Method (_Q16, 0, NotSerialized) // F7 - Dual Display = F16
        {
            If (OSDW ())
            {
                Notify(KBD, 0x0367)
            }
            Else
            {
                // Call original _Q16 method.
                XQ16()
            }
        }
        
        Method (_Q64, 0, NotSerialized) // F8 - Network = F17
        {
            If (OSDW ())
            {
                Notify(KBD, 0x0368)
            }
            Else
            {
                // Call original _Q64 method.
                XQ64()
            }
        }
        
        Method (_Q66, 0, NotSerialized) // F9 - Settings = F18
        {
            If (OSDW ())
            {
                Notify(KBD, 0x0369)
            }
            Else
            {
                // Call original _Q66 method.
                XQ66()
            }
        }
        
        Method (_Q60, 0, NotSerialized) // F10 - Bluetooth
        {

            If (OSDW ())
            {
                // Left Shift + F17
                Notify (KBD, 0x012A)
                Notify (KBD, 0x0368)
                Notify (KBD, 0x01AA)
            }
            Else
            {
                // Call original _Q60 method.
                XQ60()
            }
        }
        
        Method (_Q61, 0, NotSerialized) // F11 - Keyboard
        {
            If (OSDW ())
            {
                // Send a down event for the Control key (scancode 1d), then a one-shot event (down then up) for
                // the up arrow key (scancode 0e 48), and finally an up event for the Control key (break scancode 9d).
                // This is picked up by VoodooPS2 and sent to macOS as the Control+Up key combo.
                Notify (KBD, 0x011D)
                Notify (KBD, 0x0448)
                Notify (KBD, 0x019D)
            }
            Else
            {
                // Call original _Q61 method.
                XQ61()
            }
        }
        
        Method (_Q62, 0, NotSerialized) // F12 - Star = F19
        {
            If (OSDW ())
            {
                Notify(KBD, 0x036A)
            }
            Else
            {
                // Call original _Q62 method.
                XQ62()
            }
        }
        
        Name (KEYL, Zero) // Keyboard Backlight LED (Fn+Space)
        Method (_Q1F, 0, NotSerialized) // cycle keyboard backlight
        {
            If (OSDW ())
          	{
                KEYL = (KEYL + 1) % 3               
                Switch (KEYL)
                {
                    Case (Zero)
                    {
                        // Left Shift + F16.
                        Notify (KBD, 0x012a)
                        Notify (KBD, 0x0367)
                        Notify (KBD, 0x01aa)
                        
                        // Bright --> Off
                        \_SB.PCI0.LPCB.EC.HKEY.MLCS (Zero)
                    }
                    Case (One)
                    {
                        // Right Shift + F16.
                        Notify (KBD, 0x0136)
                        Notify (KBD, 0x0367)
                        Notify (KBD, 0x01b6)
                        
                        //  Off --> Dim
                        \_SB.PCI0.LPCB.EC.HKEY.MLCS (One)
                    }
                    Case (0x02)
                    {
                        // Left Shift + F19.
                        Notify (KBD, 0x012a)
                        Notify (KBD, 0x036a)
                        Notify (KBD, 0x01aa)
                        
                        //  Dim --> Bright
                        \_SB.PCI0.LPCB.EC.HKEY.MLCS (0x02)
                    }
                }
            }
            Else
            {
                // Call original _Q1F method.
                XQ1F()
            }
        }
        
    }
        
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