DefinitionBlock("", "SSDT", 2, "tyler", "x1input", 0)
{
    External(_SB.PCI0.LPCB.KBD, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.XQ6A, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ15, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ14, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ16, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ64, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ66, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ60, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ61, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ62, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ1F, MethodObj)
    External(_SB.PCI0.LPCB.EC.HKEY.MMTS, MethodObj)
    External(_SB.PCI0.LPCB.EC.HKEY.MMTG, MethodObj)
    External(_SB.PCI0.LPCB.EC.HKEY.MLCS, MethodObj)
    
    Scope (_SB.PCI0.LPCB.EC)
    {
        Name (LED1, Zero)
        // _Q6A - Microphone Mute
        Method (_Q6A, 0, NotSerialized) // F4 - Microphone Mute = F20
        {
            If (_OSI ("Darwin"))
          	{
                // Toggle Mute Microphone LED
                If ((LED1 == Zero))
                {
                    // Right Shift + F20
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01b6)

                    // 0x02 = Enable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (0x02)
                    LED1 = One
                }
                Else
                {
                    // Left Shift + F20
                    Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x036B)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)

                    // 0x00 = Disable LED
                    \_SB.PCI0.LPCB.EC.HKEY.MMTS (Zero)
                    LED1 = Zero
                }
          	}
          	Else
          	{
                // Call original _Q6A method.
                \_SB.PCI0.LPCB.EC.XQ6A()
          	}
        }
        
        Method (_Q15, 0, NotSerialized) // F5 - Brightness Down = F14
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0405)
                Notify(\_SB.PCI0.LPCB.KBD, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ15()
            }
        }

        Method (_Q14, 0, NotSerialized) // F6 - Brightness Up = F15
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0406)
                Notify(\_SB.PCI0.LPCB.KBD, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ14()
            }
        }
        
        Method (_Q16, 0, NotSerialized) // F7 - Dual Display = F16
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0367)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ16()
            }
        }
        
        Method (_Q64, 0, NotSerialized) // F8 - Network = F17
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0368)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ64()
            }
        }
        
        Method (_Q66, 0, NotSerialized) // F9 - Settings = F18
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0369)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ66()
            }
        }
        
        Method (_Q60, 0, NotSerialized) // F10 - Bluetooth
        {

            If (_OSI ("Darwin"))
            {
                // Left Shift + F17
                Notify (\_SB.PCI0.LPCB.KBD, 0x012A)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0368)
                Notify (\_SB.PCI0.LPCB.KBD, 0x01AA)
            }
            Else
            {
                // Call original _Q60 method.
                \_SB.PCI0.LPCB.EC.XQ60()
            }
        }
        
        Method (_Q61, 0, NotSerialized) // F11 - Keyboard
        {
            If (_OSI ("Darwin"))
            {
                // Send a down event for the Control key (scancode 1d), then a one-shot event (down then up) for
                // the up arrow key (scancode 0e 48), and finally an up event for the Control key (break scancode 9d).
                // This is picked up by VoodooPS2 and sent to macOS as the Control+Up key combo.
                Notify (\_SB.PCI0.LPCB.KBD, 0x011D)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0448)
                Notify (\_SB.PCI0.LPCB.KBD, 0x019D)
            }
            Else
            {
                // Call original _Q61 method.
                \_SB.PCI0.LPCB.EC.XQ61()
            }
        }
        
        Method (_Q62, 0, NotSerialized) // F12 - Star = F19
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x036A)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ62()
            }
        }
        
        Name (LED2, Zero)
        
        // _Q1F - (Fn+Space) Toggle Keyboard Backlight.
        Method (_Q1F, 0, NotSerialized) // cycle keyboard backlight
        {
            If (_OSI ("Darwin"))
          	{
                // Cycle keyboard backlight states
                If ((LED2 == Zero))
                {
                    // Right Shift + F16.
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0136)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x0367)
                    Notify (\_SB.PCI0.LPCB.KBD, 0x01b6)
                    //  Off to dim
                    \_SB.PCI0.LPCB.EC.HKEY.MLCS (One)
                    LED2 = One
                }
                Else
                {
                    If ((LED2 == One))
                    {
                        // Left Shift + F19.
                        Notify (\_SB.PCI0.LPCB.KBD, 0x012a)
                        Notify (\_SB.PCI0.LPCB.KBD, 0x036a)
                        Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)
                        //  dim to bright
                        \_SB.PCI0.LPCB.EC.HKEY.MLCS (0x02)
                        LED2 = 2
                    }
                    Else
                    {
                        If ((LED2 == 2))
                        {
                            // Left Shift + F16.
                            Notify (\_SB.PCI0.LPCB.KBD, 0x012a)
                            Notify (\_SB.PCI0.LPCB.KBD, 0x0367)
                            Notify (\_SB.PCI0.LPCB.KBD, 0x01aa)
                            // bright to off
                            \_SB.PCI0.LPCB.EC.HKEY.MLCS (Zero)
                            LED2 = Zero
                        }
          	            Else
          	            {
                            // Call original _Q6A method.
                            \_SB.PCI0.LPCB.EC.XQ1F ()
          	            }
                    }
                }
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