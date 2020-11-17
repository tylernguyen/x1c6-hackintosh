/*
 * Patches USB 3.1  
 * Partition and continuation of Thunderbolt 3 patch.
 * Depends on other TB-DSB* patches as well as /patches/OpenCore Patches/ Thunderbolt3.plist
 *
 * Credits @benbender
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_TBXHC2", 0x00003000)
{
    /* Support methods */
    External (DTGP, MethodObj)
    External (OSDW, MethodObj)                        // OS Is Darwin?

    External (_SB.PCI0.RP09.PXSX, DeviceObj)
    External (_SB.PCI0.RP09.PXSX.DSB0.NHI0, DeviceObj)

    External (_SB.PCI0.RP09.TBST, MethodObj) // 0 Arguments
    External (_SB.PCI0.RP09.UGIO, MethodObj) // 0 Arguments

    External (_SB.PCI0.RP09.GXCI, IntObj)

    External (_SB.PCI0.RP09.PXSX.MDUV, IntObj)
    External (_SB.PCI0.RP09.UPN1, IntObj)
    External (_SB.PCI0.RP09.UPN2, IntObj)

    External (_SB.PCI0.RP09.PXSX.DSB2, DeviceObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.PRSR, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.LACR, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.LTRN, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.LACT, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.IIP3, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.RUSB, FieldUnitObj)
    External (_SB.PCI0.RP09.PXSX.DSB2.PCIA, FieldUnitObj)

    External (TBSE, IntObj)
    External (TBTS, IntObj)
    External (USME, IntObj)

    If (((TBTS == One) && (TBSE == 0x09)))
    {
        Scope (\_SB.PCI0.RP09.PXSX.DSB2)
        {
            Device (XHC2)
            {
                Name (_ADR, Zero)  // _ADR: Address

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

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    Debug = "TB:DSB2:XHC2:_PS0"

                    Sleep (0xC8)

                    If (OSDW ())
                    {
                        PCED ()

                        If (CondRefOf (\_SB.PCI0.RP09.TBST))
                        {
                            \_SB.PCI0.RP09.TBST ()
                        }
                    }
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    Debug = "TB:DSB2:XHC2:_PS3"

                    Sleep (0xC8)

                    If (OSDW ())
                    {
                        If (CondRefOf (\_SB.PCI0.RP09.TBST))
                        {
                            \_SB.PCI0.RP09.TBST ()
                        }
                    }
                }

                Method (_STA, 0, NotSerialized)
                {
                    If (OSDW ())
                    {
                        Return (0x0F) // Used in OSX
                    }

                    Return (0x0F) // hidden for others
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
                            Zero,
                        }

                    If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && \USME == One)
                    {
                        // Enable companion-setup
                        Local0[0x05] = One
                    }

                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }

                If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && \USME == One)
                {
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
                }

                // Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                // {
                //     Return (Package ()
                //     {
                //         0x6D, 
                //         0x03
                //     })
                // }

                /**
                * PCI Enable downstream
                */
                Method (PCED, 0, Serialized)
                {
                    Debug = "TB:DSB2:XHC2:PCED"
                    Debug = "TB:DSB2:XHC2:PCED - Request USB-GPIO to be enabled & force TBT-GPIO"
                    \_SB.PCI0.RP09.GXCI = One

                    // this powers up both TBT and USB when needed
                    If (\_SB.PCI0.RP09.UGIO () != Zero)
                    {
                        Debug = "TB:DSB2:XHC2:PCED - GPIOs changed, restored = true"
                        ^^PRSR = One
                    }

                    Local5 = (Timer + 0x00989680)

                    Debug = Concatenate ("TB:DSB2:XHC2:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR: ", ^^PRSR)

                    If (^^PRSR != Zero)
                    {
                        Debug = "TB:DSB2:XHC2:PCED - Wait for power up"
                        Debug = "TB:DSB2:XHC2:PCED - Wait for downstream bridge to appear"
                        Local5 = (Timer + 0x00989680)
                        While (Timer <= Local5)
                        {
                            Debug = "TB:DSB2:XHC2:PCED - Wait for link training..."
                            If (^^LACR == Zero)
                            {
                                If (^^LTRN != One)
                                {
                                    Debug = "TB:DSB2:XHC2:PCED - Link training cleared"
                                    Break
                                }
                            }
                            ElseIf ((^^LTRN != One) && (^^LACT == One))
                            {
                                Debug = "TB:DSB2:XHC2:PCED - Link training cleared and link is active"
                                Break
                            }

                            Sleep (0x0A)
                        }

                        Sleep (0x96)
                    }

                    ^^PRSR = Zero
                    While (Timer <= Local5)
                    {
                        Debug = "TB:DSB2:XHC2:PCED - Wait for config space..."
                        If (AVND != 0xFFFFFFFF)
                        {
                            Debug = "TB:DSB2:XHC2:PCED - DSB2 Up - Read VID/DID"
                            ^^PCIA = One
                            Break
                        }

                        Sleep (0x0A)
                    }

                    ^^IIP3 = Zero
                }

                /**
                * Run Time Power Check
                * Called by XHC driver when idle
                */
                Method (RTPC, 1, Serialized)
                {
                    Debug = Concatenate ("TB:DSB2:XHC2:RTPC called with Arg0: ", Arg0)

                    // If (Arg0 <= One)
                    // {
                    Debug = Concatenate ("TB:DSB2:XHC2:RTPC setting RUSB to: ", Arg0)

                    ^^RUSB = Arg0

                    //     // Force TB on 
                    //     If (Arg0 == One)
                    //     {
                    //         Debug = Concatenate ("TB:NHI0:RTPC forcing RTBT to: ", Arg0)
                    //         \_SB.PCI0.RP09.RTBT = One
                    //     }
                    // }

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
                    If (CondRefOf (\_SB.PCI0.RP09.PXSX.MDUV))
                    {
                        Debug = Concatenate ("TB:DSB2:XHC2:MODU - MDUV - return: ", \_SB.PCI0.RP09.PXSX.MDUV)

                        Return (\_SB.PCI0.RP09.PXSX.MDUV)
                    }
                    Else
                    {
                        // WORKING W/O PM
                        Debug = Concatenate ("TB:DSB2:XHC2:MODU - return: ", ^^RUSB)

                        Return (^^RUSB)
                    }
                    
                    // Debug = "TB:DSB2:XHC2:MODU - force ONE"
                    
                    // Return (One)
                }

                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address

                    If ((USME == Zero))
                    {
                        Device (HS01)
                        {
                            Name (_ADR, One)  // _ADR: Address

                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                Return (Package (0x04)  // _UPC: USB Port Capabilities
                                {
                                    One, 
                                    0x08, 
                                    Zero, 
                                    Zero
                                })
                            }
                        }

                        Device (HS02)
                        {
                            Name (_ADR, 0x02)  // _ADR: Address

                            Return (Package (0x04)  // _UPC: USB Port Capabilities
                                {
                                    One, 
                                    0x08, 
                                    Zero, 
                                    Zero
                                })
                        }
                    }

                    Device (SS01)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address

                        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                        {
                            Local0 = Package (0x04)  // _UPC: USB Port Capabilities
                                {
                                    One, 
                                    0x09, 
                                    Zero, 
                                    Zero
                                }

                            If ((USME == Zero))
                            {
                                Local0[0x01] = 0x0A
                            }

                            Return (Local0)
                        }

                        If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && \USME == One)
                        {
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
                        }

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && CondRefOf (\_SB.PCI0.RP09.UPN1) && \USME == One)
                            {
                                Local0 = Package ()
                                    {
                                        "UsbCPortNumber", 
                                        \_SB.PCI0.RP09.UPN1,
                                        "UsbCompanionPortPresent", 
                                        One
                                    }
                            }
                            Else
                            {
                                Local0 = Package (0x01) {}
                            }

                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }

                    Device (SS02)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address

                        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                        {
                            Local0 = Package (0x04)  // _UPC: USB Port Capabilities
                                {
                                    One, 
                                    0x09, 
                                    Zero, 
                                    Zero
                                }

                            If ((USME == Zero))
                            {
                                Local0[0x01] = 0x0A
                            }

                            Return (Local0)
                        }

                        If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && \USME == One)
                        {
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
                        }

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If (CondRefOf (\_SB.PCI0.RP09.PXSX.DSB0.NHI0) && CondRefOf (\_SB.PCI0.RP09.UPN2) && \USME == One)
                            {
                                Local0 = Package ()
                                    {
                                        "UsbCPortNumber", 
                                        \_SB.PCI0.RP09.UPN2,
                                        "UsbCompanionPortPresent", 
                                        One
                                    }
                            }
                            Else
                            {
                                Local0 = Package (0x01) {}
                            }

                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }
                }
            }
        }
    }
}

