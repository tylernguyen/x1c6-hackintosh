/*
 *
 * Neccessary dependcies to read from the machine's embedded controller. This patch is specific to the x1c6, and to a larger extent, ThinkPads. Not to be confused with Dortania's SSDT-EC.dsl
 *
 * For use with YogaSMC.kext and App
 * https://github.com/zhen-zen/YogaSMC
 *
 * Credits @benbender @zhen-zen
 */

/*
 https://github.com/coreboot/coreboot/blob/master/src/ec/quanta/it8518/acpi/ec.asl
 Memory layout of X1C6-embedded controller as far as known:
    OperationRegion (ECOR, EmbeddedControl, 0x00, 0x0100)
    Field (ECOR, ByteAcc, NoLock, Preserve)
    {
        HDBM,   1, 
            ,   1, 
            ,   1, 
        HFNE,   1,      //   Enable Sticky Fn Key
            ,   1, 
            ,   1, 
        HLDM,   1, 
        Offset (0x01),  // [Configuration Space 1]
        BBLS,   1,        
        BTCM,   1, 
            ,   1, 
            ,   1, 
            ,   1, 
        HBPR,   1, 
        BTPC,   1, 
        Offset (0x02),   // [Configuration Space 2]
        HDUE,   1, 
            ,   4, 
        SNLK,   1, 
        Offset (0x03),   // [Configuration Space 3]
            ,   5, 
        HAUM,   2, 
        Offset (0x05),  // [Sound Mask 1]
        HSPA,   1,        //   power off alarm
        Offset (0x06),  // [Sound ID (Write only)]
        HSUN,   8,        //   Sound ID (Write Only)
        Offset(0x07),   // [Sound Repeat Interval (unit time 125ms)]
        HSRP,   8,        //   Sound Repeat Interval (Unit time : 125ms )
        Offset (0x0C),  // [LED On/Off/ Blinking Control (Write only)]
        HLCL,   4,        //   0: power LED
                        //   1: battery status 0
                        //   2: battery status 1
                        //   3: additional Bay LED (Venice) / reserved (Toronto-4) / Slicer LED (Tokyo)
                        //   4-6: reserved
                        //   7: suspend LED
                        //   8: dock LED 1
                        //   9: dock LED 2
                        //   10-13: reserved
                        //   14: microphone mute
                        //   15: reserved
            ,   4, 
        CALM,   1, 
        Offset (0x0E),  // [Peripheral Status 4]
        HFNS,   2,        //   Bit[1, 0] : Fn Key Status
                        //      [0, 0] ... Unlock
                        //      [0, 1] ... Sticky
                        //      [1, 0] ... Lock
                        //      [1, 1] ... Reserved
        Offset (0x0F),   // [Peripheral status 5 (read only)] ?
            ,   6, 
        NULS,   1, 
        Offset (0x10),   // [Attention Mask (00-127)]
        HAM0,   8,        // 10 : Attention Mask (00-07)
        HAM1,   8,        // 11 : Attention Mask (08-0F)
        HAM2,   8,        // 12 : Attention Mask (10-17)
        HAM3,   8,        // 13 : Attention Mask (18-1F)
        HAM4,   8,        // 14 : Attention Mask (20-27)
        HAM5,   8,        // 15 : Attention Mask (28-2F)
        HAM6,   8,        // 16 : Attention Mask (30-37)
        HAM7,   8,        // 17 : Attention Mask (38-3F)
        HAM8,   8,        // 18 : Attention Mask (40-47)
        HAM9,   8,        // 19 : Attention Mask (48-4F)
        HAMA,   8,        // 1A : Attention Mask (50-57)
        HAMB,   8,        // 1B : Attention Mask (58-5F)
        HAMC,   8,        // 1C : Attention Mask (60-67)
        HAMD,   8,        // 1D : Attention Mask (68-6F)
        HAME,   8,        // 1E : Attention Mask (70-77)
        HAMF,   8,        // 1F : Attention Mask (78-7F)
        Offset (0x23),   // [Misc. control]
        HANT,   8, 
        Offset (0x26), 
            ,   2, 
        HANA,   2, 
        Offset (0x27),   // [Passward Scan Code]
        Offset (0x28), 
            ,   1, 
        SKEM,   1, 
        Offset (0x29), 
        Offset (0x2A),   // [Attention Request]
        HATR,   8,        // 2A : Attention request
        Offset(0x2B),   // [Trip point of battery capacity]
        HT0H,   8,        // 2B : MSB of Trip Point Capacity for Battery 0
        HT0L,   8,        // 2C : LSB of Trip Point Capacity for Battery 0
        HT1H,   8,        // 2D : MSB of Trip Point Capacity for Battery 1
        HT1L,   8,        // 2E : LSB of Trip Point Capacity for Battery 1
        Offset(0x2F),   // [Fan Speed Control]
        HFSP,   8,        //  bit 2-0: speed (0: stop, 7:highest speed)
                          //  bit 5-3: reserved (should be 0)
                          //  bit 6: max. speed
                          //  bit 7: Automatic mode (fan speed controlled by thermal level)
        Offset(0x30),   // [Audio mute control]
            ,   7,        //  Reserved bits[0:6]
        SMUT,   1,        //  Mute
        Offset (0x31),   // [Peripheral Control 2] 
        FANS,   2,        //   bit 0,1 Fan selector ?
                          //	   00: Fan 1, 01: Fan 2 ?
        HUWB,   1,        //   UWB on
            ,   3, 
        VPON,   1, 
        VRST,   1, 
        Offset(0x32),   // [EC Event Mask 0]
        HWPM,   1,        //   PME : Not used. PME# is connected to GPE directly.
        HWLB,   1,        //   Critical Low Bat
        HWLO,   1,        //   Lid Open
        HWDK,   1, 
        HWFN,   1,        //   FN key
        HWBT,   1, 
        HWRI,   1,        //   Ring Indicator (UART)
        HWBU,   1,        //   Bay Unlock
        HWLU,   1, 
        Offset (0x34), 
            ,   3, 
        PIBS,   1, 
            ,   3, 
        HPLO,   1, 
        Offset (0x36), 
        HWAC,   16, 
        Offset(0x38),   // [Battery 0 status (read only)]
        HB0S,   7,        //   bit 3-0 level
                          //     F: Unknown
                          //     2-n: battery level
                          //     1: low level
                          //     0: (critical low battery, suspend/ hibernate)
                          //   bit 4 error
                          //   bit 5 charge
                          //   bit 6 discharge
        HB0A,   1,        //   bit 7 battery attached
        Offset(0x39),   // [Battery 1 status (read only)]
                          //    bit definition is the same as offset(0x38)
        Offset(0x3A),   // [Peripheral control 0]
        HCMU,   1,        //   Mute
            ,   2, 
        OVRQ,   1, 
        DCBD,   1,        //   Bluetooth On
        DCWL,   1,        //   Wireless Lan On
        DCWW,   1,        //   Wireless Wan On
        HB1I,   1, 
        Offset(0x3B),   // [Peripheral control 1]
            ,   1,        //   Speaker Mute 
        KBLT,   1,        //   Keyboard Light
        BTPW,   1, 
        FNKC,   1, 
        HUBS,   1, 
        BDPW,   1,        // Bluetooth power?
        BDDT,   1,        // Bluetooth detach?
        HUBB,   1, 
        Offset(0x3C),   // [Resume reason (Read only)]
        Offset(0x3D),   // [Password Control byte]
        Offset(0x3E),   // [Password data (8 byte)~ offset:45h]
        Offset (0x46),   // [sense status 0] 
            ,   1, 
        BTWK,   1, 
        HPLD,   1,        //   LID open
            ,   1, 
        HPAC,   1,        //   External power (AC status)
        BTST,   1, 
        PSST,   1, 
        Offset (0x47),   // [sense status 1]
        HPBU,   1,        //   Bay Unlock
            ,   1, 
        HBID,   1, 
            ,   3, 
        HBCS,   1, 
        HPNF,   1, 
        Offset(0x48),   // [sense status 2]
            ,   1, 
        GSTS,   1,        //   Global Wan Enable Switch
            ,   2, 
        HLBU,   1, 
        DOCD,   1, 
        HCBL,   1, 
        Offset (0x49),   // [sense status 3]
        SLUL,   1, 
            ,   1, 
        ACAT,   1, 
            ,   4, 
        ELNK,   1, 
        Offset (0x4C),   // [MSB of Event Timer]
        HTMH,   8, 
        HTML,   8, 
        HWAK,   16, 
        HMPR,   8, 
            ,   7, 
        HMDN,   1, 
        Offset (0x78),   // [Temperature of thermal sensor 0 (centigrade)]
        TMP0,   8,        // 78 : Temperature of thermal sensor 0
        Offset (0x80),   // [Attention control byte]
        Offset (0x81),   // [Battery information ID for 0xA0-0xAF]
        HIID,   8,        //   (this byte is depend on the interface, 62&66 and 1600&1604)
        Offset (0x83),   // [Fn Dual function ID]
        HFNI,   8,        //	0: none
                          //	1-3: Reserved
                          //	4: ACPI Power
                          //	5: ACPI Sleep
                          //	6: ACPI Wake
                          //  7: Left Ctrl key
        Offset(0x84),   // [Fan Speed]
        HSPD,   16,       //
                          // (I/F Offset 3Bh bit5 => 0:Main Fan , 1:Second Fan)
        Offset (0x88), // [Thermal Status of Level 0 (low)]
        TSL0,   7, 
        TSR0,   1, 
        Offset (0x89), // [Thermal Status of Level 1 (middle)]
        TSL1,   7, 
        TSR1,   1, 
        Offset (0x8A), // [Thermal Status of Level 2 (middle high)]
        TSL2,   7, 
        TSR2,   1, 
        Offset (0x8B), // [Thermal Status of Level 3 (high)]
        TSL3,   7, 
        TSR3,   1, 
        GPUT,   1, 
        Offset(0x8D),   // [Interval of polling Always-on cards in half minute]
        HDAA,   3,        //   Warning Delay Period
        HDAB,   3,        //   Stolen Delay Period
        HDAC,   2,        //   Sensitivity
        Offset (0xB0),
        HDEN,   32, 
        HDEP,   32, 
        HDEM,   8, 
        HDES,   8, 
        Offset (0xC4), 
        SDKL,   1, 
        Offset (0xC5), 
        Offset (0xC8),  // [Adaptive Thermal Management (ATM)]
        ATMX,   8,        //  bit 7-4 - Thermal Table & bit 3-0 - Fan Speed Table
        Offset(0xC9),   // [Wattage of AC/DC]
        HWAT,   8,        //
        Offset (0xCC),   //
        PWMH,   8,        // CC : AC Power Consumption (MSB)
        PWML,   8,        // CD : AC Power Consumption (LSB) - unit: 100mW
        Offset (0xCF), 
            ,   6, 
        ESLP,   1, 
        Offset (0xD0), 
        Offset (0xED), 
            ,   4, 
        HDDD,   1
    }
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_EC", 0)
{
    Scope (\)
    {
        /*
         * Status from two EC fields
         */
        Method (B1B2, 2, NotSerialized)
        {
            Local0 = (Arg1 << 0x08)
            Local0 |= Arg0
            Return (Local0)
        }

        /*
         * Status from four EC fields
         */
        Method (B1B4, 4, NotSerialized)
        {
            Local0 = Arg3
            Local0 = (Arg2 | (Local0 << 0x08))
            Local0 = (Arg1 | (Local0 << 0x08))
            Local0 = (Arg0 | (Local0 << 0x08))
            Return (Local0)
        }
    }

    /*
     * Methods to EC read / write access in case you don't have battery patch
     * Taken from Rehabmman's guide: https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/
     */

    External (_SB_.PCI0.LPCB.EC, DeviceObj)    // EC path

    Scope (_SB.PCI0.LPCB.EC)
    {
        /* 
         * Called from RECB, grabs a single byte from EC
         * Arg0 - offset in bytes from zero-based EC
         */
        Method (RE1B, 1, Serialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE)
        }

        /* 
         * Grabs specified number of bytes from EC
         * Arg0 - offset in bytes from zero-based EC
         * Arg1 - size of buffer in bits
         */
        Method (RECB, 2, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1) {})
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }

            Return (TEMP)
        }

        Method (WE1B, 2, Serialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1) {})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }
    }
    
    /*
    Sample SSDT for ThinkSMC sensor access
    Double check name of FieldUnit for collision
    Registers return 0x00 for non-implemented, 
    and return 0x80 when not available.
    */
    
    External (_SB.PCI0.LPCB.EC.HKEY, DeviceObj)    // HKEY path
    External (_SB.PCI0.LPCB.EC.HFSP, FieldUnitObj) // Fan control register
    External (_SB.PCI0.LPCB.EC.HFNI, FieldUnitObj) // Fan control register
    External (_SB.PCI0.LPCB.EC.VRST, FieldUnitObj) // Second fan switch register
    External (_SI._SST, MethodObj)    // Indicator

    /*
     * Optional: Route to customized LED pattern or origin _SI._SST if differ from built in pattern.
     */
    Scope (\_SB.PCI0.LPCB.EC.HKEY)
    {
        // Used as a proxy-method to interface with \_SI._SST in YogaSMC
        Method (CSSI, 1, NotSerialized)
        {
            \_SI._SST (Arg0)
        }
    }

    /*
     * Optional: Sensor access
     * 
     * Double check name of FieldUnit for collision
     * Registers return 0x00 for non-implemented, 
     * and return 0x80 when not available.
     */
    
    Scope (_SB.PCI0.LPCB.EC)
    {
        OperationRegion (ESEN, EmbeddedControl, Zero, 0x0100)
        Field (ESEN, ByteAcc, Lock, Preserve)
        {
            // TP_EC_THERMAL_TMP0
            Offset (0x78), 
            EST0,   8, // CPU
            EST1,   8, 
            EST2,   8, 
            EST3,   8, // GPU ?
            EST4,   8, // Battery ?
            EST5,   8, // Battery ?
            EST6,   8, // Battery ?
            EST7,   8, // Battery ?

            // TP_EC_THERMAL_TMP8
            Offset (0xC0), 
            EST8,   8, 
            EST9,   8, 
            ESTA,   8, 
            ESTB,   8, 
            ESTC,   8, 
            ESTD,   8, 
            ESTE,   8, 
            ESTF,   8
        }
    }

    /*
     * Deprecated: Write access to fan control register
     */
    Scope (\_SB.PCI0.LPCB.EC.HKEY)
    {
        Method (CFSP, 1, NotSerialized)
        {
            \_SB.PCI0.LPCB.EC.HFSP = Arg0
        }

        Method (CFNI, 1, NotSerialized)
        {
            \_SB.PCI0.LPCB.EC.HFNI = Arg0
        }

        Method (CRST, 1, NotSerialized)
        {
            \_SB.PCI0.LPCB.EC.VRST = Arg0
        }
    }
}