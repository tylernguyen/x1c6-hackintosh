/*
 * XCPM power management compatibility table.
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_PM", 0x00001000)
{
    External (DTGP, MethodObj) // 5 Arguments
    //
    // The CPU device name. (PR00 here)
    //
    External (_PR.PR00, ProcessorObj)

    /*
    * XCPM power management compatibility table.
    */
    Scope (\_PR.PR00)
    {
        Method (_DSM, 4, NotSerialized)
        {
            //
            // Inject plugin-type = 0x01 to load X86*.kext
            //
            Debug = "Writing plugin-type to Registry!"
            Local0 = Package (0x02)
                {
                    "plugin-type", 
                    One
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}