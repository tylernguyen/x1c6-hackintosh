/*
 * Fix USB Power
 * https://dortania.github.io/OpenCore-Post-Install/usb/misc/power.html
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_USBX", 0x00001000)
{
    External (DTGP, MethodObj) // 4 Arguments
    External (OSDW, MethodObj) // 0 Arguments

    Scope (\_SB)
    {
        Device (\_SB.USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package ()
                    {
                        // Values from genuine macbook14,1 with same USB-controller
                        "kUSBSleepPortCurrentLimit", 2100,
                        "kUSBWakePortCurrentLimit", 2100,
                        "kUSBSleepPowerSupply", 9600,
                        "kUSBWakePowerSupply", 9600,
                    }
                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }
}
