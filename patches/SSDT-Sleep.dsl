/**
 * Depends on /patches/OpenCore Patches/ Sleep.plist
 *
 * # Comprehensive Sleep-patches for modern thinkpads.
 *
 * ## Abstract
 *
 * This SSDT tries to be a comprehensive solution for sleep/wake-problems on most modern thinkpads.
 * It was developed on an X1C6 with a T480 in mind.
 * It immitates the behaviour of a macbookpro14,1 which is perfectly adequate for modern, kabylake-based Thinkpads.
 *
 * For X1C6 its perfectly possible to set SleepType=Windows in BIOS while getting perfect S3-Standby in OSX. 
 * That's the recommended setting as it enables "modern standby" in Windows for dual-boot-systems.
 *
 * With this SSDT it is perfectly possible to have ACPI-sleepstates S0 (DeepIde), S3 (Standby) & S4 (Hibernation) working.
 * So generally hibernatemode 0, 3 & 25 in OSX' terms are possible. There might be smaller bugs and hickups though. 
 * F.e. S0-DeepIdle has a much higher power draw on sleep as S3 atm. There are also reports about such behaviour on 
 * native OSX & native Windows. Bugs are not infrequently rooted in poor ACPI-implementations or OSX-bugs and not 
 * directly rooted in hackintoshing.
 *
 * No special setup via pmset per se needed, but may be needed anyways depending f.e. on your bluetooth implementation.
 * If you have played with `pmset` and want to restore the defaults to have a clean state, use `sudo pmset -a restoredefaults`.
 *
 * Bottom line: We are near a relative native pm-/sleep-setup with this. 
 *
 *
 * ## Background:
 *
 * Sleep on hackintoshes is a complicated topic. More complicated as mostly percieved. The problem is
 * that many functions of power management, sleep & wake are handled by the Macbook's embedded controller (EC)
 * / SMC and therefor many functions and devices are simply missing on Hackintoshes (f.e. the topcase-device). 
 * What we do have are our own, vendor-specific ECs and a myriade of different names for different sleep-methods.
 *
 * On top of this, most parts of the config have to be configured properly to accomplish working, non (or at least less) 
 * power-loosing sleep-states. Many of the (partly) solutions out there don't try to replicate the sleep-behaviour 
 * of a genuine macbook, but try to hide shortcomings and bugs with "ons-size-fits-all"-patches.
 * 
 * With this reasoning in mind, this SSDT tries to match the sleep-behaviour of a macbookpro14,1 as closely as possible.
 *
 *
 * # Notice:
 *
 * Please remove every GPRW-, Name6x-, PTSWAK-, FixShutdown-, WakeScren-Patches or similar prior using.
 * If you adapt this patches to other models, check the occurence of the used variables and methods on your own DSDT beforehand.
 *
 * Credits @benbender
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_Sleep", 0x00001000)
{
    // Common utils from SSDT-Darwin.dsl
    External (DTGP, MethodObj) // 5 Arguments
    External (OSDW, MethodObj) // 0 Arguments

    // Sleep-config from BIOS
    External (S0ID, FieldUnitObj) // BIOS-S0 enabled, "Windows Modern Standby"
    External (STY0, FieldUnitObj) // S3 Enabled?

    // Package to signal to OS S3-capability. We'll add it if missing.
    External (SS3, FieldUnitObj) // S3 Enabled?    
    External (_S3) 

    Name (DIEN, Zero) // DeepIdle (ACPI-S0) enabled
    Name (INIB, One) // Initial BootUp

    // This make OSX independent of the BIOS-sleep-setting on X1C6 and force-enable S3
    If (OSDW ())
    {
        Debug = "SLEEP: Enabling comprehensive S3-patching..."

        // Enable S3
        //   0x00 enables S3
        //   0x02 disables S3
        STY0 = Zero

        // Disable S0 for now
        S0ID = Zero

        // This adds S3 for OSX, even when sleep=windows in bios.
        If (STY0 == Zero && !CondRefOf (\_S3))
        {
            Name (\_S3, Package (0x04)  // _S3_: S3 System State
            {
                0x05, 
                0x05, 
                0x00, 
                0x00
            })

            SS3 = One
        }
    }


    // SLTP named on OSX but already taken on X1C6. Therefor named XLTP.
    Name (XLTP, Zero)  

    // Save sleep-state in XLTP on transition. Like a genuine Mac.
    Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
    {
        Debug = Concatenate ("SLEEP:_TTS() called with Arg0 = ", Arg0)

        XLTP = Arg0
    }


    // @SEE https://github.com/tianocore/edk2-platforms/blob/master/Platform/Intel/KabylakeOpenBoardPkg/Acpi/BoardAcpiDxe/Dsdt/Gpe.asl
    // @SEE https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/
    Scope (_GPE)
    {
        // This tells xnu to evaluate _GPE.Lxx methods on resume
        Method (LXEN, 0, NotSerialized)
        {
            Return (One)
        }
    }

    External (_SB.PCI0.LPCB, DeviceObj)
    External (_SB.PCI0.LPCB.EC, DeviceObj)
    External (_SB.LID, DeviceObj)

    External (_SB.PCI0.LPCB.EC.AC._PSR, MethodObj) // 0 Arguments
    External (_SB.PCI0.RP09.UPSB.LSTX, MethodObj) // 2 Arguments
    External (_SB.PCI0.LPCB.EC.LED, MethodObj) // 2 Arguments
    External (_SB.PCI0.XHC.USBM, MethodObj) // 0 Arguments
    External (ZPRW, MethodObj) // 2 ARguments
    External (ZPTS, MethodObj) // 1 Arguments
    External (ZWAK, MethodObj) // 1 Arguments

    External (_SB.PCI0.XHC.PMEE, FieldUnitObj)
    External (_SB.PCI0.XDCI.PMEE, FieldUnitObj)
    External (_SB.PCI0.HDAS.PMEE, FieldUnitObj)
    External (_SB.PCI0.GLAN.PMEE, FieldUnitObj)
    External (_SB.SCGE, FieldUnitObj)

    External (_SB.PCI0.LPCB.EC.HPLD, FieldUnitObj)
    External (_SB.PCI0.GFX0.CLID, FieldUnitObj)
    External (LIDS, FieldUnitObj)
    External (PWRS, FieldUnitObj)
    External (TBTS, FieldUnitObj)

    Scope (\)
    {
        // Fix sleep
        Method (SPTS, 0, NotSerialized)
        {
            Debug = "SLEEP:SPTS"

            If (\LIDS != \_SB.PCI0.LPCB.EC.HPLD)
            {
                Debug = "SLEEP:SPTS - lid-state unsync."

                \LIDS = \_SB.PCI0.LPCB.EC.HPLD
                \_SB.PCI0.GFX0.CLID = LIDS
            }

            // Force-update LEDs, mainly used in ACPI-S0
            \_SB.PCI0.LPCB.EC.LED (0x07, 0xA0)
            \_SB.PCI0.LPCB.EC.LED (0x00, 0xA0)
            \_SB.PCI0.LPCB.EC.LED (0x0A, 0xA0)
        }

        // Fix wake
        Method (SWAK, 0, NotSerialized)
        {
            Debug = "SLEEP:SWAK"

            If (\LIDS != \_SB.PCI0.LPCB.EC.HPLD)
            {
                Debug = "SLEEP:SWAK - lid-state unsync."

                \LIDS = \_SB.PCI0.LPCB.EC.HPLD
                \_SB.PCI0.GFX0.CLID = LIDS
            }

            // Wake screen on wake
            Notify (\_SB.LID, 0x80)

            // Force-update LEDs, just to be sure ;)
            \_SB.PCI0.LPCB.EC.LED (0x00, 0x80)
            \_SB.PCI0.LPCB.EC.LED (0x0A, 0x80)
            \_SB.PCI0.LPCB.EC.LED (0x07, 0x80)

            // Update ac-state
            \PWRS = \_SB.PCI0.LPCB.EC.AC._PSR ()

            \_SB.SCGE = One
        }


        If (CondRefOf (\ZPTS))
        {
            Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
            {
                Debug = Concatenate ("SLEEP:_PTS called - Arg0 = ", Arg0)

                // On sleep
                If (OSDW () && (Arg0 < 0x05))
                {
                    SPTS ()
                }

                ZPTS (Arg0)

                // On shutdown
                If (OSDW () && (Arg0 == 0x05))
                {
                    If (CondRefOf (\_SB.PCI0.XHC.PMEE))
                    {
                        \_SB.PCI0.XHC.PMEE = Zero
                    }

                    If (CondRefOf (\_SB.PCI0.XDCI.PMEE))
                    {
                        \_SB.PCI0.XDCI.PMEE = Zero
                    }

                    If (CondRefOf (\_SB.PCI0.GLAN.PMEE))
                    {
                        \_SB.PCI0.GLAN.PMEE = Zero
                    }

                    If (CondRefOf (\_SB.PCI0.HDAS.PMEE))
                    {
                        \_SB.PCI0.HDAS.PMEE = Zero
                    }

                    // If (CondRefOf (\_SB.PCI0.XHC.USBM))
                    // {
                    //     \_SB.PCI0.XHC.USBM ()
                    // }

                    // If (CondRefOf (\_SB.PCI0.RP09.UPSB.LSTX))
                    // {
                    //     Debug = "SLEEP:_PTS: Call TB-LSTX"
                    //     \_SB.PCI0.RP09.UPSB.LSTX (Zero, One)
                    //     \_SB.PCI0.RP09.UPSB.LSTX (One, One)
                    // }
                }
            }
        }

        If (CondRefOf (\ZWAK))
        {
            // Patch _WAK to fire missing LID-Open event and update AC-state
            Method (_WAK, 1, Serialized)
            {
                Debug = Concatenate ("SLEEP:_WAK - called Arg0: ", Arg0)

                // On Wake
                If (OSDW () && (Arg0 < 0x05))
                {
                    SWAK ()
                }

                Local0 = ZWAK(Arg0)

                Return (Local0)
            }
        }

        // Patch _PRW-returns to match the original as closely as possible
        // and should remove instant wakeups and similar sleep-probs
        Method (GPRW, 2, Serialized)
        {
            If (OSDW ())
            {
                Local0 = Package (0x02)
                {
                    0x00, 
                    0x00
                }

                Local0[0x00] = Arg0

                If (Arg1 >= 0x04)
                {
                    // Debug = Concatenate ("SLEEP: GPRW patched to 0x00: ", Arg1)

                    Local0[0x01] = 0x00
                }

                Return (Local0)
            }

            Return (ZPRW (Arg0, Arg1))
        }
    }


    // Handles sleep/wake on ACPI-S0-DeepIdle
    Scope (_SB.PCI0.LPCB)
    {
        Method (_PS0, 0, Serialized)
        {
            If (OSDW () && DIEN == One && INIB == Zero)
            {
                \SWAK ()
            }

            If (INIB == One)
            {
                INIB = Zero
            }
        }

        Method (_PS3, 0, Serialized)
        {
            If (OSDW () && DIEN == One)
            {
                \SPTS ()
            }
        }
    }


    Scope (_SB)
    {
        // Enable ACPI-S0-DeepIdle
        Method (LPS0, 0, NotSerialized)
        {
            If (DIEN == One)
            {
                Debug = "SLEEP: Enable S0-Sleep / DeepSleep"
            }

            // If S0ID is enabled, enable deep-sleep in OSX. Can be set above.
            // Return (S0ID)
            Return (DIEN)
        }
    }
}
//EOF
