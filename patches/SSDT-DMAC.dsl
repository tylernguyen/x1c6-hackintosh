// Fix up memory controller

DefinitionBlock ("", "SSDT", 2, "tyler", "_DMAC", 0x00001000)
{
    External (OSDW, MethodObj) // 0 Arguments
    External (_SB.PCI0.LPCB, DeviceObj)

    // https://github.com/daliansky/OC-little/blob/master/06-%E6%B7%BB%E5%8A%A0%E7%BC%BA%E5%A4%B1%E7%9A%84%E9%83%A8%E4%BB%B6/SSDT-DMAC.dsl
    Scope (_SB.PCI0.LPCB)
    {
        // https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro14%2C1/ACPI%20Tables/DSL/DSDT.dsl#L5044
        // https://github.com/coreboot/coreboot/blob/master/src/soc/intel/common/block/acpi/acpi/lpc.asl
	    /* DMA Controller */
        Device (DMAC)
        {
            Name (_HID, EISAID("PNP0200"))

            Name (_CRS, ResourceTemplate()
            {
                IO (Decode16, 0x00, 0x00, 0x01, 0x20)
                IO (Decode16, 0x81, 0x81, 0x01, 0x11)
                IO (Decode16, 0x93, 0x93, 0x01, 0x0d)
                IO (Decode16, 0xc0, 0xc0, 0x01, 0x20)
                DMA (Compatibility, NotBusMaster, Transfer8_16) { 4 }
            })

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
