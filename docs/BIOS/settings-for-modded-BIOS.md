The following are further optimization settings that can be figured once your BIOS is modded.

* These settings are universally recommended optimizations for your hackintosh:

``` mermaid
graph TD
    id1[Advance Tab]-->id2[Intel Advanced Menu];
    id2-->id3[System Agent Configuration];
    id2-->id4[Power & Performance];
    id3-->id5[Graphics Configuration];
    id4-->id6[CPU - Power Management Control];
    id5-->|DVMT Pre-Allocated|64M;
    id6-->id7[CPU Lock Configuration];
    id7-->|CFG Lock|Disabled;
```

* I also recommend undervolting your machine regarless of your usage, the following are stable settings for my x1c6 with `i7-8650U`, verified by stress testing with `Prime95` and `Heaven Benchmark`, your may be worse or better, please do your own testing. In addition, I suggest you repaste your machine with an aftermarket thermal paste for lower temps and a better undervolt.

``` mermaid
graph TD
    id1[Advance Tab]-->id2[Intel Advanced Menu];
    id2-->id3[OverClocking Performance Menu];
    id3-->|OverClocking Feature|Enabled;
    id3-->Processor;
    id3-->GT;
    id3-->Uncore;
    Processor-->|Voltage Offset|100;
    Processor-->|Offset Prefix|id4[-];
    GT-->|GT Voltage Offset|id8[80];
    GT-->|Offset Prefix|id5[-];
    GT-->|GTU Voltage Offset|id8;
    GT-->|Offset Prefix|id5;
    Uncore-->|Uncore Voltage Offset|80;
    Uncore-->|Offset Prefix|id6[-];
```

* The following settings depend on your own personal preference:

 * If you want to optimize CPU **performance** at the cost of battery:

``` mermaid
graph LR
    id1[Advance Tab]-->id2[Power & Performance];
    id2-->id3[CPU - Power Management Control];
    id3-->|Boot Performance Mode|id4[Turbo Performance];
    id3-->|Config TDP Configurations|Up;
```

 * If you want to optimize **battery time** at the cost of performance:

``` mermaid
graph LR
    id1[Advance Tab]-->id2[Power & Performance];
    id2-->id3[CPU - Power Management Control];
    id3-->|Boot Performance Mode|id4[Max Battery];
    id3-->|Config TDP Configurations|Down;
```
