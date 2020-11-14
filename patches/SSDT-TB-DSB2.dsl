/*  
 * Partition and continuation of Thunderbolt 3 patch.
 * Depends on other TB-DSB* patches as well as /patches/OpenCore Patches/ Thunderbolt3.plist
 *
 * Credits @benbender
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_TBDSB2", 0x00003000)
{
    /* Support methods */
    External (DTGP, MethodObj)
    External (OSDW, MethodObj)                        // OS Is Darwin?

    External (_SB.PCI0.RP09.PXSX, DeviceObj)
    External (_SB.PCI0.RP09.PXSX.TBDU, DeviceObj)

    External (_SB.PCI0.RP09.TBST, MethodObj) // 0 Arguments
    External (_SB.PCI0.RP09.UGIO, MethodObj) // 0 Arguments

    External (_SB.PCI0.RP09.GXCI, IntObj)

    External (TBSE, IntObj)
    External (TBTS, IntObj)

    If (((TBTS == One) && (TBSE == 0x09)))
    {
        Scope (\_SB.PCI0.RP09.PXSX)
        {
            Scope (TBDU)
            {
                Method (_STA, 0, NotSerialized)
                {
                    If (OSDW ())
                    {
                        Return (Zero) // hidden for OSX
                    }

                    Return (0x0F) // visible for others
                }
            }

            Device (DSB2)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address

                Name (RUSB, One)

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
                    Return (SECB) /* SECB */
                }

                Method (_STA, 0, NotSerialized)
                {
                    If (OSDW ())
                    {
                        Return (0x0F) // Used in OSX
                    }

                    Return (0x0F) // hidden for others
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

                    PRSR = Zero
                    Debug = "TB:DSB2:PCEU - Put upstream bridge back into D0 "

                    If (PSTA != Zero)
                    {
                        Debug = "TB:DSB2:PCEU - exit D0, restored = true"
                        PRSR = One
                        PSTA = Zero
                    }

                    If (LDIS == One)
                    {
                        Debug = "TB:DSB2:PCEU - Clear link disable on upstream bridge"
                        Debug = "TB:DSB2:PCEU - clear link disable, restored = true"
                        PRSR = One
                        LDIS = Zero
                    }
                }

                /**
                * PCI disable link
                */
                Method (PCDA, 0, Serialized)
                {
                    Debug = "TB:DSB2:PCDA"

                    If (POFX () != Zero)
                    {
                        PCIA = Zero

                        Debug = "TB:DSB2:PCDA - Put upstream bridge into D3"
                        PSTA = 0x03

                        Debug = "TB:DSB2:PCDA - Set link disable on upstream bridge"
                        LDIS = One

                        Local5 = (Timer + 0x00989680)
                        While (Timer <= Local5)
                        {
                            Debug = "TB:DSB2:PCDA - Wait for link to drop..."
                            If (LACR == One)
                            {
                                If (LACT == Zero)
                                {
                                    Debug = "TB:DSB2:PCDA - No link activity"
                                    Break
                                }
                            }
                            ElseIf (AVND == 0xFFFFFFFF)
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

                    IIP3 = One
                }

                /**
                 * Is power saving requested?
                 */
                Method (POFX, 0, Serialized)
                {
                    Debug = Concatenate ("TB:DSB2:POFX - Result (!RUSB): ", (!RUSB))

                    Return (!RUSB)
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    Debug = "TB:DSB2:_PS0"

                    PCEU ()

                    // \_SB.PCI0.RP09.TBST ()
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    Debug = "TB:DSB2:_PS3"

                    PCDA ()

                    // \_SB.PCI0.RP09.TBST ()
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
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

                    Return (Zero)
                }
            }
        }
    }
}

