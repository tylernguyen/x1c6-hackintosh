// Add PMCR

DefinitionBlock ("", "SSDT", 2, "tyler", "_PMCR", 0)
{
    External (OSDW, MethodObj)
    External (_SB.PCI0.LPCB, DeviceObj)
    
    Scope (_SB.PCI0.LPCB)
    {
        Device (PMCR)
        {
            Name (_ADR, 0x001F0002)  // _ADR: Address

            Method (_STA, 0, NotSerialized)
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