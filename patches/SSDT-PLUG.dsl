/*
 * XCPM power management compatibility table.
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_PLUG", 0x00001000)
{
    External(_PR.PR00, ProcessorObj)
    /* Support methods */
    External (DTGP, MethodObj)    // 5 Arguments

    If (CondRefOf (\PR.PR00))
    {
        Scope (\_PR.PR00)
        {
            Method (_DSM, 4, NotSerialized)
            {
                Local0 = Package ()
                    {
                        // Inject plugin-type = 0x01
                        "plugin-type", 
                        One
                    }
                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }
        }
    }
}