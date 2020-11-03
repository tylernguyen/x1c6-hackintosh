// Add PMCR

DefinitionBlock ("", "SSDT", 2, "tyler", "_PMCR", 0)
{
    External (OSDW, MethodObj)
    External(_SB.PCI0.LPCB, DeviceObj)
    
    Scope (_SB.PCI0.LPCB)
    {
        Device (PMCR)
        {
            // Name (_ADR, 0x001F0002)  // _ADR: Address
            Name (_HID, EisaId ("APP9876"))
            Name (_CRS, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0xFE000000,
                    0x00010000 
                    )

            })
            Method (_STA, 0, NotSerialized)
            {
                If (OSDW ())
                {
                    Return (0x0B)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}