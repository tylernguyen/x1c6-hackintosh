/* 
 * Add PNLF device
 * For use with AppleBacklightSmoother.kext
 *
 * Credits @hieplpvip
 */

DefinitionBlock("", "SSDT", 2, "tyler", "_PNLF", 0)
{
    External(_SB.PCI0.GFX0, DeviceObj)
    // OS Is Darwin?
    External (OSDW, MethodObj)    // 0 Arguments

    // For backlight control
    Scope(_SB.PCI0.GFX0)
    {
        /**
         * The purpose of the PNLF-device is to make AppleBacklight load.
         *
         * But it is not enough to make backlight working. There is a mismatch in PWM MAX between macOS and our laptop, 
         * so we need to fix that, either by patching macOS (which AppleBacklightSmoother and WhateverGreen's CoffeeLake patch does) 
         * or set PWM MAX in hardware to match that of macOS (which the traditional SSDT-PNLF does). In addition, we also need to set 
         * UID to match profiles defined in WhateverGreen). But each platform needs a different value. If you look into SSDT-PNLF 
         * (both from this repo and WhateverGreen), you would see it contains device-id of various IGPU. They are used for 
         * automatically detecting platform and injecting corresponding value.
         *
         * SSDT-PNLF from WhateverGreen also set PWM MAX, but as I said before, it's not needed for AppleBacklightSmoother as 
         * it patches macOS to work with all PWM MAX.
         *
         * (@hieplpvip, https://github.com/hieplpvip/AppleBacklightSmoother/issues/2#issuecomment-703273278)
         */
        Device (PNLF)
        {
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID

            // _UID is set depending on device ID to match profiles in WhateverGreen
            //  0x0E - 14: Arrandale/Sandy/Ivy
            //  0x0F - 15: Haswell/Broadwell
            //  0x10 - 16: Skylake/KabyLake
            //  0x11 - 17: custom LMAX=0x7a1
            //  0x12 - 18: custom LMAX=0x1499
            //  0x13 - 19: CoffeeLake 0xffff
            Name (_UID, 0x10)  // _UID: Unique ID

            Method (_STA, 0, NotSerialized)
            {
                If (OSDW ())
                {
                    Return (0x0B)
                }

                Return (Zero)
            }
        }
    }
}
