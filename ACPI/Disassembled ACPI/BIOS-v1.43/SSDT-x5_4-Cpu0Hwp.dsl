/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-x5_4-Cpu0Hwp.aml, Mon Dec 16 16:11:48 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000BA (186)
 *     Revision         0x02
 *     Checksum         0x7D
 *     OEM ID           "PmRef"
 *     OEM Table ID     "Cpu0Hwp"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "PmRef", "Cpu0Hwp", 0x00003000)
{
    External (_PR_.CFGD, IntObj)
    External (_PR_.HWPA, FieldUnitObj)
    External (_PR_.HWPV, IntObj)
    External (_PR_.PR00, DeviceObj)
    External (_PR_.PR00.CPC2, PkgObj)
    External (_PR_.PR00.CPOC, PkgObj)
    External (CPC2, IntObj)
    External (CPOC, IntObj)
    External (TCNT, FieldUnitObj)

    Scope (\_PR.PR00)
    {
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            If (And (\_PR.CFGD, 0x01000000))
            {
                Return (CPOC) /* External reference */
            }
            Else
            {
                Return (CPC2) /* External reference */
            }
        }
    }
}

