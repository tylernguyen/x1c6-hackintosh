## Vanilla BIOS Settings

At the minimum, these BIOS settings must be made to install and run macOS without any problems:

``` mermaid
graph LR
    id1[Main Menu]-->Security;
    id1-->Config;
    id1-->Startup;
    Security-->TPM[Security Chip];
    Security-->Fingerprint;
    Security-->SBC[Secure Boot Configuration];
    Config-->Network;
    Startup-->|UEFI/Legacy Boot|id4[UEFI Only];
    Startup-->|CSM Support|No;
    TPM-->|Security Chip|id2[Disabled];
    Fingerprint-->|Predesktop Authentication|id2;
    SBC-->|Secure Boot|id2;
    Network-->|Wake on LAN|id3[Disabled];
    Network-->|Wake on LAN from Dock|id3;
    Network-->|UEFI IPv4 Network Stack|id3;
    Network-->|UEFI IPv6 Network Stack|id3;
```

!!! Tip
    You can also disable hardware/features you do not need to save power, some examples are:

``` mermaid
graph LR
    id1[Main Menu]-->Security;
    id1-->Config;
    Security-->id2[I/O Port Access];
    Config-->USB;
    id2-->|Wireless WAN|id3[Disabled];
    id2-->|Fingerprint Reader|id3;
    id2-->|Memory Card Slot|id3;
    USB-->|Always on USB|Disabled;
```

* If you **DO NOT use Thunderbolt 3 hotplug** in macOS (don't mind shutting down the machine to connect TB3 devices), this will drastically lower power consumption:

``` mermaid
graph LR
    id1[Main Menu]-->Config;
    Config-->id2[Thunderbolt 3];
    id2-->|Thunderbolt BIOS Assist Mode|Enabled;
    id2-->|Thunderbolt Device|Enabled;
```

* If you **DO use Thunderbolt 3 hotplug in macOS** (at the expense of idle power consumption):

``` mermaid
graph LR
    id1[Main Menu]-->Config;
    Config-->id2[Thunderbolt 3];
    id2-->|Thunderbolt BIOS Assist Mode|Disabled;
    id2-->|Security Level|id3[No Security];
    id2-->|Support in Pre Boot Environment: Thunderbolt Device|Disabled;
```
