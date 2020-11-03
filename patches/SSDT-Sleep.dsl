/*
 * # Comprehensive Sleep-patches for modern thinkpads.
 *
 * ## Abstract
 *
 * This SSDT tries to be a comprehensive solution for sleep/wake-problems on most modern thinkpads.
 * It was developed on an X1C6 with a T480 in mind.
 * It immitates the behaviour of a macbookpro14,1 which is perfectly adequate for modern, kabylake-based Thinkpads.
 *
 * For X1C6 its perfectly possible to set SleepType=Windows in BIOS while getting perfect S3-Standby in OSX. 
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
 * Depends on /patches/OpenCore Patches/ Sleep.plist
 */

DefinitionBlock ("", "SSDT", 1, "tyler", "_Sleep", 0x00002000)
{
    // Common utils from SSDT-Darwin.dsl
    External (DTGP, MethodObj) // 5 Arguments
    External (OSDW, MethodObj) // 0 Arguments


    // Sleep-config from BIOS
    External (S0ID, FieldUnitObj) // S0 enabled
    External (STY0, FieldUnitObj) // S3 Enabled?
    
    // Package to signal to OS S3-capability. We'll add it if missing.
    External (SS3, FieldUnitObj) // S3 Enabled?    

    If (OSDW ())
    {
        Debug = "Enabling comprehensive S3-patching..."

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


    Scope (_GPE)
    {
        // This tells xnu to evaluate _GPE.Lxx methods on resume
        Method (LXEN, 0, NotSerialized)
        {
            Debug = "LXEN()"

            Return (One)
        }
    }


    External (_SB.PCI0.LPCB.EC.AC._PSR, MethodObj) // 0 Arguments
    External (_SB.PCI0.LPCB.EC._Q2A, MethodObj) // 0 Arguments
    External (_SB.LID._LID, MethodObj) // 0 Arguments
    External (ZPRW, MethodObj) // 2 ARguments
    External (ZWAK, MethodObj) // 1 Arguments

    External (_SB.PCI0.LPCB.EC.HPLD, FieldUnitObj)
    External (_SB.PCI0.GFX0.CLID, FieldUnitObj)
    External (LIDS, FieldUnitObj)
    External (PWRS, FieldUnitObj)

    // SLTP named on OSX but already taken on X1C6. Therefor named XLTP.
    Name (XLTP, Zero)  

    // Save sleep-state in SLTP on transition. Like a genuine Mac.
    Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
    {
        Debug = "_TTS() called with Arg0:"
        Debug = Arg0

        XLTP = Arg0
    }

    Scope (\)
    {
        // Patch _PRW-returns to match the original as closely as possible
        // and remove instant wakeups and similar sleep-probs
        Method (GPRW, 2, NotSerialized)
        {
            If (OSDW ())
            {
                Local0 = Package (0x02)
                {
                    Zero, 
                    Zero
                }

                Local0[Zero] = Arg0

                If (Arg1 > 0x04)
                {
                    Local0[One] = 0x04
                }

                Return (Local0)
            }
            Else 
            {
                Return (ZPRW (Arg0, Arg1))
            }
        }

        // Patch _WAK to fire missing LID-Open event and update AC-state
        Method (_WAK, 1, Serialized)
        {
            Debug = "_WAK start: Arg0"
            Debug = Arg0

            // Save old lid-state
            Local1 = \LIDS

            Debug = "_WAK - old lid state LIDS: "
            Debug = \LIDS

            Local0 = ZWAK(Arg0)

            If (OSDW ())
            {
                // Update lid-state
                \LIDS = \_SB.PCI0.LPCB.EC.HPLD
                \_SB.PCI0.GFX0.CLID = LIDS

                Debug = "_WAK - new lid state LIDS: "
                Debug = \LIDS

                // Fire missing lid-open event if lid was closed before. 
                // Also notifies LID-device and sets LEDs to the right state on wake.
                If (Local1 == Zero)
                {
                    Debug = "_WAK - fire lid open-event "

                    // Lid-open Event
                    \_SB.PCI0.LPCB.EC._Q2A ()
                }

                // Update ac-state
                \PWRS = \_SB.PCI0.LPCB.EC.AC._PSR ()
            }

            Debug = "_WAK end - return Local0: "
            Debug = Local0

            If (OSDW ())
            {
                Return (Package (0x02)
                {
                    Zero, 
                    Zero
                })
            }
            Else 
            {
                Return (Local0)
            }
        }
    }

    Scope (_SB)
    {
        // Sync S0-state between BIOS and OS
        Method (LPS0, 0, NotSerialized)
        {
            If (S0ID == One)
            {
                Debug = "SLEEP: Enable S0-Sleep / DeepSleep"
            }

            // If S0ID is enabled, enable deep-sleep in OSX. Can be set above.
            Return (S0ID)
        }

        // Adds ACPI power-button-device
        // https://github.com/daliansky/OC-little/blob/master/06-%E6%B7%BB%E5%8A%A0%E7%BC%BA%E5%A4%B1%E7%9A%84%E9%83%A8%E4%BB%B6/SSDT-PWRB.dsl
        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Return (Zero)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (OSDW ())
                {
                    Return (0x0B)
                }

                Return (Zero)
            }
        }
    }

    External (_SB.PCI0.LPCB.EC.AC, DeviceObj)

    // Patching AC-Device so that AppleACPIACAdapter-driver loads.
    // Device named ADP1 on Mac
    // See https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro14%2C1/ACPI%20Tables/DSL/DSDT.dsl#L7965
    Scope (\_SB.PCI0.LPCB.EC.AC)
    {
        Name (WK00, One)

        Method (SWAK, 1, NotSerialized)
        {
            Debug = "AC:SWAK()"

            WK00 = (Arg0 & 0x03)

            If (!WK00)
            {
                Debug = "AC:SWAK() - WK00 = One"
                WK00 = One
            }
        }

        Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
        {
            // Lid-wake control power
            Debug = "AC:_PRW() - LWCP = "
            Debug = LWCP

            If (OSDW () || \LWCP)
            {
                Return (Package (0x02)
                {
                    0x17, 
                    0x04
                })
            }
            Else
            {
                Return (Package (0x02)
                {
                    0x17, 
                    0x03
                })
            }
        }
    }
}
//EOF
