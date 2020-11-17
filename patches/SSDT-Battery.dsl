// Depends on /patches/OpenCore Patches/ Battery.plist
//
// SSDT-BATX
// Revision 10
//
// Copyleft (c) 2020 by bb. No rights reserved.
//
//
// Abstract:
//
// This SSDT is a complete, self-contained replacement for all battery-patches on Thinkpads which share
// a common EC-layout [1] for battery-handling. It should be compatible with all(?) T- and X-series Thinkpads which are using the basic H8-EC-Layout [2].
//
// Its designed for the requirements of VirtualSMC [3], leaves the original DSDT largely untouched, 
// handles single- and dual-battery-systems gracefully and adds support for `Battery Information Supplement` [4].
//
// Sadly, it needs patching of battery-ACPI-notifies as the EC doesn't seem to be updated correctly by the firmware if they are missing.
//
// It is faster, more compatible and much more robust than existing patches as it doesn't rely on the original DSDT-implementation 
// for battery-handling and EC-access. It eliminates the need to patch mutexes and EC-fields completely. Patching notify()'s is
// not needed, but may be desireable for smoother operation - espacially on dual-battery-systems.
//
// It replaces any battery-related DSDT-patches and any SSDT like SSDT-BAT0, SSDT-BATT, SSDT-BATC, SSDT-BATN and similar.
//
// Because of its implementation, its only dependency is the memory-layout of the Embedded Controller (EC) [1],
// which is mostly the same for all decent modern thinkpads (at least T440/X440 upwards) and nothing else.
// Just drop the SSDT in and be done. For most Thinkpads, this should be the only thing you need to handle your batteries.
// Nothing more, nothing less.
//
// But be aware: this is newly created stuff, not much tested or battle proven yet. May contain bugs and edgecases. 
// If so, please open a bug @ https://github.com/benbender/x1c6-hackintosh/issues.
// Additionally, as this implementation is more straight-forward and according to specs, it may reveal bugs and glitches
// in other parts of the system.
//
// Compatibility:
//
// - Lenovo Thinkpad X1 Carbon generation 6 (X1C6)
// - Lenovo Thinkpad T480 (T480)
// - Lenovo Thinkpad T460 (T460)
// - Lenovo Thinkpad T460 (T440)
// - ... many more to be added as testing is done
//
//
// Technical Background
//
// On genuine MacBooks batteries are connected via SBS (Smart Battery System [5]) to the 
// SMC (System Management Controller) [6]. The SMC provides the battery-data via SMC-keys [7] to the OS.
//
// On Hackintoshes we "only" have an emulated SMC as substitute for the HW-SMC because of the missing hardware.
// Our systems usually provide battery-data, read from an EC (Embedded Controller), via ACPI [8].
//
// In practice the OS reads SMC-keys provided by VirtualSMC which uses its SMCBatteryManager-plugin to poll those 
// raw-data from ACPI which normally reads those data from the EC of the machine.
//
// Every part of the flow computes and interpretes the data. Therefor control in this SSDT is limited.
//
// As the ACPI-battery-interface is a proven standard and commonly implemented, this approach should, theoretically, 
// work out of the box on most laptop-systems.
//
// In practice the AppleACPIPlatform.kext doesn't implement access to EC-fields larger than 8 bits and 
// will crash on reading them. This limitation of the driver in OSX is the reason why all those battery-patching 
// is neccessary in the first place. We need to ensure that every EC-field, accessed from OSX, is 8 bit at most.
//
// Additionally no such thing as dual-battery-systems exist in mac-world. OSX is able to recognize 
// multiple batteries, but will only handle display of the data for the first battery. Therefor we need
// to combine multiple batteries transperantly into one and hide additional batteries to the OS.
//
// Implementation-wise, the apple-approach is able to provide some more data to the OS in comparison to ACPI.
// That might be the reason why apple opted for their implementation in the first place. To circumvent those 
// limitations of the ACPI specification, VirtualSMC adds `Battery Information Supplement` (BIS).
//
// BIS tries to add the missing information normally provided on genuine MacBooks. Therefor it enables 
// much more OSX-native handling of batteries but also may reveal glitches and bugs between implementations 
// of OSX/ACPI/EC. Therefor its configureable in this SSDT.
//
// 
// Known Issues:
//
// - no known issues atm
//
//
// Links & References:
//
// [1] https://github.com/coreboot/coreboot/blob/master/src/ec/quanta/it8518/acpi/ec.asl
// [2] https://en.wikipedia.org/wiki/H8_Family
// [3] https://github.com/acidanthera/VirtualSMC
// [4] https://github.com/acidanthera/VirtualSMC/blob/master/Docs/Battery%20Information%20Supplement.md
// [5] https://en.wikipedia.org/wiki/Smart_Battery_System
// [6] https://en.wikipedia.org/wiki/System_Management_Controller
// [7] https://github.com/acidanthera/VirtualSMC/blob/master/Docs/SMCKeys.txt
// [6] https://uefi.org/sites/default/files/resources/ACPI_6_3_final_Jan30.pdf
//
//
// Changelog:
//
// Revision 10 - Maybe fix that stupid race condition which leads to 20hrs battery time, fix quickpoll-handling
// Revision 9 - Fix serials for batteries with broken values
// Revision 8 - Fix battery-state handling, small corrections
// Revision 7 - Smaller fixes, adds Notify-patches as EC won't update without them in edge-cases, replaces fake serials with battery-serial
// Revision 6 - fixes, make the whole system more configureable, adds technical backround-documentation
// Revision 5 - optimization, bug-fixing. Adds temp, concatenates string-data on combined batteries. 
// Revision 4 - Waits on initialization of the batts now. Besides that: Optimization, rework, cleanup, fixes. Truely self-contained now. And faster. 
// Revision 3 - Remove need of patched notifies, handle battery attach/detach inside, make the whole device self-contained (exept for the EC-helpers)
// Revision 2 - Prelimitary dual-battery-support, large refactoring
// Revision 1 - Raised timeout for mutexes, factored bank-switching out, added sleep to bank-switching, moved HWAC to its own SSDT
// 
//
// Credits @benbender

