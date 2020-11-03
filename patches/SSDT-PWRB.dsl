//Add PWRB

DefinitionBlock("", "SSDT", 2, "tyler", "_PWRB", 0)
{
    External (OSDW, MethodObj)

    //search PNP0C0C
    Scope (\_SB)
    {
        // Adds ACPI power-button-device
        // https://github.com/daliansky/OC-little/blob/master/06-%E6%B7%BB%E5%8A%A0%E7%BC%BA%E5%A4%B1%E7%9A%84%E9%83%A8%E4%BB%B6/SSDT-PWRB.dsl
        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Return (Zero)
            }

            Method (_STA, 0, NotSerialized)
            {
                If (OSDW())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }
}
//EOF