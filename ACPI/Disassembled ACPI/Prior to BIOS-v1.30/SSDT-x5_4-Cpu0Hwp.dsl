/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-x5_4-Cpu0Hwp.aml, Sat May 26 18:40:31 2018
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
    External (_PR_.CFGD, IntObj)    // (from opcode)
    External (_PR_.HWPA, FieldUnitObj)    // (from opcode)
    External (_PR_.HWPV, IntObj)    // (from opcode)
    External (_PR_.PR00, DeviceObj)    // (from opcode)
    External (_PR_.PR00.CPC2, PkgObj)    // (from opcode)
    External (_PR_.PR00.CPOC, PkgObj)    // (from opcode)
    External (CPC2, IntObj)    // Warning: Unknown object
    External (CPOC, IntObj)    // Warning: Unknown object
    External (TCNT, FieldUnitObj)    // (from opcode)

    Scope (\_PR.PR00)
    {
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            If (And (\_PR.CFGD, 0x01000000))
            {
                Return (CPOC)
            }
            Else
            {
                Return (CPC2)
            }
        }
    }
}

