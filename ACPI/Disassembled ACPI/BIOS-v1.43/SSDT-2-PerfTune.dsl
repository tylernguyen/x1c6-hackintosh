/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-2-PerfTune.aml, Mon Dec 16 16:10:19 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000005C6 (1478)
 *     Revision         0x02
 *     Checksum         0x9F
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "PerfTune"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "PerfTune", 0x00001000)
{
    External (_SB_.PCI0.LPCB.H_EC.CFSP, UnknownObj)
    External (_SB_.PCI0.LPCB.H_EC.DIM0, UnknownObj)
    External (_SB_.PCI0.LPCB.H_EC.DIM1, UnknownObj)
    External (_SB_.PCI0.LPCB.H_EC.ECRD, MethodObj)    // 1 Arguments
    External (_TZ_.TZ01._TMP, MethodObj)    // 0 Arguments
    External (ADBG, MethodObj)    // 1 Arguments
    External (DDRF, UnknownObj)
    External (ECON, IntObj)
    External (TSOD, IntObj)
    External (XMPB, UnknownObj)
    External (XSMI, UnknownObj)
    External (XTUB, UnknownObj)
    External (XTUS, UnknownObj)

    Scope (\_SB)
    {
        Device (PTMD)
        {
            Name (_HID, EisaId ("INT3394") /* ACPI System Fan */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _CID: Compatible ID
            Name (IVER, 0x00010000)
            Name (SIZE, 0x055C)
            Method (GACI, 0, NotSerialized)
            {
                Name (RPKG, Package (0x02){})
                Store (Zero, Index (RPKG, Zero))
                If (LNotEqual (XTUB, Zero))
                {
                    ADBG ("XTUB")
                    ADBG (XTUB)
                    ADBG ("XTUS")
                    ADBG (XTUS)
                    OperationRegion (XNVS, SystemMemory, XTUB, SIZE)
                    Field (XNVS, ByteAcc, NoLock, Preserve)
                    {
                        XBUF,   10976
                    }

                    Name (TEMP, Buffer (XTUS){})
                    Store (XBUF, TEMP) /* \_SB_.PTMD.GACI.TEMP */
                    Store (TEMP, Index (RPKG, One))
                }
                Else
                {
                    ADBG ("XTUB ZERO")
                    Store (Zero, Index (RPKG, One))
                }

                Return (RPKG) /* \_SB_.PTMD.GACI.RPKG */
            }

            Method (GDSV, 1, Serialized)
            {
                If (LEqual (Arg0, 0x05))
                {
                    Return (Package (0x02)
                    {
                        Zero, 
                        Buffer (0x68)
                        {
                            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0008 */  0x01, 0x00, 0x00, 0x00, 0x4C, 0x04, 0x00, 0x00,  // ....L...
                            /* 0010 */  0x02, 0x00, 0x00, 0x00, 0x7E, 0x04, 0x00, 0x00,  // ....~...
                            /* 0018 */  0x03, 0x00, 0x00, 0x00, 0xB0, 0x04, 0x00, 0x00,  // ........
                            /* 0020 */  0x04, 0x00, 0x00, 0x00, 0xE2, 0x04, 0x00, 0x00,  // ........
                            /* 0028 */  0x05, 0x00, 0x00, 0x00, 0x14, 0x05, 0x00, 0x00,  // ........
                            /* 0030 */  0x06, 0x00, 0x00, 0x00, 0x46, 0x05, 0x00, 0x00,  // ....F...
                            /* 0038 */  0x07, 0x00, 0x00, 0x00, 0x78, 0x05, 0x00, 0x00,  // ....x...
                            /* 0040 */  0x08, 0x00, 0x00, 0x00, 0xAA, 0x05, 0x00, 0x00,  // ........
                            /* 0048 */  0x09, 0x00, 0x00, 0x00, 0xDC, 0x05, 0x00, 0x00,  // ........
                            /* 0050 */  0x0A, 0x00, 0x00, 0x00, 0x0E, 0x06, 0x00, 0x00,  // ........
                            /* 0058 */  0x0B, 0x00, 0x00, 0x00, 0x40, 0x06, 0x00, 0x00,  // ....@...
                            /* 0060 */  0x0C, 0x00, 0x00, 0x00, 0x72, 0x06, 0x00, 0x00   // ....r...
                        }
                    })
                }

                If (LEqual (Arg0, 0x13))
                {
                    ADBG ("DDR MULT")
                    If (LEqual (DDRF, One))
                    {
                        ADBG ("DDR 1")
                        Return (Package (0x02)
                        {
                            Zero, 
                            Buffer (0x50)
                            {
                                /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                                /* 0008 */  0x04, 0x00, 0x00, 0x00, 0x2B, 0x04, 0x00, 0x00,  // ....+...
                                /* 0010 */  0x05, 0x00, 0x00, 0x00, 0x35, 0x05, 0x00, 0x00,  // ....5...
                                /* 0018 */  0x06, 0x00, 0x00, 0x00, 0x40, 0x06, 0x00, 0x00,  // ....@...
                                /* 0020 */  0x07, 0x00, 0x00, 0x00, 0x4B, 0x07, 0x00, 0x00,  // ....K...
                                /* 0028 */  0x08, 0x00, 0x00, 0x00, 0x55, 0x08, 0x00, 0x00,  // ....U...
                                /* 0030 */  0x09, 0x00, 0x00, 0x00, 0x60, 0x09, 0x00, 0x00,  // ....`...
                                /* 0038 */  0x0A, 0x00, 0x00, 0x00, 0x6B, 0x0A, 0x00, 0x00,  // ....k...
                                /* 0040 */  0x0B, 0x00, 0x00, 0x00, 0x75, 0x0B, 0x00, 0x00,  // ....u...
                                /* 0048 */  0x0C, 0x00, 0x00, 0x00, 0x80, 0x0C, 0x00, 0x00   // ........
                            }
                        })
                    }
                    Else
                    {
                        ADBG ("DDR ELSE")
                        Return (Package (0x02)
                        {
                            Zero, 
                            Buffer (0x68)
                            {
                                /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                                /* 0008 */  0x05, 0x00, 0x00, 0x00, 0x2B, 0x04, 0x00, 0x00,  // ....+...
                                /* 0010 */  0x06, 0x00, 0x00, 0x00, 0xB0, 0x04, 0x00, 0x00,  // ........
                                /* 0018 */  0x07, 0x00, 0x00, 0x00, 0x78, 0x05, 0x00, 0x00,  // ....x...
                                /* 0020 */  0x08, 0x00, 0x00, 0x00, 0x40, 0x06, 0x00, 0x00,  // ....@...
                                /* 0028 */  0x09, 0x00, 0x00, 0x00, 0x08, 0x07, 0x00, 0x00,  // ........
                                /* 0030 */  0x0A, 0x00, 0x00, 0x00, 0xD0, 0x07, 0x00, 0x00,  // ........
                                /* 0038 */  0x0B, 0x00, 0x00, 0x00, 0x98, 0x08, 0x00, 0x00,  // ........
                                /* 0040 */  0x0C, 0x00, 0x00, 0x00, 0x60, 0x09, 0x00, 0x00,  // ....`...
                                /* 0048 */  0x0D, 0x00, 0x00, 0x00, 0x28, 0x0A, 0x00, 0x00,  // ....(...
                                /* 0050 */  0x0E, 0x00, 0x00, 0x00, 0xF0, 0x0A, 0x00, 0x00,  // ........
                                /* 0058 */  0x0F, 0x00, 0x00, 0x00, 0xB8, 0x0B, 0x00, 0x00,  // ........
                                /* 0060 */  0x10, 0x00, 0x00, 0x00, 0x80, 0x0C, 0x00, 0x00   // ........
                            }
                        })
                    }

                    ADBG ("DDR EXIT")
                }

                If (LEqual (Arg0, 0x0B))
                {
                    Return (Package (0x02)
                    {
                        Zero, 
                        Buffer (0x60)
                        {
                            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0008 */  0x05, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00,  // ........
                            /* 0010 */  0x06, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00,  // ........
                            /* 0018 */  0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00,  // ........
                            /* 0020 */  0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00,  // ........
                            /* 0028 */  0x0A, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00,  // ........
                            /* 0030 */  0x0C, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00,  // ........
                            /* 0038 */  0x0E, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,  // ........
                            /* 0040 */  0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00,  // ........
                            /* 0048 */  0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00,  // ........
                            /* 0050 */  0x14, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00,  // ........
                            /* 0058 */  0x18, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00   // ........
                        }
                    })
                }

                If (LEqual (Arg0, 0x49))
                {
                    Return (Package (0x02)
                    {
                        Zero, 
                        Buffer (0x18)
                        {
                            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0008 */  0x01, 0x00, 0x00, 0x00, 0x85, 0x00, 0x00, 0x00,  // ........
                            /* 0010 */  0x02, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00   // ....d...
                        }
                    })
                }

                Return (Package (0x01)
                {
                    One
                })
            }

            Method (GXDV, 1, Serialized)
            {
                If (LNotEqual (XMPB, Zero))
                {
                    OperationRegion (XMPN, SystemMemory, XMPB, SIZE)
                    Field (XMPN, ByteAcc, NoLock, Preserve)
                    {
                        XMP1,   576, 
                        XMP2,   576
                    }

                    If (LEqual (Arg0, One))
                    {
                        Name (XP_1, Package (0x02){})
                        Store (Zero, Index (XP_1, Zero))
                        Store (XMP1, Index (XP_1, One))
                        Return (XP_1) /* \_SB_.PTMD.GXDV.XP_1 */
                    }

                    If (LEqual (Arg0, 0x02))
                    {
                        Name (XP_2, Package (0x02){})
                        Store (Zero, Index (XP_2, Zero))
                        Store (XMP2, Index (XP_2, One))
                        Return (XP_2) /* \_SB_.PTMD.GXDV.XP_2 */
                    }
                }

                Return (Package (0x01)
                {
                    One
                })
            }

            Method (GSCV, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    0x72
                })
            }

            Method (GSCB, 0, NotSerialized)
            {
                Return (XSMI) /* External reference */
            }

            Method (CDRD, 1, Serialized)
            {
                Return (Package (0x01)
                {
                    One
                })
            }

            Method (CDWR, 2, Serialized)
            {
                Return (One)
            }

            Name (RPMV, Package (0x04)
            {
                One, 
                0x07, 
                Zero, 
                Zero
            })
            Name (TMP1, Package (0x0C)
            {
                One, 
                0x02, 
                Zero, 
                Zero, 
                0x05, 
                0x04, 
                Zero, 
                Zero, 
                0x06, 
                0x05, 
                Zero, 
                Zero
            })
            Name (TMP2, Package (0x08)
            {
                One, 
                0x02, 
                Zero, 
                Zero, 
                0x05, 
                0x04, 
                Zero, 
                Zero
            })
            Name (TMP3, Package (0x04)
            {
                One, 
                0x02, 
                Zero, 
                Zero
            })
            Method (TSDD, 0, NotSerialized)
            {
                If (LEqual (XTUS, Zero))
                {
                    Return (Zero)
                }

                If (\ECON)
                {
                    If (\TSOD)
                    {
                        Store (\_TZ.TZ01._TMP (), Index (TMP1, 0x02))
                        Return (TMP1) /* \_SB_.PTMD.TMP1 */
                    }
                    Else
                    {
                        Store (\_TZ.TZ01._TMP (), Index (TMP2, 0x02))
                        Return (TMP2) /* \_SB_.PTMD.TMP2 */
                    }
                }
                Else
                {
                    Store (\_TZ.TZ01._TMP (), Index (TMP3, 0x02))
                    Return (TMP3) /* \_SB_.PTMD.TMP3 */
                }
            }

            Method (FSDD, 0, NotSerialized)
            {
                If (LEqual (XTUS, Zero))
                {
                    Return (Zero)
                }

                If (\ECON)
                {
                    Store (\_SB.PCI0.LPCB.H_EC.ECRD (RefOf (\_SB.PCI0.LPCB.H_EC.CFSP)), Index (RPMV, 0x02))
                }

                Return (RPMV) /* \_SB_.PTMD.RPMV */
            }

            Method (SDSP, 0, NotSerialized)
            {
                Return (0x0A)
            }
        }
    }
}