DefinitionBlock ("", "SSDT", 2, "tyler", "_Battery", 0x00010000)
{
    // Please ensure that your LPC bus-device is available at \_SB.PCI0.LPCB (check your DSDT). 
    // Some older Thinkpads provide the LPC on \_SB.PCI0.LPC and if thats the case for you,
    // you need to adjust the paths in the following line until the first "Scope ()".
    External (_SB.PCI0.LPCB.EC, DeviceObj)

    // @see https://en.wikipedia.org/wiki/Bank_switching
    //
    // HIID: [Battery information ID for 0xA0-0xAF]
    //   (this byte is depend on the interface, 62&66 and 1600&1604)
    External (_SB.PCI0.LPCB.EC.HIID, FieldUnitObj)

    External (_SB.PCI0.LPCB.EC.BAT0._STA, MethodObj)
    External (_SB.PCI0.LPCB.EC.BAT0._HID, IntObj)

    External (_SB.PCI0.LPCB.EC.BAT1._STA, MethodObj)
    External (_SB.PCI0.LPCB.EC.BAT1._HID, IntObj)

    External (H8DR, FieldUnitObj)

    Scope (\_SB.PCI0.LPCB.EC)
    {
        //
        // EC region overlay.
        //
        OperationRegion (BRAM, EmbeddedControl, 0x00, 0x0100)

        /**
         * New battery device
         */
        Device (BATX)
        {
            /************************* Configuration *************************/

            //
            // Enable debugging output
            //
            // Add https://github.com/acidanthera/DebugEnhancer to your kexts
            // and add `debug=0x12a acpi_layer=0x8 acpi_level=0x2` to your boot-args
            // to see the output in syslog/dmesg (f.e. via `sudo dmesg|egrep BATX`)
            //
            Name (BDBG, Zero) // possible values: One / Zero

            //
            // Enable Battery Information Supplement (BIS)
            //
            // BIS tries to add the missing information normally provided on genuine MacBooks
            // but not available in the ACPI-specification. It enables much more OSX-native handling
            // of batteries but also may reveal glitches and bugs between implementation of OSX/ACPI/EC.
            //
            // Therefor its configureable here.
            //
            // See https://github.com/acidanthera/VirtualSMC/blob/master/Docs/Battery%20Information%20Supplement.md
            //
            Name (BBIS, One) // possible values: One / Zero

            //
            // Disable quickpoll in VirtualSMC SMCBatteryManager
            //
            // Implicitly disabled if BBIS is disabled
            //
            Name (BDQP, Zero) // possible values: One / Zero


            /************************* Mutex **********************************/

            // We reimplement the battery-mutex here to solve the need to patch the original mutex
            // on older thinkpads where the mutex has a non-zero synclevel which isn't handled by OSX.
            Mutex (BAXM, 0x00)


            /************************* EC overlay *****************************/

            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset (0x38),
                            // HB0S: [Battery 0 status (read only)]
                            //   bit 3-0 level
                            //     F: Unknown
                            //     2-n: battery level
                            //     1: low level
                            //     0: (critical low battery, suspend/ hibernate)
                            //   bit 4 error
                            //   bit 5 charge
                            //   bit 6 discharge
                HB0S, 7,    /* Battery 0 state */
                HB0A, 1,    /* Battery 0 present */
                
                // Offset (0x39),
                HB1S, 7,    /* Battery 1 state */
                HB1A, 1,    /* Battery 1 present */
            }

            //
            // EC Registers 
            // HIID == 0x00
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                // SBRC, 16,    // Remaining Capacity
                RC00,   8,
                RC01,   8,
                // SBFC, 16,    // Fully Charged Capacity
                FC00,   8,
                FC01,   8,
                // SBAE, 16,    // Average Time To Empty
                AE00,   8,
                AE01,   8,
                // SBRS, 16,    // Relative State Of Charge
                RS00,   8,
                RS01,   8,
                // SBAC, 16,    // Average Current / present rate
                AC00,   8,
                AC01,   8,
                // SBVO, 16,    // Voltage
                VO00,   8,
                VO01,   8,
                // SBAF, 16,    // Average Time To Full
                AF00,   8,
                AF01,   8,
                // SBBS, 16,    // Battery State
                BS00,   8,
                BS01,   8,
            }

            //
            // EC Registers 
            // HIID == 0x01
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                                // Battery Mode(w)
                //     , 15,
                // SBCM, 1,     //  bit 15 - CAPACITY_MODE
                                //   0: Report in mA/mAh ; 1: Enabled
                // SBBM, 16,    // Battery Mode(w)
                BM00,   8,
                BM01,   8,
                // SBMD, 16,    // Manufacture Data
                MD00,   8,
                MD01,   8,
                // SBCC, 16,    // Cycle Count
                CC00,   8,
                CC01,   8,
            }

            //
            // EC Registers 
            // HIID == 0x02
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                // SBDC, 16,    // Design Capacity
                DC00,   8,
                DC01,   8,
                // SBDV, 16,    // Design Voltage
                DV00,   8,
                DV01,   8,
                // SBOM, 16,    // Optional Mfg Function 1
                OM00,   8,
                OM01,   8,
                // SBSI, 16,    // Specification Info
                SI00,   8,
                SI01,   8,
                // SBDT, 16,    // Manufacture Date
                DT00,   8,
                DT01,   8,
                // SBSN, 16,    // Serial Number
                SN00,   8,
                SN01,   8,
            }

            //
            // EC Registers 
            // HIID == 0x04: Battery type
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                // SBCH, 32,    // Device Checmistory (string)
                CH00,    8,
                CH01,    8,
                CH02,    8,
                CH03,    8
            }

            //
            // EC Registers 
            // HIID == 0x05: Battery OEM information
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                // SBMN, 128,   // Manufacture Name (s)
                MN00,   8,
                MN01,   8,
                MN02,   8,
                MN03,   8,
                MN04,   8,
                MN05,   8,
                MN06,   8,
                MN07,   8,
                MN08,   8,
                MN09,   8,
                MN0A,   8,
                MN0B,   8,
                MN0C,   8,
                MN0D,   8,
                MN0E,   8,
                MN0F,   8,
            }

            //
            // EC Registers 
            // HIID == 0x06: Battery name
            //
            Field (BRAM, ByteAcc, NoLock, Preserve)
            {
                Offset(0xA0),
                // SBDN, 128,   // Device Name (s)
                DN00,   8,
                DN01,   8,
                DN02,   8,
                DN03,   8,
                DN04,   8,
                DN05,   8,
                DN06,   8,
                DN07,   8,
                DN08,   8,
                DN09,   8,
                DN0A,   8,
                DN0B,   8,
                DN0C,   8,
                DN0D,   8,
                DN0E,   8,
                DN0F,   8,
            }


            /************************* Access methods *************************/

            /**
             * Method to read the 16-bit-EC-field SBRC 
             *
             * Remaining Capacity
             */
            Method (SBRC, 0, NotSerialized)
            {
                Return (B1B2 (RC00, RC01))
            }

            /**
             * Method to read the 16 bit-EC-field SBFC
             *
             * Fully Charged Capacity
             */
            Method (SBFC, 0, NotSerialized)
            {
                Return (B1B2 (FC00, FC01))
            }

            /**
             * Method to read the 16 bit-EC-field SBAE
             *
             * Average Time To Empty
             */
            Method (SBAE, 0, NotSerialized)
            {
                Return (B1B2 (AE00, AE01))
            }

            /**
             * Method to read the 16 bit-EC-field SBRS
             *
             * Relative State Of Charge
             */
            Method (SBRS, 0, NotSerialized)
            {
                Return (B1B2 (RS00, RS01))
            }

            /**
             * Method to read the 16 bit-EC-field SBAC
             *
             * Average Current / present rate
             */
            Method (SBAC, 0, NotSerialized)
            {
                Return (B1B2 (AC00, AC01))
            }

            /**
             * Method to read the 16 bit-EC-field SBVO
             *
             * Voltage
             */
            Method (SBVO, 0, NotSerialized)
            {
                Return (B1B2 (VO00, VO01))
            }

            /**
             * Method to read the 16 bit-EC-field SBAF
             *
             * Average Time To Full
             */
            Method (SBAF, 0, NotSerialized)
            {
                Return (B1B2 (AF00, AF01))
            }

            /**
             * Method to read the 16 bit-EC-field SBBS
             *
             * Battery State
             */
            Method (SBBS, 0, NotSerialized)
            {
                Return (B1B2 (BS00, BS01))
            }


            /**
             * Method to read the 16 bit-EC-field SBBM
             *
             * Battery Mode(w)
             */
            Method (SBBM, 0, NotSerialized)
            {
                Return (B1B2 (BM00, BM01))
            }

            /**
             * Method to read the 16 bit-EC-field SBMD
             *
             * Manufacture Data
             */
            Method (SBMD, 0, NotSerialized)
            {
                Return (B1B2 (MD00, MD01))
            }

            /**
             * Method to read the 16 bit-EC-field SBCC
             *
             * Cycle Count
             */
            Method (SBCC, 0, NotSerialized)
            {
                Return (B1B2 (CC00, CC01))
            }


            /**
             * Method to read the 16 bit-EC-field SBDC
             *
             * Design Capacity
             */
            Method (SBDC, 0, NotSerialized)
            {
                Return (B1B2 (DC00, DC01))
            }

            /**
             * Method to read the 16 bit-EC-field SBDV
             *
             * Design Voltage
             */
            Method (SBDV, 0, NotSerialized)
            {
                Return (B1B2 (DV00, DV01))
            }

            /**
             * Method to read the 16 bit-EC-field SBOM
             *
             * Optional Mfg Function 1
             */
            Method (SBOM, 0, NotSerialized)
            {
                Return (B1B2 (OM00, OM01))
            }

            /**
             * Method to read the 16 bit-EC-field SBSI
             *
             * Specification Info
             */
            Method (SBSI, 0, NotSerialized)
            {
                Return (B1B2 (SI00, SI01))
            }

            /**
             * Method to read the 16 bit-EC-field SBDT
             *
             * Manufacture Date
             */
            Method (SBDT, 0, NotSerialized)
            {
                Return (B1B2 (DT00, DT01))
            }

            /**
             * Method to read the 16 bit-EC-field SBSN
             *
             * Serial Number (string)
             */
            Method (SBSN, 0, NotSerialized)
            {
                Return (ToDecimalString (B1B2 (SN00, SN01)))
            }

            /**
             * Method to read the 32 bit-EC-field SBCH
             *
             * Device Checmistory (string)
             */
            Method (SBCH, 0, NotSerialized)
            {
                Return (ToString (B1B4 (CH00, CH01, CH02, CH03)))
            }


            /**
             * Method to read 128 bit-EC-field SBMN 
             *
             * Manufacture Name (string)
             */
            Method (SBMN, 0, NotSerialized)
            {
                Local0 = Buffer (0x10) {}

                Local0 [0x00] = MN00
                Local0 [0x01] = MN01
                Local0 [0x02] = MN02
                Local0 [0x03] = MN03
                Local0 [0x04] = MN04
                Local0 [0x05] = MN05
                Local0 [0x06] = MN06
                Local0 [0x07] = MN07
                Local0 [0x08] = MN08
                Local0 [0x09] = MN09
                Local0 [0x0A] = MN0A
                Local0 [0x0B] = MN0B
                Local0 [0x0C] = MN0C
                Local0 [0x0D] = MN0D
                Local0 [0x0E] = MN0E
                Local0 [0x0F] = MN0F

                Return (ToString (Local0))
            }

            /**
             * Method to read 128 bit-EC-field SBDN
             *
             * Device Name (string)
             */
            Method (SBDN, 0, NotSerialized)
            {   
                Local0 = Buffer (0x10) {}

                Local0 [0x00] = DN00
                Local0 [0x01] = DN01
                Local0 [0x02] = DN02
                Local0 [0x03] = DN03
                Local0 [0x04] = DN04
                Local0 [0x05] = DN05
                Local0 [0x06] = DN06
                Local0 [0x07] = DN07
                Local0 [0x08] = DN08
                Local0 [0x09] = DN09
                Local0 [0x0A] = DN0A
                Local0 [0x0B] = DN0B
                Local0 [0x0C] = DN0C
                Local0 [0x0D] = DN0D
                Local0 [0x0E] = DN0E
                Local0 [0x0F] = DN0F

                Return (ToString (Local0))
            }


            /************************* Helper methods *************************/

            /**
             * Status from two EC fields
             * 
             * e.g. B1B2 (0x3A, 0x03) -> 0x033A
             */
            Method (B1B2, 2, NotSerialized)
            {
                Return ((Arg0 | (Arg1 << 0x08)))
            }

            /**
             * Status from four EC fields
             */
            Method (B1B4, 4, NotSerialized)
            {
                Local0 = (Arg2 | (Arg3 << 0x08))
                Local0 = (Arg1 | (Local0 << 0x08))
                Local0 = (Arg0 | (Local0 << 0x08))

                Return (Local0)
            }


            /************************* Battery device *************************/

            Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
            {
                _SB
            })

            /**
             * Battery Slot Status
             */
            Method (_STA, 0, NotSerialized)
            {
                Local0 = Zero

                // call original _STA for BAT0 and BAT1
                // result is bitwise OR between them
                If (_OSI ("Darwin"))
                {
                    If (CondRefOf (^^BAT1._STA))
                    {
                        If (CondRefOf (^^BAT0._STA))
                        {
                            Local0 = (^^BAT0._STA () | ^^BAT1._STA ())
                        }
                        Else
                        {
                            Local0 = (^^BAT1._STA ())
                        }
                    }
                    Else 
                    {
                        Local0 = (^^BAT0._STA ())
                    }

                    If (\H8DR)
                    {
                        Return (Local0)
                    }
                    Else
                    {
                        Return (0x0F)
                    }
                }

                Return (Zero)
            }

            Method (_INI, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    If (CondRefOf (^^BAT0._HID))
                    {
                        // disable original battery objects by setting invalid _HID
                        ^^BAT0._HID = 0
                    }

                    If (CondRefOf (^^BAT1._HID))
                    {
                        // disable original battery objects by setting invalid _HID
                        ^^BAT1._HID = 0
                    }
                }
            }


            /**
             *  Extended Battery Static Information pack layout
             */
            Name (PBIX, Package (0x15) {
                0x01,        // 0x00: BIXRevision - Revision - Integer
                0x01,        // 0x01: BIXPowerUnit - Power Unit: mAh - Integer (DWORD)
                             //       ACPI spec     : 0 - mWh   : 1 - mAh                
                0xFFFFFFFF,  // 0x02: BIXDesignCapacity - Design Capacity - Integer (DWORD)
                0xFFFFFFFF,  // 0x03: BIXLastFullChargeCapacity - Last Full Charge Capacity - Integer (DWORD)
                0x01,        // 0x04: BIXBatteryTechnology - Battery Technology: Rechargeable - Integer (DWORD)
                0xFFFFFFFF,  // 0x05: BIXDesignVoltage - Design Voltage - Integer (DWORD)
                0xFFFFFFFF,  // 0x06: BIXDesignCapacityOfWarning - Design Capacity of Warning - Integer (DWORD)
                0xFFFFFFFF,  // 0x07: BIXDesignCapacityOfLow - Design Capacity of Low - Integer (DWORD)
                0xFFFFFFFF,  // 0x08: BIXCycleCount - Cycle Count - Integer (DWORD)
                0x00017318,  // 0x09: BIXMeasurementAccuracy - Measurement Accuracy (98.3%?) - Integer (DWORD)
                0xFFFFFFFF,  // 0x0a: BIXMaxSamplingTime - Max Sampling Time (500ms) - Integer (DWORD)
                0xFFFFFFFF,  // 0x0b: BIXMinSamplingTime - Min Sampling Time (10ms) - Integer (DWORD)
                1000,        // 0x0c: BIXMaxAveragingInterval - Max Averaging Interval - Integer (DWORD)
                500,         // 0x0d: BIXMinAveragingInterval - Min Averaging Interval - Integer (DWORD)
                0xFFFFFFFF,  // 0x0e: BIXBatteryCapacityGranularity1 - Capacity Granularity 1
                0xFFFFFFFF,  // 0x0f: BIXBatteryCapacityGranularity2 - Capacity Granularity 2
                "",          // 0x10: BIXModelNumber - Model Number - String
                "",          // 0x11: BIXSerialNumber - Serial Number - String
                "",          // 0x12: BIXBatteryType - Battery Type - String
                "",          // 0x13: BIXOEMInformation - OEM Information - String
                0x00         // 0x14: ??? - Battery Swapping Capability, 0x00000000 = non-swappable - Integer (DWORD)
                             //       added in Revision 1: Zero means Non-swappable, One - Cold-swappable, 0x10 - Hot-swappable
            })

            Name (BX0I, Package (0x15) {})
            Name (BX1I, Package (0x15) {})

            /**
             * Get Battery extended information per battery
             *
             * Arg0: Battery id 0x00 / 0x10
             * Arg1: Battery Real-time Information pack             
             */
            Method (GBIX, 2, NotSerialized)
            {
                // Wait for the battery to become available
                If (Arg0 == 0x10)
                {
                    // use BAT1
                    Local4 = HB1S
                    Local5 = HB1A
                }
                Else
                {
                    // use BAT0
                    Local4 = HB0S
                    Local5 = HB0A
                }

                Local6 = 10
                Local7 = Zero

                While ((!Local7 && Local6))
                {
                    // If battery available
                    If (Local5)
                    {
                        // If battery not ok, wait
                        If (((Local4 & 0x07) == 0x07))
                        {
                            // decrease timer and wait for battery to be ready
                            Sleep (1000)
                            Local6--
                        }
                        Else
                        {
                            // Battery ok
                            Local7 = One
                        }
                    }
                    Else
                    {
                        // battery unavailable, not need to wait
                        Local6 = Zero
                    }
                }

                // Battery not ready, give up for now
                If (Local7 != One)
                {
                    Debug = "BATX:GBIX: !!!WARNING: Could not get battery-data in time. Giving up for now. - WARNING!!!"

                    Arg1 [0x02] = 0xFFFFFFFF
                    Arg1 [0x03] = 0xFFFFFFFF
                    Arg1 [0x06] = 0x00
                    Arg1 [0x07] = 0x00

                    Return (Arg1)
                }

                // Aquire Mutex
                If (Acquire (BAXM, 65535))
                {
                    Debug = "BATX:AcquireLock failed in GBIX"

                    Return (Arg1)
                }


                //
                // Information Page 1 -
                //
                HIID = (Arg0 | 0x01)

                // cycle count
                Arg1 [0x08] = SBCC /* \_SB_.PCI0.LPCB.EC__.BATX.SBCC */

                // needs conversion?
                Local7 = SBBM /* \_SB_.PCI0.LPCB.EC__.BATX.SBBM */
                Local7 >>= 0x0F
                Arg1 [0x01] = (Local7 ^ 0x01)


                //
                // Information Page 0 -
                //
                HIID = Arg0

                If (Local7)
                {
                    Local1 = (SBFC * 10)
                }
                Else
                {
                    Local1 = SBFC /* \_SB_.PCI0.LPCB.EC__.BATX.SBFC */
                }

                Arg1 [0x03] = Local1


                //
                // Information Page 2 -
                //
                HIID = (Arg0 | 0x02)

                // Design capacity
                If (Local7)
                {
                    Local0 = (SBDC * 10)
                }
                Else
                {
                    Local0 = SBDC /* \_SB_.PCI0.LPCB.EC__.BATX.SBDC */
                }

                Arg1 [0x02] = Local0

                // Design capacity of high at 10%, values of VirtualSMC
                Arg1 [0x06] = Local0 / 100 * 10

                // Design capacity of low  at 5%, values of VirtualSMC
                Arg1 [0x07] = Local0 / 100 * 5

                // Design voltage
                Arg1 [0x05] = SBDV /* \_SB_.PCI0.LPCB.EC__.BATX.SBDV */

                // Serial Number
                Arg1 [0x11] = SBSN /* \_SB_.PCI0.LPCB.EC__.BATX.SBSN */


                //
                // Information Page 6 -
                //
                HIID = (Arg0 | 0x06)

                // Model Number - Device Name
                Arg1 [0x10] = SBDN /* \_SB_.PCI0.LPCB.EC__.BATX.SBDN */


                //
                // Information Page 4 -
                //
                HIID = (Arg0 | 0x04)

                // Battery Type - Device Chemistry
                Arg1 [0x12] = SBCH /* \_SB_.PCI0.LPCB.EC__.BATX.SBCH */


                //
                // Information Page 5 -
                //
                HIID = (Arg0 | 0x05)

                // OEM Information - Manufacturer Name
                Arg1 [0x13] = SBMN /* \_SB_.PCI0.LPCB.EC__.BATX.SBMN */

                // Release mutex
                Release (BAXM)

                // Return result
                Return (Arg1)
            }

            /**
             * Acpi-Spec:
             * 10.2.2.2 _BIX (Battery Information Extended)
             * The _BIX object returns the static portion of the Control Method Battery information. This information
             * remains constant until the battery is changed. The _BIX object returns all information available via the
             * _BIF object plus additional battery information. The _BIF object is deprecated in lieu of _BIX in ACPI 4.0
             */
            Method (_BIX, 0, NotSerialized)  // _BIX: Battery Information Extended
            {
                If (BDBG == One)
                {
                    Debug = "BATX:_BIX"
                }

                // needs to be run in any way as it waits for the bat-device to be available
                BX0I = GBIX (0x00, PBIX)

                // If BAT0 present and debugging enabled
                If (HB0A && BDBG == One)
                {
                    Concatenate ("BATX:BIXPowerUnit: BAT0 ", BX0I[0x01], Debug)
                    Concatenate ("BATX:BIXDesignCapacity: BAT0 ", ToDecimalString (DerefOf (BX0I [0x02])), Debug)
                    Concatenate ("BATX:BIXLastFullChargeCapacity: BAT0 ", ToDecimalString (DerefOf (BX0I [0x03])), Debug)
                    Concatenate ("BATX:BIXBatteryTechnology: BAT0 ", ToDecimalString (DerefOf (BX0I [0x04])), Debug)
                    Concatenate ("BATX:BIXDesignVoltage: BAT0 ", ToDecimalString(DerefOf (BX0I [0x05])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfWarning: BAT0 ", ToDecimalString (DerefOf (BX0I [0x06])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfLow: BAT0 ", ToDecimalString (DerefOf (BX0I [0x07])), Debug)
                    Concatenate ("BATX:BIXCycleCount: BAT0 ", ToDecimalString (DerefOf (BX0I [0x08])), Debug)
                    Concatenate ("BATX:BIXModelNumber: BAT0 ", DerefOf (BX0I [0x10]), Debug)
                    Concatenate ("BATX:BIXSerialNumber: BAT0 ", DerefOf (BX0I [0x11]), Debug)
                    Concatenate ("BATX:BIXBatteryType: BAT0 ", DerefOf (BX0I [0x12]), Debug)
                    Concatenate ("BATX:BIXOEMInformation: BAT0 ", DerefOf (BX0I [0x13]), Debug)
                }

                // If BAT1 is not available, simply return data from BAT0
                If (!HB1A)
                {
                    Return (BX0I)
                }

                // Get data from BAT1
                BX1I = GBIX (0x10, PBIX)

                // If BAT1 present and debugging enabled
                If (BDBG == One)
                {
                    Concatenate ("BATX:BIXPowerUnit: BAT1 ", BX1I[0x01], Debug)
                    Concatenate ("BATX:BIXDesignCapacity: BAT1 ", ToDecimalString (DerefOf (BX1I [0x02])), Debug)
                    Concatenate ("BATX:BIXLastFullChargeCapacity: BAT1 ", ToDecimalString (DerefOf (BX1I [0x03])), Debug)
                    Concatenate ("BATX:BIXBatteryTechnology: BAT1 ", ToDecimalString (DerefOf (BX1I [0x04])), Debug)
                    Concatenate ("BATX:BIXDesignVoltage: BAT1 ", ToDecimalString(DerefOf (BX1I [0x05])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfWarning: BAT1 ", ToDecimalString (DerefOf (BX1I [0x06])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfLow: BAT1 ", ToDecimalString (DerefOf (BX1I [0x07])), Debug)
                    Concatenate ("BATX:BIXCycleCount: BAT1 ", ToDecimalString (DerefOf (BX1I [0x08])), Debug)
                    Concatenate ("BATX:BIXModelNumber: BAT1 ", DerefOf (BX1I [0x10]), Debug)
                    Concatenate ("BATX:BIXSerialNumber: BAT1 ", DerefOf (BX1I [0x11]), Debug)
                    Concatenate ("BATX:BIXBatteryType: BAT1 ", DerefOf (BX1I [0x12]), Debug)
                    Concatenate ("BATX:BIXOEMInformation: BAT1 ", DerefOf (BX1I [0x13]), Debug)
                }

                // If BAT1 available and BAT0 not, return data from BAT1. Very unlikely.
                If (!HB0A)
                {
                    Return (BX1I)
                }


                // PowerUnits differ between both batteries. This case isn't handled in SSDT-BATX atm. Please report a bug.
                If (DerefOf (BX0I [0x01]) != DerefOf (BX1I [0x01]))
                {
                    Debug = "BATX:BIXPowerUnit: !!!WARNING: PowerUnits differ between batteries. This case isn't handled in SSDT-BATX atm. Please report a bug - WARNING!!!"
                }


                // combine batteries into Local0 if both present
                Local0 = BX0I

                // _BIX 0 Revision - leave BAT0 value

                // _BIX 1 Power Unit - leave BAT0 value

                // _BIX 2 Design Capacity - add BAT0 and BAT1 values
                Local0 [0x02] = DerefOf (BX0I [0x02]) + DerefOf (BX1I [0x02])

                // _BIX 3 Last Full Charge Capacity - add BAT0 and BAT1 values
                Local0 [0x03] = DerefOf (BX0I [0x03]) + DerefOf (BX1I [0x03])

                // _BIX 4 Battery Technology - leave BAT0 value

                // _BIX 5 Design Voltage - average between BAT0 and BAT1 values
                Local0 [0x05] = (DerefOf (BX0I [0x05]) + DerefOf (BX1I [0x05])) / 2

                // _BIX 6 Design Capacity of Warning - add BAT0 and BAT1 values
                Local0 [0x06] = DerefOf (BX0I [0x06]) + DerefOf (BX1I [0x06])

                // _BIX 7 Design Capacity of Low - add BAT0 and BAT1 values
                Local0 [0x07] = DerefOf (BX0I [0x07]) + DerefOf (BX1I [0x07])

                // _BIX 8 Cycle Count - average between BAT0 and BAT1 values
                Local0 [0x08] = (DerefOf (BX0I [0x08]) + DerefOf (BX1I [0x08])) / 2

                // _BIX 10 Model Number - concatenate BAT0 and BAT1 values
                Local0 [0x10] = Concatenate  (Concatenate (DerefOf (BX0I [0x10]), " / "), DerefOf (BX1I [0x10]))

                // _BIX 11 Serial Number - concatenate BAT0 and BAT1 values
                Local0 [0x11] = Concatenate (Concatenate (DerefOf (BX0I [0x11]), " / "), DerefOf (BX1I [0x11]))

                // _BIX 12 Battery Type - concatenate BAT0 and BAT1 values
                Local0 [0x12] = Concatenate (Concatenate (DerefOf (BX0I [0x12]), " / "), DerefOf (BX1I [0x12]))

                // _BIX 13 OEM Information - concatenate BAT0 and BAT1 values
                Local0 [0x13] = Concatenate (Concatenate (DerefOf (BX0I [0x13]), " / "), DerefOf (BX1I [0x13]))

                If (BDBG == One)
                {
                    Concatenate ("BATX:BIXPowerUnit: BATX ", Local0 [0x01], Debug)
                    Concatenate ("BATX:BIXDesignCapacity: BATX ", ToDecimalString (DerefOf (Local0 [0x02])), Debug)
                    Concatenate ("BATX:BIXLastFullChargeCapacity: BATX ", ToDecimalString (DerefOf (Local0 [0x03])), Debug)
                    Concatenate ("BATX:BIXBatteryTechnology: BATX ", ToDecimalString (DerefOf (Local0 [0x04])), Debug)
                    Concatenate ("BATX:BIXDesignVoltage: BATX ", ToDecimalString(DerefOf (Local0 [0x05])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfWarning: BATX ", ToDecimalString (DerefOf (Local0 [0x06])), Debug)
                    Concatenate ("BATX:BIXDesignCapacityOfLow: BATX ", ToDecimalString (DerefOf (Local0 [0x07])), Debug)
                    Concatenate ("BATX:BIXCycleCount: BATX ", ToDecimalString (DerefOf (Local0 [0x08])), Debug)
                    Concatenate ("BATX:BIXModelNumber: BATX ", DerefOf (Local0 [0x10]), Debug)
                    Concatenate ("BATX:BIXSerialNumber: BATX ", DerefOf (Local0 [0x11]), Debug)
                    Concatenate ("BATX:BIXBatteryType: BATX ", DerefOf (Local0 [0x12]), Debug)
                    Concatenate ("BATX:BIXOEMInformation: BATX ", DerefOf (Local0 [0x13]), Debug)
                }

                Return (Local0)
            }

            /**
             *  Battery Real-time Information pack layout
             */
            Name (PBST, Package (0x04)
            {
                0x00000000,  // 0x00: BSTState - Battery State
                             //       0 - Not charging / Full
                             //       1 - Discharge
                             //       2 - Charging
                0,           // 0x01: BSTPresentRate - Battery Present Rate [mW], 0xFFFFFFFF if unknown rate
                0,           // 0x02: BSTRemainingCapacity - Battery Remaining Capacity [mWh], 0xFFFFFFFF if unknown capacity
                0,           // 0x03: BSTPresentVoltage - Battery Present Voltage [mV], 0xFFFFFFFF if unknown voltage
            })

            Name (BT0P, Package (0x04) {}) // Cache of PBST for BAT0
            Name (BT1P, Package (0x04) {}) // Cache of PBST for BAT1

            /**
             * Get Battery Status per battery
             *
             * Arg0: Battery id 0x00 / 0x10
             * Arg1: Battery Real-time Information pack
             */
            Method (GBST, 2, NotSerialized)
            {
                // Aquire mutex
                If (Acquire (BAXM, 65535))
                {
                    Debug = "BATX:AcquireLock failed in GBST"

                    Return (Arg1)
                }

                If (Arg0 == 0x00)
                {
                    Local6 = HB0S
                }
                Else
                {
                    Local6 = HB1S
                }

                If ((Local6 & 0x20))
                {
                    // 2 = Charging
                    Local0 = 2
                }
                ElseIf ((Local6 & 0x40) )
                {
                    // 1 = Discharging
                    Local0 = 1
                }
                Else
                {
                    // 0 = Not charging / Full
                    Local0 = 0
                }


                //
                // Information Page 1 -
                //
                HIID = (Arg0 | 0x01)

                // needs conversion?
                Local7 = SBBM /* \_SB_.PCI0.LPCB.EC__.BATX.SBBM */
                Local7 >>= 0x0F


                //
                // Information Page 0 -
                //
                HIID = Arg0

                // 
                Local2 = SBRC /* \_SB_.PCI0.LPCB.EC__.BATX.SBRC */

                If (Local7)
                {
                    Local2 = (Local2 * 10)
                }

                // Present rate is a 16bit signed int, positive while charging
                // and negative while discharging.
                Local1 = SBAC /* \_SB_.PCI0.LPCB.EC__.BATX.SBAC */

                // If discharging
                If (Local0 == 1)
                {
                    If ((Local1 >= 0x8000))
                    {
                        // Negate present rate
                        Local1 = (0x00010000 - Local1)
                    }
                }
                Else
                {
                    Local1 = 0x00
                }

                // Get voltage
                Local3 = SBVO /* \_SB_.PCI0.LPCB.EC__.BATX.SBVO */

                // Needs conversion
                If (Local7)
                {
                    Local1 = (Local1 * Local3 / 1000)
                }

                // Set data
                Arg1 [0x00] = Local0
                Arg1 [0x01] = Local1
                Arg1 [0x02] = Local2
                Arg1 [0x03] = Local3

                // Release mutex
                Release (BAXM)

                // Return data
                Return (Arg1)
            }

            /**
             *  Battery availability info
             */
            Name (PBAI, Package ()
            {
                0xFF,        // 0x00: BAT0 present or not
                0xFF,        // 0x01: BAT1 present or not
            })

            /**
             * Battery status
             */
            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                If (BDBG == One)
                {
                    Debug = "BATX:_BST()"
                }

                // Check if battery is added or removed
                Local3 = DerefOf (PBAI [0x00])
                Local4 = DerefOf (PBAI [0x01])

                If (Local3 != HB0A || Local4 != HB1A)
                {
                    PBAI [0x00] = HB0A
                    PBAI [0x01] = HB1A

                    If (Local3 != 0xFF || Local4 != 0xFF)
                    {
                        If (BDBG == One)
                        {
                            Concatenate ("BATX:_BST() - PBAI:HB0A (old): ", Local3, Debug)
                            Concatenate ("BATX:_BST() - PBAI:HB1A (old): ", Local4, Debug)
                            Concatenate ("BATX:_BST() - PBAI:HB0A (new): ", HB0A, Debug)
                            Concatenate ("BATX:_BST() - PBAI:HB1A (new): ", HB1A, Debug)
                        }

                        //
                        // Here we actually would need an option to tell VirtualSMC to refresh the static battery data
                        // because a battery was dettached or attached.
                        //
                        Notify (BATX, 0x81) // Status Change
                    }
                }

                // gather battery data from BAT0 if available
                If (HB0A)
                {
                    BT0P = GBST (0x00, PBST)

                    If (BDBG == One)
                    {
                        Concatenate ("BATX:BSTState: BAT0 (acpi) - ", HB0S, Debug)
                        Concatenate ("BATX:BSTState: BAT0 ", DerefOf (BT0P [0x00]), Debug)
                        Concatenate ("BATX:BSTPresentRate: BAT0 ", ToDecimalString (DerefOf (BT0P [0x01])), Debug)
                        Concatenate ("BATX:BSTRemainingCapacity: BAT0 ", ToDecimalString (DerefOf (BT0P [0x02])), Debug)
                        Concatenate ("BATX:BSTPresentVoltage: BAT0 ", ToDecimalString (DerefOf (BT0P [0x03])), Debug)
                    }

                    // If BAT1 isn't available, simply return data from BAT0
                    If (!HB1A)
                    {
                        Return (BT0P)
                    }
                }


                // gather battery data from BAT1
                BT1P = GBST (0x10, PBST)

                If (BDBG == One)
                {
                    Concatenate ("BATX:BSTState: BAT1 (acpi) - ", HB1S, Debug)
                    Concatenate ("BATX:BSTState: BAT1 ", DerefOf (BT1P [0x00]), Debug)
                    Concatenate ("BATX:BSTPresentRate: BAT1 ", ToDecimalString (DerefOf (BT1P [0x01])), Debug)
                    Concatenate ("BATX:BSTRemainingCapacity: BAT1 ", ToDecimalString (DerefOf (BT1P [0x02])), Debug)
                    Concatenate ("BATX:BSTPresentVoltage: BAT1 ", ToDecimalString (DerefOf (BT1P [0x03])), Debug)
                }

                // If BAT1 is availble but BAT0 isn't, simply return data from BAT1. Very unlikely.
                If (!HB0A)
                {
                    Return (BT1P)
                }

                // combine batteries into Local0 result if possible
                Local0 = BT0P

                // _BST 0 - Battery State - if one battery is charging, then charging, else discharging
                Local4 = DerefOf (BT0P [0x00])
                Local5 = DerefOf (BT1P [0x00])

                // Not charging / Full
                Local0 [0x00] = 0

                If ((Local4 == 2) || (Local5 == 2))
                {
                    // 2 = Charging
                    Local0 [0x00] = 2
                }
                ElseIf ((Local4 == 1) || (Local5 == 1))
                {
                    // 1 = Discharging
                    Local0 [0x00] = 1
                }

                // _BST 1 - Battery Present Rate - add BAT0 and BAT1 values
                Local0 [0x01] = DerefOf (BT0P [0x01]) + DerefOf (BT1P [0x01])

                // _BST 2 - Battery Remaining Capacity - add BAT0 and BAT1 values
                Local0 [0x02] = DerefOf (BT0P [0x02]) + DerefOf (BT1P [0x02])

                // _BST 3 - Battery Present Voltage - average between BAT0 and BAT1 values
                Local0 [0x03] = (DerefOf (BT0P [0x03]) + DerefOf (BT1P [0x03])) / 2

                If (BDBG == One)
                {
                    Concatenate ("BATX:BSTState: BATX ", DerefOf (Local0 [0x00]), Debug)
                    Concatenate ("BATX:BSTPresentRate: BATX ", ToDecimalString (DerefOf (Local0 [0x01])), Debug)
                    Concatenate ("BATX:BSTRemainingCapacity: BATX ", ToDecimalString (DerefOf (Local0 [0x02])), Debug)
                    Concatenate ("BATX:BSTPresentVoltage: BATX ", ToDecimalString (DerefOf (Local0 [0x03])), Debug)
                }

                // Return combined battery
                Return (Local0)
            }


            // Provide the API for `Battery Information Supplement` if enabled in configuration above
            If (BBIS)
            {
                /**
                *  Battery Status Supplement pack layout
                */
                Name (PBSS, Package (0x07)
                {
                    0xFFFFFFFF,  // 0x00: BSSTemperature - Temperature, AppleSmartBattery format
                    0xFFFFFFFF,  // 0x01: BSSTimeToFull - TimeToFull [minutes] (0xFF)
                    0xFFFFFFFF,  // 0x02: BSSTimeToEmpty - TimeToEmpty [minutes] (0)
                    0xFFFFFFFF,  // 0x03: BSSChargeLevel - ChargeLevel [percent]
                    0xFFFFFFFF,  // 0x04: BSSAverageRate - AverageRate [mA] (signed)
                    0xFFFFFFFF,  // 0x05: BSSChargingCurrent - ChargingCurrent [mA]
                    0xFFFFFFFF,  // 0x06: BSSChargingVoltage - ChargingVoltage [mV]
                })

                Name (PBS0, Package (0x07) {})
                Name (PBS1, Package (0x07) {})

                /**
                * Get Battery Status Supplement per battery
                *
                * Arg0: Battery 0x00/0x10
                * Arg1: package
                */
                Method (GBSS, 2, NotSerialized)
                {
                    If (Acquire (BAXM, 65535))
                    {
                        Debug = "BATX:AcquireLock failed in GBSS"

                        Return (PBSS)
                    }

                    //
                    // Information Page 0 -
                    //
                    HIID = Arg0

                    // 0x01: TimeToFull (0x11), minutes (0xFF)
                    Local6 = SBAF

                    If (Local6 == 0xFFFF)
                    {
                        Local6 = 0
                    }

                    Arg1 [0x01] = Local6

                    // 0x02: TimeToEmpty (0x12), minutes (0)
                    Local6 = SBAE

                    If (Local6 == 0xFFFF)
                    {
                        Local6 = 0
                    }

                    Arg1 [0x02] = Local6

                    // 0x03: BSSChargeLevel - ChargeLevel, percentage
                    Arg1 [0x03] = SBRS
                    
                    // 0x04: AverageRate (0x14), mA (signed)
                    Arg1 [0x04] = SBAC

                    // 0x05: ChargingCurrent (0x15), mA, seems to be unused anyways
                    // Arg1 [0x05] = ???

                    // 0x06: ChargingVoltage (0x16), mV, seems to be unused anyways
                    // Arg1 [0x06] = ???

                    // Fake Temperature (0x10) to 30C as it isn't available from the EC, AppleSmartBattery format
                    Arg1 [0x00] = 0xBD7

                    Release (BAXM)

                    Return (Arg1)
                }

                /**
                *  Battery Status Supplement
                */
                Method (CBSS, 0, NotSerialized)
                {
                    If (BDBG == One)
                    {
                        Debug = "BATX:CBSS()"
                    }

                    If (HB0A)
                    {
                        PBS0 = GBSS (0x00, PBSS)

                        If (BDBG == One)
                        {
                            Concatenate ("BATX:BSSTimeToFull: BAT0 ", ToDecimalString (DerefOf (PBS0 [0x01])), Debug)
                            Concatenate ("BATX:BSSTimeToEmpty: BAT0 ", ToDecimalString (DerefOf (PBS0 [0x02])), Debug)
                            Concatenate ("BATX:BSSChargeLevel: BAT0 ", ToDecimalString (DerefOf (PBS0 [0x03])), Debug)
                            Concatenate ("BATX:BSSAverageRate: BAT0 ", ToDecimalString (DerefOf (PBS0 [0x04])), Debug)
                        }

                        If (!HB1A)
                        {
                            Return (PBS0)
                        }
                    }

                    // gather battery data from BAT1
                    PBS1 = GBSS (0x10, PBSS)

                    If (BDBG == One)
                    {
                        Concatenate ("BATX:BSSTimeToFull: BAT1 ", ToDecimalString (DerefOf (PBS1 [0x01])), Debug)
                        Concatenate ("BATX:BSSTimeToEmpty: BAT1 ", ToDecimalString (DerefOf (PBS1 [0x02])), Debug)
                        Concatenate ("BATX:BSSChargeLevel: BAT1 ", ToDecimalString (DerefOf (PBS1 [0x03])), Debug)
                        Concatenate ("BATX:BSSAverageRate: BAT1 ", ToDecimalString (DerefOf (PBS1 [0x04])), Debug)
                    }

                    If (!HB0A)
                    {
                        Return (PBS1)
                    }

                    // combine batteries into Local0 result if possible
                    Local0 = PBS0

                    // 0x01: TimeToFull (0x11), minutes (0xFF), Valid integer in minutes
                    Local0 [0x01] = (DerefOf (PBS0 [0x01]) + DerefOf (PBS1 [0x01]))

                    // 0x02: BSSTimeToEmpty - TimeToEmpty, minutes (0), Valid integer in minutes
                    Local0 [0x02] = (DerefOf (PBS0 [0x02]) + DerefOf (PBS1 [0x02]))

                    // 0x03: BSSChargeLevel - ChargeLevel, percentage, 0 - 100 for percentage.
                    Local0 [0x03] = (DerefOf (PBS0 [0x03]) + DerefOf (PBS1 [0x03])) / 2

                    // 0x04: BSSAverageRate - AverageRate, mA (signed), Valid signed integer in mA.
                    Local0 [0x04] = (DerefOf (PBS0 [0x04]) + DerefOf (PBS1 [0x04]))

                    If (BDBG == One)
                    {
                        Concatenate ("BATX:BSSTimeToFull: BATX ", ToDecimalString (DerefOf (Local0 [0x01])), Debug)
                        Concatenate ("BATX:BSSTimeToEmpty: BATX ", ToDecimalString (DerefOf (Local0 [0x02])), Debug)
                        Concatenate ("BATX:BSSChargeLevel: BATX ", ToDecimalString (DerefOf (Local0 [0x03])), Debug)
                        Concatenate ("BATX:BSSAverageRate: BATX ", ToDecimalString (DerefOf (Local0 [0x04])), Debug)
                    }

                    Return (Local0)
                }


                /**
                *  Battery Information Supplement pack layout
                */
                Name (PBIS, Package ()
                {
                    0x007F007F,  // 0x00: BISConfig - config
                                 //   double check if you have valid AverageRate before disabling QuicPoll
                                 //     - 0x007F007F - Quickpoll disabled, more native battery handling
                                 //     - 0x006F007F - Quickpoll enabled, more robust battery handling
                    0xFFFFFFFF,  // 0x01: BISManufactureDate - ManufactureDate (0x1), AppleSmartBattery format
                    0x00002342,  // 0x02: BISPackLotCode - PackLotCode 
                    0x00002342,  // 0x03: BISPCBLotCode - PCBLotCode
                    0x00002342,  // 0x04: BISFirmwareVersion - FirmwareVersion
                    0x00002342,  // 0x05: BISHardwareVersion - HardwareVersion
                    0x00002342,  // 0x06: BISBatteryVersion - BatteryVersion 
                })

                /**
                *  Battery Information Supplement 
                */
                Method (CBIS, 0, NotSerialized)
                {
                    If (BDQP == One)
                    {
                        PBIS[0x00] = 0x006F007F
                    }

                    If (BDBG == One)
                    {
                        Debug = "BATX:CBIS()"
                    }

                    If (Acquire (BAXM, 65535))
                    {
                        Debug = "BATX:AcquireLock failed in CBIS"

                        Return (PBIS)
                    }

                    // Check your _BST method for similiar condition of EC accessibility
                    If (!HB0A)
                    {
                        Debug = "BATX:CBIS - Error HB0A not ready yet. Returning defaults."

                        Return (PBIS)
                    }

                    //
                    // Information Page 2 -
                    //
                    HIID = (0x02)

                    // 0x01: ManufactureDate (0x1), AppleSmartBattery format
                    PBIS [0x01] = SBDT

                    Local6 = ToDecimalString (SBSN) /* \_SB_.PCI0.LPCB.EC__.BATX.SBSN */

                    // Serial Number
                    PBIS [0x02] = Local6
                    PBIS [0x03] = Local6
                    PBIS [0x04] = Local6
                    PBIS [0x05] = Local6
                    PBIS [0x06] = Local6

                    Release (BAXM)

                    If (BDBG == One)
                    {
                        Concatenate ("BATX:CBIS:BISConfig BATX ", PBIS [0x00], Debug)
                        Concatenate ("BATX:CBIS:BISManufactureDate BATX ", PBIS [0x01], Debug)
                        Concatenate ("BATX:CBIS:BISPackLotCode BATX ", PBIS [0x02], Debug)
                    }

                    Return (PBIS)
                }
            }
        }
    }
}
//EOF
