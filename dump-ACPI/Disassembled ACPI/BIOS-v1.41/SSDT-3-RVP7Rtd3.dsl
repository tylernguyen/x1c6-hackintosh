/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-3-RVP7Rtd3.aml, Thu Oct  3 00:56:10 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00001D1D (7453)
 *     Revision         0x02
 *     Checksum         0x3D
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "RVP7Rtd3"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "RVP7Rtd3", 0x00001000)
{
    External (_SB_.GGOV, MethodObj)    // 1 Arguments
    External (_SB_.GPC0, MethodObj)    // 1 Arguments
    External (_SB_.OSCO, UnknownObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GEXP, DeviceObj)
    External (_SB_.PCI0.GEXP.GEPS, MethodObj)    // 2 Arguments
    External (_SB_.PCI0.GEXP.SGEP, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.GLAN, DeviceObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.I2C1.TPL1, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.ECAV, IntObj)
    External (_SB_.PCI0.LPCB.H_EC.SPT2, UnknownObj)
    External (_SB_.PCI0.RP01, DeviceObj)
    External (_SB_.PCI0.RP01.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP01.DPGE, UnknownObj)
    External (_SB_.PCI0.RP01.L23E, UnknownObj)
    External (_SB_.PCI0.RP01.L23R, UnknownObj)
    External (_SB_.PCI0.RP01.LASX, UnknownObj)
    External (_SB_.PCI0.RP01.LDIS, UnknownObj)
    External (_SB_.PCI0.RP01.LEDM, UnknownObj)
    External (_SB_.PCI0.RP01.VDID, UnknownObj)
    External (_SB_.PCI0.RP02, DeviceObj)
    External (_SB_.PCI0.RP02.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP02.DPGE, UnknownObj)
    External (_SB_.PCI0.RP02.L23E, UnknownObj)
    External (_SB_.PCI0.RP02.L23R, UnknownObj)
    External (_SB_.PCI0.RP02.LASX, UnknownObj)
    External (_SB_.PCI0.RP02.LDIS, UnknownObj)
    External (_SB_.PCI0.RP02.LEDM, UnknownObj)
    External (_SB_.PCI0.RP02.VDID, UnknownObj)
    External (_SB_.PCI0.RP03, DeviceObj)
    External (_SB_.PCI0.RP03.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP03.DPGE, UnknownObj)
    External (_SB_.PCI0.RP03.L23E, UnknownObj)
    External (_SB_.PCI0.RP03.L23R, UnknownObj)
    External (_SB_.PCI0.RP03.LASX, UnknownObj)
    External (_SB_.PCI0.RP03.LDIS, UnknownObj)
    External (_SB_.PCI0.RP03.LEDM, UnknownObj)
    External (_SB_.PCI0.RP03.VDID, UnknownObj)
    External (_SB_.PCI0.RP04, DeviceObj)
    External (_SB_.PCI0.RP04.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP04.DPGE, UnknownObj)
    External (_SB_.PCI0.RP04.L23E, UnknownObj)
    External (_SB_.PCI0.RP04.L23R, UnknownObj)
    External (_SB_.PCI0.RP04.LASX, UnknownObj)
    External (_SB_.PCI0.RP04.LDIS, UnknownObj)
    External (_SB_.PCI0.RP04.LEDM, UnknownObj)
    External (_SB_.PCI0.RP04.VDID, UnknownObj)
    External (_SB_.PCI0.RP05, DeviceObj)
    External (_SB_.PCI0.RP05.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP05.DPGE, UnknownObj)
    External (_SB_.PCI0.RP05.L23E, UnknownObj)
    External (_SB_.PCI0.RP05.L23R, UnknownObj)
    External (_SB_.PCI0.RP05.LASX, UnknownObj)
    External (_SB_.PCI0.RP05.LDIS, UnknownObj)
    External (_SB_.PCI0.RP05.LEDM, UnknownObj)
    External (_SB_.PCI0.RP05.VDID, UnknownObj)
    External (_SB_.PCI0.RP06, DeviceObj)
    External (_SB_.PCI0.RP06.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP06.DPGE, UnknownObj)
    External (_SB_.PCI0.RP06.L23E, UnknownObj)
    External (_SB_.PCI0.RP06.L23R, UnknownObj)
    External (_SB_.PCI0.RP06.LASX, UnknownObj)
    External (_SB_.PCI0.RP06.LDIS, UnknownObj)
    External (_SB_.PCI0.RP06.LEDM, UnknownObj)
    External (_SB_.PCI0.RP06.VDID, UnknownObj)
    External (_SB_.PCI0.RP07, DeviceObj)
    External (_SB_.PCI0.RP07.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP07.DPGE, UnknownObj)
    External (_SB_.PCI0.RP07.L23E, UnknownObj)
    External (_SB_.PCI0.RP07.L23R, UnknownObj)
    External (_SB_.PCI0.RP07.LASX, UnknownObj)
    External (_SB_.PCI0.RP07.LDIS, UnknownObj)
    External (_SB_.PCI0.RP07.LEDM, UnknownObj)
    External (_SB_.PCI0.RP07.VDID, UnknownObj)
    External (_SB_.PCI0.RP08, DeviceObj)
    External (_SB_.PCI0.RP08.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP08.DPGE, UnknownObj)
    External (_SB_.PCI0.RP08.L23E, UnknownObj)
    External (_SB_.PCI0.RP08.L23R, UnknownObj)
    External (_SB_.PCI0.RP08.LASX, UnknownObj)
    External (_SB_.PCI0.RP08.LDIS, UnknownObj)
    External (_SB_.PCI0.RP08.LEDM, UnknownObj)
    External (_SB_.PCI0.RP08.VDID, UnknownObj)
    External (_SB_.PCI0.RP09, DeviceObj)
    External (_SB_.PCI0.RP09.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP09.DPGE, UnknownObj)
    External (_SB_.PCI0.RP09.L23E, UnknownObj)
    External (_SB_.PCI0.RP09.L23R, UnknownObj)
    External (_SB_.PCI0.RP09.LASX, UnknownObj)
    External (_SB_.PCI0.RP09.LDIS, UnknownObj)
    External (_SB_.PCI0.RP09.LEDM, UnknownObj)
    External (_SB_.PCI0.RP09.PCRA, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.RP09.PCRO, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.RP09.VDID, UnknownObj)
    External (_SB_.PCI0.RP10, DeviceObj)
    External (_SB_.PCI0.RP10.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP10.DPGE, UnknownObj)
    External (_SB_.PCI0.RP10.L23E, UnknownObj)
    External (_SB_.PCI0.RP10.L23R, UnknownObj)
    External (_SB_.PCI0.RP10.LASX, UnknownObj)
    External (_SB_.PCI0.RP10.LDIS, UnknownObj)
    External (_SB_.PCI0.RP10.LEDM, UnknownObj)
    External (_SB_.PCI0.RP10.VDID, UnknownObj)
    External (_SB_.PCI0.RP11, DeviceObj)
    External (_SB_.PCI0.RP11.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP11.DPGE, UnknownObj)
    External (_SB_.PCI0.RP11.L23E, UnknownObj)
    External (_SB_.PCI0.RP11.L23R, UnknownObj)
    External (_SB_.PCI0.RP11.LASX, UnknownObj)
    External (_SB_.PCI0.RP11.LDIS, UnknownObj)
    External (_SB_.PCI0.RP11.LEDM, UnknownObj)
    External (_SB_.PCI0.RP11.VDID, UnknownObj)
    External (_SB_.PCI0.RP12, DeviceObj)
    External (_SB_.PCI0.RP12.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP12.DPGE, UnknownObj)
    External (_SB_.PCI0.RP12.L23E, UnknownObj)
    External (_SB_.PCI0.RP12.L23R, UnknownObj)
    External (_SB_.PCI0.RP12.LASX, UnknownObj)
    External (_SB_.PCI0.RP12.LDIS, UnknownObj)
    External (_SB_.PCI0.RP12.LEDM, UnknownObj)
    External (_SB_.PCI0.RP12.VDID, UnknownObj)
    External (_SB_.PCI0.RP13, DeviceObj)
    External (_SB_.PCI0.RP13.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP13.DPGE, UnknownObj)
    External (_SB_.PCI0.RP13.L23E, UnknownObj)
    External (_SB_.PCI0.RP13.L23R, UnknownObj)
    External (_SB_.PCI0.RP13.LASX, UnknownObj)
    External (_SB_.PCI0.RP13.LDIS, UnknownObj)
    External (_SB_.PCI0.RP13.LEDM, UnknownObj)
    External (_SB_.PCI0.RP13.VDID, UnknownObj)
    External (_SB_.PCI0.RP14, DeviceObj)
    External (_SB_.PCI0.RP14.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP14.DPGE, UnknownObj)
    External (_SB_.PCI0.RP14.L23E, UnknownObj)
    External (_SB_.PCI0.RP14.L23R, UnknownObj)
    External (_SB_.PCI0.RP14.LASX, UnknownObj)
    External (_SB_.PCI0.RP14.LDIS, UnknownObj)
    External (_SB_.PCI0.RP14.LEDM, UnknownObj)
    External (_SB_.PCI0.RP14.VDID, UnknownObj)
    External (_SB_.PCI0.RP15, DeviceObj)
    External (_SB_.PCI0.RP15.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP15.DPGE, UnknownObj)
    External (_SB_.PCI0.RP15.L23E, UnknownObj)
    External (_SB_.PCI0.RP15.L23R, UnknownObj)
    External (_SB_.PCI0.RP15.LASX, UnknownObj)
    External (_SB_.PCI0.RP15.LDIS, UnknownObj)
    External (_SB_.PCI0.RP15.LEDM, UnknownObj)
    External (_SB_.PCI0.RP15.VDID, UnknownObj)
    External (_SB_.PCI0.RP16, DeviceObj)
    External (_SB_.PCI0.RP16.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP16.DPGE, UnknownObj)
    External (_SB_.PCI0.RP16.L23E, UnknownObj)
    External (_SB_.PCI0.RP16.L23R, UnknownObj)
    External (_SB_.PCI0.RP16.LASX, UnknownObj)
    External (_SB_.PCI0.RP16.LDIS, UnknownObj)
    External (_SB_.PCI0.RP16.LEDM, UnknownObj)
    External (_SB_.PCI0.RP16.VDID, UnknownObj)
    External (_SB_.PCI0.RP17, DeviceObj)
    External (_SB_.PCI0.RP17.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP17.DPGE, UnknownObj)
    External (_SB_.PCI0.RP17.L23E, UnknownObj)
    External (_SB_.PCI0.RP17.L23R, UnknownObj)
    External (_SB_.PCI0.RP17.LASX, UnknownObj)
    External (_SB_.PCI0.RP17.LDIS, UnknownObj)
    External (_SB_.PCI0.RP17.LEDM, UnknownObj)
    External (_SB_.PCI0.RP17.VDID, UnknownObj)
    External (_SB_.PCI0.RP18, DeviceObj)
    External (_SB_.PCI0.RP18.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP18.DPGE, UnknownObj)
    External (_SB_.PCI0.RP18.L23E, UnknownObj)
    External (_SB_.PCI0.RP18.L23R, UnknownObj)
    External (_SB_.PCI0.RP18.LASX, UnknownObj)
    External (_SB_.PCI0.RP18.LDIS, UnknownObj)
    External (_SB_.PCI0.RP18.LEDM, UnknownObj)
    External (_SB_.PCI0.RP18.VDID, UnknownObj)
    External (_SB_.PCI0.RP19, DeviceObj)
    External (_SB_.PCI0.RP19.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP19.DPGE, UnknownObj)
    External (_SB_.PCI0.RP19.L23E, UnknownObj)
    External (_SB_.PCI0.RP19.L23R, UnknownObj)
    External (_SB_.PCI0.RP19.LASX, UnknownObj)
    External (_SB_.PCI0.RP19.LDIS, UnknownObj)
    External (_SB_.PCI0.RP19.LEDM, UnknownObj)
    External (_SB_.PCI0.RP19.VDID, UnknownObj)
    External (_SB_.PCI0.RP20, DeviceObj)
    External (_SB_.PCI0.RP20.D3HT, FieldUnitObj)
    External (_SB_.PCI0.RP20.DPGE, UnknownObj)
    External (_SB_.PCI0.RP20.L23E, UnknownObj)
    External (_SB_.PCI0.RP20.L23R, UnknownObj)
    External (_SB_.PCI0.RP20.LASX, UnknownObj)
    External (_SB_.PCI0.RP20.LDIS, UnknownObj)
    External (_SB_.PCI0.RP20.LEDM, UnknownObj)
    External (_SB_.PCI0.RP20.VDID, UnknownObj)
    External (_SB_.PCI0.SAT0, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT0, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT1, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT2, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT3, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT4, DeviceObj)
    External (_SB_.PCI0.SAT0.PRT5, DeviceObj)
    External (_SB_.PCI0.XDCI, DeviceObj)
    External (_SB_.PCI0.XDCI.D0I3, UnknownObj)
    External (_SB_.PCI0.XDCI.XDCB, UnknownObj)
    External (_SB_.PCI0.XHC_, DeviceObj)
    External (_SB_.PCI0.XHC_.MEMB, UnknownObj)
    External (_SB_.PCI0.XHC_.PMEE, UnknownObj)
    External (_SB_.PCI0.XHC_.PMES, UnknownObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB_.SGOV, MethodObj)    // 2 Arguments
    External (_SB_.SHPO, MethodObj)    // 2 Arguments
    External (_SB_.SPC0, MethodObj)    // 2 Arguments
    External (ADBG, MethodObj)    // 1 Arguments
    External (AUDD, FieldUnitObj)
    External (DVID, UnknownObj)
    External (ECON, IntObj)
    External (GBEP, UnknownObj)
    External (I20D, FieldUnitObj)
    External (I21D, FieldUnitObj)
    External (IC0D, FieldUnitObj)
    External (IC1D, FieldUnitObj)
    External (IC1S, FieldUnitObj)
    External (MMRP, MethodObj)    // 1 Arguments
    External (MMTB, MethodObj)    // 1 Arguments
    External (OSYS, UnknownObj)
    External (PCHG, UnknownObj)
    External (PCHS, UnknownObj)
    External (PEP0, UnknownObj)
    External (PEP3, UnknownObj)
    External (PWRM, UnknownObj)
    External (RCG0, IntObj)
    External (RCG1, IntObj)
    External (RIC0, FieldUnitObj)
    External (RTBC, IntObj)
    External (RTBT, IntObj)
    External (RTD3, IntObj)
    External (S0ID, UnknownObj)
    External (SDS0, FieldUnitObj)
    External (SDS1, FieldUnitObj)
    External (SGMD, UnknownObj)
    External (SHSB, FieldUnitObj)
    External (SPST, IntObj)
    External (TBCD, IntObj)
    External (TBHR, IntObj)
    External (TBOD, IntObj)
    External (TBPE, IntObj)
    External (TBRP, IntObj)
    External (TBSE, IntObj)
    External (TBTS, IntObj)
    External (TOFF, IntObj)
    External (TRD3, IntObj)
    External (TRDO, IntObj)
    External (UAMS, UnknownObj)
    External (VRRD, FieldUnitObj)
    External (VRSD, FieldUnitObj)
    External (XDST, IntObj)
    External (XHPR, UnknownObj)

    If (LAnd (LEqual (\RTBT, 0x01), LEqual (\TBTS, 0x01)))
    {
        Scope (\_SB.PCI0.RP09)
        {
            Name (SLOT, 0x09)
            ADBG ("Rvp7Rtd3:Slot:")
            ADBG (SLOT)
            Name (RSTG, Package (0x04)
            {
                0x01, 
                0x00, 
                0x02060006, 
                0x01
            })
            Name (PWRG, Package (0x04)
            {
                0x01, 
                0x00, 
                0x02060004, 
                0x01
            })
            Name (WAKG, Package (0x04)
            {
                0x01, 
                0x00, 
                0x02060007, 
                0x00
            })
            Name (SCLK, Package (0x03)
            {
                0x01, 
                0x20, 
                0x00
            })
            Name (G2SD, 0x00)
            Name (WKEN, 0x00)
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                OperationRegion (PLTR, SystemMemory, PWRM, 0x0800)
                Field (PLTR, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x3EC), 
                    Offset (0x3EE), 
                    BI16,   1, 
                    Offset (0x3EF), 
                    BI24,   1
                }

                Store (0x01, BI16) /* \_SB_.PCI0.RP09._PS0.BI16 */
                Store (0x00, BI24) /* \_SB_.PCI0.RP09._PS0.BI24 */
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                OperationRegion (PLTR, SystemMemory, PWRM, 0x0800)
                Field (PLTR, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x3EC), 
                    Offset (0x3EE), 
                    BI16,   1, 
                    Offset (0x3EF), 
                    BI24,   1
                }

                Store (0x00, BI16) /* \_SB_.PCI0.RP09._PS3.BI16 */
                Store (0x00, BI24) /* \_SB_.PCI0.RP09._PS3.BI24 */
            }

            Method (_S0W, 0, NotSerialized)  // _S0W: S0 Device Wake State
            {
                Return (0x04)
            }

            Method (_DSD, 0, NotSerialized)  // _DSD: Device-Specific Data
            {
                ADBG ("Tbt:_DSD")
                Return (Package (0x02)
                {
                    ToUUID ("6211e2c0-58a3-4af3-90e1-927a4e0c55a4"), 
                    Package (0x01)
                    {
                        Package (0x02)
                        {
                            "HotPlugSupportInD3", 
                            0x01
                        }
                    }
                })
            }

            Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
            {
                ADBG ("Tbt:_DSW")
                ADBG (Arg0)
                ADBG (Arg1)
                ADBG (Arg2)
                If (LGreaterEqual (Arg1, 0x01))
                {
                    Store (0x00, WKEN) /* \_SB_.PCI0.RP09.WKEN */
                    Store (0x02, TOFF) /* External reference */
                }
                ElseIf (LAnd (Arg0, Arg2))
                {
                    Store (0x01, WKEN) /* \_SB_.PCI0.RP09.WKEN */
                    Store (0x01, TOFF) /* External reference */
                }
                Else
                {
                    Store (0x00, WKEN) /* \_SB_.PCI0.RP09.WKEN */
                    Store (0x00, TOFF) /* External reference */
                }
            }

            PowerResource (PXP, 0x00, 0x0000)
            {
                ADBG ("TBT:PXP")
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    ADBG ("PSTA")
                    Return (PSTA ())
                }

                Method (_ON, 0, NotSerialized)  // _ON_: Power On
                {
                    ADBG ("S_ON")
                    Store (0x01, TRDO) /* External reference */
                    PON ()
                    Store (0x00, TRDO) /* External reference */
                    ADBG ("E_ON")
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    ADBG ("S_OFF")
                    Store (0x01, TRD3) /* External reference */
                    POFF ()
                    Store (0x00, TRD3) /* External reference */
                    ADBG ("E_OFF")
                }
            }

            Method (PSTA, 0, NotSerialized)
            {
                If (LNotEqual (DerefOf (Index (PWRG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x01))
                    {
                        If (LEqual (\_SB.GGOV (DerefOf (Index (PWRG, 0x02))), DerefOf (Index (PWRG, 0x03
                            ))))
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x02))
                    {
                        If (LEqual (\_SB.PCI0.GEXP.GEPS (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02
                            ))), DerefOf (Index (PWRG, 0x03))))
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }
                }

                If (LNotEqual (DerefOf (Index (RSTG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x01))
                    {
                        If (LEqual (\_SB.GGOV (DerefOf (Index (RSTG, 0x02))), DerefOf (Index (RSTG, 0x03
                            ))))
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x02))
                    {
                        If (LEqual (\_SB.PCI0.GEXP.GEPS (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02
                            ))), DerefOf (Index (RSTG, 0x03))))
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }
                }

                Return (0x00)
            }

            Method (SXEX, 0, Serialized)
            {
                Store (\MMTB (TBSE), Local7)
                OperationRegion (TBDI, SystemMemory, Local7, 0x0550)
                Field (TBDI, DWordAcc, NoLock, Preserve)
                {
                    DIVI,   32, 
                    CMDR,   32, 
                    Offset (0x548), 
                    TB2P,   32, 
                    P2TB,   32
                }

                Store (0x64, Local1)
                Store (0x09, P2TB) /* \_SB_.PCI0.RP09.SXEX.P2TB */
                While (LGreater (Local1, 0x00))
                {
                    Store (Subtract (Local1, 0x01), Local1)
                    Store (TB2P, Local2)
                    If (LEqual (Local2, 0xFFFFFFFF))
                    {
                        Return (Zero)
                    }

                    If (And (Local2, 0x01))
                    {
                        Break
                    }

                    Sleep (0x05)
                }

                Store (0x00, P2TB) /* \_SB_.PCI0.RP09.SXEX.P2TB */
                Store (0x01F4, Local1)
                While (LGreater (Local1, 0x00))
                {
                    Store (Subtract (Local1, 0x01), Local1)
                    Store (TB2P, Local2)
                    If (LEqual (Local2, 0xFFFFFFFF))
                    {
                        Return (Zero)
                    }

                    If (LNotEqual (DIVI, 0xFFFFFFFF))
                    {
                        Break
                    }

                    Sleep (0x0A)
                }
            }

            Method (PON, 0, NotSerialized)
            {
                Store (\MMRP (\TBSE), Local7)
                OperationRegion (L23P, SystemMemory, Local7, 0xE4)
                Field (L23P, WordAcc, NoLock, Preserve)
                {
                    Offset (0xA4), 
                    PSD0,   2, 
                    Offset (0xE2), 
                        ,   2, 
                    L2TE,   1, 
                    L2TR,   1
                }

                Store (\MMTB (\TBSE), Local6)
                OperationRegion (TBDI, SystemMemory, Local6, 0x0550)
                Field (TBDI, DWordAcc, NoLock, Preserve)
                {
                    DIVI,   32, 
                    CMDR,   32, 
                    Offset (0xA4), 
                    TBPS,   2, 
                    Offset (0x548), 
                    TB2P,   32, 
                    P2TB,   32
                }

                If (TBPE)
                {
                    Return (Zero)
                }

                Store (0x00, TOFF) /* External reference */
                Store (0x00, G2SD) /* \_SB_.PCI0.RP09.G2SD */
                If (\RTBC)
                {
                    If (LNotEqual (DerefOf (Index (SCLK, 0x00)), 0x00))
                    {
                        PCRA (0xDC, 0x100C, Not (DerefOf (Index (SCLK, 0x01))))
                    }

                    Sleep (\TBCD)
                }

                If (LNotEqual (DerefOf (Index (PWRG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x01))
                    {
                        \_SB.SGOV (DerefOf (Index (PWRG, 0x02)), DerefOf (Index (PWRG, 0x03)))
                        Store (0x01, TBPE) /* External reference */
                        Sleep (0x0A)
                    }

                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02)), DerefOf (
                            Index (PWRG, 0x03)))
                        Store (0x01, TBPE) /* External reference */
                        Sleep (0x0A)
                    }
                }

                If (LNotEqual (DerefOf (Index (RSTG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x01))
                    {
                        \_SB.SPC0 (DerefOf (Index (RSTG, 0x02)), Or (\_SB.GPC0 (DerefOf (Index (RSTG, 0x02
                            ))), 0x0100))
                    }

                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02)), DerefOf (
                            Index (RSTG, 0x03)))
                    }
                }

                Store (0x00, DPGE) /* External reference */
                Store (0x01, L2TR) /* \_SB_.PCI0.RP09.PON_.L2TR */
                Sleep (0x10)
                Store (0x00, Local0)
                While (L2TR)
                {
                    If (LGreater (Local0, 0x04))
                    {
                        Break
                    }

                    Sleep (0x10)
                    Increment (Local0)
                }

                Store (0x01, DPGE) /* External reference */
                Store (0x00, Local0)
                While (LEqual (LASX, 0x00))
                {
                    If (LGreater (Local0, 0x08))
                    {
                        Break
                    }

                    Sleep (0x10)
                    Increment (Local0)
                }

                Store (0x00, LEDM) /* External reference */
                Store (PSD0, Local1)
                Store (0x00, PSD0) /* \_SB_.PCI0.RP09.PON_.PSD0 */
                Store (0x14, Local2)
                While (LGreater (Local2, 0x00))
                {
                    Store (Subtract (Local2, 0x01), Local2)
                    Store (TB2P, Local3)
                    If (LNotEqual (Local3, 0xFFFFFFFF))
                    {
                        Break
                    }

                    Sleep (0x0A)
                }

                If (LLessEqual (Local2, 0x00)){}
                SXEX ()
                Store (Local1, PSD0) /* \_SB_.PCI0.RP09.PON_.PSD0 */
            }

            Method (POFF, 0, NotSerialized)
            {
                If (LEqual (TOFF, 0x00))
                {
                    Return (Zero)
                }

                Store (\MMRP (\TBSE), Local7)
                OperationRegion (L23P, SystemMemory, Local7, 0xE4)
                Field (L23P, WordAcc, NoLock, Preserve)
                {
                    Offset (0xA4), 
                    PSD0,   2, 
                    Offset (0xE2), 
                        ,   2, 
                    L2TE,   1, 
                    L2TR,   1
                }

                Store (\MMTB (TBSE), Local6)
                OperationRegion (TBDI, SystemMemory, Local6, 0x0550)
                Field (TBDI, DWordAcc, NoLock, Preserve)
                {
                    DIVI,   32, 
                    CMDR,   32, 
                    Offset (0xA4), 
                    TBPS,   2, 
                    Offset (0x548), 
                    TB2P,   32, 
                    P2TB,   32
                }

                Store (PSD0, Local1)
                Store (0x00, PSD0) /* \_SB_.PCI0.RP09.POFF.PSD0 */
                Store (P2TB, Local3)
                If (LGreater (TOFF, 0x01))
                {
                    Sleep (0x0A)
                    Store (Local1, PSD0) /* \_SB_.PCI0.RP09.POFF.PSD0 */
                    Return (Zero)
                }

                Store (0x00, TOFF) /* External reference */
                Store (Local1, PSD0) /* \_SB_.PCI0.RP09.POFF.PSD0 */
                Store (0x01, L2TE) /* \_SB_.PCI0.RP09.POFF.L2TE */
                Sleep (0x10)
                Store (0x00, Local0)
                While (L2TE)
                {
                    If (LGreater (Local0, 0x04))
                    {
                        Break
                    }

                    Sleep (0x10)
                    Increment (Local0)
                }

                Store (0x01, LEDM) /* External reference */
                If (LNotEqual (DerefOf (Index (RSTG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x01))
                    {
                        \_SB.SPC0 (DerefOf (Index (RSTG, 0x02)), And (\_SB.GPC0 (DerefOf (Index (RSTG, 0x02
                            ))), 0xFFFFFEFF, Local4))
                        Sleep (0x0A)
                    }

                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02)), XOr (
                            DerefOf (Index (RSTG, 0x03)), 0x01))
                        Sleep (0x0A)
                    }
                }

                If (\RTBC)
                {
                    If (LNotEqual (DerefOf (Index (SCLK, 0x00)), 0x00))
                    {
                        PCRO (0xDC, 0x100C, DerefOf (Index (SCLK, 0x01)))
                        Sleep (0x10)
                    }
                }

                If (LNotEqual (DerefOf (Index (PWRG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x01))
                    {
                        \_SB.SGOV (DerefOf (Index (PWRG, 0x02)), XOr (DerefOf (Index (PWRG, 0x03)), 
                            0x01))
                    }

                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02)), XOr (
                            DerefOf (Index (PWRG, 0x03)), 0x01))
                    }
                }

                Store (0x00, TBPE) /* External reference */
                Store (0x01, LDIS) /* External reference */
                Store (0x00, LDIS) /* External reference */
                If (WKEN)
                {
                    If (LNotEqual (DerefOf (Index (WAKG, 0x00)), 0x00))
                    {
                        If (LEqual (DerefOf (Index (WAKG, 0x00)), 0x01))
                        {
                            \_SB.SGOV (DerefOf (Index (WAKG, 0x02)), DerefOf (Index (WAKG, 0x03)))
                            \_SB.SHPO (DerefOf (Index (WAKG, 0x02)), 0x00)
                        }

                        If (LEqual (DerefOf (Index (WAKG, 0x00)), 0x02))
                        {
                            \_SB.PCI0.GEXP.SGEP (DerefOf (Index (WAKG, 0x01)), DerefOf (Index (WAKG, 0x02)), DerefOf (
                                Index (WAKG, 0x03)))
                        }
                    }
                }

                Sleep (\TBOD)
            }

            Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
            {
                PXP
            })
            Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
            {
                PXP
            })
        }
    }
}

