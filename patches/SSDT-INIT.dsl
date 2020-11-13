// Depends on /patches/OpenCore Patches/ INIT.plist
//
/*
 Source: https://github.com/tianocore/edk2-platforms/blob/master/Platform/Intel/KabylakeOpenBoardPkg/Include/Acpi/GlobalNvs.asl
   //
   // Miscellaneous Dynamic Registers:
   //
   Offset(0),      OSYS, 16, // Offset(0),     Operating System
   Offset(2),      SMIF, 8,  // Offset(2),     SMI Function Call (ASL to SMI via I/O Trap)
   Offset(3),      P80D, 32, // Offset(3),     Port 80 Debug Port Value
   Offset(7),      PWRS, 8,  // Offset(7),     Power State (AC Mode = 1)
   //
   // Thermal Policy Registers:
   //
   Offset(8),      DTSE, 8,  // Offset(8),    Digital Thermal Sensor Enable
   Offset(9),      DTSF, 8,  // Offset(9),    DTS SMI Function Call
   //                 
   // CPU Identification Registers:
   //
   Offset(10),     APIC, 8,  // Offset(10),    APIC Enabled by SBIOS (APIC Enabled = 1)
   Offset(11),     TCNT, 8,  // Offset(11),    Number of Enabled Threads
   //
   // PCIe Hot Plug
   //
   Offset(12),     OSCC, 8,  // Offset(12),    PCIE OSC Control
   Offset(13),     NEXP, 8,  // Offset(13),    Native PCIE Setup Value
   [...]
   Offset(65),     RTD3, 8,  // Offset(65),    Runtime D3 support.
   Offset(66),     S0ID, 8,  // Offset(66),    Low Power S0 Idle Enable
   Offset(67),     GBSX, 8,  // Offset(67),    Virtual GPIO button Notify Sleep State Change
   Offset(68),     PSCP, 8,  // Offset(68),    P-state Capping
   Offset(69),     P2ME, 8,  // Offset(69),    Ps2 Mouse Enable
   Offset(70),     P2MK, 8,  // Offset(70),    Ps2 Keyboard and Mouse Enable
   //
   // Driver Mode
   //
   Offset(71),     GIRQ, 32, // Offset(71),    GPIO IRQ
   Offset(75),     PLCS, 8,  // Offset(75),    set PL1 limit when entering CS
   Offset(76),     PLVL, 16, // Offset(76),    PL1 limit value
   Offset(78),     PB1E, 8,  // Offset(78),    10sec Power button support
   Offset(79),     ECR1, 8,  // Offset(79),    Pci Delay Optimization Ecr
   Offset(80),     TBTS, 8,  // Offset(80),    Thunderbolt(TM) support
   Offset(81),     TNAT, 8,  // Offset(81),    TbtNativeOsHotPlug
   Offset(82),     TBSE, 8,  // Offset(82),    Thunderbolt(TM) Root port selector
   Offset(83),     TBS1, 8,  // Offset(83),    Thunderbolt(TM) Root port selector
   Offset(84),     BDID, 8,  // Offset(84),    Board ID
*/
//
// Credits @benbender

DefinitionBlock ("", "SSDT", 2, "tyler", "_INIT", 0x00001000)
{
    // External method from SSDT-Darwin.dsl
    External (OSDW, MethodObj) // 0 Arguments

    External (_SB.PCI0, DeviceObj)

    // System
    External (HPTE, FieldUnitObj) // HPET enabled?
    External (WNTF, FieldUnitObj) // DYTC enabled?
    External (DPTF, FieldUnitObj) // DPTF enabled?
    External (OSYS, FieldUnitObj) // OS type

    External (ZINI, MethodObj)

    // Thunderbolt
    External (_SB.PCI0.RP09.INIT, MethodObj)


    Scope (\_SB.PCI0)
    {
        Method (OINI, 0, NotSerialized)
        {
            If (OSDW())
            {
                Debug = "INIT: Set Variables..."

                // disable HPET. It shouldn't be needed on modern systems anyway and is also disabled in genuine OSX
                HPTE = Zero

                // Enables DYTC, Lenovos thermal solution. Can be controlled by YogaSMC
                WNTF = One

                // Disable DPTF, we use DYTC!
                DPTF = Zero

                // Patch OSYS to native value of darwin
                OSYS = 0x07DF
            }

            ZINI ()

            // Thunderbolt-setup
            If (OSDW () && CondRefOf (\_SB.PCI0.RP09.INIT))
            {
                \_SB.PCI0.RP09.INIT ()
            }
        }
    }
}
//EOF
