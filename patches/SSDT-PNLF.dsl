/* 
 * Add PNLF device
 * For use with AppleBacklightSmoother.kext
 *
 * Credits @hieplpvip
 */

DefinitionBlock("", "SSDT", 2, "tyler", "_PNLF", 0)
{
    External(_SB.PCI0.GFX0, DeviceObj)
    Scope(_SB.PCI0.GFX0)
    {
        OperationRegion(RMP1, PCI_Config, 2, 2)
    }

    // For backlight control
    Device(_SB.PCI0.GFX0.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId("APP0002"))
        Name(_CID, "backlight")
        // _UID is set depending on device ID to match profiles in WhateverGreen
        // 14: Arrandale/Sandy/Ivy
        // 15: Haswell/Broadwell
        // 16: Skylake/KabyLake
        // 17: custom LMAX=0x7a1
        // 18: custom LMAX=0x1499
        // 19: CoffeeLake 0xffff
        Name(_UID, 0)
        Name(_STA, 0x0B)

        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            GDID, 16
        }

        Method(_INI)
        {
            Local0 = ^GDID

            // check Arrandale/Sandy/Ivy
            If (Ones != Match(Package()
            {
                // Arrandale
                0x0042, 0x0046, 0x004a,
                // Sandy HD3000
                0x0102, 0x0106, 0x010a, 0x010b, 0x010e,
                0x0112, 0x0116, 0x0122, 0x0126,
                // Ivy
                0x0152, 0x0156, 0x015a, 0x015e, 0x0162,
                0x0166, 0x016a, 0x0172, 0x0176,
            }, MEQ, Local0, MTR, 0, 0))
            {
                _UID = 14
            }

            // check Haswell/Broadwell
            ElseIf (Ones != Match(Package()
            {
                // Haswell
                0x0402, 0x0406, 0x040a, 0x0412, 0x0416,
                0x041a, 0x041e, 0x0a06, 0x0a16, 0x0a1e,
                0x0a22, 0x0a26, 0x0a2a, 0x0a2b, 0x0a2e,
                0x0d12, 0x0d16, 0x0d22, 0x0d26, 0x0d2a,
                0x0d36,
                // Broadwell
                0x1612, 0x1616, 0x161e, 0x1622, 0x1626,
                0x162a, 0x162b, 0x162d,
            }, MEQ, Local0, MTR, 0, 0))
            {
                _UID = 15
            }

            // check Skylake/Kaby Lake
            ElseIf (Ones != Match(Package()
            {
                // Skylake
                0x1902, 0x1906, 0x190b, 0x1912, 0x1916,
                0x191b, 0x191d, 0x191e, 0x1921, 0x1923,
                0x1926, 0x1927, 0x192b, 0x192d, 0x1932,
                0x193a, 0x193b,
                // Kaby Lake
                0x5902, 0x5912, 0x5916, 0x5917, 0x591b,
                0x591c, 0x591d, 0x591e, 0x5923, 0x5926,
                0x5927, 0x87c0
            }, MEQ, Local0, MTR, 0, 0))
            {
                _UID = 16
            }

            // assume Coffee Lake and newer
            Else
            {
                _UID = 19
            }
        }
    }
}
