/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190405 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-7-UsbCTabl.aml, Tue Apr 30 02:38:48 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000006BF (1727)
 *     Revision         0x02
 *     Checksum         0xBC
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "UsbCTabl"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "UsbCTabl", 0x00001000)
{
    External (_SB_.PCI0.LPCB.EC__.HKEY.MHPF, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.RP09.PXSX.TBDU.XHC_.RHUB.TPLD, MethodObj)    // 2 Arguments
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (ADBG, MethodObj)    // 1 Arguments
    External (OSYS, UnknownObj)
    External (TBTS, UnknownObj)
    External (UBCB, UnknownObj)
    External (USTC, UnknownObj)
    External (UTCM, UnknownObj)
    External (XDCE, UnknownObj)

    Scope (\_SB)
    {
        Device (UBTC)
        {
            Name (_HID, EisaId ("USBC000"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0CA0"))  // _CID: Compatible ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DDN, "USB Type C")  // _DDN: DOS Device Name
            Name (_ADR, Zero)  // _ADR: Address
            Name (CRS, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00001000,         // Address Length
                    _Y48)
            })
            Device (CR01)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    If (LEqual (USTC, One))
                    {
                        Return (\_SB.PCI0.RP09.PXSX.TBDU.XHC.RHUB.TPLD (One, One))
                    }
                }
            }

            Device (CR02)
            {
                Name (_ADR, One)  // _ADR: Address
                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    If (LEqual (USTC, One))
                    {
                        Return (\_SB.PCI0.RP09.PXSX.TBDU.XHC.RHUB.TPLD (One, 0x02))
                    }
                }
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateDWordField (CRS, \_SB.UBTC._Y48._BAS, CBAS)  // _BAS: Base Address
                Store (UBCB, CBAS) /* \_SB_.UBTC._CRS.CBAS */
                Return (CRS) /* \_SB_.UBTC.CRS_ */
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (LAnd (LGreaterEqual (OSYS, 0x07DF), LEqual (TBTS, One)))
                {
                    If (LEqual (USTC, One))
                    {
                        Return (0x0F)
                    }
                }

                Return (Zero)
            }

            OperationRegion (USBC, SystemMemory, UBCB, 0x38)
            Field (USBC, ByteAcc, Lock, Preserve)
            {
                VER1,   8, 
                VER2,   8, 
                RSV1,   8, 
                RSV2,   8, 
                CCI0,   8, 
                CCI1,   8, 
                CCI2,   8, 
                CCI3,   8, 
                CTL0,   8, 
                CTL1,   8, 
                CTL2,   8, 
                CTL3,   8, 
                CTL4,   8, 
                CTL5,   8, 
                CTL6,   8, 
                CTL7,   8, 
                MGI0,   8, 
                MGI1,   8, 
                MGI2,   8, 
                MGI3,   8, 
                MGI4,   8, 
                MGI5,   8, 
                MGI6,   8, 
                MGI7,   8, 
                MGI8,   8, 
                MGI9,   8, 
                MGIA,   8, 
                MGIB,   8, 
                MGIC,   8, 
                MGID,   8, 
                MGIE,   8, 
                MGIF,   8, 
                MGO0,   8, 
                MGO1,   8, 
                MGO2,   8, 
                MGO3,   8, 
                MGO4,   8, 
                MGO5,   8, 
                MGO6,   8, 
                MGO7,   8, 
                MGO8,   8, 
                MGO9,   8, 
                MGOA,   8, 
                MGOB,   8, 
                MGOC,   8, 
                MGOD,   8, 
                MGOE,   8, 
                MGOF,   8
            }

            Mutex (UBSY, 0x00)
            Method (ECWR, 0, Serialized)
            {
                ADBG ("ECWR")
                Acquire (UBSY, 0xFFFF)
                Store (Buffer (0x25){}, Local0)
                Store (0x0A, Index (Local0, Zero))
                Store (Zero, Index (Local0, One))
                Store (0x02, Index (Local0, 0x02))
                Store (0x06, Index (Local0, 0x03))
                Store (MGO0, Index (Local0, 0x04))
                Store (MGO1, Index (Local0, 0x05))
                Store (MGO2, Index (Local0, 0x06))
                Store (MGO3, Index (Local0, 0x07))
                Store (MGO4, Index (Local0, 0x08))
                Store (MGO5, Index (Local0, 0x09))
                Store (MGO6, Index (Local0, 0x0A))
                Store (MGO7, Index (Local0, 0x0B))
                Store (MGO8, Index (Local0, 0x0C))
                Store (MGO9, Index (Local0, 0x0D))
                Store (MGOA, Index (Local0, 0x0E))
                Store (MGOB, Index (Local0, 0x0F))
                Store (MGOC, Index (Local0, 0x10))
                Store (MGOD, Index (Local0, 0x11))
                Store (MGOE, Index (Local0, 0x12))
                Store (MGOF, Index (Local0, 0x13))
                Store (0x10, Index (Local0, 0x24))
                \_SB.PCI0.LPCB.EC.HKEY.MHPF (Local0)
                Store (0x0A, Index (Local0, Zero))
                Store (Zero, Index (Local0, One))
                Store (0x02, Index (Local0, 0x02))
                Store (0x04, Index (Local0, 0x03))
                Store (CTL0, Index (Local0, 0x04))
                Store (CTL1, Index (Local0, 0x05))
                Store (CTL2, Index (Local0, 0x06))
                Store (CTL3, Index (Local0, 0x07))
                Store (CTL4, Index (Local0, 0x08))
                Store (CTL5, Index (Local0, 0x09))
                Store (CTL6, Index (Local0, 0x0A))
                Store (CTL7, Index (Local0, 0x0B))
                Store (0x08, Index (Local0, 0x24))
                \_SB.PCI0.LPCB.EC.HKEY.MHPF (Local0)
                Release (UBSY)
            }

            Method (ECRD, 0, Serialized)
            {
                ADBG ("ECRD")
                Acquire (UBSY, 0xFFFF)
                Store (Buffer (0x25){}, Local0)
                Store (0x0B, Index (Local0, Zero))
                Store (Zero, Index (Local0, One))
                Store (0x02, Index (Local0, 0x02))
                Store (0x05, Index (Local0, 0x03))
                Store (0x10, Index (Local0, 0x24))
                Store (\_SB.PCI0.LPCB.EC.HKEY.MHPF (Local0), Local1)
                Store (DerefOf (Index (Local1, 0x04)), MGI0) /* \_SB_.UBTC.MGI0 */
                Store (DerefOf (Index (Local1, 0x05)), MGI1) /* \_SB_.UBTC.MGI1 */
                Store (DerefOf (Index (Local1, 0x06)), MGI2) /* \_SB_.UBTC.MGI2 */
                Store (DerefOf (Index (Local1, 0x07)), MGI3) /* \_SB_.UBTC.MGI3 */
                Store (DerefOf (Index (Local1, 0x08)), MGI4) /* \_SB_.UBTC.MGI4 */
                Store (DerefOf (Index (Local1, 0x09)), MGI5) /* \_SB_.UBTC.MGI5 */
                Store (DerefOf (Index (Local1, 0x0A)), MGI6) /* \_SB_.UBTC.MGI6 */
                Store (DerefOf (Index (Local1, 0x0B)), MGI7) /* \_SB_.UBTC.MGI7 */
                Store (DerefOf (Index (Local1, 0x0C)), MGI8) /* \_SB_.UBTC.MGI8 */
                Store (DerefOf (Index (Local1, 0x0D)), MGI9) /* \_SB_.UBTC.MGI9 */
                Store (DerefOf (Index (Local1, 0x0E)), MGIA) /* \_SB_.UBTC.MGIA */
                Store (DerefOf (Index (Local1, 0x0F)), MGIB) /* \_SB_.UBTC.MGIB */
                Store (DerefOf (Index (Local1, 0x10)), MGIC) /* \_SB_.UBTC.MGIC */
                Store (DerefOf (Index (Local1, 0x11)), MGID) /* \_SB_.UBTC.MGID */
                Store (DerefOf (Index (Local1, 0x12)), MGIE) /* \_SB_.UBTC.MGIE */
                Store (DerefOf (Index (Local1, 0x13)), MGIF) /* \_SB_.UBTC.MGIF */
                Store (0x0B, Index (Local0, Zero))
                Store (Zero, Index (Local0, One))
                Store (0x02, Index (Local0, 0x02))
                Store (0x03, Index (Local0, 0x03))
                Store (0x04, Index (Local0, 0x24))
                Store (\_SB.PCI0.LPCB.EC.HKEY.MHPF (Local0), Local1)
                Store (DerefOf (Index (Local1, 0x04)), CCI0) /* \_SB_.UBTC.CCI0 */
                Store (DerefOf (Index (Local1, 0x05)), CCI1) /* \_SB_.UBTC.CCI1 */
                Store (DerefOf (Index (Local1, 0x06)), CCI2) /* \_SB_.UBTC.CCI2 */
                Store (DerefOf (Index (Local1, 0x07)), CCI3) /* \_SB_.UBTC.CCI3 */
                Release (UBSY)
            }

            Method (NTFY, 0, Serialized)
            {
                ADBG ("NTFY_EC")
                ECRD ()
                Sleep (One)
                Notify (\_SB.UBTC, 0x80) // Status Change
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg0, ToUUID ("6f8398c2-7ca4-11e4-ad36-631042b5008f")))
                {
                    ADBG (Concatenate ("S_UCSI=", ToHexString (Arg2)))
                    Switch (ToInteger (Arg2))
                    {
                        Case (Zero)
                        {
                            Return (Buffer (One)
                            {
                                 0x0F                                             // .
                            })
                        }
                        Case (One)
                        {
                            ECWR ()
                        }
                        Case (0x02)
                        {
                            ECRD ()
                        }
                        Case (0x03)
                        {
                            Return (XDCE) /* External reference */
                        }

                    }

                    ADBG ("E_UCSI")
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }
        }
    }
}

