/**
 * Thunderbolt For Alpine Ridge on X1C6
 * 
 * Large parts (link training and enumeration) 
 * taken from decompiled Mac AML.
 *
 * Implements mostly of the ACPI-part for handling Thunderbolt 3 on an Lenovo X1C6. Does power management and force power management for TB & USB 3.1.
 * WIP but should be complete now. And full of bugs. Its largely untested. Intended to give a mostly complete and as native as possible experience.
 * Pair with SSDT-XHC1.dsl (native USB 2.0/3.0), SSDT-XHC2.dsl (USB 3.1) & SSDT-PTS.dsl (handling sleep).
 * See config.plist for details.
 * 
 * Copyright (c) 2019 osy86
 * Copyleft (c) 2020 benben
 *
 * Debugging & Bug-reports:
 * sudo dmesg|egrep -i "PMRD|ACPI Debug|Thunderbolt|usb"|less
 *
 * Platform-reference: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Intel/KabylakeOpenBoardPkg/Features/Tbt/AcpiTables
 * osy86-implementation: https://github.com/osy86/HaC-Mini/blob/master/ACPI/SSDT-TbtOnPCH.asl
 */
DefinitionBlock ("", "SSDT", 2, "tyler", "_TB3", 0x00001000)
{
    /* Support methods */
    External (DTGP, MethodObj)    // 5 Arguments
    // OS Is Darwin?
    External (OSDW, MethodObj)    // 0 Arguments

    /* Patching existing devices */
    External (\_SB.PCI0.RP09, DeviceObj)
    External (\_SB.PCI0.RP09.LEDM, FieldUnitObj)
    External (\_SB.PCI0.RP09.L23E, FieldUnitObj)
    External (\_SB.PCI0.RP09.L23R, FieldUnitObj)
    External (\_SB.PCI0.RP09.LDIS, FieldUnitObj)
    External (\_SB.PCI0.RP09.PXSX, DeviceObj)
    External (\_SB.PCI0.RP09.PXSX.TBDU, DeviceObj)
    External (\_SB.PCI0.XHC1, DeviceObj)

    External (\_SB.PCI0.RP09.XINI, MethodObj)         // original _INI patched by OC
    External (\_SB.PCI0.RP09.XPS0, MethodObj)         // original _PS0 patched by OC
    External (\_SB.PCI0.RP09.XPS3, MethodObj)         // original _PS3 patched by OC

    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2, DeviceObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND, FieldUnitObj)

    // get PCI MMIO base
    External (_SB.PCI0.GPCB, MethodObj)              
    // Get GPI Input Value
    External (_SB_.GGII, MethodObj)    // 1 Arguments
    // Set GPI Input Value
    External (_SB_.SGII, MethodObj)    // 2 Arguments
    // Get GPO Output Value
    External (_SB_.GGOV, MethodObj)    // 1 Arguments    
    // Set GPO Output Value
    External (_SB_.SGOV, MethodObj)    // 2 Arguments
    // Get GPIO group index for GpioPad
    External (GGRP, MethodObj)    // 1 Arguments
    // Get GPIO pin number for GpioPad
    External (GNMB, MethodObj)    // 1 Arguments
    // Get GPIO register address
    // This is internal library function
    External (GADR, MethodObj)    // 2 Arguments
    // Memory mapped root port
    External (MMRP, MethodObj)      // 1 Arguments
    // Memory mapped TB port
    External (MMTB, MethodObj)      // 1 Arguments

    External (TBSE, FieldUnitObj)   // TB root port number
    External (TBTS, FieldUnitObj)   // TB enabled?
    External (SLTP, IntObj)

    External (_GPE.XTFY, MethodObj)      // 1 Arguments

    Scope (\_GPE)
    {
        Method (NTFY, 1, Serialized)
        {
            If (OSDW ())
            {
                Debug = "TB:_GPE:NTFY()"

                \_SB.PCI0.RP09.UPSB.AMPE ()
            }
            Else
            {
                XTFY(Arg0)
            }
        }
    }

    Scope (\_SB)
    {
        Method (SGDI, 1, Serialized)
        {
            Local0 = GGRP (Arg0)
            Local1 = GNMB (Arg0)
            Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
            OperationRegion (PDW0, SystemMemory, Local2, 0x04)
            Field (PDW0, AnyAcc, NoLock, Preserve)
            {
                Offset (0x01), 
                TEMP,   2, 
                Offset (0x04)
            }

            TEMP = One
        }

        Method (SGDO, 1, Serialized)
        {
            Local0 = GGRP (Arg0)
            Local1 = GNMB (Arg0)
            Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
            OperationRegion (PDW0, SystemMemory, Local2, 0x04)
            Field (PDW0, AnyAcc, NoLock, Preserve)
            {
                Offset (0x01), 
                TEMP,   2, 
                Offset (0x04)
            }

            TEMP = 0x02
        }

        Method (GGDV, 1, Serialized)
        {
            Local0 = GGRP (Arg0)
            Local1 = GNMB (Arg0)
            Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
            OperationRegion (PDW0, SystemMemory, Local2, 0x04)
            Field (PDW0, AnyAcc, NoLock, Preserve)
            {
                Offset (0x01), 
                TEMP,   2, 
                Offset (0x04)
            }

            If (TEMP == One)
            {
                Return (One)
            }
            ElseIf (TEMP == 0x02)
            {
                Return (Zero)
            }
            Else
            {
                Return (One)
            }
        }

    }

    Scope (\_SB.PCI0.RP09)
    {
        Name (EICM, Zero)
        Name (R020, Zero) // RP base/limit from UEFI
        Name (R024, Zero) // RP prefetch base/limit from UEFI
        Name (R028, Zero)
        Name (R02C, Zero)

        Name (R118, Zero) // UPSB Pri Bus = RP Sec Bus (UEFI)
        Name (R119, Zero) // UPSB Sec Bus = RP Sec Bus + 1
        Name (R11A, Zero) // UPSB Sub Bus = RP Sub Bus (UEFI)
        Name (R11C, Zero) // UPSB IO base/limit = RP IO base/limit (UEFI)
        Name (R120, Zero) // UPSB mem base/limit = RP mem base/limit (UEFI)
        Name (R124, Zero) // UPSB pre base/limit = RP pre base/limit (UEFI)
        Name (R128, Zero)
        Name (R12C, Zero)

        Name (R218, Zero) // DSB0 Pri Bus = UPSB Sec Bus
        Name (R219, Zero) // DSB0 Sec Bus = UPSB Sec Bus + 1
        Name (R21A, Zero) // DSB0 Sub Bus = UPSB Sub Bus
        Name (R21C, Zero) // DSB0 IO base/limit = UPSB IO base/limit
        Name (R220, Zero) // DSB0 mem base/limit = UPSB mem base/limit
        Name (R224, Zero) // DSB0 pre base/limit = UPSB pre base/limit
        Name (R228, Zero)
        Name (R22C, Zero)

        Name (R318, Zero) // DSB1 Pri Bus = UPSB Sec Bus
        Name (R319, Zero) // DSB1 Sec Bus = UPSB Sec Bus + 2
        Name (R31A, Zero) // DSB1 Sub Bus = no children
        Name (R31C, Zero) // DSB1 disable IO
        Name (R320, Zero) // DSB1 disable mem
        Name (R324, Zero) // DSB1 disable prefetch
        Name (R328, Zero)
        Name (R32C, Zero)

        Name (R418, Zero) // DSB2 Pri Bus = UPSB Sec Bus
        Name (R419, Zero) // DSB2 Sec Bus = UPSB Sec Bus + 3
        Name (R41A, Zero) // DSB2 Sub Bus = no children
        Name (R41C, Zero) // DSB2 disable IO
        Name (R420, Zero) // DSB2 disable mem
        Name (R424, Zero) // DSB2 disable prefetch
        Name (R428, Zero)
        Name (R42C, Zero)

        Name (RVES, Zero) // DSB2 offset 0x564, unknown
        Name (R518, Zero) // DSB4 Pri Bus = UPSB Sec Bus
        Name (R519, Zero) // DSB4 Sec Bus = UPSB Sec Bus + 4
        Name (R51A, Zero) // DSB4 Sub Bus = no children
        Name (R51C, Zero) // DSB4 disable IO
        Name (R520, Zero) // DSB4 disable mem
        Name (R524, Zero) // DSB4 disable prefetch
        Name (R528, Zero)
        Name (R52C, Zero)

        Name (R618, Zero)
        Name (R619, Zero)
        Name (R61A, Zero)
        Name (R61C, Zero)
        Name (R620, Zero)
        Name (R624, Zero)
        Name (R628, Zero)
        Name (R62C, Zero)

        Name (RH10, Zero) // NHI0 BAR0 = DSB0 mem base
        Name (RH14, Zero) // NHI0 BAR1 unused
        Name (POC0, Zero)

        Name (TBH1, Zero)
        Name (BICM, Zero) // Boot windows?

        /**
         * Get PCI base address
         * Arg0 = bus, Arg1 = device, Arg2 = function
         */
        Method (MMIO, 3, NotSerialized)
        {
            Local0 = \_SB.PCI0.GPCB () // base address
            Local0 += (Arg0 << 20)
            Local0 += (Arg1 << 15)
            Local0 += (Arg2 << 12)
            Return (Local0)
        }

        // OperationRegion (RSTR, SystemMemory, NHI1, 0x0100)
        OperationRegion (RSTR, SystemMemory, NH10 + 0x39858, 0x0100)
        Field (RSTR, DWordAcc, NoLock, Preserve)
        {
            CIOR,   32, 
            Offset (0xB8), 
            ISTA,   32, 
            Offset (0xF0), 
            ICME,   32
        }

        // OperationRegion (T2PM, SystemMemory, T2P1, 0x08)
        // Field (T2PM, DWordAcc, NoLock, Preserve)
        // {
        //     T2PR,   32, 
        //     P2TR,   32
        // }

        // OperationRegion (RPSM, SystemMemory, 0xE00E4000, 0x54)
        // Root port configuration base
        OperationRegion (RPSM, SystemMemory, MMRP (TBSE), 0x54)
        Field (RPSM, DWordAcc, NoLock, Preserve)
        {
            RPVD,   32, 
            RPR4,   8, 
            Offset (0x18), 
            RP18,   8, 
            RP19,   8, 
            RP1A,   8, 
            Offset (0x1C), 
            RP1C,   16, 
            Offset (0x20), 
            R_20,   32, 
            R_24,   32, 
            R_28,   32, 
            R_2C,   32, 
            Offset (0x52), 
                ,   11, 
            RPLT,   1, 
            Offset (0x54)
        }

        // OperationRegion (UPSM, SystemMemory, TUP1, 0x0548)
        // UPSB (up stream port) configuration base
        OperationRegion (UPSM, SystemMemory, MMTB (TBSE), 0x0550)
        Field (UPSM, DWordAcc, NoLock, Preserve)
        {
            UPVD,   32, 
            UP04,   8, 
            Offset (0x08), 
            CLRD,   32, 
            Offset (0x18), 
            UP18,   8, 
            UP19,   8, 
            UP1A,   8, 
            Offset (0x1C), 
            UP1C,   16, 
            Offset (0x20), 
            UP20,   32, 
            UP24,   32, 
            UP28,   32, 
            UP2C,   32, 
            Offset (0xD2), 
                ,   11, 
            UPLT,   1, 
            Offset (0xD4), 
            Offset (0x544), 
            UPMB,   1, 
            Offset (0x548),
            T2PR,   32, 
            P2TR,   32
        }

        // OperationRegion (DNSM, SystemMemory, TDB1, 0xD4)
        // DSB0 configuration base
        OperationRegion (DNSM, SystemMemory, MMIO (UP19, 0, 0), 0xD4)
        Field (DNSM, DWordAcc, NoLock, Preserve)
        {
            DPVD,   32, 
            DP04,   8, 
            Offset (0x18), 
            DP18,   8, 
            DP19,   8, 
            DP1A,   8, 
            Offset (0x1C), 
            DP1C,   16, 
            Offset (0x20), 
            DP20,   32, 
            DP24,   32, 
            DP28,   32, 
            DP2C,   32, 
            Offset (0xD2), 
                ,   11, 
            DPLT,   1, 
            Offset (0xD4)
        }

        // OperationRegion (DS3M, SystemMemory, TD11, 0x40)
        // DSB1 configuration base
        OperationRegion (DS3M, SystemMemory, MMIO (UP19, 1, 0), 0x40)
        Field (DS3M, DWordAcc, NoLock, Preserve)
        {
            D3VD,   32, 
            D304,   8, 
            Offset (0x18), 
            D318,   8, 
            D319,   8, 
            D31A,   8, 
            Offset (0x1C), 
            D31C,   16, 
            Offset (0x20), 
            D320,   32, 
            D324,   32, 
            D328,   32, 
            D32C,   32
        }

        // OperationRegion (DS4M, SystemMemory, TD21, 0x0568)
        // DSB2 configuration base
        OperationRegion (DS4M, SystemMemory, MMIO (UP19, 2, 0), 0x0568)
        Field (DS4M, DWordAcc, NoLock, Preserve)
        {
            D4VD,   32, 
            D404,   8, 
            Offset (0x18), 
            D418,   8, 
            D419,   8, 
            D41A,   8, 
            Offset (0x1C), 
            D41C,   16, 
            Offset (0x20), 
            D420,   32, 
            D424,   32, 
            D428,   32, 
            D42C,   32, 
            Offset (0x564), 
            DVES,   32
        }

        // OperationRegion (DS5M, SystemMemory, TD41, 0x40)
        // DSB4 configuration base
        OperationRegion (DS5M, SystemMemory, MMIO (UP19, 4, 0), 0x40)
        Field (DS5M, DWordAcc, NoLock, Preserve)
        {
            D5VD,   32, 
            D504,   8, 
            Offset (0x18), 
            D518,   8, 
            D519,   8, 
            D51A,   8, 
            Offset (0x1C), 
            D51C,   16, 
            Offset (0x20), 
            D520,   32, 
            D524,   32, 
            D528,   32, 
            D52C,   32
        }

        // OperationRegion (NHIM, SystemMemory, TNH1, 0x40)
        OperationRegion (NHIM, SystemMemory, MMIO (DP19, 0, 0), 0x40)
        Field (NHIM, DWordAcc, NoLock, Preserve)
        {
            NH00,   32, 
            NH04,   8, 
            Offset (0x10), 
            NH10,   32, 
            NH14,   32
        }

        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            Debug = "TB:_INI"

            \_SB.PCI0.RP09.XINI()

            If (!OSDW ())
            {
                TBH1 = One
                BICM = One

                Debug = "TB:_INI - Save Ridge Config on Boot ICM"

                R020 = R_20 /* \_SB_.PCI0.RP09.R_20 */
                R024 = R_24 /* \_SB_.PCI0.RP09.R_24 */
                R028 = R_28 /* \_SB_.PCI0.RP09.R_28 */
                R02C = R_2C /* \_SB_.PCI0.RP09.R_2C */
                R118 = UP18 /* \_SB_.PCI0.RP09.UP18 */
                R119 = UP19 /* \_SB_.PCI0.RP09.UP19 */
                R11A = UP1A /* \_SB_.PCI0.RP09.UP1A */
                R11C = UP1C /* \_SB_.PCI0.RP09.UP1C */
                R120 = UP20 /* \_SB_.PCI0.RP09.UP20 */
                R124 = UP24 /* \_SB_.PCI0.RP09.UP24 */
                R128 = UP28 /* \_SB_.PCI0.RP09.UP28 */
                R12C = UP2C /* \_SB_.PCI0.RP09.UP2C */
                R218 = DP18 /* \_SB_.PCI0.RP09.DP18 */
                R219 = DP19 /* \_SB_.PCI0.RP09.DP19 */
                R21A = DP1A /* \_SB_.PCI0.RP09.DP1A */
                R21C = DP1C /* \_SB_.PCI0.RP09.DP1C */
                R220 = DP20 /* \_SB_.PCI0.RP09.DP20 */
                R224 = DP24 /* \_SB_.PCI0.RP09.DP24 */
                R228 = DP28 /* \_SB_.PCI0.RP09.DP28 */
                R228 = DP28 /* \_SB_.PCI0.RP09.DP28 */
                R318 = D318 /* \_SB_.PCI0.RP09.D318 */
                R319 = D319 /* \_SB_.PCI0.RP09.D319 */
                R31A = D31A /* \_SB_.PCI0.RP09.D31A */
                R31C = D31C /* \_SB_.PCI0.RP09.D31C */
                R320 = D320 /* \_SB_.PCI0.RP09.D320 */
                R324 = D324 /* \_SB_.PCI0.RP09.D324 */
                R328 = D328 /* \_SB_.PCI0.RP09.D328 */
                R32C = D32C /* \_SB_.PCI0.RP09.D32C */
                R418 = D418 /* \_SB_.PCI0.RP09.D418 */
                R419 = D419 /* \_SB_.PCI0.RP09.D419 */
                R41A = D41A /* \_SB_.PCI0.RP09.D41A */
                R41C = D41C /* \_SB_.PCI0.RP09.D41C */
                R420 = D420 /* \_SB_.PCI0.RP09.D420 */
                R424 = D424 /* \_SB_.PCI0.RP09.D424 */
                R428 = D428 /* \_SB_.PCI0.RP09.D428 */
                R42C = D42C /* \_SB_.PCI0.RP09.D42C */
                RVES = DVES /* \_SB_.PCI0.RP09.DVES */
                R518 = D518 /* \_SB_.PCI0.RP09.D518 */
                R519 = D519 /* \_SB_.PCI0.RP09.D519 */
                R51A = D51A /* \_SB_.PCI0.RP09.D51A */
                R51C = D51C /* \_SB_.PCI0.RP09.D51C */
                R520 = D520 /* \_SB_.PCI0.RP09.D520 */
                R524 = D524 /* \_SB_.PCI0.RP09.D524 */
                R528 = D528 /* \_SB_.PCI0.RP09.D528 */
                R52C = D52C /* \_SB_.PCI0.RP09.D52C */
                RH10 = NH10 /* \_SB_.PCI0.RP09.NH10 */
                RH14 = NH14 /* \_SB_.PCI0.RP09.NH14 */

                Debug = "TB:_INI - Store Complete"
                Debug = "TB:_INI - ICM ready"

                Sleep (One)
                ICMS ()
            }
        }

        /**
         * Boot ICM
         */
        Method (ICMB, 0, NotSerialized)
        {
            If (BICM == One)
            {
                Debug = "TB:ICMB"

                If (!OSDW ())
                {
                    ICMS ()
                    Debug = "TB:ICMB - Enable ICM on Boot, Complete"
                    SGOV (0x02060001, Zero)
                    SGDO (0x02060001)
                    Debug = "TB:ICMB - Enable ICM on Boot, Complete"
                }
            }
        }

        // ICM Start ???
        Method (ICMS, 0, NotSerialized)
        {
            POC0 = One

            Debug = "TB:ICMS - ICME"
            Debug = \_SB.PCI0.RP09.ICME

            If (\_SB.PCI0.RP09.ICME != 0x800001A6 && \_SB.PCI0.RP09.ICME != 0x800000A6)
            {
                If (\_SB.PCI0.RP09.CNHI ())
                {
                    Debug = "TB:ICMS - ICME"
                    Debug = \_SB.PCI0.RP09.ICME

                    If (\_SB.PCI0.RP09.ICME != 0xFFFFFFFF)
                    {
                        SGDI (0x01070004)
                        \_SB.PCI0.RP09.WTLT ()
                        
                        Debug = "TB:ICMS - ICME"
                        Debug = \_SB.PCI0.RP09.ICME

                        If (!Local0 = (\_SB.PCI0.RP09.ICME & 0x80000000)) // NVM started means we need reset
                        {
                            \_SB.PCI0.RP09.ICME |= 0x06 // invert EN | enable CPU
                            Local0 = 1000
                            While ((Local1 = (\_SB.PCI0.RP09.ICME & 0x80000000)) == Zero)
                            {
                                Local0--
                                If (Local0 == Zero)
                                {
                                    Break
                                }

                                Sleep (One)
                            }
                            
                            Debug = "TB:ICMS - TB:ICME"
                            Debug = \_SB.PCI0.RP09.ICME
                            \_SB.SGOV (0x01070004, Zero)
                            \_SB.SGDO (0x01070004)
                        }
                    }
                }
            }

            \_SB.PCI0.RP09.POC0 = Zero

            // disable USB force power
            SGOV (0x01070007, Zero)
            SGDO (0x01070007)
        }

        /**
         * Send TBT command
         */
        Method (TBTC, 1, Serialized)
        {
            Debug = "TB:TBTC - Send TBT command"

            P2TR = Arg0

            Local0 = 0x64
            Local1 = T2PR /* \_SB_.PCI0.RP09.T2PR */

            While ((Local2 = (Local1 & One)) == Zero)
            {
                If (Local1 == 0xFFFFFFFF)
                {
                    Return (Zero)
                }

                Local0--
                If (Local0 == Zero)
                {
                    Break
                }

                Local1 = T2PR /* \_SB_.PCI0.RP09.T2PR */
                Sleep (0x32)
            }

            P2TR = Zero

            Return (Zero)
        }

        /**
         * Plug detection for Windows
         */
        Method (CMPE, 0, Serialized)
        {
            Debug = "TB:CMPE - Plug detection for Windows"

            Notify (\_SB.PCI0.RP09, Zero) // Bus Check
        }

        /**
         * Configure NHI device
         */
        Method (CNHI, 0, Serialized)
        {
            // Configure root port
            Debug = "TB:CNHI - Configure NHI root"
            
            Local0 = 10

            While (Local0)
            {
                R_20 = R020 // Memory Base/Limit
                R_24 = R024 // Prefetch Base/Limit
                R_28 = R028 /* \_SB_.PCI0.RP09.R028 */
                R_2C = R02C /* \_SB_.PCI0.RP09.R02C */

                RPR4 = 0x07 // Command

                If (R020 == R_20)
                {
                    Break
                }

                Sleep (One)

                Local0--
            }

            If (R020 != R_20) // configure failed
            {
                Debug = "TB:CNHI - Configure NHI failed"

                Return (Zero)
            }

            // Configure UPSB
            Debug = "TB:CNHI - Configure UPSB"

            Local0 = 10

            While (Local0)
            {
                UP18 = R118 // UPSB Pri Bus
                UP19 = R119 // UPSB Sec Bus
                UP1A = R11A // UPSB Sub Bus
                UP1C = R11C // UPSB IO Base/Limit
                UP20 = R120 // UPSB Memory Base/Limit
                UP24 = R124 // UPSB Prefetch Base/Limit
                UP28 = R128 /* \_SB_.PCI0.RP09.R128 */
                UP2C = R12C /* \_SB_.PCI0.RP09.R12C */
                UP04 = 0x07 // UPSB Command

                If (R119 == UP19) // read back check
                {
                    Break
                }

                Sleep (One)

                Local0--
            }

            If (R119 != UP19) // configure failed
            {
                Debug = "TB:CNHI - Configure UPSB failed"

                Return (Zero)
            }

            Debug = "TB:CNHI - Wait for link training"

            If (WTLT () != One)
            {
                Debug = "TB:CNHI - Wait for link training failed"

                Return (Zero)
            }

            // Configure DSB0
            Debug = "TB:CNHI - Configure DSB"

            Local0 = 10

            While (Local0)
            {
                DP18 = R218 // Pri Bus
                DP19 = R219 // Sec Bus
                DP1A = R21A // Sub Bus
                DP1C = R21C // IO Base/Limit
                DP20 = R220 // Memory Base/Limit
                DP24 = R224 // Prefetch Base/Limit
                DP28 = R228 /* \_SB_.PCI0.RP09.R228 */
                DP2C = R22C /* \_SB_.PCI0.RP09.R22C */
                DP04 = 0x07 // Command
                Debug = "TB:CNHI - Configure NHI Dp 0 done"

                D318 = R318 // Pri Bus
                D319 = R319 // Sec Bus
                D31A = R31A // Sub Bus
                D31C = R31C // IO Base/Limit
                D320 = R320 // Memory Base/Limit
                D324 = R324 // Prefetch Base/Limit
                D328 = R328 /* \_SB_.PCI0.RP09.R328 */
                D32C = R32C /* \_SB_.PCI0.RP09.R32C */
                D304 = 0x07 // Command
                Debug = "TB:CNHI - Configure NHI Dp 3 done"

                D418 = R418 // Pri Bus
                D419 = R419 // Sec Bus
                D41A = R41A // Sub Bus
                D41C = R41C // IO Base/Limit
                D420 = R420 // Memory Base/Limit
                D424 = R424 // Prefetch Base/Limit
                D428 = R428 /* \_SB_.PCI0.RP09.R428 */
                D42C = R42C /* \_SB_.PCI0.RP09.R42C */
                DVES = RVES // DSB2 0x564
                D404 = 0x07 // Command
                Debug = "TB:CNHI - Configure NHI Dp 4 done"

                D518 = R518 // Pri Bus
                D519 = R519 // Sec Bus
                D51A = R51A // Sub Bus
                D51C = R51C // IO Base/Limit
                D520 = R520 // Memory Base/Limit
                D524 = R524 // Prefetch Base/Limit
                D528 = R528 /* \_SB_.PCI0.RP09.R528 */
                D52C = R52C /* \_SB_.PCI0.RP09.R52C */
                D504 = 0x07 // Command
                Debug = "TB:CNHI - Configure NHI Dp 5 done"

                If (R219 == DP19) // read back check
                {
                    Break
                }

                Sleep (One)
                Local0--
            }

            If (R219 != DP19) // configure failed
            {
                Debug = "TB:CNHI - Configure DSB failed"

                Return (Zero)
            }

            Debug = "TB:CNHI - Wait for down link"
          
            If (WTDL () == One)
            {
                Debug = "TB:CNHI - Configure NHI DPs done"
            }
            Else
            {
                Return (Zero)
            }

            // Configure NHI
            Debug = "TB:CNHI - Configure NHI"

            Local0 = 100

            While (Local0)
            {
                NH10 = RH10 // NHI BAR 0
                NH14 = RH14 // NHI BAR 1
                NH04 = 0x07 // NHI Command

                If (RH10 == NH10) // read back check
                {
                    Break
                }

                Sleep (One)
                Local0--
            }

            // Debug = "TB:CNHI NHI BAR"
            // Debug = NH10

            If (RH10 != NH10) // configure failed
            {
                Return (Zero)
            }

            Debug = "TB:CNHI - CNHI done"

            Return (One)
        }

        /**
         * Uplink check
         */
        Method (UPCK, 0, Serialized)
        {
            Debug = "TB:UBCK - Uplink check - Upstream VID/DID ="
            Debug = UPVD /* \_SB_.PCI0.RP09.UPVD */

            // accepts every intel chip
            If ((UPVD & 0xFFFF) == 0x8086)
            {
                Return (One)
            }

            Return (Zero)
        }

        /**
         * Uplink training check
         */
        Method (ULTC, 0, Serialized)
        {
            Debug = "TB:ULTC - Uplink training check"

            If (RPLT == Zero)
            {
                If (UPLT == Zero)
                {
                    Return (One)
                }
            }

            Return (Zero)
        }

        /**
         * Wait for link training
         */
        Method (WTLT, 0, Serialized)
        {
            Debug = "TB:WTLT - Wait for link training"

            Local0 = 2000
            Local1 = Zero

            While (Local0)
            {
                If (RPR4 == 0x07)
                {
                    If (ULTC ())
                    {
                        If (UPCK ())
                        {
                            Local1 = One
                            Break
                        }
                    }
                }

                Sleep (One)
                Local0--
            }

            // Debug = "TB:WTLT LOOP="
            // Debug = Local0

            Return (Local1)
        }

        /**
         * Downlink training check
         */
        Method (DLTC, 0, Serialized)
        {
            Debug = "TB:DLTC - Downlink training check"

            If (RPLT == Zero)
            {
                If (UPLT == Zero)
                {
                    If (DPLT == Zero)
                    {
                        Return (One)
                    }
                }
            }

            Return (Zero)
        }

        /**
         * Wait for downlink training
         */
        Method (WTDL, 0, Serialized)
        {
            Debug = "TB:WTDL - Wait for downlink training"

            Local0 = 2000
            Local1 = Zero

            While (Local0)
            {
                If (RPR4 == 0x07)
                {
                    If (DLTC ())
                    {
                        If (UPCK ())
                        {
                            Local1 = One
                            Break
                        }
                    }
                }

                Sleep (One)
                Local0--
            }

            // Debug = "TB:WTDL LOOP="
            // Debug = Local0

            Return (Local1)
        }

        Name (IIP3, Zero)
        Name (PRSR, Zero)
        Name (PCIA, One)

        /**
         * Bring up PCI link
         * Train downstream link
         */
        Method (PCEU, 0, Serialized)
        {
            Debug = "TB:PCEU - Bring up PCI link"

            \_SB.PCI0.RP09.PRSR = Zero

            // Debug = "TB:PCEU - Put upstream bridge back into D0 "
            If (\_SB.PCI0.RP09.PSTX != Zero)
            {
                // Debug = "TB:PCEU - exit D0, restored = true"
                \_SB.PCI0.RP09.PRSR = One
                \_SB.PCI0.RP09.PSTX = Zero
            }

            If (\_SB.PCI0.RP09.LDXX == One)
            {
                // Debug = "TB:PCEU - Clear link disable on upstream bridge"
                // Debug = "TB:PCEU - clear link disable, restored = true"
                \_SB.PCI0.RP09.PRSR = One
                \_SB.PCI0.RP09.LDXX = Zero
            }

            If (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.XRTE != Zero)
            {
                // Debug = "TB:PCEU - XRST changed, restored = true"
                \_SB.PCI0.RP09.PRSR = One
                \_SB.PCI0.RP09.UPSB.DSB0.NHI0.XRST (Zero)
            }
        }

        /**
         * Bring down PCI link
         */
        Method (PCDA, 0, Serialized)
        {
            Debug = "TB:PCDA - Bring down PCI link"

            If (\_SB.PCI0.RP09.POFX () != Zero)
            {
                \_SB.PCI0.RP09.PCIA = Zero

                // Debug = "TB:PCDA - Put upstream bridge into D3"
                \_SB.PCI0.RP09.PSTX = 0x03

                // Debug = "TB:PCDA - Set link disable on upstream bridge"
                \_SB.PCI0.RP09.LDXX = One

                Local5 = (Timer + 0x00989680)

                While (Timer <= Local5)
                {
                    // Debug = "TB:PCDA - Wait for link to drop..."
                    If (\_SB.PCI0.RP09.LACR == One)
                    {
                        If (\_SB.PCI0.RP09.LACT == Zero)
                        {
                            // Debug = "TB:PCDA - No link activity"
                            Break
                        }
                    }
                    ElseIf (\_SB.PCI0.RP09.UPSB.AVND == 0xFFFFFFFF)
                    {
                        // Debug = "TB:PCDA - VID/DID is -1"
                        Break
                    }

                    Sleep (0x0A)
                }

                // Debug = "TB:PCDA - disable GPIO"
                \_SB.PCI0.RP09.GPCI = Zero
                \_SB.PCI0.RP09.UGIO ()
            }
            Else
            {
                Debug = "TB:PCDA - Not disabling"
            }

            \_SB.PCI0.RP09.IIP3 = One
        }

        /**
         * Returns true if both TB and TB-USB are idle
         */
        Method (POFX, 0, Serialized)
        {
            If (!\_SB.PCI0.RP09.RTBT && !\_SB.PCI0.RP09.RUSB)
            {
                Debug = "TB:POFX - TB & USB are both idle"
            }
            ElseIf (!\_SB.PCI0.RP09.RTBT)
            {
                Debug = "TB:POFX - USB active, TB idle"
            }
            ElseIf (!\_SB.PCI0.RP09.RUSB)
            {
                Debug = "TB:POFX - USB idle, TB active"
            }
            Else
            {
                Debug = "TB:POFX - WE SHOULDNT SEE THIS CASE, IF YOU DO, ITS A BUG :)"
            }
            

            Return ((!\_SB.PCI0.RP09.RTBT && !\_SB.PCI0.RP09.RUSB))
        }

        Name (GPCI, One)
        Name (GNHI, One)
        Name (GXCI, One)
        Name (RTBT, One)
        Name (RUSB, One)
        Name (CTPD, Zero)

        /**
         * Send power down ack to CP
         */
        Method (CTBT, 0, Serialized)
        {
            Debug = "TB:CTBT - Send power down ack to CP"

            If ((GGDV (0x02060000) == One) && (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
            // If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
            {
                // Debug = "TB:CTBT - TBT domain is enabled"
                Local2 = \_SB.PCI0.RP09.UPSB.CRMW (0x3C, Zero, 0x02, 0x04000000, 0x04000000)

                If (Local2 == Zero)
                {
                    // Debug = "TB:CTBT - Set CP_ACK_POWERDOWN_OVERRIDE"
                    \_SB.PCI0.RP09.CTPD = One
                }
            }
        }

        /**
         * Toggle controller power
         * Power controllers either up or down depending on the request.
         * On Macs, there's two GPIO signals for controlling TB and XHC 
         * separately. If such signals exist, we need to find it. Otherwise 
         * we lose the power saving capabilities.
         * Returns if controller is powered up
         */
        Method (UGIO, 0, Serialized)
        {
            // Which controller is requested to be on?
            Local0 = (\_SB.PCI0.RP09.GNHI || \_SB.PCI0.RP09.RTBT) // TBT
            Local1 = (\_SB.PCI0.RP09.GXCI || \_SB.PCI0.RP09.RUSB) // USB

            // Debug = "TB:UGIO - TBT-state:"
            // Debug = Local0 
            // Debug = "TB:UGIO - usb-state:"
            // Debug = Local1

            If (\_SB.PCI0.RP09.GPCI == Zero)
            {
                Debug = "TB:UGIO - PCI wants off (GPCI = Zero)"
            }
            Else
            {
                Debug = "TB:UGIO - PCI wants on (GPCI = One)"
            }

            If (\_SB.PCI0.RP09.GNHI == Zero)
            {
                Debug = "TB:UGIO - NHI wants off (GNHI = Zero)"
            }
            Else
            {
                Debug = "TB:UGIO - NHI wants on (GNHI = One)"
            }

            If (\_SB.PCI0.RP09.GXCI == Zero)
            {
                Debug = "TB:UGIO - XHCI wants off (GXCI = Zero)"
            }
            Else
            {
                Debug = "TB:UGIO - XHCI wants on (GXCI = One)"
            }

            If (\_SB.PCI0.RP09.RTBT == Zero)
            {
                Debug = "TB:UGIO - TBT allows off (RTBT = Zero)"
            }
            Else
            {
                Debug = "TB:UGIO - TBT forced on (RTBT = One)"
            }

            If (\_SB.PCI0.RP09.RUSB == Zero)
            {
                Debug = "TB:UGIO - USB allows off (RUSB = Zero)"
            }
            Else
            {
                Debug = "TB:UGIO - USB forced on (RUSB = One)"
            }

            // NHI controller wants to be on
            If (\_SB.PCI0.RP09.GPCI != Zero)
            {
                // if neither are requested to be on but the NHI controller 
                // needs to be up, then we go ahead and power it on anyways
                If ((Local0 == Zero) && (Local1 == Zero))
                {
                    Local0 = One
                    Local1 = One
                }
            }

            // If (Local0 == Zero)
            // {
            //     Debug = "TB:UGIO - TBT GPIO should be off"
            // }
            // Else
            // {
            //     Debug = "TB:UGIO - TBT GPIO should be on"
            // }

            // If (Local1 == Zero)
            // {
            //     Debug = "TB:UGIO - USB GPIO should be off"
            // }
            // Else
            // {
            //     Debug = "TB:UGIO - USB GPIO should be on"
            // }

            Local2 = Zero

            If (Local0 != Zero)
            {
                // Debug = "TB:UGIO - Make sure TBT is on"
                If (GGDV (0x02060000) == Zero)
                {
                    // Debug = "TB:UGIO - Turn on TBT GPIO"
                    SGDI (0x02060000)
                    Local2 = One
                    \_SB.PCI0.RP09.CTPD = Zero

                    Debug = "TB:UGIO - Enable TB"
                }
            }

            If (Local1 != Zero)
            {
                // Debug = "TB:UGIO - Make sure USB is on"
                If (GGDV (0x02060001) == Zero)
                {
                    // Debug = "TB:UGIO - Turn on USB GPIO"
                    SGDI (0x02060001)
                    Local2 = One

                    Debug = "TB:UGIO - Enable USB"
                }
            }

            If (Local2 != Zero)
            {
                Sleep (0x01F4)
            }

            Local3 = Zero

            If (Local0 == Zero)
            {
                // Debug = "TB:UGIO - Make sure TBT is off"

                If (GGDV (0x02060000) == One)
                {
                    \_SB.PCI0.RP09.CTBT ()

                    If (\_SB.PCI0.RP09.CTPD != Zero)
                    {
                        // Debug = "TB:UGIO - Turn off TBT GPIO"
                        SGOV (0x02060000, Zero)
                        SGDO (0x02060000)
                        Local3 = One

                        Debug = "TB:UGIO - Disable TB"
                    }
                    Else
                    {
                        // Debug = "TB:UGIO - CP_ACK_POWERDOWN_OVERRIDE not configured, cannot turn off TBT GPIO"
                    }
                }
            }

            If (Local1 == Zero)
            {
                // Debug = "TB:UGIO - Make sure USB is off"
                If (GGDV (0x02060001) == One)
                {
                    // Debug = "TB:UGIO - Turn off USB GPIO"
                    SGOV (0x02060001, Zero)
                    SGDO (0x02060001)
                    Local3 = One

                    Debug = "TB:UGIO - Disable USB"
                }
            }

            If (Local3 != Zero)
            {
                Sleep (0x64)
            }

            If (Local2 != Zero)
            {
                // Debug = "TB:UGIO - Either TB or USB powerstate changed"
            }

            // One if status of TB or USB changed to on
            Return (Local2)
        }

        Method (_PS0, 0, Serialized)  // _PS0: Power State 0
        {
            Debug = "TB:_PS0"

            \_SB.PCI0.RP09.XPS0()

            If (OSDW ())
            {
                PCEU ()
            }
        }

        Method (_PS3, 0, Serialized)  // _PS3: Power State 3
        {
            Debug = "TB:_PS3"

            If (OSDW ())
            {
                If (\_SB.PCI0.RP09.POFX () != Zero)
                {
                    \_SB.PCI0.RP09.CTBT ()
                }

                PCDA ()
            }

            \_SB.PCI0.RP09.XPS3()
        }

        Method (TGPE, 0, Serialized)
        {
            Debug = "TB:TGPE"

            Notify (\_SB.PCI0.RP09, 0x02) // Device Wake
        }

        Method (UTLK, 2, Serialized)
        {
            Debug = "TB:UTLK"

            Local0 = Zero

            // if CIO force power is zero
            If ((GGOV (0x02060000) == Zero) && (GGDV (0x02060000) == Zero))
            // If (Zero)
            {
                \_SB.PCI0.RP09.PSTX = Zero
                While (One)
                {
                    If (\_SB.PCI0.RP09.LDXX == One)
                    {
                        \_SB.PCI0.RP09.LDXX = Zero
                    }

                    // here, we force CIO power on
                    SGDI (0x02060000)
                    Local1 = Zero
                    Local2 = (Timer + 0x00989680)

                    While (Timer <= Local2)
                    {
                        If (\_SB.PCI0.RP09.LACR == Zero)
                        {
                            If (\_SB.PCI0.RP09.LTRN != One)
                            {
                                Break
                            }
                        }
                        ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                        {
                            Break
                        }

                        Sleep (0x0A)
                    }

                    Sleep (Arg1)
                    While (Timer <= Local2)
                    {
                        If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                        {
                            Local1 = One
                            Break
                        }

                        Sleep (0x0A)
                    }

                    If (Local1 == One)
                    {
                        \_SB.PCI0.RP09.MABT = One
                        Break
                    }

                    If (Local0 == 0x04)
                    {
                        Break
                    }

                    Local0++
                    // CIO force power back to 0
                    SGOV (0x02060000, Zero)
                    SGDO (0x02060000)
                    Sleep (0x03E8)
                }
            }

            Debug = "UTLK: Up Stream VID/DID ="
            Debug = \_SB.PCI0.RP09.UPSB.AVND
            Debug = "UTLK: Root Port VID/DID ="
            Debug = \_SB.PCI0.RP09.AVND
            // Debug = "UTLK: Root Port PRIB ="
            // Debug = \_SB.PCI0.RP09.PRIB
            // Debug = "UTLK: Root Port SECB ="
            // Debug = \_SB.PCI0.RP09.SECB
            // Debug = "UTLK: Root Port SUBB ="
            // Debug = \_SB.PCI0.RP09.SUBB
        }

        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
        Field (A1E0, ByteAcc, NoLock, Preserve)
        {
            AVND,   32, 
            BMIE,   3, 
            Offset (0x18), 
            PRIB,   8, 
            SECB,   8, 
            SUBB,   8, 
            Offset (0x1E), 
                ,   13, 
            MABT,   1
        }

        OperationRegion (HD94, PCI_Config, 0x0D94, 0x08)
        Field (HD94, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            PLEQ,   1, 
            Offset (0x08)
        }

        OperationRegion (A1E1, PCI_Config, 0x40, 0x40)
        Field (A1E1, ByteAcc, NoLock, Preserve)
        {
            Offset (0x01), 
            Offset (0x02), 
            Offset (0x04), 
            Offset (0x08), 
            Offset (0x0A), 
                ,   5, 
            TPEN,   1, 
            Offset (0x0C), 
            SSPD,   4, 
                ,   16, 
            LACR,   1, 
            Offset (0x10), 
                ,   4, 
            LDXX,   1, 
            LRTN,   1, 
            Offset (0x12), 
            CSPD,   4, 
            CWDT,   6, 
                ,   1, 
            LTRN,   1, 
                ,   1, 
            LACT,   1, 
            Offset (0x14), 
            Offset (0x30), 
            TSPD,   4
        }

        OperationRegion (A1E2, PCI_Config, 0xA0, 0x08)
        Field (A1E2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x01), 
            Offset (0x02), 
            Offset (0x04), 
            PSTX,   2
        }

        // OperationRegion (OE2H, PCI_Config, 0xE2, One)
        // Field (OE2H, ByteAcc, NoLock, Preserve)
        // {
        //         ,   2, 
        //     L23E,   1, 
        //     L23D,   1
        // }

        // OperationRegion (DMIH, PCI_Config, 0x0324, One)
        // Field (DMIH, ByteAcc, NoLock, Preserve)
        // {
        //         ,   3, 
        //     LEDM,   1
        // }

        OperationRegion (A1E3, PCI_Config, 0x0200, 0x20)
        Field (A1E3, ByteAcc, NoLock, Preserve)
        {
            Offset (0x14), 
            Offset (0x16), 
            PSTS,   4
        }

        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
        {
            Return (Zero)
        }

        /**
         * PXSX replaced by UPSB
         */
        Scope (PXSX)
        {
            Method (_STA, 0, NotSerialized)
            {
                Return (Zero) // hidden
            }
        }

        Device (UPSB)
        {
            Name (_ADR, Zero)  // _ADR: Address
            OperationRegion (A1E0, PCI_Config, Zero, 0x40)
            Field (A1E0, ByteAcc, NoLock, Preserve)
            {
                AVND,   32, 
                BMIE,   3, 
                Offset (0x18), 
                PRIB,   8, 
                SECB,   8, 
                SUBB,   8, 
                Offset (0x1E), 
                    ,   13, 
                MABT,   1
            }

            OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
            Field (A1E1, ByteAcc, NoLock, Preserve)
            {
                Offset (0x01), 
                Offset (0x02), 
                Offset (0x04), 
                Offset (0x08), 
                Offset (0x0A), 
                    ,   5, 
                TPEN,   1, 
                Offset (0x0C), 
                SSPD,   4, 
                    ,   16, 
                LACR,   1, 
                Offset (0x10), 
                    ,   4, 
                LDIS,   1, 
                LRTN,   1, 
                Offset (0x12), 
                CSPD,   4, 
                CWDT,   6, 
                    ,   1, 
                LTRN,   1, 
                    ,   1, 
                LACT,   1, 
                Offset (0x14), 
                Offset (0x30), 
                TSPD,   4
            }

            OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
            Field (A1E2, ByteAcc, NoLock, Preserve)
            {
                Offset (0x01), 
                Offset (0x02), 
                Offset (0x04), 
                PSTA,   2
            }

            Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
            {
                Return (SECB) /* \_SB_.PCI0.RP09.UPSB.SECB */
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (TBTS != One)
                {
                    Return (Zero)
                }

                Return (0x0F)
            }

            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
            {
                Return (Zero)
            }

            /**
             * Enable downstream link
             */
            Method (PCED, 0, Serialized)
            {
                Debug = "TB:UPSB:PCED - Enable downstream link"
                // Debug = "TB:UPSB:PCED - enable GPIO"
                \_SB.PCI0.RP09.GPCI = One

                // power up the controller
                If (\_SB.PCI0.RP09.UGIO () != Zero)
                {
                    // Debug = "TB:UPSB:PCED - GPIOs changed, restored = true"
                    \_SB.PCI0.RP09.PRSR = One
                }

                Local0 = Zero
                Local1 = Zero

                If (Local1 == Zero)
                {
                    If (\_SB.PCI0.RP09.IIP3 != Zero)
                    {
                        \_SB.PCI0.RP09.PRSR = One
                        Local0 = One

                        // Debug = "TB:UPSB:PCED - Set link disable on upstream bridge"
                        \_SB.PCI0.RP09.LDXX = One
                    }
                }

                Local5 = (Timer + 0x00989680)

                // Debug = "TB:UPSB:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR"
                // Debug = \_SB.PCI0.RP09.PRSR

                If (\_SB.PCI0.RP09.PRSR != Zero)
                {
                    // Debug = "TB:UPSB:PCED - Wait for power up"
                    Sleep (0x1E)

                    If ((Local0 != Zero) || (Local1 != Zero))
                    {
                        \_SB.PCI0.RP09.TSPD = One

                        If (Local1 != Zero) {}
                        ElseIf (Local0 != Zero)
                        {
                            // Debug = "TB:UPSB:PCED - Clear link disable on upstream bridge"
                            \_SB.PCI0.RP09.LDXX = Zero
                        }

                        While (Timer <= Local5)
                        {
                            // Debug = "TB:UPSB:PCED - Wait for link training..."
                            If (\_SB.PCI0.RP09.LACR == Zero)
                            {
                                If (\_SB.PCI0.RP09.LTRN != One)
                                {
                                    // Debug = "TB:UPSB:PCED - GENSTEP WA - Link training cleared"
                                    Break
                                }
                            }
                            ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                            {
                                // Debug = "TB:UPSB:PCED - GENSTEP WA - Link training cleared and link is active"
                                Break
                            }

                            Sleep (0x0A)
                        }

                        Sleep (0x78)

                        While (Timer <= Local5)
                        {
                            // Debug = "TB:UPSB:PCED - PEG WA - Wait for config space..."
                            
                            If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                            {
                                // Debug = "TB:UPSB:PCED - PEG WA - Read VID/DID - _SB.PCI0.RP09.UPSB.AVND:"
                                Debug = \_SB.PCI0.RP09.UPSB.AVND

                                Break
                            }

                            Sleep (0x0A)
                        }

                        \_SB.PCI0.RP09.TSPD = 0x03
                        \_SB.PCI0.RP09.LRTN = One
                    }

                    // Debug = "TB:UPSB:PCED - Wait for downstream bridge to appear"
                    Local5 = (Timer + 0x00989680)

                    While (Timer <= Local5)
                    {
                        // Debug = "TB:UPSB:PCED - Wait for link training..."

                        If (\_SB.PCI0.RP09.LACR == Zero)
                        {
                            If (\_SB.PCI0.RP09.LTRN != One)
                            {
                                // Debug = "TB:UPSB:PCED - Link training cleared"
                                Break
                            }
                        }
                        ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                        {
                            // Debug = "TB:UPSB:PCED - Link training cleared and link is active"
                            Break
                        }

                        Sleep (0x0A)
                    }

                    Sleep (0xFA)
                }

                \_SB.PCI0.RP09.PRSR = Zero
                While (Timer <= Local5)
                {
                    // Debug = "TB:UPSB:PCED - Wait for config space..."
                    If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                    {
                        // Debug = "TB:UPSB:PCED - Read VID/DID"
                        Break
                    }

                    Sleep (0x0A)
                }

                If (\_SB.PCI0.RP09.CSPD != 0x03)
                {
                    If (\_SB.PCI0.RP09.SSPD == 0x03)
                    {
                        If (\_SB.PCI0.RP09.UPSB.SSPD == 0x03)
                        {
                            If (\_SB.PCI0.RP09.TSPD != 0x03)
                            {
                                \_SB.PCI0.RP09.TSPD = 0x03
                            }

                            If (\_SB.PCI0.RP09.UPSB.TSPD != 0x03)
                            {
                                \_SB.PCI0.RP09.UPSB.TSPD = 0x03
                            }

                            \_SB.PCI0.RP09.LRTN = One
                            Local2 = (Timer + 0x00989680)
                            While (Timer <= Local2)
                            {
                                If (\_SB.PCI0.RP09.LACR == Zero)
                                {
                                    If ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                                    {
                                        \_SB.PCI0.RP09.PCIA = One
                                        Local1 = One
                                        Break
                                    }
                                }
                                ElseIf (((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One)) && 
                                    (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                                {
                                    \_SB.PCI0.RP09.PCIA = One
                                    Local1 = One
                                    Break
                                }

                                Sleep (0x0A)
                            }
                        }
                        Else
                        {
                            \_SB.PCI0.RP09.PCIA = One
                        }
                    }
                    Else
                    {
                        \_SB.PCI0.RP09.PCIA = One
                    }
                }
                Else
                {
                    \_SB.PCI0.RP09.PCIA = One
                }

                \_SB.PCI0.RP09.IIP3 = Zero
            }

            /**
             * Hotplug notify - Called by ACPI
             */
            Method (AMPE, 0, Serialized)
            {
                Debug = "TB:UPSB:AMPE - Hotplug notify called by ACPI"

                Notify (\_SB.PCI0.RP09.UPSB.DSB0.NHI0, Zero) // Bus Check
            }

            /**
             * Hotplug notify
             *
             * MUST called by NHI driver indicating cable plug-in
             * This passes the message to the XHC driver
             */
            Method (UMPE, 0, Serialized)
            {
                Debug = "TB:UPSB:UMPE - Hotplug notify on cable called by NHI"
                
                If (CondRefOf (\_SB.PCI0.RP09.UPSB.DSB2.XHC2))
                {
                    Debug = "TB:UPSB:UMPE - Notified XHC2"
                    Notify (\_SB.PCI0.RP09.UPSB.DSB2.XHC2, Zero) // Bus Check
                }

                If (CondRefOf (\_SB.PCI0.XHC1))
                {
                    Debug = "TB:UPSB:UMPE - Notified XHC1"
                    Notify (\_SB.PCI0.XHC1, Zero) // Bus Check
                }
            }

            Name (MDUV, One) // plug status

            /**
             * Cable status callback
             * Called from NHI driver on hotplug
             */
            Method (MUST, 1, Serialized)
            {
                // Debug = "TB:UPSB:MUST - Cable status callback from NHI"
                // Debug = "TB:UPSB:MUST - Plug status Arg0: "
                // Debug = Arg0
                // Debug = "TB:UPSB:MUST - Plug status MDUV: "
                // Debug = MDUV

                If (OSDW ())
                {
                    If (MDUV != Arg0)
                    {
                        If (Arg0 == One)
                        {
                            Debug = "TB:UPSB:MUST - Cable status callback from NHI - status changed - plugged (MDUV = One)"
                        }
                        Else
                        {
                            Debug = "TB:UPSB:MUST - Cable status callback from NHI - status changed - unplugged (MDUV = Zero)"
                        }

                        MDUV = Arg0
                        UMPE ()
                    }
                    Else
                    {
                        Debug = "TB:UPSB:MUST - Cable status callback from NHI - status unchanged"
                    }
                }

                Return (Zero)
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                Debug = "TB:UPSB:_PS0"

                If (OSDW ())
                {
                    PCED () // enable downlink

                    // some magical commands to CIO
                    \_SB.PCI0.RP09.UPSB.CRMW (0x013E, Zero, 0x02, 0x0200, 0x0200)
                    \_SB.PCI0.RP09.UPSB.CRMW (0x023E, Zero, 0x02, 0x0200, 0x0200)
                }
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                Debug = "TB:UPSB:_PS3"

                If (!OSDW ())
                {
                    If (\_SB.PCI0.RP09.UPCK () == Zero)
                    {
                        // Debug = "TB:UPSB:_PS3 calling UTLK _PS3"
                        \_SB.PCI0.RP09.UTLK (One, 0x03E8)
                    }
                    Else
                    {
                        // Debug = "TB:UPSB:_PS3 - UTLK OK"
                    }

                    \_SB.PCI0.RP09.TBTC (0x05)
                }
            }

            OperationRegion (H548, PCI_Config, 0x0548, 0x20)
            Field (H548, DWordAcc, Lock, Preserve)
            {
                T2PC,   32, 
                PC2T,   32
            }

            OperationRegion (H530, PCI_Config, 0x0530, 0x0C)
            Field (H530, DWordAcc, Lock, Preserve)
            {
                DWIX,   13, 
                PORT,   6, 
                SPCE,   2, 
                CMD0,   1, 
                CMD1,   1, 
                CMD2,   1, 
                    ,   6, 
                PROG,   1, 
                TMOT,   1, 
                WDAT,   32, 
                RDAT,   32
            }

            /**
             * CIO write
             */
            Method (CIOW, 4, Serialized)
            {
                // Debug = "TB:UPSB:CIOW"

                WDAT = Arg3
                // Debug = "TB:UPSB:CIOW - WDAT"
                // Debug = WDAT /* \_SB_.PCI0.RP09.UPSB.WDAT */

                DWIX = Arg0
                PORT = Arg1
                SPCE = Arg2
                CMD0 = One
                CMD1 = Zero
                CMD2 = Zero
                TMOT = Zero
                PROG = One

                Local1 = One
                Local0 = 0x2710

                While (Zero < Local0)
                {
                    If (PROG == Zero)
                    {
                        Local1 = Zero
                        Break
                    }

                    Stall (0x19)
                    Local0--
                }

                If (Local1 == Zero)
                {
                    Local1 = TMOT /* \_SB_.PCI0.RP09.UPSB.TMOT */
                }

                If (Local1 != Zero)
                {
                    Debug = "TB:UPSB:CIOW - Error"
                    Debug = Local1
                }

                Return (Local1)
            }

            /**
             * CIO read
             */
            Method (CIOR, 3, Serialized)
            {
                // Debug = "TB:UPSB:CIOR"

                RDAT = Zero
                DWIX = Arg0
                PORT = Arg1
                SPCE = Arg2
                CMD0 = Zero
                CMD1 = Zero
                CMD2 = Zero
                TMOT = Zero
                PROG = One

                Local1 = One
                Local0 = 0x2710

                While (Zero < Local0)
                {
                    If (PROG == Zero)
                    {
                        Local1 = Zero
                        Break
                    }

                    Stall (0x19)
                    Local0--
                }

                If (Local1 == Zero)
                {
                    Local1 = TMOT /* \_SB_.PCI0.RP09.UPSB.TMOT */
                }

                If (Local1)
                {
                    Debug = "TB:UPSB:CIOR - Error"
                    Debug = Local1
                }

                // Debug = "TB:UPSB:CIOR - RDAT"
                // Debug = RDAT /* \_SB_.PCI0.RP09.UPSB.RDAT */

                If (Local1 == Zero)
                {
                    Return (Package (0x02)
                    {
                        Zero, 
                        RDAT
                    })
                }
                Else
                {
                    Return (Package (0x02)
                    {
                        One, 
                        RDAT
                    })
                }
            }

            /**
             * CIO Read Modify Write
             */
            Method (CRMW, 5, Serialized)
            {
                // Debug = "TB:UPSB:CRMW"

                // Debug = "TB:UPSB:CRMW - AVND:"
                // Debug = \_SB.PCI0.RP09.UPSB.AVND

                // Debug = "TB:UPSB:CRMW - GGDV (0x02060000):"
                // Debug = GGDV (0x02060000)

                // Debug = "TB:UPSB:CRMW - GGDV (0x02060001):"
                // Debug = GGDV (0x02060001)


                Local1 = One
                If (((GGDV (0x02060000) == One) || (GGDV (0x02060001) == One)) && 
                    (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                // If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                {
                    // Debug = "TB:UPSB:CRMW - TBT domain is enabled"
                    Local3 = Zero

                    While (Local3 <= 0x04)
                    {
                        Local2 = CIOR (Arg0, Arg1, Arg2)
                        If (DerefOf (Local2 [Zero]) == Zero)
                        {
                            Local2 = DerefOf (Local2 [One])
                            // Debug = "TB:UPSB:CRMW - Read Value"
                            // Debug = Local2

                            Local2 &= ~Arg4
                            Local2 |= Arg3
                            // Debug = "TB:UPSB:CRMW - Write Value"
                            // Debug = Local2

                            Local2 = CIOW (Arg0, Arg1, Arg2, Local2)

                            If (Local2 == Zero)
                            {
                                Local2 = CIOR (Arg0, Arg1, Arg2)

                                If (DerefOf (Local2 [Zero]) == Zero)
                                {
                                    Local2 = DerefOf (Local2 [One])
                                    // Debug = "TB:UPSB:CRMW - Read Value 2"
                                    // Debug = Local2

                                    Local2 &= Arg4

                                    If (Local2 == Arg3)
                                    {
                                        // Debug = "TB:UPSB:CRMW - Success"

                                        Local1 = Zero

                                        Break
                                    }
                                }
                            }
                        }

                        Local3++
                        Sleep (0x64)
                    }
                }

                If (Local1 != Zero)
                {
                    Debug = "TB:UPSB:CRMW - Error value"
                    Debug = Local1
                }

                Return (Local1)
            }

            /**
             * Used in PTS/WAK
             */
            Method (LSTX, 2, Serialized)
            {
                Debug = "TB:UPSB:LSTX"

                If (T2PC != 0xFFFFFFFF)
                {
                    Local0 = Zero
                    If ((T2PC & One) && One)
                    {
                        Local0 = One
                    }

                    If (Local0 == Zero)
                    {
                        Local1 = 0x2710
                        While (Zero < Local1)
                        {
                            If (T2PC == Zero)
                            {
                                Break
                            }

                            Stall (0x19)
                            Local1--
                        }

                        If (Zero == Local1)
                        {
                            Local0 = One
                        }
                    }

                    If (Local0 == Zero)
                    {
                        Local1 = One
                        Local1 |= 0x14
                        Local1 |= (Arg0 << 0x08)
                        Local1 |= (Arg1 << 0x0C)
                        Local1 |= 0x00400000
                        PC2T = Local1
                    }

                    If (Local0 == Zero)
                    {
                        Local1 = 0x2710

                        While (Zero < Local1)
                        {
                            If (T2PC == 0x15)
                            {
                                Break
                            }

                            Stall (0x19)
                            Local1--
                        }

                        If (Zero == Local1)
                        {
                            Local0 = One
                        }
                    }

                    Sleep (0x0A)
                    PC2T = Zero
                }
            }

            Device (DSB0)
            {
                Name (_ADR, Zero)  // _ADR: Address
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB0.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Name (IIP3, Zero)
                Name (PRSR, Zero)
                Name (PCIA, One)

                /**
                 * Enable Upstream link
                 */
                Method (PCEU, 0, Serialized)
                {
                    Debug = "TB:UPSB:DSB0:PCEU - Enable Upstream link"

                    \_SB.PCI0.RP09.UPSB.DSB0.PRSR = Zero

                    // Debug = "TB:UPSB:DSB0:PCEU - Put upstream bridge back into D0 "
                    If (\_SB.PCI0.RP09.UPSB.DSB0.PSTA != Zero)
                    {
                        // Debug = "TB:UPSB:DSB0:PCEU - exit D0, restored = true"
                        \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                        \_SB.PCI0.RP09.UPSB.DSB0.PSTA = Zero
                    }

                    If (\_SB.PCI0.RP09.UPSB.DSB0.LDIS == One)
                    {
                        // Debug = "TB:UPSB:DSB0:PCEU - Clear link disable on upstream bridge"
                        // Debug = "TB:UPSB:DSB0:PCEU - clear link disable, restored = true"
                        \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                        \_SB.PCI0.RP09.UPSB.DSB0.LDIS = Zero
                    }
                }

                /**
                 * Bring down PCI link
                 */
                Method (PCDA, 0, Serialized)
                {
                    Debug = "TB:UPSB:DSB0:PCDA - Bring down PCI link"

                    If (\_SB.PCI0.RP09.UPSB.DSB0.POFX () != Zero)
                    {
                        \_SB.PCI0.RP09.UPSB.DSB0.PCIA = Zero

                        // Debug = "TB:UPSB:DSB0:PCDA - Put upstream bridge into D3"
                        \_SB.PCI0.RP09.UPSB.DSB0.PSTA = 0x03

                        // Debug = "TB:UPSB:DSB0:PCDA - Set link disable on upstream bridge"
                        \_SB.PCI0.RP09.UPSB.DSB0.LDIS = One

                        Local5 = (Timer + 0x00989680)
                        While (Timer <= Local5)
                        {
                            // Debug = "TB:UPSB:DSB0:PCDA - Wait for link to drop..."
                            If (\_SB.PCI0.RP09.UPSB.DSB0.LACR == One)
                            {
                                If (\_SB.PCI0.RP09.UPSB.DSB0.LACT == Zero)
                                {
                                    // Debug = "TB:UPSB:DSB0:PCDA - No link activity"
                                    Break
                                }
                            }
                            ElseIf (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.AVND == 0xFFFFFFFF)
                            {
                                // Debug = "TB:UPSB:DSB0:PCDA - VID/DID is -1"
                                Break
                            }

                            Sleep (0x0A)
                        }

                        // Debug = "TB:UPSB:DSB0:PCDA - disable GPIO & run UGIO()"
                        \_SB.PCI0.RP09.GNHI = Zero
                        \_SB.PCI0.RP09.UGIO ()
                    }
                    Else
                    {
                        // Debug = "TB:UPSB:DSB0:PCDA - Not disabling"
                    }

                    \_SB.PCI0.RP09.UPSB.DSB0.IIP3 = One
                }

                /**
                 * Check if TB is idle
                 */
                Method (POFX, 0, Serialized)
                {
                    If (!\_SB.PCI0.RP09.RTBT)
                    {
                        Debug = "TB:UPSB:DSB0:POFX - TB is idle (RTBT = Zero)"
                    }
                    Else
                    {
                        Debug = "TB:UPSB:DSB0:POFX - TB is active (RTBT != Zero)"
                    }

                    Return (!\_SB.PCI0.RP09.RTBT)
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    Debug = "TB:UPSB:DSB0:_PS0"

                    If (OSDW ())
                    {
                        PCEU ()
                    }
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    Debug = "TB:UPSB:DSB0:_PS3"

                    If (OSDW ())
                    {
                        PCDA ()
                    }
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If (OSDW ())
                    {
                        If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                        {
                            Local0 = Package (0x02)
                                {
                                    "PCIHotplugCapable", 
                                    Zero
                                }
                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }

                    Return (Zero)
                }

                /**
                 * Thunderbolt NHI controller
                 */
                Device (NHI0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Name (_STR, Unicode ("Thunderbolt"))  // _STR: Description String

                    /**
                     * Enable downstream link
                     */
                    Method (PCED, 0, Serialized)
                    {
                        Debug = "TB:UPSB:NHI0:PCED - Enable downstream link"

                        // Debug = "TB:UPSB:NHI0:PCED - enable GPIO"
                        \_SB.PCI0.RP09.GNHI = One

                        // we should not need to force power since 
                        // UPSX init should already have done so!
                        If (\_SB.PCI0.RP09.UGIO () != Zero)
                        {
                            // Debug = "TB:UPSB:NHI0:PCED - GPIOs changed, restored = true"
                            \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                        }

                        Local0 = Zero
                        Local1 = Zero
                        Local5 = (Timer + 0x00989680)

                        // Debug = "TB:UPSB:NHI0:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR"
                        Debug = \_SB.PCI0.RP09.UPSB.DSB0.PRSR

                        If (\_SB.PCI0.RP09.UPSB.DSB0.PRSR != Zero)
                        {
                            // Debug = "TB:UPSB:NHI0:PCED - Wait for power up"
                            // Debug = "TB:UPSB:NHI0:PCED - Wait for downstream bridge to appear"
                            Local5 = (Timer + 0x00989680)

                            While (Timer <= Local5)
                            {
                                // Debug = "TB:UPSB:NHI0:PCED - Wait for link training..."
                                If (\_SB.PCI0.RP09.UPSB.DSB0.LACR == Zero)
                                {
                                    If (\_SB.PCI0.RP09.UPSB.DSB0.LTRN != One)
                                    {
                                        // Debug = "TB:UPSB:NHI0:PCED - Link training cleared"
                                        Break
                                    }
                                }
                                ElseIf ((\_SB.PCI0.RP09.UPSB.DSB0.LTRN != One) && (\_SB.PCI0.RP09.UPSB.DSB0.LACT == One))
                                {
                                    // Debug = "TB:UPSB:NHI0:PCED - Link training cleared and link is active"
                                    Break
                                }

                                Sleep (0x0A)
                            }

                            Sleep (0x96)
                        }

                        \_SB.PCI0.RP09.UPSB.DSB0.PRSR = Zero

                        While (Timer <= Local5)
                        {
                            // Debug = "TB:UPSB:NHI0:PCED - Wait for config space..."
                            If (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.AVND != 0xFFFFFFFF)
                            {
                                // Debug = "TB:UPSB:NHI0:PCED - Read VID/DID"
                                \_SB.PCI0.RP09.UPSB.DSB0.PCIA = One
                                Break
                            }

                            Sleep (0x0A)
                        }

                        \_SB.PCI0.RP09.UPSB.DSB0.IIP3 = Zero
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (Zero)
                    }

                    OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                    Field (A1E0, ByteAcc, NoLock, Preserve)
                    {
                        AVND,   32, 
                        BMIE,   3, 
                        Offset (0x18), 
                        PRIB,   8, 
                        SECB,   8, 
                        SUBB,   8, 
                        Offset (0x1E), 
                            ,   13, 
                        MABT,   1
                    }

                    /**
                     * Run Time Power Check
                     * Called by NHI driver when link is idle.
                     * Once both XHC and NHI idle, we can power down.
                     */
                    Method (RTPC, 1, Serialized)
                    {
                        If (OSDW ())
                        {
                            If (Arg0 <= One)
                            {
                                If (Arg0 == One)
                                {
                                    Debug = "TB:UPSB:NHI0:RTPC - TB Run Time Power Check - Running"
                                }

                                If (Arg0 == Zero)
                                {
                                    Debug = "TB:UPSB:NHI0:RTPC - TB Run Time Power Check - Idle"    
                                }

                                \_SB.PCI0.RP09.RTBT = Arg0
                            }
                            Else
                            {
                                Debug = "TB:UPSB:NHI0:RTPC - TB Run Time Power Check - ??? - Arg0: "
                                Debug = Arg0
                            }
                        }

                        Return (Zero)
                    }

                    /**
                     * Cable detection callback
                     * Called by NHI driver on hotplug
                     */
                    Method (MUST, 1, Serialized)
                    {
                        Debug = "TB:UPSB:NHI0:MUST - Cable detection callback"

                        Return (\_SB.PCI0.RP09.UPSB.MUST (Arg0))
                    }

                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        Debug = "TB:UPSB:NHI0:_PS0"

                        If (OSDW ())
                        {
                            PCED ()
                            \_SB.PCI0.RP09.CTBT ()
                        }
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        Debug = "TB:UPSB:NHI0:_PS3"
                    }

                    Method (TRPE, 2, Serialized)
                    {
                        Debug = "TB:UPSB:NHI0:TRPE - args:"
                        Debug = Arg0
                        Debug = Arg1

                        If (OSDW ())
                        {
                            If (Arg0 <= One)
                            {
                                If (Arg0 == Zero)
                                {
                                    \_SB.PCI0.RP09.PSTX = 0x03
                                    \_SB.PCI0.RP09.LDXX = One

                                    Local0 = (Timer + 0x00989680)

                                    While (Timer <= Local0)
                                    {
                                        If (\_SB.PCI0.RP09.LACR == One)
                                        {
                                            If (\_SB.PCI0.RP09.LACT == Zero)
                                            {
                                                Break
                                            }
                                        }
                                        ElseIf (\_SB.PCI0.RP09.UPSB.AVND == 0xFFFFFFFF)
                                        {
                                            Break
                                        }

                                        Sleep (0x0A)
                                    }

                                    SGOV (0x02060000, Zero)
                                    SGDO (0x02060000)
                                }
                                Else
                                {
                                    Local0 = Zero

                                    // Debug = "TB:UPSB:NHI0:TRPE GGOV (0x02060000):"
                                    // Debug = GGOV (0x02060000)

                                    // Debug = "TB:UPSB:NHI0:TRPE GGOV (0x02060000):"
                                    // Debug = GGDV (0x02060000)

                                    If ((GGOV (0x02060000) == Zero) && (GGDV (0x02060000) == Zero))
                                    // If (Zero)
                                    {
                                        \_SB.PCI0.RP09.PSTX = Zero

                                        While (One)
                                        {
                                            If (\_SB.PCI0.RP09.LDXX == One)
                                            {
                                                \_SB.PCI0.RP09.LDXX = Zero
                                            }

                                            SGDI (0x02060000)

                                            Local1 = Zero
                                            Local2 = (Timer + 0x00989680)

                                            While (Timer <= Local2)
                                            {
                                                If (\_SB.PCI0.RP09.LACR == Zero)
                                                {
                                                    If (\_SB.PCI0.RP09.LTRN != One)
                                                    {
                                                        Break
                                                    }
                                                }
                                                ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                                                {
                                                    Break
                                                }

                                                Sleep (0x0A)
                                            }

                                            Sleep (Arg1)
                                            While (Timer <= Local2)
                                            {
                                                If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                                                {
                                                    Local1 = One
                                                    Break
                                                }

                                                Sleep (0x0A)
                                            }

                                            If (Local1 == One)
                                            {
                                                MABT = One
                                                Break
                                            }

                                            If (Local0 == 0x04)
                                            {
                                                Return (Zero)
                                            }

                                            Local0++
                                            SGOV (0x02060000, Zero)
                                            SGDO (0x02060000)
                                            Sleep (0x03E8)
                                        }

                                        If (\_SB.PCI0.RP09.CSPD != 0x03)
                                        {
                                            If (\_SB.PCI0.RP09.SSPD == 0x03)
                                            {
                                                If (\_SB.PCI0.RP09.UPSB.SSPD == 0x03)
                                                {
                                                    If (\_SB.PCI0.RP09.TSPD != 0x03)
                                                    {
                                                        \_SB.PCI0.RP09.TSPD = 0x03
                                                    }

                                                    If (\_SB.PCI0.RP09.UPSB.TSPD != 0x03)
                                                    {
                                                        \_SB.PCI0.RP09.UPSB.TSPD = 0x03
                                                    }

                                                    \_SB.PCI0.RP09.LRTN = One
                                                    Local2 = (Timer + 0x00989680)
                                                    While (Timer <= Local2)
                                                    {
                                                        If (\_SB.PCI0.RP09.LACR == Zero)
                                                        {
                                                            If ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                                                            {
                                                                Local1 = One
                                                                Break
                                                            }
                                                        }
                                                        ElseIf (((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One)) && 
                                                            (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                                                        {
                                                            Local1 = One
                                                            Break
                                                        }

                                                        Sleep (0x0A)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Return (Zero)
                    }


                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        If ((Arg2 == Zero))
                        {
                            Return (Buffer (One)
                            {
                                 0x03                                             // .
                            })
                        }

                        Local0 = Package (0x05)
                            {
                                "ThunderboltDROM",
                                Buffer (0x6F)
                                {
                                    /* 0x00     */  0x61,                                           // CRC8 checksum: 0x61
                                    /* 0x01     */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x01, // Thunderbolt Bus 0, UID: 0x0109000000000000
                                    /* 0x09     */  0x2b, 0xcc, 0xb9, 0xf7,                         // CRC32c checksum: 0xF7B9CC2B
                                    /* 0x0D     */  0x01,                                           // Device ROM Revision: 1
                                    /* 0x0E     */  0x62, 0x00,                                     // Length: 98 (starting from previous byte)
                                    /* 0x10     */  0x09, 0x01,                                     // Vendor ID: 0x109
                                    /* 0x12     */  0x06, 0x17,                                     // Device ID: 0x1706
                                    /* 0x14     */  0x01,                                           // Device Revision: 0x1
                                    /* 0x15     */  0x2b,                                           // EEPROM Revision: 43
                                    /* 0x16   1 */  0x08, 0x81, 0x80, 0x02, 0x80, 0x00, 0x00, 0x00,
                                    /* 0x1E   2 */  0x08, 0x82, 0x90, 0x01, 0x80, 0x00, 0x00, 0x00,
                                    /* 0x26   3 */  0x08, 0x83, 0x80, 0x04, 0x80, 0x01, 0x00, 0x00,
                                    /* 0x2E   4 */  0x08, 0x84, 0x90, 0x03, 0x80, 0x01, 0x00, 0x00,
                                    /* 0x36   5 */  0x02, 0x85,
                                    /* 0x38   6 */  0x0b, 0x86, 0x20, 0x01, 0x00, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00,
                                    /* 0x43   7 */  0x03, 0x87, 0x80, // PCIe xx:04.0
                                    /* 0x46   8 */  0x05, 0x88, 0x50, 0x40, 0x00,
                                    /* 0x4B   9 */  0x05, 0x89, 0x50, 0x00, 0x00,
                                    /* 0x50   A */  0x05, 0x8a, 0x50, 0x00, 0x00,
                                    /* 0x55   B */  0x05, 0x8b, 0x50, 0x40, 0x00,
                                    /* 0x5A   1 */  0x09, 0x01, 0x4c, 0x65, 0x6e, 0x6f, 0x76, 0x6f, 0x00, // Vendor Name: "Lenovo"
                                    /* 0x63   2 */  0x0c, 0x02, 0x58, 0x31, 0x20, 0x43, 0x61, 0x72, 0x62, 0x6f, 0x6e, 0x00, // Device Name: "X1 Carbon"
                                },

                                "power-save", 
                                One, 
                                Buffer (One)
                                {
                                     0x00                                             // .
                                }
                            }
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }

                    /**
                     * Late sleep force power
                     * NHI driver sends a sleep cmd to TB controller
                     * But we might be sleeping at this time. So this will 
                     * force the power on right before sleep.
                     */
                    Method (SXFP, 1, Serialized)
                    {
                        Debug = "TB:UPSB:NHI0:SXFP - Late sleep force power - Arg0:"
                        Debug = Arg0

                        // Debug = "TB:UPSB:NHI0:SXFP - GGDV (0x02060001)"
                        // Debug = GGDV (0x02060001)

                        If (Arg0 == Zero)
                        {
                            If (GGDV (0x02060001) == One)
                            {
                                SGOV (0x02060001, Zero)
                                SGDO (0x02060001)
                                Sleep (0x64)
                            }

                            SGOV (0x02060000, Zero)
                            SGDO (0x02060000)
                        }
                    }

                    Name (XRTE, Zero)

                    Method (XRST, 1, Serialized)
                    {
                        Debug = "TB:UPSB:NHI0:XRST - Arg0:"
                        Debug = Arg0

                        If (Arg0 == Zero)
                        {
                            XRTE = Zero
                            If (SLTP == Zero)
                            {
                                // Debug = "TB:UPSB:NHI0:TRPE L23 Detect"
                                \_SB.PCI0.RP09.L23R = One

                                Sleep (One)

                                Local2 = Zero

                                While (\_SB.PCI0.RP09.L23R)
                                {
                                    If (Local2 > 0x04)
                                    {
                                        Break
                                    }

                                    Sleep (One)
                                    Local2++
                                }

                                // Debug = "TB:UPSB:NHI0:TRPE Clear LEDM"
                                \_SB.PCI0.RP09.LEDM = Zero

                                SGDI (0x02060004)
                            }
                        }
                        ElseIf (Arg0 == One)
                        {
                            XRTE = One
                            If (SLTP == Zero)
                            {
                                \_SB.PCI0.RP09.PSTX = 0x03
                                If (\_SB.PCI0.RP09.LACR == One)
                                {
                                    If (\_SB.PCI0.RP09.LACT == Zero)
                                    {
                                        // Debug = "TB:UPSB:NHI0:XRST: Root Port LDIS - Skipping L23 Ready Request"
                                    }
                                    Else
                                    {
                                        // Debug = "TB:UPSB:NHI0:XRST Root Port Requesting L23 Ready"
                                        \_SB.PCI0.RP09.L23E = One

                                        Sleep (One)

                                        Local2 = Zero

                                        While (\_SB.PCI0.RP09.L23E == One)
                                        {
                                            If (Local2 > 0x04)
                                            {
                                                Break
                                            }

                                            Sleep (One)
                                            Local2++
                                        }

                                        // Debug = "TB:UPSB:NHI0:XRST Root Port Set DMI L1 EN"
                                        \_SB.PCI0.RP09.LEDM = One
                                    }
                                }

                                SGOV (0x02060004, Zero)
                                SGDO (0x02060004)
                                Sleep (0x4B)
                            }
                        }
                    }
                }
            }

            Device (DSB1)
            {
                Name (_ADR, 0x00010000)  // _ADR: Address
                Name (_SUN, One)  // _SUN: Slot User Number
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Device (UPS0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                    Field (ARE0, ByteAcc, NoLock, Preserve)
                    {
                        AVND,   16
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        If (OSDW ())
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Device (DSB0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1, 
                            Offset (0x3E), 
                                ,   6, 
                            SBRS,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB0.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (DEV0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Device (DSB3)
                    {
                        Name (_ADR, 0x00030000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB4)
                    {
                        Name (_ADR, 0x00040000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB5)
                    {
                        Name (_ADR, 0x00050000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB5.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }

                    Device (DSB6)
                    {
                        Name (_ADR, 0x00060000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB1.UPS0.DSB6.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }
                }
            }

            Device (DSB2)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB2.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Name (IIP3, Zero)
                Name (PRSR, Zero)
                Name (PCIA, One)

                /**
                 * Enable upstream link
                 */
                Method (PCEU, 0, Serialized)
                {
                    Debug = "TB:UPSB:DSB2:PCEU - Enable upstream link"

                    \_SB.PCI0.RP09.UPSB.DSB2.PRSR = Zero

                    // Debug = "TB:UPSB:DSB2:PCEU - Put upstream bridge back into D0 "
                    If (\_SB.PCI0.RP09.UPSB.DSB2.PSTA != Zero)
                    {
                        // Debug = "TB:UPSB:DSB2:PCEU - exit D0, restored = true"
                        \_SB.PCI0.RP09.UPSB.DSB2.PRSR = One
                        \_SB.PCI0.RP09.UPSB.DSB2.PSTA = Zero
                    }

                    If (\_SB.PCI0.RP09.UPSB.DSB2.LDIS == One)
                    {
                        // Debug = "TB:UPSB:DSB2:PCEU - Clear link disable on upstream bridge"
                        // Debug = "TB:UPSB:DSB2:PCEU - clear link disable, restored = true"
                        \_SB.PCI0.RP09.UPSB.DSB2.PRSR = One
                        \_SB.PCI0.RP09.UPSB.DSB2.LDIS = Zero
                    }
                }

                /**
                 * PCI disable link
                 */
                Method (PCDA, 0, Serialized)
                {
                    Debug = "TB:UPSB:DSB2:PCDA - PCI disable link"

                    If (\_SB.PCI0.RP09.UPSB.DSB2.POFX () != Zero)
                    {
                        \_SB.PCI0.RP09.UPSB.DSB2.PCIA = Zero

                        // Debug = "TB:UPSB:DSB2:PCDA - Put upstream bridge into D3"
                        \_SB.PCI0.RP09.UPSB.DSB2.PSTA = 0x03

                        // Debug = "TB:UPSB:DSB2:PCDA - Set link disable on upstream bridge"
                        \_SB.PCI0.RP09.UPSB.DSB2.LDIS = One

                        Local5 = (Timer + 0x00989680)

                        While (Timer <= Local5)
                        {
                            // Debug = "TB:UPSB:DSB2:PCDA - Wait for link to drop..."
                            If (\_SB.PCI0.RP09.UPSB.DSB2.LACR == One)
                            {
                                If (\_SB.PCI0.RP09.UPSB.DSB2.LACT == Zero)
                                {
                                    // Debug = "TB:UPSB:DSB2:PCDA - No link activity"
                                    Break
                                }
                            }
                            Else
                            {
                                If (CondRefOf (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND))
                                {
                                    If (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND == 0xFFFFFFFF)
                                    {
                                        Debug = "TB:UPSB:DSB2:PCDA - VID/DID is -1"
                                        Break
                                    }
                                }
                                Else 
                                {
                                    Debug = "TB:UPSB:DSB2:PCDA - XHC2 disabled? BUG?"
                                }
                            }

                            Sleep (0x0A)
                        }

                        // Debug = "PCDA - disable GPIO"
                        \_SB.PCI0.RP09.GXCI = Zero
                        \_SB.PCI0.RP09.UGIO () // power down if needed
                    }
                    Else
                    {
                        // Debug = "PCDA - Not disabling"
                    }

                    \_SB.PCI0.RP09.UPSB.DSB2.IIP3 = One
                }

                /**
                 * Is power saving requested?
                 */
                Method (POFX, 0, Serialized)
                {
                    If (!\_SB.PCI0.RP09.RUSB)
                    {
                        Debug = "TB:UPSB:DSB2:POFX - USB is idle (RUSB = Zero)"
                    }
                    Else
                    {
                        Debug = "TB:UPSB:DSB2:POFX - USB is active (RUSB != Zero)"
                    }
                    

                    Return (!\_SB.PCI0.RP09.RUSB)
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    Debug = "TB:UPSB:DSB2:_PS0"

                    If (OSDW ())
                    {
                        PCEU ()
                    }
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    Debug = "TB:UPSB:DSB2:_PS3"

                    If (OSDW ())
                    {
                        PCDA ()
                    }
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If (OSDW ())
                    {
                        If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                        {
                            Local0 = Package (0x02)
                                {
                                    "PCIHotplugCapable", 
                                    Zero
                                }
                            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                            Return (Local0)
                        }
                    }

                    Return (Zero)
                }
            }

            Device (DSB3)
            {
                Name (_ADR, 0x00030000)  // _ADR: Address
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Device (UPS0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                    Field (ARE0, ByteAcc, NoLock, Preserve)
                    {
                        AVND,   16
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        If (OSDW ())
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Device (DSB0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1, 
                            Offset (0x3E), 
                                ,   6, 
                            SBRS,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB0.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (DEV0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Device (DSB3)
                    {
                        Name (_ADR, 0x00030000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB4)
                    {
                        Name (_ADR, 0x00040000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB5)
                    {
                        Name (_ADR, 0x00050000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB5.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }

                    Device (DSB6)
                    {
                        Name (_ADR, 0x00060000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB3.UPS0.DSB6.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }
                }
            }

            Device (DSB4)
            {
                Name (_ADR, 0x00040000)  // _ADR: Address
                Name (_SUN, 0x02)  // _SUN: Slot User Number
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Device (UPS0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                    Field (ARE0, ByteAcc, NoLock, Preserve)
                    {
                        AVND,   16
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        If (OSDW ())
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Device (DSB0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1, 
                            Offset (0x3E), 
                                ,   6, 
                            SBRS,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB0.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (DEV0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Device (DSB3)
                    {
                        Name (_ADR, 0x00030000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB4)
                    {
                        Name (_ADR, 0x00040000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB5)
                    {
                        Name (_ADR, 0x00050000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB5.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }

                    Device (DSB6)
                    {
                        Name (_ADR, 0x00060000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB4.UPS0.DSB6.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }
                }
            }

            Device (DSB5)
            {
                Name (_ADR, 0x00050000)  // _ADR: Address
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }

                Device (UPS0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                    Field (ARE0, ByteAcc, NoLock, Preserve)
                    {
                        AVND,   16
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        If (OSDW ())
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Device (DSB0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1, 
                            Offset (0x3E), 
                                ,   6, 
                            SBRS,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB0.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (DEV0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }
                        }
                    }

                    Device (DSB3)
                    {
                        Name (_ADR, 0x00030000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB4)
                    {
                        Name (_ADR, 0x00040000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }

                        Device (UPS0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                            Field (ARE0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   16
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                If (OSDW ())
                                {
                                    Return (One)
                                }

                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1, 
                                    Offset (0x3E), 
                                        ,   6, 
                                    SBRS,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB3)
                            {
                                Name (_ADR, 0x00030000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB3.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }

                                Device (DEV0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                    {
                                        Return (0x0F)
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        If (OSDW ())
                                        {
                                            Return (One)
                                        }

                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB5)
                            {
                                Name (_ADR, 0x00050000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB5.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }

                            Device (DSB6)
                            {
                                Name (_ADR, 0x00060000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB6.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    If (OSDW ())
                                    {
                                        Return (One)
                                    }

                                    Return (Zero)
                                }
                            }
                        }
                    }

                    Device (DSB5)
                    {
                        Name (_ADR, 0x00050000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB5.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }

                    Device (DSB6)
                    {
                        Name (_ADR, 0x00060000)  // _ADR: Address
                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                        Field (A1E0, ByteAcc, NoLock, Preserve)
                        {
                            AVND,   32, 
                            BMIE,   3, 
                            Offset (0x18), 
                            PRIB,   8, 
                            SECB,   8, 
                            SUBB,   8, 
                            Offset (0x1E), 
                                ,   13, 
                            MABT,   1
                        }

                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                        {
                            Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB5.UPS0.DSB6.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            If (OSDW ())
                            {
                                Return (One)
                            }

                            Return (Zero)
                        }
                    }
                }
            }

            Device (DSB6)
            {
                Name (_ADR, 0x00060000)  // _ADR: Address
                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    AVND,   32, 
                    BMIE,   3, 
                    Offset (0x18), 
                    PRIB,   8, 
                    SECB,   8, 
                    SUBB,   8, 
                    Offset (0x1E), 
                        ,   13, 
                    MABT,   1
                }

                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    Offset (0x08), 
                    Offset (0x0A), 
                        ,   5, 
                    TPEN,   1, 
                    Offset (0x0C), 
                    SSPD,   4, 
                        ,   16, 
                    LACR,   1, 
                    Offset (0x10), 
                        ,   4, 
                    LDIS,   1, 
                    LRTN,   1, 
                    Offset (0x12), 
                    CSPD,   4, 
                    CWDT,   6, 
                        ,   1, 
                    LTRN,   1, 
                        ,   1, 
                    LACT,   1, 
                    Offset (0x14), 
                    Offset (0x30), 
                    TSPD,   4
                }

                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    Offset (0x02), 
                    Offset (0x04), 
                    PSTA,   2
                }

                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (SECB) /* \_SB_.PCI0.RP09.UPSB.DSB6.SECB */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (OSDW ())
                {
                    If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                    {
                        Local0 = Package (0x02)
                            {
                                "PCI-Thunderbolt", 
                                One
                            }
                        DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                        Return (Local0)
                    }
                }

                Return (Zero)
            }
        }
    }
}
