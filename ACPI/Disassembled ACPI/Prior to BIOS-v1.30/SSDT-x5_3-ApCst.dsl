/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-x5_3-ApCst.aml, Sat May 26 18:40:31 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000030A (778)
 *     Revision         0x02
 *     Checksum         0x93
 *     OEM ID           "PmRef"
 *     OEM Table ID     "ApCst"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "PmRef", "ApCst", 0x00003000)
{
    External (_PR_.PR00._CST, UnknownObj)    // (from opcode)
    External (_PR_.PR01, DeviceObj)    // (from opcode)
    External (_PR_.PR02, DeviceObj)    // (from opcode)
    External (_PR_.PR03, DeviceObj)    // (from opcode)
    External (_PR_.PR04, DeviceObj)    // (from opcode)
    External (_PR_.PR05, DeviceObj)    // (from opcode)
    External (_PR_.PR06, DeviceObj)    // (from opcode)
    External (_PR_.PR07, DeviceObj)    // (from opcode)
    External (_PR_.PR08, DeviceObj)    // (from opcode)
    External (_PR_.PR09, DeviceObj)    // (from opcode)
    External (_PR_.PR10, DeviceObj)    // (from opcode)
    External (_PR_.PR11, DeviceObj)    // (from opcode)
    External (_PR_.PR12, DeviceObj)    // (from opcode)
    External (_PR_.PR13, DeviceObj)    // (from opcode)
    External (_PR_.PR14, DeviceObj)    // (from opcode)
    External (_PR_.PR15, DeviceObj)    // (from opcode)

    Scope (\_PR.PR01)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR02)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR03)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR04)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR05)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR06)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR07)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR08)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR09)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR10)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR11)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR12)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR13)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR14)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }

    Scope (\_PR.PR15)
    {
        Method (_CST, 0, NotSerialized)  // _CST: C-States
        {
            Return (\_PR.PR00._CST)
        }
    }
}

