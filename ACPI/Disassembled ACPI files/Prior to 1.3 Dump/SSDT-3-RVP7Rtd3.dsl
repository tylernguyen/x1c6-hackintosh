/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-3-RVP7Rtd3.aml, Sat May 26 18:40:30 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00001C9C (7324)
 *     Revision         0x02
 *     Checksum         0x38
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "RVP7Rtd3"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "RVP7Rtd3", 0x00001000)
{
    External (_SB_.GGOV, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.GPC0, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.OSCO, UnknownObj)    // (from opcode)
    External (_SB_.PCI0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.GEXP, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.GEXP.GEPS, MethodObj)    // 2 Arguments (from opcode)
    External (_SB_.PCI0.GEXP.SGEP, MethodObj)    // 3 Arguments (from opcode)
    External (_SB_.PCI0.GLAN, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C0.TPD0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.TPL1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.ECAV, IntObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.H_EC.SPT2, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP01.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP01.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP02.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP02.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP02.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP03.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP03.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP03.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP04.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP04.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP04.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP05.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP05.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP05.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP06.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP06.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP06.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP07.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP07.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP07.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP08.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP08.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP08.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP09.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP09.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP09.PCRA, MethodObj)    // 3 Arguments (from opcode)
    External (_SB_.PCI0.RP09.PCRO, MethodObj)    // 3 Arguments (from opcode)
    External (_SB_.PCI0.RP09.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP10.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP10.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP10.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP11.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP11.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP11.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP12.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP12.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP12.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP13.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP13.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP13.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP14.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP14.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP14.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP15.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP15.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP15.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP16.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP16.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP16.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP17.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP17.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP17.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP18.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP18.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP18.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP19.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP19.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP19.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP20.D3HT, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.RP20.DPGE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.L23E, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.L23R, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.LASX, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.LDIS, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.LEDM, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP20.VDID, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.SAT0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT2, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT3, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT4, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.SAT0.PRT5, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XDCI, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XDCI.D0I3, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.XDCI.XDCB, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.XHC_, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.MEMB, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.PMEE, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.PMES, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.RHUB.HS01, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.RHUB.HS02, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)    // (from opcode)
    External (_SB_.SGOV, MethodObj)    // 2 Arguments (from opcode)
    External (_SB_.SHPO, MethodObj)    // 2 Arguments (from opcode)
    External (_SB_.SPC0, MethodObj)    // 2 Arguments (from opcode)
    External (ADBG, MethodObj)    // 1 Arguments (from opcode)
    External (AUDD, FieldUnitObj)    // (from opcode)
    External (DVID, UnknownObj)    // (from opcode)
    External (ECON, IntObj)    // (from opcode)
    External (GBEP, UnknownObj)    // (from opcode)
    External (I20D, FieldUnitObj)    // (from opcode)
    External (I21D, FieldUnitObj)    // (from opcode)
    External (IC0D, FieldUnitObj)    // (from opcode)
    External (IC1D, FieldUnitObj)    // (from opcode)
    External (IC1S, FieldUnitObj)    // (from opcode)
    External (MMRP, MethodObj)    // 1 Arguments (from opcode)
    External (MMTB, MethodObj)    // 1 Arguments (from opcode)
    External (OSYS, UnknownObj)    // (from opcode)
    External (PCHG, UnknownObj)    // (from opcode)
    External (PCHS, UnknownObj)    // (from opcode)
    External (PEP0, UnknownObj)    // (from opcode)
    External (PEP3, UnknownObj)    // (from opcode)
    External (RCG0, IntObj)    // (from opcode)
    External (RCG1, IntObj)    // (from opcode)
    External (RIC0, FieldUnitObj)    // (from opcode)
    External (RTBC, IntObj)    // (from opcode)
    External (RTBT, IntObj)    // (from opcode)
    External (RTD3, IntObj)    // (from opcode)
    External (S0ID, UnknownObj)    // (from opcode)
    External (SDS0, FieldUnitObj)    // (from opcode)
    External (SDS1, FieldUnitObj)    // (from opcode)
    External (SGMD, UnknownObj)    // (from opcode)
    External (SHSB, FieldUnitObj)    // (from opcode)
    External (SPST, IntObj)    // (from opcode)
    External (TBCD, IntObj)    // (from opcode)
    External (TBHR, IntObj)    // (from opcode)
    External (TBOD, IntObj)    // (from opcode)
    External (TBPE, IntObj)    // (from opcode)
    External (TBRP, IntObj)    // (from opcode)
    External (TBSE, IntObj)    // (from opcode)
    External (TBTS, IntObj)    // (from opcode)
    External (TOFF, IntObj)    // (from opcode)
    External (TRD3, IntObj)    // (from opcode)
    External (TRDO, IntObj)    // (from opcode)
    External (UAMS, UnknownObj)    // (from opcode)
    External (VRRD, FieldUnitObj)    // (from opcode)
    External (VRSD, FieldUnitObj)    // (from opcode)
    External (XDST, IntObj)    // (from opcode)
    External (XHPR, UnknownObj)    // (from opcode)

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
                    Store (0x00, WKEN)
                    Store (0x02, TOFF)
                }
                ElseIf (LAnd (Arg0, Arg2))
                {
                    Store (0x01, WKEN)
                    Store (0x01, TOFF)
                }
                Else
                {
                    Store (0x00, WKEN)
                    Store (0x00, TOFF)
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
                    Store (0x01, TRDO)
                    PON ()
                    Store (0x00, TRDO)
                    ADBG ("E_ON")
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    ADBG ("S_OFF")
                    Store (0x01, TRD3)
                    POFF ()
                    Store (0x00, TRD3)
                    ADBG ("E_OFF")
                }
            }

            Method (PSTA, 0, NotSerialized)
            {
                If (LNotEqual (DerefOf (Index (PWRG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x01))
                    {
                        If (LEqual (\_SB.GGOV (DerefOf (Index (PWRG, 0x02))), DerefOf (Index (PWRG, 0x03))))
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
                        If (LEqual (\_SB.PCI0.GEXP.GEPS (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02))), DerefOf (Index (PWRG, 0x03))))
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
                        If (LEqual (\_SB.GGOV (DerefOf (Index (RSTG, 0x02))), DerefOf (Index (RSTG, 0x03))))
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
                        If (LEqual (\_SB.PCI0.GEXP.GEPS (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02))), DerefOf (Index (RSTG, 0x03))))
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
                Store (0x09, P2TB)
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

                Store (0x00, P2TB)
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

                Store (0x00, TOFF)
                Store (0x00, G2SD)
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
                        Store (0x01, TBPE)
                        Sleep (0x0A)
                    }

                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02)), DerefOf (Index (PWRG, 0x03)))
                        Store (0x01, TBPE)
                        Sleep (0x0A)
                    }
                }

                If (LNotEqual (DerefOf (Index (RSTG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x01))
                    {
                        \_SB.SPC0 (DerefOf (Index (RSTG, 0x02)), Or (\_SB.GPC0 (DerefOf (Index (RSTG, 0x02))), 0x0100))
                    }

                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02)), DerefOf (Index (RSTG, 0x03)))
                    }
                }

                Store (0x00, DPGE)
                Store (0x01, L2TR)
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

                Store (0x01, DPGE)
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

                Store (0x00, LEDM)
                Store (PSD0, Local1)
                Store (0x00, PSD0)
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
                Store (Local1, PSD0)
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
                Store (0x00, PSD0)
                Store (P2TB, Local3)
                If (LGreater (TOFF, 0x01))
                {
                    Sleep (0x0A)
                    Store (Local1, PSD0)
                    Return (Zero)
                }

                Store (0x00, TOFF)
                Store (Local1, PSD0)
                Store (0x01, L2TE)
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

                Store (0x01, LEDM)
                If (LNotEqual (DerefOf (Index (RSTG, 0x00)), 0x00))
                {
                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x01))
                    {
                        \_SB.SPC0 (DerefOf (Index (RSTG, 0x02)), And (\_SB.GPC0 (DerefOf (Index (RSTG, 0x02))), 0xFFFFFEFF, Local4))
                        Sleep (0x0A)
                    }

                    If (LEqual (DerefOf (Index (RSTG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (RSTG, 0x01)), DerefOf (Index (RSTG, 0x02)), XOr (DerefOf (Index (RSTG, 0x03)), 0x01))
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
                        \_SB.SGOV (DerefOf (Index (PWRG, 0x02)), XOr (DerefOf (Index (PWRG, 0x03)), 0x01))
                    }

                    If (LEqual (DerefOf (Index (PWRG, 0x00)), 0x02))
                    {
                        \_SB.PCI0.GEXP.SGEP (DerefOf (Index (PWRG, 0x01)), DerefOf (Index (PWRG, 0x02)), XOr (DerefOf (Index (PWRG, 0x03)), 0x01))
                    }
                }

                Store (0x00, TBPE)
                Store (0x01, LDIS)
                Store (0x00, LDIS)
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
                            \_SB.PCI0.GEXP.SGEP (DerefOf (Index (WAKG, 0x01)), DerefOf (Index (WAKG, 0x02)), DerefOf (Index (WAKG, 0x03)))
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

