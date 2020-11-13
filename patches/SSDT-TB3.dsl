// // Depends on /patches/OpenCore Patches/ Thunderbolt3.plist
//
/**
 * Thunderbolt For Alpine Ridge on X1C6
 * 
 * Large parts (link training and enumeration) 
 * taken from decompiled Mac AML.
 *
 * Implements mostly of the ACPI-part for handling Thunderbolt 3 on an Lenovo X1C6. Does power management for TB.
 *
 * This SSDT expects an unpatched controller in "windows native mode with RTD3" aka disabled "BIOS assist". It will silently disable itself on "bios-assist".
 *
 * It enables not only the PCIe-to-PCIe-bridge mode of the TB controller but the native drivers incl. power-management.
 * The controller is visible in SysInfo and the ICM is disabled on boot to let OSX' drivers take over the job.
 *
 * WIP but should be complete now. And full of bugs. Its largely untested. Intended to give a mostly complete and as native as possible experience.
 * Pair with SSDT-XHC1.dsl (native USB 2.0/3.0), SSDT-XHC2.dsl (USB 3.1 Gen2), SSDT-INIT.dsl (boot-time init) & SSDT-PTS.dsl (handling sleep).
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
//
// Credits @benbeder

DefinitionBlock ("", "SSDT", 2, "tyler", "_TB3", 0x00002000)
{
    // Common utils from SSDT-Darwin.dsl
    External (DTGP, MethodObj) // 5 Arguments
    External (OSDW, MethodObj) // 0 Arguments

    External (_SB.PCI0.RP09, DeviceObj)              // PCIe-port
    External (_SB.PCI0.RP09.PXSX, DeviceObj)         // original PCIe-bridge
    External (_SB.PCI0.RP09.XINI, MethodObj)         // original _INI patched by OC
    External (_SB.PCI0.RP09.XPS0, MethodObj)         // original _PS0 patched by OC
    External (_SB.PCI0.RP09.XPS3, MethodObj)         // original _PS3 patched by OC
    External (_SB.PCI0.XHC, DeviceObj)               // USB2/3 device

    External (_SB.PCI0.GPCB, MethodObj)              // 0 Arguments

    External (_GPE.TBFF, MethodObj)                  // detect TB root port
    External (_GPE.TFPS, MethodObj)                  // TB force status
    External (_GPE.XTFY, MethodObj)                  // Notify TB-controller on hotplug
    External (_SB.TBFP, MethodObj)                   // 1 Arguments
    External (FFTB, MethodObj)                       // Detect TB powered on
    External (MMRP, MethodObj)                       // Memory mapped root port
    External (MMTB, MethodObj)                       // Memory mapped TB port

    External (OSUM, MutexObj)                        // OSUP mutex

    External (_SB.PCI0.RP09.VDID, FieldUnitObj)

    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2, DeviceObj)
    External (_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND, FieldUnitObj)

    External (TNAT, FieldUnitObj)                    // Native hot plug
    External (TBSF, FieldUnitObj)
    External (SOHP, FieldUnitObj)                    // SMI on Hot Plug
    External (TWIN, FieldUnitObj)                    // TB Windows native mode
    External (GP5F, FieldUnitObj)
    External (NOHP, FieldUnitObj)                    // Notify HotPlug
    External (TBSE, FieldUnitObj)                    // TB root port number
    External (WKFN, FieldUnitObj)
    External (TBTS, IntObj)                          // TB enabled
    External (TARS, FieldUnitObj)
    External (FPEN, FieldUnitObj)
    External (FPG1, FieldUnitObj)
    External (FP1L, FieldUnitObj)
    External (CPGN, FieldUnitObj)                    // CIO Hotplug GPIO
    External (CPG1, FieldUnitObj)
    External (TRWA, FieldUnitObj)
    External (TBOD, FieldUnitObj)
    External (TSXW, FieldUnitObj)
    External (RTBT, IntObj)                          // Runtime D3 on TB enabled
    External (RTBC, FieldUnitObj)
    External (TBCD, FieldUnitObj)
    External (USME, FieldUnitObj)
    External (UWAB, FieldUnitObj)
    External (USBP, FieldUnitObj)
    External (USTC, FieldUnitObj)
    External (TBAS, FieldUnitObj)

    External (XLTP, IntObj)                          // DeepSleep ACPI-S0

    Scope (\_GPE)
    {
        Method (NTFY, 1, Serialized)
        {
            Debug = "TB:_GPE:NTFY"

            // Patch only if in windows native mode and OSX
            If (OSDW () && (\TWIN != Zero) && (NOHP == 0x01) && Arg0 == 0x09)
            {
                Debug = "TB:_GPE:NTFY() - call AMPE ()"

                \_SB.PCI0.RP09.UPSB.AMPE () // Notify UPSB
            }
            Else
            {
                XTFY(Arg0)
            }
        }
    }


    If (\TBTS == One)
    {
        // Scope (_SB)
        // {
        //     Method (GGDV, 1, Serialized)
        //     {
        //         Local0 = GGRP (Arg0)
        //         Local1 = GNMB (Arg0)
        //         Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
        //         OperationRegion (PDW0, SystemMemory, Local2, 0x04)
        //         Field (PDW0, AnyAcc, NoLock, Preserve)
        //         {
        //             Offset (0x01), 
        //             TEMP,   2, 
        //             Offset (0x04)
        //         }

        //         If (TEMP == One)
        //         {
        //             Return (One)
        //         }
        //         ElseIf (TEMP == 0x02)
        //         {
        //             Return (Zero)
        //         }
        //         Else
        //         {
        //             Return (One)
        //         }
        //     }

        //     Method (SGDI, 1, Serialized)
        //     {
        //         Local0 = GGRP (Arg0)
        //         Local1 = GNMB (Arg0)
        //         Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
        //         OperationRegion (PDW0, SystemMemory, Local2, 0x04)
        //         Field (PDW0, AnyAcc, NoLock, Preserve)
        //         {
        //             Offset (0x01), 
        //             TEMP,   2, 
        //             Offset (0x04)
        //         }

        //         TEMP = One
        //     }

        //     Method (SGDO, 1, Serialized)
        //     {
        //         Local0 = GGRP (Arg0)
        //         Local1 = GNMB (Arg0)
        //         Local2 = (GADR (Local0, 0x02) + (Local1 * 0x08))
        //         OperationRegion (PDW0, SystemMemory, Local2, 0x04)
        //         Field (PDW0, AnyAcc, NoLock, Preserve)
        //         {
        //             Offset (0x01), 
        //             TEMP,   2, 
        //             Offset (0x04)
        //         }

        //         TEMP = 0x02
        //     }
        // }

        Scope (\_SB.PCI0.RP09)
        {
            Name (UPN1, 0x03)                                // USBCPortNumber of SSP1/HS03
            Name (UPN2, 0x04)                                // USBCPortNumber of SSP2/HS04

            Name (R020, Zero)
            Name (R024, Zero)
            Name (R028, Zero)
            Name (R02C, Zero)

            Name (R118, Zero)
            Name (R119, Zero)
            Name (R11A, Zero)
            Name (R11C, Zero)
            Name (R120, Zero)
            Name (R124, Zero)
            Name (R128, Zero)
            Name (R12C, Zero)

            Name (R218, Zero)
            Name (R219, Zero)
            Name (R21A, Zero)
            Name (R21C, Zero)
            Name (R220, Zero)
            Name (R224, Zero)
            Name (R228, Zero)
            Name (R22C, Zero)

            Name (R318, Zero)
            Name (R319, Zero)
            Name (R31A, Zero)
            Name (R31C, Zero)
            Name (R320, Zero)
            Name (R324, Zero)
            Name (R328, Zero)
            Name (R32C, Zero)

            Name (R418, Zero)
            Name (R419, Zero)
            Name (R41A, Zero)
            Name (R41C, Zero)
            Name (R420, Zero)
            Name (R424, Zero)
            Name (R428, Zero)
            Name (R42C, Zero)
            Name (RVES, Zero)

            Name (R518, Zero)
            Name (R519, Zero)
            Name (R51A, Zero)
            Name (R51C, Zero)
            Name (R520, Zero)
            Name (R524, Zero)
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

            Name (RH10, Zero)
            Name (RH14, Zero)

            Name (POC0, Zero)


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

            OperationRegion (NHIM, SystemMemory, MMIO (DP19, 0, 0), 0x40)
            Field (NHIM, DWordAcc, NoLock, Preserve)
            {
                NH00,   32, 
                NH04,   8, 
                Offset (0x10), 
                NH10,   32, 
                NH14,   32
            }

            OperationRegion (RSTR, SystemMemory, NH10 + 0x39858, 0x0100)
            // OperationRegion (RSTR, SystemMemory, NHI1, 0x0100)
            Field (RSTR, DWordAcc, NoLock, Preserve)
            {
                CIOR,   32, 
                Offset (0xB8), 
                ISTA,   32, 
                // Offset (0xF0), 
                Offset (0xEC),
                ICME,   32
            }

            Method (INIT, 0, NotSerialized)
            {
                If (OSDW ())
                {
                    Concatenate("TB:INIT: TBSF - Thunderbolt(TM) SMI Function Number: ", TBSF, Debug)
                    Concatenate("TB:INIT: SOHP - SMI on Hot Plug for TBT devices: ", SOHP, Debug)
                    Concatenate("TB:INIT: TWIN - TbtWin10Support: ", TWIN, Debug)
                    Concatenate("TB:INIT: GP5F - Gpio filter to detect USB Hotplug event: ", GP5F, Debug)
                    Concatenate("TB:INIT: NOHP - Notify on Hot Plug for TBT devices: ", NOHP, Debug)
                    Concatenate("TB:INIT: TBSE - Thunderbolt(TM) Root port selector: ", TBSE, Debug)
                    Concatenate("TB:INIT: WKFN - WAK Finished: ", WKFN, Debug)
                    Concatenate("TB:INIT: TBTS - Thunderbolt support: ", TBTS, Debug)
                    Concatenate("TB:INIT: TARS - TbtAcpiRemovalSupport: ", TARS, Debug)
                    Concatenate("TB:INIT: FPEN - TbtFrcPwrEn: ", FPEN, Debug)
                    Concatenate("TB:INIT: FPG1 - TbtFrcPwrGpioNo: ", FPG1, Debug)
                    Concatenate("TB:INIT: FP1L - TbtFrcPwrGpioLevel: ", FP1L, Debug)
                    Concatenate("TB:INIT: CPG1 - TbtCioPlugEventGpioNo: ", CPG1, Debug)
                    Concatenate("TB:INIT: TRWA - Titan Ridge Osup command: ", TRWA, Debug)
                    Concatenate("TB:INIT: TBOD - Rtd3TbtOffDelay TBT RTD3 Off Delay: ", TBOD, Debug)
                    Concatenate("TB:INIT: TSXW - TbtSxWakeSwitchLogicEnable Set True if TBT_WAKE_N will be routed to PCH WakeB at Sx entry point. HW logic is required: ", TSXW, Debug)
                    Concatenate("TB:INIT: RTBT - Enable Rtd3 support for TBT: ", RTBT, Debug)
                    Concatenate("TB:INIT: RTBC - Enable TBT RTD3 CLKREQ mask: ", RTBC, Debug)
                    Concatenate("TB:INIT: TBCD - TBT RTD3 CLKREQ mask delay: ", TBCD, Debug)
                    
                    Concatenate("TB:INIT: USBP - Allow USB2 PHY Core Power Gating (ALLOW_USB2_CORE_PG): ", USBP, Debug)
                    Concatenate("TB:INIT: UWAB - USB2 Workaround Available: ", UWAB, Debug)
                    Concatenate("TB:INIT: USME - Disables HS01/HS01@XHC2 & Switches SSP1/SSP2@XHC2 -> 0x0A (maybe like U2OP?) ???: ", USME, Debug)
                    Concatenate("TB:INIT: USTC - USBC-if enabled (UBTC) ???: ", USTC, Debug)
                    Concatenate("TB:INIT: TBAS - Enables HS03/04@XHC1 ???: ", TBAS, Debug)

                    If (\TBTS)
                    {
                        Debug = "INIT: TB enabled"

                        If (\TWIN != Zero)
                        {
                            Debug = "INIT: TB native mode enabled"
                            Debug = "TB:INIT - Save Ridge Config on Boot ICM"
                            R020 = R_20 /* \_SB.PCI0.RP09.R_20 */
                            R024 = R_24 /* \_SB.PCI0.RP09.R_24 */
                            R028 = R_28 /* \_SB.PCI0.RP09.R_28 */
                            R02C = R_2C /* \_SB.PCI0.RP09.R_2C */
                            R118 = UP18 /* \_SB.PCI0.RP09.UP18 */
                            R119 = UP19 /* \_SB.PCI0.RP09.UP19 */
                            R11A = UP1A /* \_SB.PCI0.RP09.UP1A */
                            R11C = UP1C /* \_SB.PCI0.RP09.UP1C */
                            R120 = UP20 /* \_SB.PCI0.RP09.UP20 */
                            R124 = UP24 /* \_SB.PCI0.RP09.UP24 */
                            R128 = UP28 /* \_SB.PCI0.RP09.UP28 */
                            R12C = UP2C /* \_SB.PCI0.RP09.UP2C */
                            R218 = DP18 /* \_SB.PCI0.RP09.DP18 */
                            R219 = DP19 /* \_SB.PCI0.RP09.DP19 */
                            R21A = DP1A /* \_SB.PCI0.RP09.DP1A */
                            R21C = DP1C /* \_SB.PCI0.RP09.DP1C */
                            R220 = DP20 /* \_SB.PCI0.RP09.DP20 */
                            R224 = DP24 /* \_SB.PCI0.RP09.DP24 */
                            R228 = DP28 /* \_SB.PCI0.RP09.DP28 */
                            R228 = DP28 /* \_SB.PCI0.RP09.DP28 */
                            R318 = D318 /* \_SB.PCI0.RP09.D318 */
                            R319 = D319 /* \_SB.PCI0.RP09.D319 */
                            R31A = D31A /* \_SB.PCI0.RP09.D31A */
                            R31C = D31C /* \_SB.PCI0.RP09.D31C */
                            R320 = D320 /* \_SB.PCI0.RP09.D320 */
                            R324 = D324 /* \_SB.PCI0.RP09.D324 */
                            R328 = D328 /* \_SB.PCI0.RP09.D328 */
                            R32C = D32C /* \_SB.PCI0.RP09.D32C */
                            R418 = D418 /* \_SB.PCI0.RP09.D418 */
                            R419 = D419 /* \_SB.PCI0.RP09.D419 */
                            R41A = D41A /* \_SB.PCI0.RP09.D41A */
                            R41C = D41C /* \_SB.PCI0.RP09.D41C */
                            R420 = D420 /* \_SB.PCI0.RP09.D420 */
                            R424 = D424 /* \_SB.PCI0.RP09.D424 */
                            R428 = D428 /* \_SB.PCI0.RP09.D428 */
                            R42C = D42C /* \_SB.PCI0.RP09.D42C */
                            RVES = DVES /* \_SB.PCI0.RP09.DVES */
                            R518 = D518 /* \_SB.PCI0.RP09.D518 */
                            R519 = D519 /* \_SB.PCI0.RP09.D519 */
                            R51A = D51A /* \_SB.PCI0.RP09.D51A */
                            R51C = D51C /* \_SB.PCI0.RP09.D51C */
                            R520 = D520 /* \_SB.PCI0.RP09.D520 */
                            R524 = D524 /* \_SB.PCI0.RP09.D524 */
                            R528 = D528 /* \_SB.PCI0.RP09.D528 */
                            R52C = D52C /* \_SB.PCI0.RP09.D52C */
                            RH10 = NH10 /* \_SB.PCI0.RP09.NH10 */
                            RH14 = NH14 /* \_SB.PCI0.RP09.NH14 */
                            Debug = "TB:INIT - Store Complete"
                            
                            Sleep (One)

                            ICMD ()
                        }
                        Else
                        {
                            Debug = "INIT: TB bios-assist enabled"

                            If (\_GPE.TFPS ())
                            {
                                Debug = "INIT: TB Force Power alread enabled"
                            }
                            Else
                            {
                                Debug = "INIT: enabling TB Force Power"

                                \_SB.TBFP (One) // force power

                                Local0 = 10000 // 10 seconds
                                While (Local0 > 0 && \_SB.PCI0.RP09.VDID == 0xFFFFFFFF)
                                {
                                    Sleep (1)
                                    Local0--
                                }

                                Debug = Concatenate ("INIT: saw TB-Controller VDID: ", \_SB.PCI0.RP09.VDID)
                                Debug = Concatenate ("INIT: ms waited:  ", (10000 - Local0))
                            }
                        }
                    }
                }
            }

            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                If (!OSDW ())
                {
                    XINI ()
                }
            }

            // /**
            // * ThunderboltPowerUp
            // * Force power with controller and does init.
            // * Returns 1 if power up was successful
            // */
            // Method (TBON, 0, Serialized)
            // {
            //     Debug = Concatenate ("TB:TBON - CPGN: ", CPGN)

            //     If (\_GPE.TFPS ())
            //     {
            //         Debug = "TB:TBON - Already on"
            //         Return (Zero)
            //     }

            //     Debug = "TB:TBON - Force power on"
            //     TBFP (One) // force power

            //     Debug = "TB:TBON - Wait for TB root power up"
            //     Local1 = Timer + 6000000 // timeout in 600ms
            //     While (Timer < Local1 && FFTB (TBSE))
            //     {
            //         Sleep (1) // 1 millisecond
            //     }

            //     Debug = "TB:TBON - Sending OSUP handshake"
            //     Acquire (OSUM, 0xFFFF)
            //     Local0 = \_GPE.TBFF (TBSE) // calls OSUP if not already up
            //     Release (OSUM)
            //     Debug = Concatenate ("TB:TBON - TBFF: ", Local0)

            //     Debug = "TB:TBON - TB hardware init sequence"
            //     SOHP = Zero
            //     TNAT = One
            //     \_GPE.XTBT (TBSE, CPGN)

            //     Debug = "TB:TBON - Waiting for controller to appear"
            //     Local1 = Timer + 50000000 // timeout in 5s
            //     While (Timer < Local1 && UPVD == 0xFFFFFFFF)
            //     {
            //         Sleep (100) // 100 milliseconds
            //     }

            //     If (UPVD != 0xFFFFFFFF)
            //     {
            //         Debug = Concatenate ("TB:TBON - Seen controller: ", UPVD)
            //         Debug = Concatenate ("TB:TBON - CPGN: ", CPGN)

            //         Return (One)
            //     }

            //     Debug = "TB:TBON - Failed"
            //     Return (Zero)
            // }

            // /**
            // * ThunderboltPowerOff
            // * Release force power. This does not poll until controller 
            // * is actually down!
            // * Return 1 if power down was successful.
            // */
            // Method (TBOF, 0, Serialized)
            // {
            //     Debug = "TB:TBOF"

            //     If (\_GPE.TFPS ())
            //     {
            //         TBFP (Zero)

            //         Return (One)
            //     }

            //     Debug = "TB:TBOF - Already off"

            //     Return (Zero)
            // }

            /**
             * Thunderbolt status
             */
            Method (TBST, 0, Serialized)
            {
                Debug = Concatenate ("TB:_PS0 - MDUV: ", \_SB.PCI0.RP09.UPSB.MDUV)
                Debug = Concatenate ("TB:_PS0 - NHI: ", \_SB.PCI0.RP09.NH00)
                Debug = Concatenate ("TB:_PS0 - Root port: ", \_SB.PCI0.RP09.RPVD)
                Debug = Concatenate ("TB:_PS0 - Upstream port: ", \_SB.PCI0.RP09.UPVD)
                Debug = Concatenate ("TB:_PS0 - DSB0: ", \_SB.PCI0.RP09.DPVD)
                Debug = Concatenate ("TB:_PS0 - DSB1: ", \_SB.PCI0.RP09.D3VD)
                Debug = Concatenate ("TB:_PS0 - DSB2: ", \_SB.PCI0.RP09.D4VD)
                Debug = Concatenate ("TB:_PS0 - DSB4: ", \_SB.PCI0.RP09.D5VD)
            }

            /**
            * SendCMD
            * Sends command to TB controller. Assumes powered up.
            */
            Method (SCMD, 2, Serialized)
            {
                Debug = "TB:SCMD"
                // Local0 = (MMTB (TBSE) + 0x0548)
                // OperationRegion (PXVD, SystemMemory, Local0, 0x8)
                // Field (PXVD, DWordAcc, NoLock, Preserve)
                // {
                //     TB2P,   32, 
                //     P2TB,   32
                // }

                // T2PR,   32, 
                // P2TR,   32

                P2TR = (Arg1 << 8) | (Arg0 << 1) | 0x1
                Local0 = 50
                While (Local0 > 0)
                {
                    If (T2PR == 0xC || (T2PR & 1)) // 0xC = error, 0x1 = success
                    {
                        Break
                    }
                    Local0--
                    Sleep (100)
                }

                Debug = Concatenate ("TB:SCMD - P2TR: ", P2TR)
                Debug = Concatenate ("TB:SCMD - T2PR: ", T2PR)

                P2TR = Zero
            }

            /**
             * ICM Disable

             * Disable ICM to allow the OSX-driver to take control
             *
             * #define REG_FW_STS			        0x39944
             * #define REG_FW_STS_NVM_AUTH_DONE	    BIT(31)
             * #define REG_FW_STS_CIO_RESET_REQ	    BIT(30)
             * #define REG_FW_STS_ICM_EN_CPU		BIT(2)
             * #define REG_FW_STS_ICM_EN_INVERT	    BIT(1)
             * #define REG_FW_STS_ICM_EN		    BIT(0)
             *
             * Source: https://github.com/dell/thunderbolt-dkms/blob/master/thunderbolt/nhi_regs.h
             */ 
            Method (ICMD, 0, NotSerialized)
            {
                Debug = "TB:ICMD - Disable ICM "

                \_SB.PCI0.RP09.POC0 = One

                Debug = Concatenate ("TB:ICMD - ICME 1: ", \_SB.PCI0.RP09.ICME)

                If (\_SB.PCI0.RP09.ICME != 0x800001A3)
                {
                    If (\_SB.PCI0.RP09.CNHI ())
                    {
                        Debug = Concatenate ("TB:ICMD - ICME 2: ", \_SB.PCI0.RP09.ICME)

                        If (\_SB.PCI0.RP09.ICME != 0xFFFFFFFF)
                        {
                            \_SB.PCI0.RP09.WTLT ()

                            Debug = Concatenate ("TB:ICMD - ICME 3: ", \_SB.PCI0.RP09.ICME)

                            If (Local0 = (\_SB.PCI0.RP09.ICME & 0x80000000)) // NVM started means we need reset
                            {
                                Debug = "TB:ICMD - NVM already started, resetting"

                                \_SB.PCI0.RP09.ICME = 0x102 // REG_FW_STS_ICM_EN_INVERT

                                Local0 = 1000
                                While ((\_SB.PCI0.RP09.ICME & 0x1) == Zero)
                                {
                                    Local0--
                                    If (Local0 == Zero)
                                    {
                                        Break
                                    }

                                    Sleep (One)
                                }

                                Debug = Concatenate ("TB:ICMD - ICME 4: ", \_SB.PCI0.RP09.ICME)

                                Sleep (1000)
                            }
                        }
                    }
                }

                \_SB.PCI0.RP09.POC0 = Zero
            }


            /**
             * Send TBT command
             */
            Method (TBTC, 1, Serialized)
            {
                Debug = "TB:TBTC"

                P2TR = Arg0

                Local0 = 0x64
                Local1 = T2PR /* \_SB.PCI0.RP09.T2PR */

                While ((Local1 & One) == Zero)
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

                    Local1 = T2PR /* \_SB.PCI0.RP09.T2PR */
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
                Debug = "TB:CMPE"

                Notify (\_SB.PCI0.RP09, Zero) // Bus Check
            }

            Method (CNHI, 0, Serialized)
            {
                Debug = "TB:CNHI"
                
                Local0 = 10

                Debug = "TB:CNHI - Configure root port"
                While (Local0)
                {
                    R_20 = R020 // Memory Base/Limit
                    R_24 = R024 // Prefetch Base/Limit
                    R_28 = R028 /* \_SB.PCI0.RP09.R028 */
                    R_2C = R02C /* \_SB.PCI0.RP09.R02C */
                    RPR4 = 0x07 // Command
                
                    If (R020 == R_20) // read back check
                    {
                        Break
                    }

                    Sleep (One)
                    Local0--
                }

                If (R020 != R_20) // configure root port failed
                {
                    Debug = "TB:CNHI - Error: configure root port failed"

                    Return (Zero)
                }

                Local0 = 10

                Debug = "TB:CNHI - Configure UPSB"
                While (Local0)
                {

                    UP18 = R118 // UPSB Pri Bus
                    UP19 = R119 // UPSB Sec Bus
                    UP1A = R11A // UPSB Sub Bus
                    UP1C = R11C // UPSB IO Base/Limit
                    UP20 = R120 // UPSB Memory Base/Limit
                    UP24 = R124 // UPSB Prefetch Base/Limit
                    UP28 = R128 /* \_SB.PCI0.RP09.R128 */
                    UP2C = R12C /* \_SB.PCI0.RP09.R12C */
                    UP04 = 0x07 // Command

                    If (R119 == UP19) // read back check
                    {
                        Break
                    }

                    Sleep (One)
                    Local0--
                }

                If (R119 != UP19) // configure UPSB failed
                {
                    Debug = "TB:CNHI - Error: configure UPSB failed"

                    Return (Zero)
                }

                Debug = "TB:CNHI - Wait for link training"
                If (WTLT () != One)
                {
                    Debug = "TB:CNHI - Error: Wait for link training failed"

                    Return (Zero)
                }

                Local0 = 10

                // Configure DSB0
                Debug = "TB:CNHI - Configure DSB"
                While (Local0)
                {
                    DP18 = R218 // Pri Bus
                    DP19 = R219 // Sec Bus
                    DP1A = R21A // Sub Bus
                    DP1C = R21C // IO Base/Limit
                    DP20 = R220 // Memory Base/Limit
                    DP24 = R224 // Prefetch Base/Limit
                    DP28 = R228 /* \_SB.PCI0.RP09.R228 */
                    DP2C = R22C /* \_SB.PCI0.RP09.R22C */
                    DP04 = 0x07 // Command
                    Debug = "TB:CNHI - Configure NHI Dp 0 done"

                    D318 = R318 // Pri Bus
                    D319 = R319 // Sec Bus
                    D31A = R31A // Sub Bus
                    D31C = R31C // IO Base/Limit
                    D320 = R320 // Memory Base/Limit
                    D324 = R324 // Prefetch Base/Limit
                    D328 = R328 /* \_SB.PCI0.RP09.R328 */
                    D32C = R32C /* \_SB.PCI0.RP09.R32C */
                    D304 = 0x07 // Command
                    Debug = "TB:CNHI - Configure NHI Dp 3 done"

                    D418 = R418 // Pri Bus
                    D419 = R419 // Sec Bus
                    D41A = R41A // Sub Bus
                    D41C = R41C // IO Base/Limit
                    D420 = R420 // Memory Base/Limit
                    D424 = R424 // Prefetch Base/Limit
                    D428 = R428 /* \_SB.PCI0.RP09.R428 */
                    D42C = R42C /* \_SB.PCI0.RP09.R42C */
                    DVES = RVES // DSB2 0x564
                    D404 = 0x07 // Command
                    Debug = "TB:CNHI - Configure NHI Dp 4 done"

                    D518 = R518 // Pri Bus
                    D519 = R519 // Sec Bus
                    D51A = R51A // Sub Bus
                    D51C = R51C // IO Base/Limit
                    D520 = R520 // Memory Base/Limit
                    D524 = R524 // Prefetch Base/Limit
                    D528 = R528 /* \_SB.PCI0.RP09.R528 */
                    D52C = R52C /* \_SB.PCI0.RP09.R52C */
                    D504 = 0x07 // Command
                    Debug = "TB:CNHI - Configure NHI Dp 5 done"

                    If (R219 == DP19)
                    {
                        Break
                    }

                    Sleep (One)
                    Local0--
                }

                If (R219 != DP19) // configure DSB failed
                {
                    Debug = "TB:CNHI - Error: configure DSB failed"

                    Return (Zero)
                }

                If (WTDL () != One)
                {
                    Debug = "TB:CNHI - Error: Configure NHI DPs failed"

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

                    If (RH10 == NH10)
                    {
                        Break
                    }

                    Sleep (One)
                    Local0--
                }

                If (RH10 != NH10) // configure failed
                {
                    Debug = "TB:CNHI - Error: Configure NHI failed"

                    Return (Zero)
                }

                Debug = "TB:CNHI - Configure NHI0 done"

                Return (One)
            }

            /**
             * Uplink check
             */
            Method (UPCK, 0, Serialized)
            {
                Debug = Concatenate ("TB:UPCK - Up Stream VID/DID: ", UPVD)

                // Accepts every intel device
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
                Debug = "TB:ULTC"

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
                // Debug = "TB:WTLT"

                Local0 = 0x07D0
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

                Return (Local1)
            }

            /**
             * Downlink training check
             */
            Method (DLTC, 0, Serialized)
            {
                // Debug = "TB:DLTC"

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
                // Debug = "TB:WTDL"

                Local0 = 0x07D0
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
                Debug = "TB:PCEU"
                \_SB.PCI0.RP09.PRSR = Zero

                Debug = "TB:PCEU - Put upstream bridge back into D0 "
                If (\_SB.PCI0.RP09.PSTX != Zero)
                {
                    Debug = "TB:PCEU - exit D0, restored = true"
                    \_SB.PCI0.RP09.PRSR = One
                    \_SB.PCI0.RP09.PSTX = Zero
                }

                If (\_SB.PCI0.RP09.LDXX == One)
                {
                    Debug = "TB:PCEU - Clear link disable on upstream bridge"
                    Debug = "TB:PCEU - clear link disable, restored = true"
                    \_SB.PCI0.RP09.PRSR = One
                    \_SB.PCI0.RP09.LDXX = Zero
                }

                If (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.XRTE != Zero)
                {
                    Debug = "TB:PCEU - XRST changed, restored = true"
                    \_SB.PCI0.RP09.PRSR = One
                    \_SB.PCI0.RP09.UPSB.DSB0.NHI0.XRST (Zero)
                }
            }

            /**
             * Bring down PCI link
             */
            Method (PCDA, 0, Serialized)
            {
                Debug = "TB:PCDA"
                If (\_SB.PCI0.RP09.POFX () != Zero)
                {
                    \_SB.PCI0.RP09.PCIA = Zero

                    Debug = "TB:PCDA - Put upstream bridge into D3"
                    \_SB.PCI0.RP09.PSTX = 0x03

                    Debug = "TB:PCDA - Set link disable on upstream bridge"
                    \_SB.PCI0.RP09.LDXX = One

                    Local5 = (Timer + 10000000)
                    While (Timer <= Local5)
                    {
                        Debug = "TB:PCDA - Wait for link to drop..."
                        If (\_SB.PCI0.RP09.LACR == One)
                        {
                            If (\_SB.PCI0.RP09.LACT == Zero)
                            {
                                Debug = "TB:PCDA - No link activity"
                                Break
                            }
                        }
                        ElseIf (\_SB.PCI0.RP09.UPSB.AVND == 0xFFFFFFFF)
                        {
                            Debug = "TB:PCDA - UPSB is down - VID/DID is -1"
                            Break
                        }

                        Sleep (0x0A)
                    }

                    Debug = "TB:PCDA - Request PCI-GPIO to be disabled"
                    \_SB.PCI0.RP09.GPCI = Zero
                    \_SB.PCI0.RP09.UGIO ()
                }
                Else
                {
                    Debug = "TB:PCDA - Already disabled, not disabling"
                }

                \_SB.PCI0.RP09.IIP3 = One
            }

            /**
             * Returns true if both TB and TB-USB are idle
             */
            Method (POFX, 0, Serialized)
            {
                Debug = Concatenate ("TB:POFX - Result (!RTBT && !RUSB): ", (!\_SB.PCI0.RP09.RTBT && !\_SB.PCI0.RP09.RUSB))

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
                Debug = "TB:CTBT"

                // If ((GGDV (CPGN) == One) && (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                // If ((\_GPE.TFPS () == One) && \_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                {
                    Debug = "TB:CTBT - UPSB-device enabled"
                    Local2 = \_SB.PCI0.RP09.UPSB.CRMW (0x3C, Zero, 0x02, 0x04000000, 0x04000000)

                    If (Local2 == Zero)
                    {
                        Debug = "TB:CTBT - Set CP_ACK_POWERDOWN_OVERRIDE"
                        \_SB.PCI0.RP09.CTPD = One
                    }
                }
                Else
                {
                    Debug = "TB:CTBT - UPSB-device disabled"
                }
            }

            /**
             * Set once we do a force power
             * Then when NHI comes up we do a ICM reset. We have to wait for 
             * NHI because we have to use it to send the ICM reset.
             */
            Name (IRST, Zero)


            /**
             * Toggle controller power
             *
             * Power controllers either up or down depending on the request.
             * On Macs, there's two GPIO signals for controlling TB and XHC 
             * separately. If such signals exist, we need to find it. Otherwise 
             * we lose the power saving capabilities.
             *
             * Returns non-zero Local2 if GPIOs changed and reinit is necessary
             */
            Method (UGIO, 0, Serialized)
            {
                Debug = "TB:UGIO"

                If (\_SB.PCI0.RP09.GPCI == Zero)
                {
                    Debug = "TB:UGIO - PCI wants off (GPCI)"
                }
                Else
                {
                    Debug = "TB:UGIO - PCI wants on (GPCI)"
                }

                If (\_SB.PCI0.RP09.GNHI == Zero)
                {
                    Debug = "TB:UGIO - NHI wants off (GNHI)"
                }
                Else
                {
                    Debug = "TB:UGIO - NHI wants on (GNHI)"
                }

                If (\_SB.PCI0.RP09.GXCI == Zero)
                {
                    Debug = "TB:UGIO - XHCI wants off (GXCI)"
                }
                Else
                {
                    Debug = "TB:UGIO - XHCI wants on (GXCI)"
                }

                If (\_SB.PCI0.RP09.RTBT == Zero)
                {
                    Debug = "TB:UGIO - TBT allows off (RTBT)"
                }
                Else
                {
                    Debug = "TB:UGIO - TBT forced on (RTBT)"
                }

                If (\_SB.PCI0.RP09.RUSB == Zero)
                {
                    Debug = "TB:UGIO - USB allows off (RUSB)"
                }
                Else
                {
                    Debug = "TB:UGIO - USB forced on (RUSB)"
                }

                // Which controller is requested to be on?
                Local0 = (\_SB.PCI0.RP09.GNHI || \_SB.PCI0.RP09.RTBT) // TBT
                Local1 = (\_SB.PCI0.RP09.GXCI || \_SB.PCI0.RP09.RUSB) // USB

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

                If (Local0 == Zero)
                {
                    Debug = "TB:UGIO - TBT GPIO should be off"
                }
                Else
                {
                    Debug = "TB:UGIO - TBT GPIO should be on"
                }

                If (Local1 == Zero)
                {
                    Debug = "TB:UGIO - USB GPIO should be off"
                }
                Else
                {
                    Debug = "TB:UGIO - USB GPIO should be on"
                }

                Local2 = Zero

                /**
                 * Force power to CIO
                 */
                If (Local0 != Zero)
                {
                    Debug = "TB:UGIO - Make sure TBT is on"

                    // TODO: check if CIO power is forced
                    //If (GGDV (0x01070004) == Zero)
                    If (Zero)
                    {
                        Debug = "TB:UGIO - Turn on TBT GPIO"

                        // TODO: force CIO power
                        //SGDI (0x01070004)
                        Local2 = One

                        \_SB.PCI0.RP09.CTPD = Zero
                    }
                }

                /**
                 * Force power to USB
                 */
                If (Local1 != Zero)
                {
                    Debug = "TB:UGIO - Make sure USB is on"

                    // TODO: check if USB power is forced
                    //If (GGDV (0x01070007) == Zero)
                    If (Zero)
                    {
                        // TODO: force USB power
                        //SGDI (0x01070007)
                        Local2 = One
                    }
                }

                // if we did power on
                If (Local2 != Zero)
                {
                    Sleep (500)
                }

                Local3 = Zero

                /**
                 * Disable force power to CIO
                 */
                If (Local0 == Zero)
                {
                    Debug = "TB:UGIO - Make sure TBT is off"

                    // TODO: check if CIO power is off
                    //If (GGDV (0x01070004) == One)
                    If (Zero)
                    {
                        \_SB.PCI0.RP09.CTBT ()

                        If (\_SB.PCI0.RP09.CTPD != Zero)
                        {
                            Debug = "TB:UGIO - Turn off TBT GPIO"

                            // TODO: force power off CIO
                            //SGOV (0x01070004, Zero)
                            //SGDO (0x01070004)
                            Local3 = One
                        }
                    }
                }

                /**
                 * Disable force power to USB
                 */
                If (Local1 == Zero)
                {
                    Debug = "TB:UGIO - Make sure USB is off"

                    //If (GGDV (0x01070007) == One)
                    If (Zero)
                    {
                        // TODO: force power off USB
                        //SGOV (0x01070007, Zero)
                        //SGDO (0x01070007)
                        Local3 = One
                    }
                }

                // if we did power down, wait for things to settle
                If (Local3 != Zero)
                {
                    Sleep (100)
                }

                Debug = Concatenate ("TB:UGIO finished - Result: ", Local2)

                Return (Local2)
            }

            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                Debug = "TB:_PS0"

                If (OSDW () && \TWIN != Zero)
                {
                    PCEU ()

                    \_SB.PCI0.RP09.TBST ()
                }
                ElseIf (CondRefOf (\_SB.PCI0.RP09.XPS0))
                {
                    \_SB.PCI0.RP09.XPS0 ()
                }
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                Debug = "TB:_PS3"

                If (OSDW () && \TWIN != Zero)
                {
                    If (\_SB.PCI0.RP09.POFX () != Zero)
                    {
                        \_SB.PCI0.RP09.CTBT ()
                    }

                    PCDA ()

                    \_SB.PCI0.RP09.TBST ()
                }
                ElseIf (CondRefOf (\_SB.PCI0.RP09.XPS3))
                {
                    \_SB.PCI0.RP09.XPS3 ()
                }
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
                If (Zero)
                // If ((GGOV (CPGN) == Zero) && (GGDV (CPGN) == Zero))
                // If (\_GPE.TFPS () == Zero)
                {
                    \_SB.PCI0.RP09.PSTX = Zero

                    While (One)
                    {
                        If (\_SB.PCI0.RP09.LDXX == One)
                        {
                            \_SB.PCI0.RP09.LDXX = Zero
                        }

                        // here, we force CIO power on
                        // SGDI (CPGN)
                        // \_SB.TBFP (One)

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
                        // SGOV (CPGN, Zero)
                        // SGDO (CPGN)
                        // \_SB.TBFP (Zero)

                        Sleep (0x03E8)
                    }
                }

                Debug = Concatenate ("UTLK: Up Stream VID/DID: ", \_SB.PCI0.RP09.UPSB.AVND)
                Debug = Concatenate ("UTLK: Root Port VID/DID: ", \_SB.PCI0.RP09.AVND)
                Debug = Concatenate ("UTLK: Root Port PRIB: ", \_SB.PCI0.RP09.PRIB)
                Debug = Concatenate ("UTLK: Root Port SECB: ", \_SB.PCI0.RP09.SECB)
                Debug = Concatenate ("UTLK: Root Port SUBB: ", \_SB.PCI0.RP09.SUBB)
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

            OperationRegion (OE2H, PCI_Config, 0xE2, One)
            Field (OE2H, ByteAcc, NoLock, Preserve)
            {
                    ,   2, 
                L23X,   1, 
                L23D,   1
            }

            OperationRegion (DMIH, PCI_Config, 0x0324, One)
            Field (DMIH, ByteAcc, NoLock, Preserve)
            {
                    ,   3, 
                LEDX,   1
            }

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
            * PXSX replaced by UPSB on OSX
            */
            Scope (PXSX)
            {
                Method (_STA, 0, NotSerialized)
                {
                    If (OSDW () && \TWIN != Zero)
                    {
                        Return (Zero) // hidden for OSX
                    }

                    Return (0x0F) // visible for others
                }
            }

            If (\TWIN != Zero)
            {

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

                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Debug = "TB:UPSB:_STA()"

                        If (OSDW ())
                        {
                            Return (0xF) // visible for OSX
                        }

                        Return (Zero) // hidden for others
                    }

                    Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                    {
                        Return (SECB) /* \_SB.PCI0.RP09.UPSB.SECB */
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
                        Debug = "TB:UPSB:PCED"
                        Debug = "TB:UPSB:PCED - Request TB-GPIO to be enabled"
                        \_SB.PCI0.RP09.GPCI = One

                        // power up the controller
                        If (\_SB.PCI0.RP09.UGIO () != Zero)
                        {
                            Debug = "TB:UPSB:PCED - GPIOs changed, restored = true"
                            \_SB.PCI0.RP09.PRSR = One
                        }

                        Local0 = Zero
                        Local1 = Zero

                        If (\_SB.PCI0.RP09.IIP3 != Zero)
                        {
                            \_SB.PCI0.RP09.PRSR = One

                            Local0 = One

                            Debug = "TB:UPSB:PCED - Set link disable on upstream bridge"
                            \_SB.PCI0.RP09.LDXX = One
                        }

                        Local5 = (Timer + 0x00989680)

                        Debug = Concatenate ("TB:UPSB:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR: ", \_SB.PCI0.RP09.PRSR)

                        If (\_SB.PCI0.RP09.PRSR != Zero)
                        {
                            Debug = "TB:UPSB:PCED - Wait for power up"

                            Sleep (0x1E)

                            If ((Local0 != Zero) || (Local1 != Zero))
                            {
                                \_SB.PCI0.RP09.TSPD = One

                                If (Local1 != Zero) {}
                                ElseIf (Local0 != Zero)
                                {
                                    Debug = "TB:UPSB:PCED - Clear link disable on upstream bridge"
                                    \_SB.PCI0.RP09.LDXX = Zero
                                }

                                While (Timer <= Local5)
                                {
                                    Debug = "TB:UPSB:PCED - Wait for link training..."
                                    If (\_SB.PCI0.RP09.LACR == Zero)
                                    {
                                        If (\_SB.PCI0.RP09.LTRN != One)
                                        {
                                            Debug = "TB:UPSB:PCED - GENSTEP WA - Link training cleared"
                                            Break
                                        }
                                    }
                                    ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                                    {
                                        Debug = "TB:UPSB:PCED - GENSTEP WA - Link training cleared and link is active"
                                        Break
                                    }

                                    Sleep (0x0A)
                                }

                                Sleep (0x78)
                                While (Timer <= Local5)
                                {
                                    Debug = "TB:UPSB:PCED - PEG WA - Wait for config space..."
                                    If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                                    {
                                        Debug = "TB:UPSB:PCED - UPSB UP - Read VID/DID"
                                        Break
                                    }

                                    Sleep (0x0A)
                                }

                                \_SB.PCI0.RP09.TSPD = 0x03
                                \_SB.PCI0.RP09.LRTN = One
                            }

                            Debug = "TB:UPSB:PCED - Wait for downstream bridge to appear"
                            Local5 = (Timer + 0x00989680)
                            While (Timer <= Local5)
                            {
                                Debug = "TB:UPSB:PCED - Wait for link training..."
                                If (\_SB.PCI0.RP09.LACR == Zero)
                                {
                                    If (\_SB.PCI0.RP09.LTRN != One)
                                    {
                                        Debug = "TB:UPSB:PCED - Link training cleared"
                                        Break
                                    }
                                }
                                ElseIf ((\_SB.PCI0.RP09.LTRN != One) && (\_SB.PCI0.RP09.LACT == One))
                                {
                                    Debug = "TB:UPSB:PCED - Link training cleared and link is active"
                                    Break
                                }

                                Sleep (0x0A)
                            }

                            Sleep (0xFA)
                        }

                        \_SB.PCI0.RP09.PRSR = Zero

                        While (Timer <= Local5)
                        {
                            Debug = "TB:UPSB:PCED - Wait for config space..."
                            If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                            {
                                Debug = "TB:UPSB:PCED - UPSB up"
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
                    * Hotplug notify
                    * Called by ACPI
                    */
                    Method (AMPE, 0, Serialized)
                    {
                        Debug = "TB:UPSB:AMPE() - Hotplug notify to NHI0 by ACPI"

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
                        Debug = "TB:UPSB:UMPE() - Hotplug notify XHC2 & XHC by NHI"

                        Notify (\_SB.PCI0.RP09.UPSB.DSB2.XHC2, Zero) // Bus Check

                        If (CondRefOf (\_SB.PCI0.XHC))
                        {
                            Notify (\_SB.PCI0.XHC, Zero) // Bus Check
                        }
                    }

                    Name (MDUV, One) // plug status

                    /**
                    * Cable status callback
                    * Called from NHI driver on hotplug
                    */
                    Method (MUST, 1, Serialized)
                    {
                        If (MDUV != Arg0)
                        {
                            Debug = Concatenate ("TB:UPSB:MUST calling Hotplug to XHC2 & XHC setting MDUV to: ", Arg0)

                            MDUV = Arg0
                            UMPE ()
                        }
                        Else 
                        {
                            Debug = Concatenate ("TB:UPSB:MUST not changed, leavin MDUV, called with args: ", Arg0)
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

                            \_SB.PCI0.RP09.TBST ()
                        }
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        Debug = "TB:UPSB:_PS3"

                        // If (!OSDW ())
                        // {
                        //     If (\_SB.PCI0.RP09.UPCK () == Zero)
                        //     {
                        //         Debug = "TB:UPSB:_PS3 - calling UTLK"
                        //         \_SB.PCI0.RP09.UTLK (One, 0x03E8)
                        //     }
                        //     Else
                        //     {
                        //         Debug = "TB:UPSB:_PS3 - UTLK OK"
                        //     }

                        //     \_SB.PCI0.RP09.TBTC (0x05)
                        // }

                        If (OSDW ())
                        {
                            \_SB.PCI0.RP09.TBST ()
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
                        WDAT = Arg3
                        Debug = Concatenate ("TB:UPSB:CIOW - WDAT: ", WDAT)

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
                            Local1 = TMOT /* \_SB.PCI0.RP09.UPSB.TMOT */
                        }

                        If (Local1)
                        {
                            Debug = Concatenate ("TB:UPSB:CIOW - Error: ", Local1)
                        }

                        Return (Local1)
                    }

                    /**
                    * CIO read
                    */
                    Method (CIOR, 3, Serialized)
                    {
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
                            Local1 = TMOT /* \_SB.PCI0.RP09.UPSB.TMOT */
                        }

                        If (Local1)
                        {
                            Debug = Concatenate ("TB:UPSB:CIOR - Error: ", Local1)
                            Debug = Concatenate ("TB:UPSB:CIOR - RDAT: ", RDAT)
                        }

                        If (Local1 == Zero)
                        {
                            Return (Package ()
                            {
                                Zero, 
                                RDAT
                            })
                        }
                        Else
                        {
                            Return (Package ()
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
                        Local1 = One

                        // If (((GGDV (CPGN) == One) || (GGDV (0x02060001) == One)) && 
                        // If (((GGDV (CPGN) == One)) && 
                        //      (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                        // If ((\_GPE.TFPS () == One) && (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF))
                        If (\_SB.PCI0.RP09.UPSB.AVND != 0xFFFFFFFF)
                        {
                            Local3 = Zero

                            While (Local3 <= 0x04)
                            {
                                Local2 = CIOR (Arg0, Arg1, Arg2)

                                If (DerefOf (Local2 [Zero]) == Zero)
                                {
                                    Local2 = DerefOf (Local2 [One])
                                    // Debug = Concatenate ("TB:UPSB:CRMW - Read Value: ", Local2)

                                    Local2 &= ~Arg4
                                    Local2 |= Arg3
                                    // Debug = Concatenate ("TB:UPSB:CRMW - Write Value: ", Local2)

                                    Local2 = CIOW (Arg0, Arg1, Arg2, Local2)

                                    If (Local2 == Zero)
                                    {
                                        Local2 = CIOR (Arg0, Arg1, Arg2)

                                        If (DerefOf (Local2 [Zero]) == Zero)
                                        {
                                            Local2 = DerefOf (Local2 [One])
                                            // Debug = Concatenate ("TB:UPSB:CRMW - Read Value 2: ", Local2)

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

                        If (Local1)
                        {
                            Debug = Concatenate ("TB:UPSB:CRMW - Error value: ", Local1)
                        }

                        Return (Local1)
                    }

                    /**
                    * Run on _PTS
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB0.SECB */
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

                        Method (PCEU, 0, Serialized)
                        {
                            Debug = "TB:DSB0:PCEU"
                            \_SB.PCI0.RP09.UPSB.DSB0.PRSR = Zero

                            Debug = "TB:DSB0:PCEU - Put upstream bridge back into D0 "
                            If (\_SB.PCI0.RP09.UPSB.DSB0.PSTA != Zero)
                            {
                                Debug = "TB:DSB0:PCEU - exit D0, restored = true"
                                \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                                \_SB.PCI0.RP09.UPSB.DSB0.PSTA = Zero
                            }

                            If (\_SB.PCI0.RP09.UPSB.DSB0.LDIS == One)
                            {
                                Debug = "TB:DSB0:PCEU - Clear link disable on upstream bridge"
                                Debug = "TB:DSB0:PCEU - clear link disable, restored = true"
                                \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                                \_SB.PCI0.RP09.UPSB.DSB0.LDIS = Zero
                            }
                        }

                        Method (PCDA, 0, Serialized)
                        {
                            Debug = "TB:DSB0:PCDA"

                            If (\_SB.PCI0.RP09.UPSB.DSB0.POFX () != Zero)
                            {
                                \_SB.PCI0.RP09.UPSB.DSB0.PCIA = Zero
                                Debug = "TB:DSB0:PCDA - Put upstream bridge into D3"

                                \_SB.PCI0.RP09.UPSB.DSB0.PSTA = 0x03
                                Debug = "TB:DSB0:PCDA - Set link disable on upstream bridge"

                                \_SB.PCI0.RP09.UPSB.DSB0.LDIS = One

                                Local5 = (Timer + 0x00989680)

                                While (Timer <= Local5)
                                {
                                    Debug = "TB:DSB0:PCDA - Wait for link to drop..."
                                    If (\_SB.PCI0.RP09.UPSB.DSB0.LACR == One)
                                    {
                                        If (\_SB.PCI0.RP09.UPSB.DSB0.LACT == Zero)
                                        {
                                            Debug = "TB:DSB0:PCDA - No link activity"
                                            Break
                                        }
                                    }
                                    ElseIf (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.AVND == 0xFFFFFFFF)
                                    {
                                        Debug = "TB:DSB0:PCDA - VID/DID is -1"
                                        Break
                                    }

                                    Sleep (0x0A)
                                }

                                Debug = "TB:DSB0:PCDA - Request NHI-GPIO to be disabled"
                                \_SB.PCI0.RP09.GNHI = Zero
                                \_SB.PCI0.RP09.UGIO ()
                            }
                            Else
                            {
                                Debug = "TB:DSB0:PCDA - Not disabling"
                            }

                            \_SB.PCI0.RP09.UPSB.DSB0.IIP3 = One
                        }

                        Method (POFX, 0, Serialized)
                        {
                            Debug = Concatenate ("TB:DSB0:POFX - Result (!RTBT): ", (!\_SB.PCI0.RP09.RTBT))

                            Return (!\_SB.PCI0.RP09.RTBT)
                        }

                        Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                        {
                            Debug = "TB:DSB0:_PS0"

                            If (OSDW ())
                            {
                                PCEU ()

                                \_SB.PCI0.RP09.TBST ()
                            }
                        }

                        Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                        {
                            Debug = "TB:DSB0:_PS3"

                            If (OSDW ())
                            {
                                PCDA ()

                                \_SB.PCI0.RP09.TBST ()
                            }
                        }

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If (OSDW ())
                            {
                                If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                                {
                                    Local0 = Package ()
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

                        Device (NHI0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                            Name (_STR, Unicode ("Thunderbolt"))  // _STR: Description String

                            /**
                            * Enable downstream link
                            */
                            Method (PCED, 0, Serialized)
                            {
                                Debug = "TB:NHI0:PCED"
                                Debug = "TB:NHI0:PCED - Request NHI-GPIO to be enabled"
                                \_SB.PCI0.RP09.GNHI = One


                                // we should not need to force power since 
                                // UPSX init should already have done so!
                                If (\_SB.PCI0.RP09.UGIO () != Zero)
                                {
                                    Debug = "TB:NHI0:PCED - GPIOs changed, restored = true"
                                    \_SB.PCI0.RP09.UPSB.DSB0.PRSR = One
                                }

                                // Do some link training
                                // Local0 = Zero
                                // Local1 = Zero

                                Local5 = (Timer + 0x00989680)
                                Debug = Concatenate ("TB:NHI0:PCED - restored flag, THUNDERBOLT_PCI_LINK_MGMT_DEVICE.PRSR: ", \_SB.PCI0.RP09.UPSB.DSB0.PRSR)

                                If (\_SB.PCI0.RP09.UPSB.DSB0.PRSR != Zero)
                                {
                                    Debug = "TB:NHI0:PCED - Wait for power up"
                                    Debug = "TB:NHI0:PCED - Wait for downstream bridge to appear"
                                    Local5 = (Timer + 0x00989680)
                                    While (Timer <= Local5)
                                    {
                                        Debug = "TB:NHI0:PCED - Wait for link training..."
                                        If (\_SB.PCI0.RP09.UPSB.DSB0.LACR == Zero)
                                        {
                                            If (\_SB.PCI0.RP09.UPSB.DSB0.LTRN != One)
                                            {
                                                Debug = "TB:NHI0:PCED - Link training cleared"
                                                Break
                                            }
                                        }
                                        ElseIf ((\_SB.PCI0.RP09.UPSB.DSB0.LTRN != One) && (\_SB.PCI0.RP09.UPSB.DSB0.LACT == One))
                                        {
                                            Debug = "TB:NHI0:PCED - Link training cleared and link is active"
                                            Break
                                        }

                                        Sleep (0x0A)
                                    }

                                    Sleep (0x96)
                                }

                                \_SB.PCI0.RP09.UPSB.DSB0.PRSR = Zero

                                While (Timer <= Local5)
                                {
                                    Debug = "TB:NHI0:PCED - Wait for config space..."
                                    If (\_SB.PCI0.RP09.UPSB.DSB0.NHI0.AVND != 0xFFFFFFFF)
                                    {
                                        Debug = "TB:NHI0:PCED - DSB0 UP - Read VID/DID"
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
                            *
                            * Called by NHI driver when link is idle.
                            * Once both XHC and NHI idle, we can power down.
                            */
                            Method (RTPC, 1, Serialized)
                            {
                                Debug = Concatenate ("TB:NHI0:RTPC called with args: ", Arg0)

                                If (Arg0 <= One)
                                {
                                    // Force TB on if usb is on - Test XXX
                                    If (!(Arg0 == Zero && \_SB.PCI0.RP09.RUSB == One))
                                    {
                                        Debug = Concatenate ("TB:NHI0:RTPC setting RTBT to: ", Arg0)
                                        \_SB.PCI0.RP09.RTBT = Arg0
                                    }
                                    Else
                                    {
                                        Debug = "TB:NHI0:RTPC leaving RTBT as RUSB is One"
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
                                Debug = "TB:NHI0:MUST - called Cable detection by NHI"

                                Return (\_SB.PCI0.RP09.UPSB.MUST (Arg0))
                            }

                            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                            {
                                Debug = "TB:NHI0:_PS0"

                                If (OSDW ())
                                {
                                    PCED ()

                                    \_SB.PCI0.RP09.CTBT ()

                                    \_SB.PCI0.RP09.TBST ()
                                }
                            }

                            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                            {
                                Debug = "TB:NHI0:_PS3"
                            }

                            Method (TRPE, 2, Serialized)
                            {
                                Debug = Concatenate ("TB:NHI0:TRPE called with Arg0: ", Arg0)
                                Debug = Concatenate ("TB:NHI0:TRPE called with Arg1: ", Arg1)

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

                                        // SGOV (CPGN, Zero)
                                        // SGDO (CPGN)
                                        // \_SB.TBFP (Zero)
                                    }
                                    Else
                                    {
                                        Local0 = Zero

                                        // If ((GGOV (CPGN) == Zero) && (GGDV (CPGN) == Zero))
                                        // If (\_GPE.TFPS () == Zero)
                                        If (Zero)
                                        {
                                            \_SB.PCI0.RP09.PSTX = Zero
                                            While (One)
                                            {
                                                If (\_SB.PCI0.RP09.LDXX == One)
                                                {
                                                    \_SB.PCI0.RP09.LDXX = Zero
                                                }

                                                // SGDI (CPGN)
                                                // \_SB.TBFP (One)
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

                                                // SGOV (CPGN, Zero)
                                                // SGDO (CPGN)
                                                // \_SB.TBFP (Zero)
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

                                Return (Zero)
                            }

                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                Local0 = Package ()
                                    {
                                        // Thinkpad X1 original FW, switched port 5, loading
                                        "ThunderboltDROM",
                                        Buffer ()
                                        {
                                            /* 0x00     */  0x61,                                           // CRC8 checksum: 0x61
                                            /* 0x01     */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x01, // Thunderbolt Bus 0, UID: 0x0109000000000000
                                            /* 0x09     */  0x9a, 0x6d, 0x64, 0x0c,                         // CRC32c checksum: 0x0C646D9A
                                            /* 0x0D     */  0x01,                                           // Device ROM Revision: 1
                                            /* 0x0E     */  0x62, 0x00,                                     // Length: 98 (starting from previous byte)
                                            /* 0x10     */  0x09, 0x01,                                     // Vendor ID: 0x109
                                            /* 0x12     */  0x06, 0x17,                                     // Device ID: 0x1706
                                            /* 0x14     */  0x01,                                           // Device Revision: 0x1
                                            /* 0x15     */  0x21,                                           // EEPROM Revision: 33
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

                                        "TBTDPLowToHigh",
                                        Buffer (One)
                                        {
                                             0x01, 0x00, 0x00, 0x00
                                        },

                                        "TBTFlags",
                                        Buffer ()
                                        {
                                            0x03, 0x00, 0x00, 0x00
                                        },

                                        "sscOffset",
                                        Buffer ()
                                        {
                                             0x00, 0x07
                                        },

                                        "linkDetails", 
                                        Buffer ()
                                        {
                                            0x08, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
                                        }, 

                                        "power-save", 
                                        One, 

                                        Buffer (One)
                                        {
                                            0x00
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
                                Debug = "TB:NHI0:SXFP"

                                If (Arg0 == Zero)
                                {
                                    // If (GGDV (0x02060001) == One)
                                    // {
                                    //     SGOV (0x02060001, Zero)
                                    //     SGDO (0x02060001)
                                    //     Sleep (0x64)
                                    // }

                                    // SGOV (CPGN, Zero)
                                    // SGDO (CPGN)
                                    // \_SB.TBFP (Zero)

                                    Sleep (0x64)
                                }
                            }

                            Name (XRTE, Zero)
                            Method (XRST, 1, Serialized)
                            {
                                Debug = "TB:NHI0:XRST - called with arg:"
                                Debug = Arg0
                                If (Arg0 == Zero)
                                {
                                    XRTE = Zero
                                    If (XLTP == Zero)
                                    {
                                        Debug = "TB:NHI0:XRST - TRPE L23 Detect"
                                        \_SB.PCI0.RP09.L23D = One
                                        Sleep (One)
                                        Local2 = Zero
                                        While (\_SB.PCI0.RP09.L23D)
                                        {
                                            If (Local2 > 0x04)
                                            {
                                                Break
                                            }

                                            Sleep (One)
                                            Local2++
                                        }

                                        Debug = "TB:NHI0:XRST - TRPE Clear LEDM"
                                        \_SB.PCI0.RP09.LEDX = Zero
                                        // SGDI (0x02060004)
                                    }
                                }
                                ElseIf (Arg0 == One)
                                {
                                    XRTE = One
                                    If (XLTP == Zero)
                                    {
                                        \_SB.PCI0.RP09.PSTX = 0x03
                                        If (\_SB.PCI0.RP09.LACR == One)
                                        {
                                            If (\_SB.PCI0.RP09.LACT == Zero)
                                            {
                                                Debug = "TB:NHI0:XRST: Root Port LDIS - Skipping L23 Ready Request"
                                            }
                                            Else
                                            {
                                                Debug = "TB:NHI0:XRST Root Port Requesting L23 Ready"
                                                \_SB.PCI0.RP09.L23X = One
                                                Sleep (One)
                                                Local2 = Zero
                                                While (\_SB.PCI0.RP09.L23X == One)
                                                {
                                                    If (Local2 > 0x04)
                                                    {
                                                        Break
                                                    }

                                                    Sleep (One)
                                                    Local2++
                                                }

                                                Debug = "TB:NHI0:XRST Root Port Set DMI L1 EN"
                                                \_SB.PCI0.RP09.LEDX = One
                                            }
                                        }

                                        // SGOV (0x02060004, Zero)
                                        // SGDO (0x02060004)
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB0.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB3.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB4.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB5.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB1.UPS0.DSB6.SECB */
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB2.SECB */
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
                            Debug = "TB:DSB2:PCEU"

                            \_SB.PCI0.RP09.UPSB.DSB2.PRSR = Zero
                            Debug = "TB:DSB2:PCEU - Put upstream bridge back into D0 "

                            If (\_SB.PCI0.RP09.UPSB.DSB2.PSTA != Zero)
                            {
                                Debug = "TB:DSB2:PCEU - exit D0, restored = true"
                                \_SB.PCI0.RP09.UPSB.DSB2.PRSR = One
                                \_SB.PCI0.RP09.UPSB.DSB2.PSTA = Zero
                            }

                            If (\_SB.PCI0.RP09.UPSB.DSB2.LDIS == One)
                            {
                                Debug = "TB:DSB2:PCEU - Clear link disable on upstream bridge"
                                Debug = "TB:DSB2:PCEU - clear link disable, restored = true"
                                \_SB.PCI0.RP09.UPSB.DSB2.PRSR = One
                                \_SB.PCI0.RP09.UPSB.DSB2.LDIS = Zero
                            }
                        }

                        /**
                        * PCI disable link
                        */
                        Method (PCDA, 0, Serialized)
                        {
                            Debug = "TB:DSB2:PCDA"

                            If (\_SB.PCI0.RP09.UPSB.DSB2.POFX () != Zero)
                            {
                                \_SB.PCI0.RP09.UPSB.DSB2.PCIA = Zero

                                Debug = "TB:DSB2:PCDA - Put upstream bridge into D3"
                                \_SB.PCI0.RP09.UPSB.DSB2.PSTA = 0x03

                                Debug = "TB:DSB2:PCDA - Set link disable on upstream bridge"
                                \_SB.PCI0.RP09.UPSB.DSB2.LDIS = One

                                Local5 = (Timer + 0x00989680)
                                While (Timer <= Local5)
                                {
                                    Debug = "TB:DSB2:PCDA - Wait for link to drop..."
                                    If (\_SB.PCI0.RP09.UPSB.DSB2.LACR == One)
                                    {
                                        If (\_SB.PCI0.RP09.UPSB.DSB2.LACT == Zero)
                                        {
                                            Debug = "TB:DSB2:PCDA - No link activity"
                                            Break
                                        }
                                    }
                                    ElseIf (\_SB.PCI0.RP09.UPSB.DSB2.XHC2.AVND == 0xFFFFFFFF)
                                    {
                                        Debug = "TB:DSB2:PCDA - VID/DID is -1"
                                        Break
                                    }

                                    Sleep (0x0A)
                                }

                                Debug = "TB:DSB2:PCDA - Request USB-GPIO to be disabled"
                                \_SB.PCI0.RP09.GXCI = Zero
                                \_SB.PCI0.RP09.UGIO ()
                            }
                            Else
                            {
                                Debug = "TB:DSB2:PCDA - Not disabling"
                            }

                            \_SB.PCI0.RP09.UPSB.DSB2.IIP3 = One
                        }

                        /**
                        * Is power saving requested?
                        */
                        Method (POFX, 0, Serialized)
                        {
                            Debug = Concatenate ("TB:DSB2:POFX - Result (!RUSB): ", (!\_SB.PCI0.RP09.RUSB))

                            Return (!\_SB.PCI0.RP09.RUSB)
                        }

                        Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                        {
                            Debug = "TB:DSB2:_PS0"

                            If (OSDW ())
                            {
                                PCEU ()

                                \_SB.PCI0.RP09.TBST ()
                            }
                        }

                        Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                        {
                            Debug = "TB:DSB2:_PS3"

                            If (OSDW ())
                            {
                                PCDA ()

                                \_SB.PCI0.RP09.TBST ()
                            }
                        }

                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If (OSDW ())
                            {
                                If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                                {
                                    Local0 = Package ()
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB0.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB3.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB4.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB5.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB3.UPS0.DSB6.SECB */
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB0.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB3.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB4.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB5.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB4.UPS0.DSB6.SECB */
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB0.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB3.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB0.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB3.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB4.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB5.SECB */
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
                                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB4.UPS0.DSB6.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB5.SECB */
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
                                    Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB5.UPS0.DSB6.SECB */
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
                            Return (SECB) /* \_SB.PCI0.RP09.UPSB.DSB6.SECB */
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
    }
}

