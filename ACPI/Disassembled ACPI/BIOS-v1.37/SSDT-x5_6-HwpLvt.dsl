/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190405 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-x5_6-HwpLvt.aml, Tue Apr 30 02:38:48 2019
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000628 (1576)
 *     Revision         0x02
 *     Checksum         0x85
 *     OEM ID           "PmRef"
 *     OEM Table ID     "HwpLvt"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "PmRef", "HwpLvt", 0x00003000)
{
    External (_PR_.PR00, DeviceObj)
    External (_PR_.PR01, ProcessorObj)
    External (_PR_.PR02, ProcessorObj)
    External (_PR_.PR03, ProcessorObj)
    External (_PR_.PR04, ProcessorObj)
    External (_PR_.PR05, ProcessorObj)
    External (_PR_.PR06, ProcessorObj)
    External (_PR_.PR07, ProcessorObj)
    External (_PR_.PR08, ProcessorObj)
    External (_PR_.PR09, ProcessorObj)
    External (_PR_.PR10, ProcessorObj)
    External (_PR_.PR11, ProcessorObj)
    External (_PR_.PR12, ProcessorObj)
    External (_PR_.PR13, ProcessorObj)
    External (_PR_.PR14, ProcessorObj)
    External (_PR_.PR15, ProcessorObj)
    External (TCNT, FieldUnitObj)

    Scope (\_GPE)
    {
        Method (HLVT, 0, Serialized)
        {
            Switch (ToInteger (TCNT))
            {
                Case (0x10)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                    Notify (\_PR.PR07, 0x83) // Device-Specific Change
                    Notify (\_PR.PR08, 0x83) // Device-Specific Change
                    Notify (\_PR.PR09, 0x83) // Device-Specific Change
                    Notify (\_PR.PR10, 0x83) // Device-Specific Change
                    Notify (\_PR.PR11, 0x83) // Device-Specific Change
                    Notify (\_PR.PR12, 0x83) // Device-Specific Change
                    Notify (\_PR.PR13, 0x83) // Device-Specific Change
                    Notify (\_PR.PR14, 0x83) // Device-Specific Change
                    Notify (\_PR.PR15, 0x83) // Device-Specific Change
                }
                Case (0x0E)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                    Notify (\_PR.PR07, 0x83) // Device-Specific Change
                    Notify (\_PR.PR08, 0x83) // Device-Specific Change
                    Notify (\_PR.PR09, 0x83) // Device-Specific Change
                    Notify (\_PR.PR10, 0x83) // Device-Specific Change
                    Notify (\_PR.PR11, 0x83) // Device-Specific Change
                    Notify (\_PR.PR12, 0x83) // Device-Specific Change
                    Notify (\_PR.PR13, 0x83) // Device-Specific Change
                }
                Case (0x0C)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                    Notify (\_PR.PR07, 0x83) // Device-Specific Change
                    Notify (\_PR.PR08, 0x83) // Device-Specific Change
                    Notify (\_PR.PR09, 0x83) // Device-Specific Change
                    Notify (\_PR.PR10, 0x83) // Device-Specific Change
                    Notify (\_PR.PR11, 0x83) // Device-Specific Change
                }
                Case (0x0A)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                    Notify (\_PR.PR07, 0x83) // Device-Specific Change
                    Notify (\_PR.PR08, 0x83) // Device-Specific Change
                    Notify (\_PR.PR09, 0x83) // Device-Specific Change
                }
                Case (0x08)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                    Notify (\_PR.PR07, 0x83) // Device-Specific Change
                }
                Case (0x07)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                    Notify (\_PR.PR06, 0x83) // Device-Specific Change
                }
                Case (0x06)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                    Notify (\_PR.PR05, 0x83) // Device-Specific Change
                }
                Case (0x05)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                    Notify (\_PR.PR04, 0x83) // Device-Specific Change
                }
                Case (0x04)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                    Notify (\_PR.PR03, 0x83) // Device-Specific Change
                }
                Case (0x03)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                    Notify (\_PR.PR02, 0x83) // Device-Specific Change
                }
                Case (0x02)
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                    Notify (\_PR.PR01, 0x83) // Device-Specific Change
                }
                Default
                {
                    Notify (\_PR.PR00, 0x83) // Device-Specific Change
                }

            }
        }
    }
}

