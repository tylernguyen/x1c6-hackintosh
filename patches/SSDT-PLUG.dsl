/*
 * XCPM power management compatibility table.
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_PLUG", 0x00001000)
{
    External(_PR.PR00, ProcessorObj)

    If (CondRefOf (\PR.PR00))
    {
        Scope (\_PR.PR00)
        {
            Method (_DSM, 4, NotSerialized)
            {
                If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                    {
                        0x03                                           
                    })
                }

                Return (Package (0x02)
                {
                    // Inject plugin-type = 0x01
                    "plugin-type", 
                    One
                })
            }
        }
    }
}