/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-x5_2-Cpu0Cst.aml, Sat May 26 18:40:31 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000003FF (1023)
 *     Revision         0x02
 *     Checksum         0x11
 *     OEM ID           "PmRef"
 *     OEM Table ID     "Cpu0Cst"
 *     OEM Revision     0x00003001 (12289)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160527 (538314023)
 */
DefinitionBlock ("", "SSDT", 2, "PmRef", "Cpu0Cst", 0x00003001)
{
    External (_PR_.C3LT, FieldUnitObj)
    External (_PR_.C3MW, FieldUnitObj)
    External (_PR_.C6LT, FieldUnitObj)
    External (_PR_.C6MW, FieldUnitObj)
    External (_PR_.C7LT, FieldUnitObj)
    External (_PR_.C7MW, FieldUnitObj)
    External (_PR_.CDLT, FieldUnitObj)
    External (_PR_.CDLV, FieldUnitObj)
    External (_PR_.CDMW, FieldUnitObj)
    External (_PR_.CDPW, FieldUnitObj)
    External (_PR_.CFGD, UnknownObj)    // Warning: Unknown object
    External (_PR_.PR00, DeviceObj)    // (from opcode)
    External (C3LT, UnknownObj)    // (from opcode)
    External (C3MW, UnknownObj)    // (from opcode)
    External (C6LT, UnknownObj)    // (from opcode)
    External (C6MW, UnknownObj)    // (from opcode)
    External (C7LT, UnknownObj)    // (from opcode)
    External (C7MW, UnknownObj)    // (from opcode)
    External (CDLT, UnknownObj)    // (from opcode)
    External (CDLV, UnknownObj)    // (from opcode)
    External (CDMW, UnknownObj)    // (from opcode)
    External (CDPW, UnknownObj)    // (from opcode)
    External (CFGD, UnknownObj)    // (from opcode)
    External (FEMD, UnknownObj)    // (from opcode)
    External (FMBL, UnknownObj)    // (from opcode)
    External (PC00, UnknownObj)    // (from opcode)
    External (PFLV, UnknownObj)    // (from opcode)

    Scope (\_PR.PR00)
    {
        Name (C1TM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x00,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000000, // Address
                    ,)
            }, 

            One, 
            One, 
            0x03E8
        })
        Name (C3TM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000001814, // Address
                    ,)
            }, 

            0x02, 
            Zero, 
            0x01F4
        })
        Name (C6TM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000001815, // Address
                    ,)
            }, 

            0x02, 
            Zero, 
            0x015E
        })
        Name (C7TM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000001816, // Address
                    ,)
            }, 

            0x02, 
            Zero, 
            0xC8
        })
        Name (CDTM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000001816, // Address
                    ,)
            }, 

            0x03, 
            Zero, 
            Zero
        })
        Name (MWES, ResourceTemplate ()
        {
            Register (FFixedHW, 
                0x01,               // Bit Width
                0x02,               // Bit Offset
                0x0000000000000000, // Address
                0x01,               // Access Size
                )
        })
        Name (AC2V, Zero)
        Name (AC3V, Zero)
        Name (C3ST, Package (0x04)
        {
            0x03, 
            Package (0x01)
            {
                Zero
            }, 

            Package (0x01)
            {
                Zero
            }, 

            Package (0x01)
            {
                Zero
            }
        })
        Name (C2ST, Package (0x03)
        {
            0x02, 
            Package (0x01)
            {
                Zero
            }, 

            Package (0x01)
            {
                Zero
            }
        })
        Name (C1ST, Package (0x02)
        {
            One, 
            Package (0x01)
            {
                Zero
            }
        })
        Name (CSTF, Zero)
        Method (_CST, 0, Serialized)  // _CST: C-States
        {
            If (LNot (CSTF))
            {
                Store (C3LT, Index (C3TM, 0x02))
                Store (C6LT, Index (C6TM, 0x02))
                Store (C7LT, Index (C7TM, 0x02))
                Store (CDLT, Index (CDTM, 0x02))
                Store (CDPW, Index (CDTM, 0x03))
                Store (CDLV, Index (DerefOf (Index (CDTM, Zero)), 0x07))
                If (LAnd (And (CFGD, 0x0800), And (PC00, 0x0200)))
                {
                    Store (MWES, Index (C1TM, Zero))
                    Store (MWES, Index (C3TM, Zero))
                    Store (MWES, Index (C6TM, Zero))
                    Store (MWES, Index (C7TM, Zero))
                    Store (MWES, Index (CDTM, Zero))
                    Store (C3MW, Index (DerefOf (Index (C3TM, Zero)), 0x07))
                    Store (C6MW, Index (DerefOf (Index (C6TM, Zero)), 0x07))
                    Store (C7MW, Index (DerefOf (Index (C7TM, Zero)), 0x07))
                    Store (CDMW, Index (DerefOf (Index (CDTM, Zero)), 0x07))
                }
                ElseIf (LAnd (And (CFGD, 0x0800), And (PC00, 0x0100)))
                {
                    Store (MWES, Index (C1TM, Zero))
                }

                Store (Ones, CSTF)
            }

            Store (Zero, AC2V)
            Store (Zero, AC3V)
            Store (C1TM, Index (C3ST, One))
            If (And (CFGD, 0x20))
            {
                Store (C7TM, Index (C3ST, 0x02))
                Store (Ones, AC2V)
            }
            ElseIf (And (CFGD, 0x10))
            {
                Store (C6TM, Index (C3ST, 0x02))
                Store (Ones, AC2V)
            }
            ElseIf (And (CFGD, 0x08))
            {
                Store (C3TM, Index (C3ST, 0x02))
                Store (Ones, AC2V)
            }

            If (And (CFGD, 0x4000))
            {
                Store (CDTM, Index (C3ST, 0x03))
                Store (Ones, AC3V)
            }

            If (LAnd (AC2V, AC3V))
            {
                Return (C3ST)
            }
            ElseIf (AC2V)
            {
                Store (DerefOf (Index (C3ST, One)), Index (C2ST, One))
                Store (DerefOf (Index (C3ST, 0x02)), Index (C2ST, 0x02))
                Return (C2ST)
            }
            ElseIf (AC3V)
            {
                Store (DerefOf (Index (C3ST, One)), Index (C2ST, One))
                Store (DerefOf (Index (C3ST, 0x03)), Index (C2ST, 0x02))
                Store (0x02, Index (DerefOf (Index (C2ST, 0x02)), One))
                Return (C2ST)
            }
            Else
            {
                Store (DerefOf (Index (C3ST, One)), Index (C1ST, One))
                Return (C1ST)
            }
        }
    }
}

