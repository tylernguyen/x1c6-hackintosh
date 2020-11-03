/*
 * Depends on /patches/Debug Patches/ Debug.plist
 */

DefinitionBlock ("", "SSDT", 2, "tyler", "_HOOKS", 0x00001000)
{
    External (_SB.PCI0.LPCB.EC, DeviceObj)

    // EC Events
    External (_SB.PCI0.LPCB.EC.XQ1C, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ1D, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ1F, MethodObj) // Keyboard Backlight Event
    External (_SB.PCI0.LPCB.EC.XQ2A, MethodObj) // LID Open Event
    External (_SB.PCI0.LPCB.EC.XQ2B, MethodObj) // LID Close Event
    External (_SB.PCI0.LPCB.EC.XQ2C, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ2D, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ2F, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ3B, MethodObj) // Wifi ???
    External (_SB.PCI0.LPCB.EC.XQ3D, MethodObj) // Empty
    External (_SB.PCI0.LPCB.EC.XQ3F, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ4A, MethodObj) // Battery Attach/Detach Event
    External (_SB.PCI0.LPCB.EC.XQ4B, MethodObj) // Battery State Change Event
    External (_SB.PCI0.LPCB.EC.XQ4E, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ4F, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ6A, MethodObj) // KBD MicMute Event (F4)
    External (_SB.PCI0.LPCB.EC.XQ7F, MethodObj) // "Fatal()" ?
    External (_SB.PCI0.LPCB.EC.XQ13, MethodObj) // KBD Sleepbutton Event (FN+4)
    External (_SB.PCI0.LPCB.EC.XQ14, MethodObj) // KBD Brightness up Event (F6)
    External (_SB.PCI0.LPCB.EC.XQ15, MethodObj) // KBD Brightness down Event (F5)
    External (_SB.PCI0.LPCB.EC.XQ16, MethodObj) // Next display Event (F7)
    External (_SB.PCI0.LPCB.EC.XQ19, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ22, MethodObj) // Battery at critical low state Event
    External (_SB.PCI0.LPCB.EC.XQ24, MethodObj) // Battery
    External (_SB.PCI0.LPCB.EC.XQ26, MethodObj) // AC Power Connected
    External (_SB.PCI0.LPCB.EC.XQ27, MethodObj) // AC Power Removed
    External (_SB.PCI0.LPCB.EC.XQ38, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ40, MethodObj) // Thermal/DYTC ???
    External (_SB.PCI0.LPCB.EC.XQ41, MethodObj) // Global Wireless Disable/Enable Event ?
    External (_SB.PCI0.LPCB.EC.XQ43, MethodObj) // KBD Audio Mute Event (F1)
    External (_SB.PCI0.LPCB.EC.XQ45, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ46, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ48, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ49, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ60, MethodObj) // KBD Bluetooth Event (F10)
    External (_SB.PCI0.LPCB.EC.XQ61, MethodObj) // KBD Keyboard Event (F11)
    External (_SB.PCI0.LPCB.EC.XQ62, MethodObj) // KBD Star Event (F12)
    External (_SB.PCI0.LPCB.EC.XQ63, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ64, MethodObj) // KBD Wifi Event (F8)
    External (_SB.PCI0.LPCB.EC.XQ65, MethodObj) // ???
    External (_SB.PCI0.LPCB.EC.XQ66, MethodObj) // KBD Settings Event (F9)
    External (_SB.PCI0.LPCB.EC.XQ70, MethodObj) // Fan ???
    External (_SB.PCI0.LPCB.EC.XQ72, MethodObj) // Fan ???
    External (_SB.PCI0.LPCB.EC.XQ73, MethodObj) // Fan ???
    External (_SB.PCI0.LPCB.EC.XQ74, MethodObj) // KBD FNLock Event

    // GPE Events (General Purpose)
    External (_GPE.XL17, MethodObj) // ???
    External (_GPE.XL27, MethodObj) // ???
    External (_GPE.XL61, MethodObj) // ???
    External (_GPE.XL62, MethodObj) // ???
    External (_GPE.XL66, MethodObj) // ???
    External (_GPE.XL69, MethodObj) // ???
    // External (_GPE.XL6D, MethodObj) // ???
    External (_GPE.XL6F, MethodObj) // Thunderbolt HotPlug


    Scope (\_SB.PCI0.LPCB.EC)
    {
        // MHKK
        Method (_Q1C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q1C (???)"

            XQ1C()
        }

        // ???
        Method (_Q1D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q1D (???)"

            XQ1D()
        }

        // Keyboard Backlight Event
        Method (_Q1F, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q1F (Keyboard Backlight Event)"

            XQ1F()
        }

        // LID Open Event
        Method (_Q2A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q2A (LID Open Event)"

            XQ2A()
        }

        // LID Close Event
        Method (_Q2B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q2B (LID Close Event)"

            XQ2B()
        }

        // ???
        Method (_Q2C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q2C (???)"

            XQ2C()
        }

        // ???
        Method (_Q2D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q2D (???)"

            XQ2D()
        }

        // ???
        Method (_Q2F, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q2F (???)"

            XQ2F()
        }

        // Wifi ???
        Method (_Q3B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q3B (Wifi ???)"

            XQ3B()
        }

        // Empty???
        Method (_Q3D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q3D (Empty???)"

            XQ3D()
        }

        // ???
        Method (_Q3F, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q3F (???)"

            XQ3F()
        }

        // Battery Attach/Detach Event
        Method (_Q4A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q4A (Battery Attach/Detach Event)"

            XQ4A()
        }

        // Battery State Change Event
        Method (_Q4B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q4B (Battery State Change Event)"

            XQ4B()
        }

        // ???
        Method (_Q4E, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q4E (???)"

            XQ4E()
        }

        // ???
        Method (_Q4F, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q4F (???)"

            XQ4F()
        }

        // KBD MicMute Event (F4)
        Method (_Q6A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q6A (KBD MicMute Event - F4)"

            XQ6A()
        }

        // "Fatal()" ?
        Method (_Q7F, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q7F (FATAL())"

            XQ7F()
        }

        // KBD Sleepbutton Event (FN+4)
        Method (_Q13, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q13 (KBD Sleepbutton Event - FN+4)"

            XQ13()
        }

        // KBD Brightness up Event (F4)
        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q14 (KBD Brightness up Event - F4)"

            XQ14()
        }

        // KBD Brightness down Event (F5)
        Method (_Q15, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q15 (KBD Brightness down Event - F5)"

            XQ15()
        }

        // KBD Next display Event
        Method (_Q16, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q16 (Next display Event)"

            XQ16()
        }

        // ???
        Method (_Q19, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q19 (???)"

            XQ19()
        }

        // Battery at critical low state Event
        Method (_Q22, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q22 (Battery at critical low state Event)"

            XQ22()
        }

        // Battery
        Method (_Q24, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q24 (Battery)"

            XQ24()
        }

        // AC Power Connected Event
        Method (_Q26, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q26 (AC Power Connected Event)"

            XQ26()
        }

        // AC Power Removed Event
        Method (_Q27, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q27 (AC Power Removed Event)"

            XQ27()
        }

        // ???
        Method (_Q38, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q38 (???)"

            XQ38()
        }

        // Thermal/DYTC ???
        Method (_Q40, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q40 (Thermal/DYTC???)"

            XQ40()
        }

        // ???
        Method (_Q41, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q41 (???)"

            XQ41()
        }

        // KBD Audio Mute Event (F1)
        Method (_Q43, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q43 (KBD Audio Mute Event - F1)"

            XQ43()
        }

        // ???
        Method (_Q45, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q45 (???)"

            XQ45()
        }

        // ???
        Method (_Q46, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q46 (???)"

            XQ46()
        }

        // ???
        Method (_Q48, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q48 (???)"

            XQ48()
        }

        // ???
        Method (_Q49, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q49 (???)"

            XQ49()
        }

        // ???
        Method (_Q60, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q60 (???)"

            XQ60()
        }

        // ???
        Method (_Q61, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q61 (???)"

            XQ61()
        }

        // ???
        Method (_Q62, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q62 (???)"

            XQ62()
        }

        // ???
        Method (_Q63, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q63 (???)"

            XQ63()
        }

        // ???
        Method (_Q64, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q64 (???)"

            XQ64()
        }

        // ???
        Method (_Q65, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q65 (???)"

            XQ65()
        }

        // ???
        Method (_Q66, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q66 (???)"

            XQ66()
        }

        // Fan???
        Method (_Q70, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q70 (Fan???)"

            XQ70()
        }

        // Fan ???
        Method (_Q72, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q72 (Fan???)"

            XQ72()
        }

        // Fan ???
        Method (_Q73, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q73 (Fan???)"

            XQ73()
        }

        // Keyboard FNLock Event
        Method (_Q74, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Debug = "HOOKS: EC:_Q74 (Keyboard FNLock Event)"

            XQ73()
        }
    }


    Scope (_GPE)
    {
        Method (_L17, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            Debug = "HOOKS: _L17() start"
            
            XL17()
        }

        Method (_L27, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            Debug = "HOOKS: _L27() start"
            
            XL27()
        }

        Method (_L61, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        {
            Debug = "HOOKS: _L61()"
            
            XL61()
        }


        Method (_L62, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        {
            Debug = "HOOKS: _L62()"
            
            XL62()
        }

        Method (_L66, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        {
            Debug = "HOOKS: _L66() start (iGPU)"
            
            XL66()
        }

        // PCI Wake
        Method (_L69, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        {
            Debug = "HOOKS: _L69() start (PCI)"

            XL69()
        }

        // Device Wake - already hooked
        // Method (_L6D, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        // {
        //     Debug = "HOOKS: _L6D() (Device wake"

        //     XL6D()
        // }

        // TB HotPlug
        Method (_L6F, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
        {
            Debug = "HOOKS: _L6F() (TB HotPlug)"

            XL6F()
        }
    }
}