/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-7-TbtTypeC.aml, Mon Dec 16 16:10:19 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000590 (1424)
 *     Revision         0x02
 *     Checksum         0x32
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "TbtTypeC"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "TbtTypeC", 0x00000000)
{
    External (_SB_.PCI0.RP01.PXSX, DeviceObj)
    External (_SB_.PCI0.RP09.PXSX, DeviceObj)
    External (TBSE, IntObj)
    External (TBTS, IntObj)
    External (UPT1, IntObj)
    External (UPT2, IntObj)
    External (USME, IntObj)

    If (LAnd (LEqual (TBTS, One), LEqual (TBSE, One)))
    {
        Scope (\_SB.PCI0.RP01.PXSX)
        {
            Name (TUSB, Package (0x02)
            {
                One, 
                0x04
            })
            Device (TBDU)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                Device (XHC)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        Sleep (0xC8)
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        Sleep (0xC8)
                    }

                    Device (RHUB)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (TPLD, 2, Serialized)
                        {
                            Name (PCKG, Package (0x01)
                            {
                                Buffer (0x10){}
                            })
                            CreateField (DerefOf (Index (PCKG, Zero)), Zero, 0x07, REV)
                            Store (One, REV) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.REV_ */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x40, One, VISI)
                            Store (Arg0, VISI) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.VISI */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x57, 0x08, GPOS)
                            Store (Arg1, GPOS) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.GPOS */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x4A, 0x04, SHAP)
                            Store (One, SHAP) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.SHAP */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x20, 0x10, WID)
                            Store (0x08, WID) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.WID_ */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x30, 0x10, HGT)
                            Store (0x03, HGT) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.HGT_ */
                            Return (PCKG) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TPLD.PCKG */
                        }

                        Method (TUPC, 2, Serialized)
                        {
                            Name (PCKG, Package (0x04)
                            {
                                One, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Store (Arg0, Index (PCKG, Zero))
                            Store (Arg1, Index (PCKG, One))
                            Return (PCKG) /* \_SB_.PCI0.RP01.PXSX.TBDU.XHC_.RHUB.TUPC.PCKG */
                        }

                        Device (HS01)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x08))
                                }
                                Else
                                {
                                    Return (TUPC (Zero, Zero))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, One))
                                }
                                Else
                                {
                                    Return (TPLD (Zero, Zero))
                                }
                            }
                        }

                        Device (HS02)
                        {
                            Name (_ADR, 0x02)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x08))
                                }
                                Else
                                {
                                    Return (TUPC (Zero, Zero))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, 0x02))
                                }
                                Else
                                {
                                    Return (TPLD (Zero, Zero))
                                }
                            }
                        }

                        Device (SS01)
                        {
                            Name (_ADR, 0x03)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x09))
                                }
                                Else
                                {
                                    Return (TUPC (One, 0x0A))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, One))
                                }
                                Else
                                {
                                    Return (TPLD (One, UPT1))
                                }
                            }
                        }

                        Device (SS02)
                        {
                            Name (_ADR, 0x04)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x09))
                                }
                                Else
                                {
                                    Return (TUPC (One, 0x0A))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, 0x02))
                                }
                                Else
                                {
                                    Return (TPLD (One, UPT2))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    If (LAnd (LEqual (TBTS, One), LEqual (TBSE, 0x09)))
    {
        Scope (\_SB.PCI0.RP09.PXSX)
        {
            Name (TUSB, Package (0x02)
            {
                0x03, 
                0x04
            })
            Device (TBDU)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                Device (XHC)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        Sleep (0xC8)
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        Sleep (0xC8)
                    }

                    Device (RHUB)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (TPLD, 2, Serialized)
                        {
                            Name (PCKG, Package (0x01)
                            {
                                Buffer (0x10){}
                            })
                            CreateField (DerefOf (Index (PCKG, Zero)), Zero, 0x07, REV)
                            Store (One, REV) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.REV_ */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x40, One, VISI)
                            Store (Arg0, VISI) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.VISI */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x57, 0x08, GPOS)
                            Store (Arg1, GPOS) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.GPOS */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x4A, 0x04, SHAP)
                            Store (One, SHAP) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.SHAP */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x20, 0x10, WID)
                            Store (0x08, WID) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.WID_ */
                            CreateField (DerefOf (Index (PCKG, Zero)), 0x30, 0x10, HGT)
                            Store (0x03, HGT) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.HGT_ */
                            Return (PCKG) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD.PCKG */
                        }

                        Method (TUPC, 2, Serialized)
                        {
                            Name (PCKG, Package (0x04)
                            {
                                One, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Store (Arg0, Index (PCKG, Zero))
                            Store (Arg1, Index (PCKG, One))
                            Return (PCKG) /* \_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TUPC.PCKG */
                        }

                        Device (HS01)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x08))
                                }
                                Else
                                {
                                    Return (TUPC (Zero, Zero))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, One))
                                }
                                Else
                                {
                                    Return (TPLD (Zero, Zero))
                                }
                            }
                        }

                        Device (HS02)
                        {
                            Name (_ADR, 0x02)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x08))
                                }
                                Else
                                {
                                    Return (TUPC (Zero, Zero))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, 0x02))
                                }
                                Else
                                {
                                    Return (TPLD (Zero, Zero))
                                }
                            }
                        }

                        Device (SS01)
                        {
                            Name (_ADR, 0x03)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x09))
                                }
                                Else
                                {
                                    Return (TUPC (One, 0x0A))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, One))
                                }
                                Else
                                {
                                    Return (TPLD (One, UPT1))
                                }
                            }
                        }

                        Device (SS02)
                        {
                            Name (_ADR, 0x04)  // _ADR: Address
                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TUPC (One, 0x09))
                                }
                                Else
                                {
                                    Return (TUPC (One, 0x0A))
                                }
                            }

                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                            {
                                If (LEqual (USME, Zero))
                                {
                                    Return (TPLD (One, 0x02))
                                }
                                Else
                                {
                                    Return (TPLD (One, UPT2))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

