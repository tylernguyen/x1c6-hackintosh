// Depends on /patches/OpenCore Patches/ XHC1.plist
//
// Native ACPI-setup for the USB2/3-controller on x80-series Thinkpads
//
// This enables all ports to be as native as possible on OSX and only disables those devices which
// have definetly no drivers on OSX. It should be compatible with almost all thinkpad-configs.
//
// The opinion that things like cardreader, which might not be used, are adding to a significant
// power-draw is false - if one has a working USB-setup. Even if it does not hurt.
//
// This SSDT is developed with compatibility in mind and therefor all devices are enabled by default.
//
// I'm driving both of my thinkpads with ~0.7W pkg-power draw on idle with all devices enabled.
//
// Reference: https://www.intel.com/content/dam/www/public/us/en/documents/technical-specifications/extensible-host-controler-interface-usb-xhci.pdf
//
// Credits @benbender

DefinitionBlock ("", "SSDT", 2, "tyler", "_XHC1", 0x00001000)
{
    // External method from SSDT-UTILS.dsl
    External (OSDW, MethodObj) // 0 Arguments
    External (DTGP, MethodObj) // 5 Arguments

    External (_SB.PCI0.XHC_, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS01, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS02, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS03, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS04, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS05, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS06, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS07, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS08, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS09, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.HS10, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS03, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS04, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS05, DeviceObj)
    External (_SB.PCI0.XHC_.RHUB.SS06, DeviceObj)

    External (_SB.PCI0.XHC_.PDBM, FieldUnitObj)
    External (_SB.PCI0.XHC_.MEMB, FieldUnitObj)

    External (_SB.PCI0.XHC_.XPS0, MethodObj)
    External (_SB.PCI0.XHC_.XPS3, MethodObj)

    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2, DeviceObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2.MODU, MethodObj)    // 0 Arguments
    External (_SB.PCI0.RP09.UPN1, IntObj)
    External (_SB.PCI0.RP09.UPN2, IntObj)

    External (TBAS, IntObj)

    External (XLTP, FieldUnitObj)
    External (MPMC, FieldUnitObj)
    External (PMFS, FieldUnitObj)
    External (UWAB, FieldUnitObj)


    Scope (\_SB)
    {
        // kUSBPlatformProperties
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package ()
                    {
                        "kUSBSleepPortCurrentLimit", 
                        3000, 
                        "kUSBWakePortCurrentLimit", 
                        3000,
                        "kUSBSleepPowerSupply", 
                        9600, 
                        "kUSBWakePowerSupply", 
                        9600, 
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
 
        Scope (PCI0.XHC_)
        {
            // Name (SDPC, Zero)
            Name (_GPE, 0x6D)  // _GPE: General Purpose Events

            // Name (SBAR, Zero)
            // OperationRegion (XPRX, PCI_Config, Zero, 0x0100)
            // Field (XPRX, AnyAcc, NoLock, Preserve)
            // {
            //     DVIX,   16, 
            //     Offset (0x40), 
            //         ,   11, 
            //     SWAI,   1, 
            //     Offset (0x44), 
            //         ,   12, 
            //     SAIP,   2, 
            //     Offset (0x48), 
            //     Offset (0x50), 
            //         ,   2, 
            //     STGX,   1, 
            //     Offset (0x74), 
            //     D03X,   2, 
            //     Offset (0x75), 
            //     PXEE,   1, 
            //         ,   6, 
            //     PXES,   1, 
            //     Offset (0xA2), 
            //         ,   2, 
            //     D3HX,   1, 
            //     Offset (0xA8), 
            //         ,   13, 
            //     MW13,   1, 
            //     MW14,   1, 
            //     Offset (0xAC), 
            //     Offset (0xB0), 
            //         ,   13, 
            //     MB13,   1, 
            //     MB14,   1, 
            //     Offset (0xB4), 
            //     Offset (0xD0), 
            //     PR2,    32, 
            //     PR2M,   32, 
            //     PR3,    32, 
            //     PR3M,   32
            // }

            // kUSBTypeCCableDetectACPIMethodSupported
            Method (RTPC, 1, Serialized)
            {
                Debug = Concatenate ("XHC:RTPC called with args: ", Arg0)

                Return (Zero)
            }

            /**
             * kUSBTypeCCableDetectACPIMethod
             *
             * Return:
             *    kUSBTypeCCableTypeNone              = 0,
             *    kUSBTypeCCableTypeUSB               = 1,
             */
            Method (MODU, 0, Serialized)
            {
                // If (CondRefOf (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.MODU, Local0))
                // {
                //     Local0 = \_SB.PCI0.RP09.UPSB.DSB2.XHC2.MODU ()
                // }

                // Local1 = Zero

                // If ((Local0 == One) || (Local1 == One))
                // {
                //     Local0 = One
                // }
                // ElseIf ((Local0 == 0xFF) || (Local1 == 0xFF))
                // {
                //     Local0 = 0xFF
                // }
                // Else
                // {
                //     Local0 = Zero
                // }

                // Debug = Concatenate ("XHC:MODU - Result: ", Local0)

                // Return (Local0)

                Local0 = One

                If (CondRefOf (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.MODU))
                {
                    Local0 = (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.MODU ())
                }

                Debug = Concatenate ("XHC:MODU - Result: ", Local0)

                Return (Local0)
            }

            // Method (USBM, 0, Serialized)
            // {
            //     ^D03X = Zero
            //     Local1 = ^PDBM /* \_SB_.PCI0.XHC1.PDBM */
            //     Local2 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //     ^PDBM = (Local1 | 0x02)
            //     Local0 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //     Local0 &= 0xFFFFFFFFFFFFFFF0
            //     OperationRegion (PSCA, SystemMemory, Local0, 0x0600)
            //     Field (PSCA, DWordAcc, NoLock, Preserve)
            //     {
            //         Offset (0x480), 
            //         PC01,   32, 
            //         Offset (0x490), 
            //         PC02,   32, 
            //         Offset (0x4A0), 
            //         PC03,   32, 
            //         Offset (0x4B0), 
            //         PC04,   32
            //     }

            //     Local6 = PC03 /* \_SB_.PCI0.XHC1.USBM.PC03 */
            //     Local6 = (PC03 & 0xFFFFFFFFFFFFFFFD)
            //     PC03 = (Local6 & 0xFFFFFFFFFFFFFDFF)
            //     Sleep (0x32)
            //     Local6 = PC03 /* \_SB_.PCI0.XHC1.USBM.PC03 */
            //     ^PDBM &= 0xFFFFFFFFFFFFFFF9
            //     ^D03X = 0x03
            //     ^MEMB = Local2
            //     ^PDBM = Local1
            //     Return (Zero)
            // }

            // Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            // {
            //     If (OSDW ())
            //     {
            //         Local2 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //         Local1 = ^PDBM /* \_SB_.PCI0.XHC1.PDBM */
            //         ^PDBM &= 0xFFFFFFFFFFFFFFF9
            //         ^D03X = Zero

            //         If (SBAR == Zero)
            //         {
            //             Local7 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //             Local7 &= 0xFFFFFFFFFFFFFFF0

            //             If ((Local7 == Zero) || (Local7 == 0xFFFFFFFFFFFFFFF0))
            //             {
            //                 ^MEMB = 0xFEAF0000
            //             }
            //         }
            //         Else
            //         {
            //             ^MEMB = SBAR /* \_SB_.PCI0.XHC1.SBAR */
            //         }

            //         ^PDBM = (Local1 | 0x02)
            //         Local0 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //         Local0 &= 0xFFFFFFFFFFFFFFF0

            //         OperationRegion (MCA1, SystemMemory, Local0, 0x9000)
            //         Field (MCA1, DWordAcc, NoLock, Preserve)
            //         {
            //             Offset (0x80A4), 
            //                 ,   28, 
            //             AX28,   1, 
            //             Offset (0x80C0), 
            //                 ,   10, 
            //             S0IX,   1, 
            //             Offset (0x81C4), 
            //                 ,   2, 
            //             CLK0,   1, 
            //                 ,   3, 
            //             CLK1,   1
            //         }

            //         S0IX = Zero

            //         AX28 = One
            //         Stall (0x33)
            //         AX28 = Zero
            //         CLK0 = Zero
            //         CLK1 = Zero
            //         ^PDBM &= 0xFFFFFFFFFFFFFFFD
            //         ^MEMB = Local2
            //         ^PDBM = Local1

            //         If (UWAB && (D03X == Zero))
            //         {
            //             MPMC = One
            //             Local0 = (Timer + 0x00989680)
            //             While (Timer <= Local0)
            //             {
            //                 If (PMFS == Zero)
            //                 {
            //                     Break
            //                 }

            //                 Sleep (0x0A)
            //             }
            //         }
            //     }
            //     Else
            //     {
            //         // NON-OSX
            //         \_SB.PCI0.XHC_.XPS0 ()
            //     }
            // }

            // Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            // {
            //     If (OSDW ())
            //     {
            //         Local1 = ^PDBM /* \_SB_.PCI0.XHC1.PDBM */
            //         Local2 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //         ^PDBM &= 0xFFFFFFFFFFFFFFF9

            //         If (XLTP == Zero)
            //         {
            //             ^D03X = 0x03
            //             Stall (0x1E)
            //         }

            //         ^D03X = Zero
            //         ^PDBM = (Local1 | 0x02)
            //         SBAR = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //         If (SBAR == Zero)
            //         {
            //             Local7 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //             Local7 &= 0xFFFFFFFFFFFFFFF0

            //             If ((Local7 == Zero) || (Local7 == 0xFFFFFFFFFFFFFFF0))
            //             {
            //                 ^MEMB = 0xFEAF0000
            //             }
            //         }

            //         Local0 = ^MEMB /* \_SB_.PCI0.XHC1.MEMB */
            //         Local0 &= 0xFFFFFFFFFFFFFFF0

            //         OperationRegion (MCA1, SystemMemory, Local0, 0x9000)
            //         Field (MCA1, DWordAcc, NoLock, Preserve)
            //         {
            //             Offset (0x80A4), 
            //                 ,   28, 
            //             AX28,   1, 
            //             Offset (0x80C0), 
            //                 ,   10, 
            //             S0IX,   1, 
            //             Offset (0x81C4), 
            //                 ,   2, 
            //             CLK0,   1, 
            //                 ,   3, 
            //             CLK1,   1
            //         }

            //         If (XLTP == Zero)
            //         {
            //             S0IX = One
            //             Stall (0x14)
            //         }

            //         CLK0 = Zero
            //         CLK1 = One
            //         ^PDBM = Local1
            //         ^D03X = 0x03
            //         ^MEMB = Local2
            //         ^PDBM = Local1

            //         If (UWAB && (D03X == 0x03))
            //         {
            //             MPMC = 0x03
            //             Local0 = (Timer + 0x00989680)
            //             While (Timer <= Local0)
            //             {
            //                 If (PMFS == Zero)
            //                 {
            //                     Break
            //                 }

            //                 Sleep (0x0A)
            //             }
            //         }
            //     }
            //     Else
            //     {
            //         // NON-OSX
            //         \_SB.PCI0.XHC_.XPS3 ()
            //     }
            // }

            Scope (RHUB)
            {
                Scope (HS01) // Right USB-A-Port, 480 Mbit/s
                {
                    Name (_UPC, Package ()  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0x03, 
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS02) // Left USB-A-Port, 480 Mbit/s
                {
                    Name (_UPC, Package ()  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0x03, 
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS03) // Upper USB-C-Port, weired config, needs investigation
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        If (CondRefOf (\_SB_.PCI0.RP09.UPSB.DSB2.XHC2))
                        {
                            Debug = "XHC:U2OP - companion ports enabled"
                        }

                        If (\TBAS)
                        {
                            Local0 = Package (0x04) {
                                0xFF,
                                0x08,
                                Zero,
                                Zero
                            }
                        }
                        Else
                        {
                            Local0 = Package (0x04) {
                                One,
                                0x09,
                                Zero,
                                Zero
                            }
                        }

                        Return (Local0)
                    }

                    If (CondRefOf (\_SB_.PCI0.RP09.UPSB.DSB2.XHC2))
                    {
                        Name (SSP, Package (0x02)
                        {
                            "XHC2", 
                            0x03
                        })
                        Name (SS, Package (0x02)
                        {
                            "XHC2", 
                            0x03
                        })

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            Local0 = Package (0x01) {}

                            If (CondRefOf (\_SB.PCI0.RP09.UPN2))
                            {
                                Local0 = Package (0x02) {
                                    "UsbCPortNumber", 
                                    \_SB.PCI0.RP09.UPN1
                                }
                            }

                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }
                }

                Scope (HS04) // Lower USB-C-Port, weired config, needs investigation
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        If (\TBAS)
                        {
                            Local0 = Package (0x04) {
                                0xFF,
                                0x08,
                                Zero,
                                Zero
                            }
                        }
                        Else
                        {
                            Local0 = Package (0x04) {
                                One,
                                0x09,
                                Zero,
                                Zero
                            }
                        }

                        Return (Local0)
                    }

                    If (CondRefOf (\_SB_.PCI0.RP09.UPSB.DSB2.XHC2))
                    {
                        Name (SSP, Package (0x02)
                        {
                            "XHC2", 
                            0x04
                        })
                        Name (SS, Package (0x02)
                        {
                            "XHC2", 
                            0x04
                        })

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            Local0 = Package (0x01) {}

                            If (CondRefOf (\_SB.PCI0.RP09.UPN2))
                            {
                                Local0 = Package (0x02) {
                                    "UsbCPortNumber", 
                                    \_SB.PCI0.RP09.UPN2
                                }
                            }

                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }

                }

                Scope (HS05) // internal, ir-webcam, deactivated
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (OSDW ())
                        {
                            Return (Zero) // disabled on OSX
                        }

                        Return (0xF) // enabled on others
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS06) // internal, unused
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS07) // Bluetooth, internal
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS08) // Webcam, internal
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS09) // Fingerprint reader, internal, deactivated
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (OSDW ())
                        {
                            Return (Zero) // disabled on OSX
                        }

                        Return (0xF) // enabled on others
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (HS10) // Touchscreen, internal
                {
                    Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                    {
                        Return (Package (0x04) {
                            0xFF,
                            0xFF,
                            Zero, 
                            Zero
                        })
                    }

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS01) // Right USB-A-Port, 5 Gbit/s
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0x03, 
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS02) // Left USB-A-Port, 5 Gbit/s
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0x03, 
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS03) // Cardreader, internal
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0xFF,
                        Zero, 
                        Zero
                    })

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (0x00)
                    }

                    Name (IGNR, 0x00)

                    Method (SBHV, 1, Serialized)
                    {
                        If (Arg0)
                        {
                            Store (0x01, IGNR)
                        }
                        Else
                        {
                            Store (0x00, IGNR)
                        }
                    }

                    // kGetBehaviorACPIMethod
                    Method (GBHV, 0, Serialized)
                    {
                        Return (IGNR)
                    }

                    // kSDControllerCaptiveUSB3ReaderKey
                    Name (U3SD, 0x0FBE)

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x02) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS04) // Unused, internal
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0xFF,
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS05) // Unused, internal
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0xFF,
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Scope (SS06) // Unused, internal
                {
                    Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                    {
                        0xFF,
                        0xFF,
                        Zero, 
                        Zero
                    })

                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        Local0 = Package (0x01) {}
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }
            }

            // system support SuperDrive
            Method (MBSD, 0, NotSerialized)
            {
                Return (One)
            }

            If (CondRefOf (\_SB_.PCI0.RP09.UPSB.DSB2.XHC2))
            {
                Name (SSP, Package (0x01)
                {
                    "XHC2"
                })
                Name (SS, Package (0x01)
                {
                    "XHC2"
                })
            }
        }
    }
}