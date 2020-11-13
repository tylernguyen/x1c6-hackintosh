//
// USB-C 3.1 Gen2-controller
//
// The controller is part of the alpine ridge Thunderbolt-controller.
//
// At the moment there is no known way to have - or at least I haven't found it yet -
// to have native Thunderbolt incl. power-management and USB-C 3.1 Gen2-hotplug at the
// same time. For the moment I opted for thunderbolt and the runtime power saving.
//
// So sadly, this is broken on runtime for the moment :(
//
// Credits @benbender

DefinitionBlock ("", "SSDT", 2, "tyler", "_XHC2", 0x00001000)
{
    /* Support methods */
    External (DTGP, MethodObj)
    External (OSDW, MethodObj)                        // OS Is Darwin?

    External (_SB.PCI0.RP09.RUSB, IntObj)
    External (_SB.PCI0.RP09.RTBT, IntObj)
    External (_SB.PCI0.RP09.GXCI, IntObj)
    External (_SB.PCI0.RP09.GNHI, IntObj)
    External (_SB.PCI0.RP09.UGIO, MethodObj)
    External (_SB.PCI0.RP09.TBST, MethodObj)
    External (_SB.PCI0.RP09.UPSB.DSB2, DeviceObj)
    External (_SB.PCI0.RP09.UPSB.PCED, MethodObj)
    External (_SB.PCI0.RP09.UPSB.MDUV, IntObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.PCIA, FieldUnitObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.IIP3, FieldUnitObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.PRSR, FieldUnitObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.LACR, FieldUnitObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.LACT, FieldUnitObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.LTRN, FieldUnitObj)

    External (_SB.PCI0.RP09.UPN1, IntObj)
    External (_SB.PCI0.RP09.UPN2, IntObj)

    External (TBSE, IntObj)
    External (TBTS, IntObj)
    External (TBAS, IntObj)
    External (USME, IntObj)

    Name (U2OP, One) // Companion controller present?

    Scope (_SB.PCI0.RP09.UPSB.DSB2)
    {
        Device (XHC2)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (SDPC, Zero)

            OperationRegion (A1E0, PCI_Config, Zero, 0x40)
            Field (A1E0, ByteAcc, NoLock, Preserve)
            {
                AVND,   32, 
                BMIE,   3, 
                Offset (0x18), 
                PRIB,   8, 
                SECB,   8, 
                SUBB,   8, 
                Offset (0x1E), 
                    ,   13, 
                MABT,   1
            }

            /**
            * PCI Enable downstream
            */
            Method (PCED, 0, Serialized)
            {
                Debug = "TB:DSB2:XHC2:PCED"
                Debug = "TB:DSB2:XHC2:PCED - Request USB-GPIO to be enabled & force TBT-GPIO"
                \_SB.PCI0.RP09.GXCI = One
                \_SB.PCI0.RP09.GNHI = One

                // this powers up both TBT and USB when needed
                If (\_SB.PCI0.RP09.UGIO () != Zero)
                {
                    Debug = "TB:DSB2:XHC2:PCED - GPIOs changed, restored = true"
                    \_SB.PCI0.RP09.UPSB.DSB2.PRSR = One
                }

                // Local0 = Zero
                // Local1 = Zero
                Local5 = (Timer + 0x00989680)

                Debug = Concatenate ("TB:DSB2:XHC2:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR: ", \_SB.PCI0.RP09.UPSB.DSB2.PRSR)

                If (\_SB.PCI0.RP09.UPSB.DSB2.PRSR != Zero)
                {
                    Debug = "TB:DSB2:XHC2:PCED - Wait for power up"
                    Debug = "TB:DSB2:XHC2:PCED - Wait for downstream bridge to appear"
                    Local5 = (Timer + 0x00989680)
                    While (Timer <= Local5)
                    {
                        Debug = "TB:DSB2:XHC2:PCED - Wait for link training..."
                        If (\_SB.PCI0.RP09.UPSB.DSB2.LACR == Zero)
                        {
                            If (\_SB.PCI0.RP09.UPSB.DSB2.LTRN != One)
                            {
                                Debug = "TB:DSB2:XHC2:PCED - Link training cleared"
                                Break
                            }
                        }
                        ElseIf ((\_SB.PCI0.RP09.UPSB.DSB2.LTRN != One) && (\_SB.PCI0.RP09.UPSB.DSB2.LACT == One))
                        {
                            Debug = "TB:DSB2:XHC2:PCED - Link training cleared and link is active"
                            Break
                        }

                        Sleep (0x0A)
                    }

                    Sleep (0x96)
                }

                \_SB.PCI0.RP09.UPSB.DSB2.PRSR = Zero
                While (Timer <= Local5)
                {
                    Debug = "TB:DSB2:XHC2:PCED - Wait for config space..."
                    If (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND != 0xFFFFFFFF)
                    {
                        Debug = "TB:DSB2:XHC2:PCED - DSB2 Up - Read VID/DID"
                        \_SB.PCI0.RP09.UPSB.DSB2.PCIA = One
                        Break
                    }

                    Sleep (0x0A)
                }

                \_SB.PCI0.RP09.UPSB.DSB2.IIP3 = Zero
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package (0x06)
                    {
                        "USBBusNumber", 
                        Zero, 
                        "AAPL,xhci-clock-id", 
                        One, 
                        "UsbCompanionControllerPresent", 
                        One
                    }

                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }

            Name (HS, Package (0x01)
            {
                "XHC"
            })

            Name (FS, Package (0x01)
            {
                "XHC"
            })

            Name (LS, Package (0x01)
            {
                "XHC"
            })

            Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
            {
                Return (Package ()
                {
                    0x6D, 
                    0x03
                })
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                Debug = "TB:DSB2:XHC2:_PS0"

                If (OSDW ())
                {
                    PCED ()

                    \_SB.PCI0.RP09.TBST ()
                }
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                Debug = "TB:DSB2:XHC2:_PS3"

                If (OSDW ())
                {
                    \_SB.PCI0.RP09.TBST ()
                }
            }

            /**
            * Run Time Power Check
            * Called by XHC driver when idle
            */
            Method (RTPC, 1, Serialized)
            {
                Debug = Concatenate ("TB:DSB2:XHC2:RTPC called with Arg0: ", Arg0)

                If (Arg0 <= One)
                {
                    Debug = Concatenate ("TB:NHI0:RTPC setting RUSB to: ", Arg0)

                    \_SB.PCI0.RP09.RUSB = Arg0

                    // Force TB on 
                    If (Arg0 == One)
                    {
                        Debug = Concatenate ("TB:NHI0:RTPC forcing RTBT to: ", Arg0)
                        \_SB.PCI0.RP09.RTBT = One
                    }
                }

                Return (Zero)
            }

            /**
            * USB cable check
            * Called by XHC driver to check cable status
            * Used as idle hint.
            *
            * Return:
            *    kUSBTypeCCableTypeNone              = 0,
            *    kUSBTypeCCableTypeUSB               = 1,
            */
            Method (MODU, 0, Serialized)
            {
                Debug = Concatenate ("TB:DSB2:XHC2:MODU - return: ", \_SB.PCI0.RP09.UPSB.MDUV)

                Return (\_SB.PCI0.RP09.UPSB.MDUV)
            }

            Device (RHUB)
            {
                Name (_ADR, Zero)  // _ADR: Address

                Device (SSP1)
                {
                    Name (_ADR, 0x03)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF, 
                        0x09, 
                        Zero, 
                        Zero
                    })

                    Name (HS, Package ()
                    {
                        "XHC", 
                        0x03
                    })

                    Name (FS, Package ()
                    {
                        "XHC", 
                        0x03
                    })

                    Name (LS, Package ()
                    {
                        "XHC", 
                        0x03
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package ()
                            {
                                "UsbCPortNumber", 
                                \_SB.PCI0.RP09.UPN1,
                                "UsbCompanionPortPresent", 
                                One
                            }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Device (SSP2)
                {
                    Name (_ADR, 0x04)  // _ADR: Address
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF, 
                        0x09, 
                        Zero, 
                        Zero
                    })

                    Name (HS, Package ()
                    {
                        "XHC", 
                        0x04
                    })

                    Name (FS, Package ()
                    {
                        "XHC", 
                        0x04
                    })

                    Name (LS, Package ()
                    {
                        "XHC", 
                        0x04
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package ()
                            {
                                "UsbCPortNumber", 
                                \_SB.PCI0.RP09.UPN2,
                                "UsbCompanionPortPresent", 
                                One
                            }

                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }
        }
    }

}