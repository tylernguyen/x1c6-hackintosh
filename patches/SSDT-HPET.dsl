//
// Supplementary HPET _CRS from Goldfish64
// Requires the HPET's _CRS to XCRS rename
//
DefinitionBlock ("", "SSDT", 2, "tyler", "HPET", 0x00000000)
{
    External (_SB.PCI0.LPCB.HPET, DeviceObj)    // (from opcode)
    
    Name (\_SB.PCI0.LPCB.HPET._CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
    {
        IRQNoFlags()
            {0}
        IRQNoFlags()
            {8}
        IRQNoFlags()
            {11}
        Memory32Fixed (ReadWrite,
            0xFED00000,         // Address Base
            0x00000400,         // Address Length
            )
    })
}
