AppleIntelInfo.kext v1.4 Copyright © 2012-2015 Pike R. Alpha. All rights reserved

Settings:
------------------------------------
logMSRs............................: 1
logIGPU............................: 1
logIntelRegs.......................: 1
logCStates.........................: 1
logIPGStyle........................: 1
InitialTSC.........................: 0x256c527082a
MWAIT C-States.....................: 286531872

Model Specific Regiters
------------------------------------
MSR_CORE_THREAD_COUNT......(0x35)  : 0x40008
MSR_PLATFORM_INFO..........(0xCE)  : 0x804043DF1011500
MSR_PMG_CST_CONFIG_CONTROL.(0xE2)  : 0x1E008008
MSR_PMG_IO_CAPTURE_BASE....(0xE4)  : 0x51814
IA32_MPERF.................(0xE7)  : 0x8B24D66381
IA32_APERF.................(0xE8)  : 0x93B224C490
MSR_FLEX_RATIO.............(0x194) : 0x0
MSR_IA32_PERF_STATUS.......(0x198) : 0x26D900002700
MSR_IA32_PERF_CONTROL......(0x199) : 0xA00
IA32_CLOCK_MODULATION......(0x19A) : 0x0
IA32_THERM_STATUS..........(0x19C) : 0x882E2800
IA32_MISC_ENABLES..........(0x1A0) : 0x850089
MSR_MISC_PWR_MGMT..........(0x1AA) : 0x401CC1
MSR_TURBO_RATIO_LIMIT......(0x1AD) : 0x27272A2A
IA32_ENERGY_PERF_BIAS......(0x1B0) : 0x5
MSR_POWER_CTL..............(0x1FC) : 0x24005F
MSR_RAPL_POWER_UNIT........(0x606) : 0xA0E03
MSR_PKG_POWER_LIMIT........(0x610) : 0x42816000DD80C8
MSR_PKG_ENERGY_STATUS......(0x611) : 0x59D8A0F
MSR_PKG_POWER_INFO.........(0x614) : 0x78
MSR_PP0_CURRENT_CONFIG.....(0x601) : 0x80000238
MSR_PP0_POWER_LIMIT........(0x638) : 0x0
MSR_PP0_ENERGY_STATUS......(0x639) : 0x340EE53
MSR_PP0_POLICY.............(0x63a) : 0x0
MSR_PKGC6_IRTL.............(0x60b) : 0x8876
MSR_PKG_C2_RESIDENCY.......(0x60d) : 0x5BE265529A
MSR_PKG_C3_RESIDENCY.......(0x3f8) : 0xF61793363A
MSR_PKG_C6_RESIDENCY.......(0x3f9) : 0x0
IA32_TSC_DEADLINE..........(0x6E0) : 0x256C6D05AA6
PCH device.................: 0x9D4E8086

Intel Register Data
------------------------------------
CPU_VGACNTRL...............: 0x5A798D4A
IS_ELSE(devid)
DCC........................: 0x8e6bb291 ()
CHDECMISC..................: 0xb32a4d59 (swap bank, ch2 enh enabled, ch1 enh enabled, ch0 enh disabled, flex disabled, ep present)
C0DRB0.....................: 0x8e6bb291 (0xb291)
C0DRB1.....................: 0xf6b88e6b (0x8e6b)
C0DRB2.....................: 0x7479f6b8 (0xf6b8)
C0DRB3.....................: 0x92957479 (0x7479)
C1DRB0.....................: 0x17158bc2 (0x8bc2)
C1DRB1.....................: 0x38561715 (0x1715)
C1DRB2.....................: 0xb3dd3856 (0x3856)
C1DRB3.....................: 0x8bc0b3dd (0xb3dd)
C0DRA01....................: 0x2f6b9295 (0x9295)
C0DRA23....................: 0xf6bc2f6b (0x2f6b)
C1DRA01....................: 0x17178bc0 (0x8bc0)
C1DRA23....................: 0x38541717 (0x1717)
PGETBL_CTL.................: 0xdb7dcfc9
VCLK_DIVISOR_VGA0..........: 0xc5c987e8 (n = 9, m1 = 7, m2 = 40)
VCLK_DIVISOR_VGA1..........: 0x79c6a5f0 (n = 6, m1 = 37, m2 = 48)
VCLK_POST_DIV..............: 0x87eec7ca (vga0 p1 = 12, p2 = 4, vga1 p1 = 9, p2 = 4)
DPLL_TEST..................: 0xe07fbd0b (, DPLLA N bypassed, DPLLB N bypassed, DPLLB M bypassed)
CACHE_MODE_0...............: 0x0c295749
D_STATE....................: 0xfc76382d
DSPCLK_GATE_D..............: 0x2a49e0a4 (clock gates disabled: VSUNIT VRDUNIT DPUNIT_A TVCUNIT DVSUNIT DPRUNIT DPFUNIT DPBMUNIT DPLSUNIT VRUNIT OVFUNIT OVCUNIT)
RENCLK_GATE_D1.............: 0xa0ae47e5
RENCLK_GATE_D2.............: 0x6e4be2a6
SDVOB......................: 0x7f8e34e4 (disabled, pipe B, stall enabled, detected)
SDVOC......................: 0x7a8611ec (disabled, pipe B, stall enabled, detected)
SDVOUDI....................: 0x7fa614ec
DSPARB.....................: 0x76c8c355
FW_BLC.....................: 0x3d1fc886
FW_BLC2....................: 0x472686fd
FW_BLC_SELF................: 0x3c1b8886
DSPFW1.....................: 0x0cf7cd2e
DSPFW2.....................: 0x76c8c355
DSPFW3.....................: 0x0cf7cd2e
ADPA.......................: 0x0c13eb5a (disabled, pipe A, +hsync, +vsync)
LVDS.......................: 0xa8120549 (enabled, pipe A, 18 bit, 1 channel)
DVOA.......................: 0x0e77e97e (disabled, pipe A, no stall, +hsync, +vsync)
DVOB.......................: 0x7f8e34e4 (disabled, pipe B, unknown stall, -hsync, -vsync)
DVOC.......................: 0x7a8611ec (disabled, pipe B, unknown stall, +hsync, -vsync)
DVOA_SRCDIM................: 0xc9a79cfb
DVOB_SRCDIM................: 0x1d673b13
DVOC_SRCDIM................: 0x187f2e1b
BLC_PWM_CTL................: 0x19e45d94
BLC_PWM_CTL2...............: 0x8ca0ad98
PP_CONTROL.................: 0x74dd6694 (power target: off)
PP_STATUS..................: 0xf85b0794 (on, ready, sequencing unknown)
PP_ON_DELAYS...............: 0xd85e2795
PP_OFF_DELAYS..............: 0x55d8c695
PP_DIVISOR.................: 0xd94a27c5
PFIT_CONTROL...............: 0xfc0203cd
PFIT_PGM_RATIOS............: 0x7180eaec
PORT_HOTPLUG_EN............: 0x0c37eb3e
PORT_HOTPLUG_STAT..........: 0xcbe79e9b
DSPACNTR...................: 0x78c9a6b2 (disabled, pipe A)
DSPASTRIDE.................: 0x584d8634 (1481475636 bytes)
DSPAPOS....................: 0x2bc5582b (22571, 11205)
DSPASIZE...................: 0x58dd86b4 (34485, 22750)
DSPABASE...................: 0x0bc1386f
DSPASURF...................: 0x2ac5582b
DSPATILEOFF................: 0x2ac5592b
PIPEACONF..................: 0x9e7963e4 (enabled, single-wide)
PIPEASRC...................: 0x8e389014 (36409, 36885)
PIPEASTAT..................: 0xacd66d0f (status: FIFO_UNDERRUN CRC_ERROR_ENABLE GMBUS_EVENT_ENABLE DPST_EVENT_ENABLE LBLC_EVENT_ENABLE EFIELD_INT_ENABLE SVBLANK_INT_ENABLE VBLANK_INT_ENABLE CRC_ERROR_INT_STATUS GMBUS_INT_STATUS DLINE_COMPARE_STATUS SVBLANPIPEA_GMCH_DATA_M..........: 0x39ec630a
PIPEA_GMCH_DATA_N..........: 0xcbb0f5b7
PIPEA_DP_LINK_M............: 0x316c6b8a
PIPEA_DP_LINK_N............: 0xc7305d37
CURSOR_A_BASE..............: 0x7b9305a5
CURSOR_A_CONTROL...........: 0xc79d85bd
CURSOR_A_POSITION..........: 0xc79d85bd
FPA0.......................: 0x0bc1ecc8 (n = 1, m1 = 44, m2 = 8)
FPA1.......................: 0xcc919945 (n = 17, m1 = 25, m2 = 5)
DPLL_A.....................: 0x39f465d2 (disabled, non-dvo, unknown clock, LVDS mode, p1 = 3, p2 = 7, using FPx1!)
DPLL_A_MD..................: 0x39644552
HTOTAL_A...................: 0x960f584c (22605 active, 38416 total)
HBLANK_A...................: 0x8f289006 (36871 start, 36649 end)
HSYNC_A....................: 0x960d484e (18511 start, 38414 end)
VTOTAL_A...................: 0x8f2a9004 (36869 active, 36651 total)
VBLANK_A...................: 0x961958de (22751 start, 38426 end)
VSYNC_A....................: 0x8f3a9014 (36885 start, 36667 end)
BCLRPAT_A..................: 0x9f1d515e
VSYNCSHIFT_A...............: 0x9f1f515c
DSPBCNTR...................: 0xd981fab9 (enabled, pipe B)
DSPBSTRIDE.................: 0xf985d8b9 (-108668743 bytes)
DSPBPOS....................: 0x68c50835 (2101, 26821)
DSPBSIZE...................: 0xf9a1d8d9 (55514, 63906)
DSPBBASE...................: 0x4cc42855
DSPBSURF...................: 0x6de51915
DSPBTILEOFF................: 0x6de50955
PIPEBCONF..................: 0xa07d42eb (enabled, single-wide)
PIPEBSRC...................: 0xd8924ec1 (55443, 20162)
PIPEBSTAT..................: 0x2371bfe4 (status: CRC_ERROR_ENABLE VSYNC_INT_ENABLE DLINE_COMPARE_ENABLE LBLC_EVENT_ENABLE OFIELD_INT_ENABLE EFIELD_INT_ENABLE OREG_UPDATE_ENABLE CRC_ERROR_INT_STATUS CRC_DONE_INT_STATUS GMBUS_INT_STATUS VSYNC_INT_STATUS DLIPIPEB_GMCH_DATA_M..........: 0x4befa41a
PIPEB_GMCH_DATA_N..........: 0xac4253cf
PIPEB_DP_LINK_M............: 0x4eefa51a
PIPEB_DP_LINK_N............: 0xad4256cf
CURSOR_B_BASE..............: 0x354658fc
CURSOR_B_CONTROL...........: 0xdadc1f8d
CURSOR_B_POSITION..........: 0xdbd65fcf
FPB0.......................: 0x2fc5cccc (n = 5, m1 = 12, m2 = 12)
FPB1.......................: 0xec15b969 (n = 21, m1 = 57, m2 = 41)
DPLL_B.....................: 0x856a874a (enabled, non-dvo, VGA, default clock, DAC/serial mode, p1 = 2, p2 = 5, using FPx1!)
DPLL_B_MD..................: 0x876ac54a
HTOTAL_B...................: 0xe36ea3f0 (41969 active, 58223 total)
HBLANK_B...................: 0xc8b14c63 (19556 start, 51378 end)
HSYNC_B....................: 0xb37cb3f2 (46067 start, 45949 end)
VTOTAL_B...................: 0xd8b24ce1 (19682 active, 55475 total)
VBLANK_B...................: 0xf35cb382 (45955 start, 62301 end)
VSYNC_B....................: 0xd8924cc1 (19650 start, 55443 end)
BCLRPAT_B..................: 0xb75c37d2
VSYNCSHIFT_B...............: 0xb71eb790
VCLK_DIVISOR_VGA0..........: 0xc5c987e8
VCLK_DIVISOR_VGA1..........: 0x79c6a5f0
VCLK_POST_DIV..............: 0x87eec7ca
VGACNTRL...................: 0x642589d2 (enabled)
TV_CTL.....................: 0x39bd12d7
TV_DAC.....................: 0x5f446d09
TV_CSC_Y...................: 0x391c52f6
TV_CSC_Y2..................: 0x5b656d01
TV_CSC_U...................: 0x391c5276
TV_CSC_U2..................: 0x5be56d81
TV_CSC_V...................: 0x391c5276
TV_CSC_V2..................: 0x5be56d81
TV_CLR_KNOBS...............: 0x29184272
TV_CLR_LEVEL...............: 0x4be17d85
TV_H_CTL_1.................: 0x2912427a
TV_H_CTL_2.................: 0x4be97d8d
TV_H_CTL_3.................: 0x2950421a
TV_V_CTL_1.................: 0x4b28f9cd
TV_V_CTL_2.................: 0xc6f1e7c9
TV_V_CTL_3.................: 0x53b5b6c5
TV_V_CTL_4.................: 0xc6f3e7cb
TV_V_CTL_5.................: 0x53b73747
TV_V_CTL_6.................: 0xc6e3e7db
TV_V_CTL_7.................: 0x53a73757
TV_SC_CTL_1................: 0xc3e3e2db
TV_SC_CTL_2................: 0x56a73257
TV_SC_CTL_3................: 0xc3e3e2db
TV_WIN_POS.................: 0xc3e3e2db
TV_WIN_SIZE................: 0x56a7a057
TV_FILTER_CTL_1............: 0x32ee9fb5
TV_FILTER_CTL_2............: 0x0283056b
TV_FILTER_CTL_3............: 0x52eebfb5
TV_CC_CONTROL..............: 0x52ceff97
TV_CC_DATA.................: 0x63a3654b
TV_H_LUMA_0................: 0x2e578bf0
TV_H_LUMA_59...............: 0x117c2ac0
TV_H_CHROMA_0..............: 0xe86068ee
TV_H_CHROMA_59.............: 0x5b95b2fd
FBC_CFB_BASE...............: 0xe9f60eff
FBC_LL_BASE................: 0x2e267b5a
FBC_CONTROL................: 0xe9f70efe
FBC_COMMAND................: 0x2e277b5b
FBC_STATUS.................: 0xa9d74ede
FBC_CONTROL2...............: 0x6e073b7b
FBC_FENCE_OFF..............: 0x07397ba1
FBC_MOD_NUM................: 0x29d74cde
MI_MODE....................: 0x198c06a2
MI_ARB_STATE...............: 0x472486fd
MI_RDRET_STATE.............: 0x562697ff
ECOSKPD....................: 0xe464cda0
DP_B.......................: 0x6feb9858
DPB_AUX_CH_CTL.............: 0x6ff998ca
DPB_AUX_CH_DATA1...........: 0xc206fbba
DPB_AUX_CH_DATA2...........: 0x6fb9988a
DPB_AUX_CH_DATA3...........: 0xc2467bfa
DPB_AUX_CH_DATA4...........: 0x67b9908a
DPB_AUX_CH_DATA5...........: 0xca46f3fa
DP_C.......................: 0x469699ef
DPC_AUX_CH_CTL.............: 0x679ab9e3
DPC_AUX_CH_DATA1...........: 0x9492677c
DPC_AUX_CH_DATA2...........: 0x27dabba2
DPC_AUX_CH_DATA3...........: 0x1492647c
DPC_AUX_CH_DATA4...........: 0xe3dab9a1
DPC_AUX_CH_DATA5...........: 0x1492773c
DP_D.......................: 0x91ef15de
DPD_AUX_CH_CTL.............: 0x81ef15fe
DPD_AUX_CH_DATA1...........: 0x6f7522cf
DPD_AUX_CH_DATA2...........: 0x81ff07be
DPD_AUX_CH_DATA3...........: 0x6f7522cf
DPD_AUX_CH_DATA4...........: 0x83ef07fe
DPD_AUX_CH_DATA5...........: 0x6c75204f
AUD_CONFIG.................: 0x91a75d48
AUD_HDMIW_STATUS...........: 0x83a22fbf
AUD_CONV_CHCNT.............: 0x8078f986
VIDEO_DIP_CTL..............: 0x3a8451ae
AUD_PINW_CNTR..............: 0x11d5115b
AUD_CNTL_ST................: 0x6a1bfe48
AUD_PIN_CAP................: 0xea096a52
AUD_PINW_CAP...............: 0x81878149
AUD_PINW_UNSOLRESP.........: 0x115511db
AUD_OUT_DIG_CNVT...........: 0x4573ab72
AUD_OUT_CWCAP..............: 0x50caf98e
AUD_GRP_CAP................: 0x729b5b9f
FENCE  0...................: 0x5b374b83 (enabled, X tiled,  512 pitch, 0x0b300000 - 0x0bb00000 (8192kb))
FENCE  1...................: 0x5ad4b245 (enabled, Y tiled, 2048 pitch, 0x0ad00000 - 0x0b100000 (4096kb))
FENCE  2...................: 0x5a344b81 (enabled, X tiled,  512 pitch, 0x0a300000 - 0x0ab00000 (8192kb))
FENCE  3...................: 0x52d4b247 (enabled, Y tiled, 2048 pitch, 0x02d00000 - 0x03100000 (4096kb))
FENCE  4...................: 0xda3dcb89 (enabled, X tiled,  512 pitch, 0x0a300000 - 0x0ab00000 (8192kb))
FENCE  5...................: 0xd3dc324f (enabled, Y tiled, 2048 pitch, 0x03d00000 - 0x04100000 (4096kb))
FENCE  6...................: 0xdb7dcbc9 (enabled, X tiled, 8192 pitch, 0x0b700000 - 0x0bf00000 (8192kb))
FENCE  7...................: 0xda8c320f (enabled, Y tiled,  128 pitch, 0x0a800000 - 0x0ac00000 (4096kb))
FENCE  8...................: 0xe6e78471 (enabled, X tiled, 65536 pitch, 0x06e00000 - 0x07e00000 (16384kb))
FENCE  9...................: 0xa46138f6 (disabled)
FENCE  10..................: 0xf6e394f7 (enabled, Y tiled, 16384 pitch, 0x06e00000 - 0x07e00000 (16384kb))
FENCE  11..................: 0xb46728b2 (disabled)
FENCE  12..................: 0xb6f3d525 (enabled, Y tiled,  512 pitch, 0x06f00000 - 0x08f00000 (32768kb))
FENCE  13..................: 0xf47768e2 (disabled)
FENCE  14..................: 0xb7f3d465 (enabled, Y tiled, 8192 pitch, 0x07f00000 - 0x08f00000 (16384kb))
FENCE  15..................: 0xf53769e2 (disabled)
FENCE START 0..............: 0xe6e78471 ()
FENCE END 0................: 0xa46138f6 ()
FENCE START 1..............: 0xf6e394f7 ()
FENCE END 1................: 0xb46728b2 ()
FENCE START 2..............: 0xb6f3d525 ()
FENCE END 2................: 0xf47768e2 ()
FENCE START 3..............: 0xb7f3d465 ()
FENCE END 3................: 0xf53769e2 ()
FENCE START 4..............: 0xb7f3d465 ()
FENCE END 4................: 0xf53569ea ()
FENCE START 5..............: 0xb7f3d425 ()
FENCE END 5................: 0xf57769e2 ()
FENCE START 6..............: 0xb3fbd46d ()
FENCE END 6................: 0x757f69aa ()
FENCE START 7..............: 0x36fbd56d ()
FENCE END 7................: 0xb47f6cea ()
FENCE START 8..............: 0x972378d6 ()
FENCE END 8................: 0x608e8f03 ()
FENCE START 9..............: 0x83276892 ()
FENCE END 9................: 0x608b9b07 ()
FENCE START 10.............: 0xa637ea82 ()
FENCE END 10...............: 0xe09a0b17 ()
FENCE START 11.............: 0x0637e982 ()
FENCE END 11...............: 0xe19a1e13 ()
FENCE START 12.............: 0x0437ebc2 ()
FENCE END 12...............: 0xe29a1c17 ()
FENCE START 13.............: 0x0437eb80 ()
FENCE END 13...............: 0xe19a1c17 ()
FENCE START 14.............: 0x0417ebe2 ()
FENCE END 14...............: 0x72fa1e37 ()
FENCE START 15.............: 0x241769e2 ()
FENCE END 15...............: 0xe3ba1c37 ()
INST_PM....................: 0x1d90a80f
p1 out of range
fp select out of range
pipe A dot 571428 n 1 m1 44 m2 8 p1 1 p2 14
p1 out of range
fp select out of range
pipe B dot 230400 n 5 m1 12 m2 12 p1 1 p2 5

CPU Ratio Info:
------------------------------------
CPU Low Frequency Mode.............: 400 MHz
CPU Maximum non-Turbo Frequency....: 2100 MHz
CPU Maximum Turbo Frequency........: 4200 MHz

IGPU Info:
------------------------------------
IGPU Current Frequency.............:    0 MHz
IGPU Minimum Frequency.............:  300 MHz
IGPU Maximum Non-Turbo Frequency...:  300 MHz
IGPU Maximum Turbo Frequency.......: 1150 MHz
IGPU Maximum limit.................: No Limit

CPU P-States [ (20) 22 39 ] iGPU P-States [ ]
CPU C3-Cores [ 0 1 6 7 ]
CPU P-States [ (8) 13 20 22 39 ] iGPU P-States [ ]
CPU C3-Cores [ 0 1 2 3 6 7 ]
CPU P-States [ 8 11 13 20 22 (23) 39 ] iGPU P-States [ ]
CPU C3-Cores [ 0 1 2 3 5 6 7 ]
CPU P-States [ (8) 11 13 19 20 22 23 39 ] iGPU P-States [ ]
CPU P-States [ (8) 11 13 14 19 20 22 23 39 ] iGPU P-States [ ]
CPU C3-Cores [ 0 1 2 3 4 5 6 7 ]
CPU P-States [ (8) 11 13 14 16 19 20 22 23 39 ] iGPU P-States [ ]
CPU P-States [ (8) 11 13 14 16 19 20 21 22 23 39 ] iGPU P-States [ ]
CPU P-States [ 8 11 12 13 14 16 19 20 21 22 23 (25) 39 ] iGPU P-States [ ]
CPU P-States [ 8 11 12 13 14 15 16 19 (20) 21 22 23 25 39 ] iGPU P-States [ ]
CPU P-States [ (8) 11 12 13 14 15 16 18 19 20 21 22 23 25 39 ] iGPU P-States [ ]
CPU P-States [ (8) 11 12 13 14 15 16 18 19 20 21 22 23 24 25 39 ] iGPU P-States [ ]
CPU P-States [ (8) 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 39 ] iGPU P-States [ ]
CPU P-States [ 8 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 (30) 39 ] iGPU P-States [ ]
CPU P-States [ 8 11 12 13 14 15 16 17 18 19 20 21 22 23 24 (25) 26 30 39 ] iGPU P-States [ (30) ]
CPU P-States [ 8 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 30 (35) 39 ] iGPU P-States [ (30) ]
CPU P-States [ 8 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 (28) 30 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ (8) 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 30 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 30 (32) 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 30 (31) 32 35 39 ] iGPU P-States [ (30) ]
CPU P-States [ 8 9 11 12 13 14 15 16 17 18 19 (20) 21 22 23 24 25 26 28 30 31 32 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 8 9 11 12 13 14 15 16 17 18 19 (20) 21 22 23 24 25 26 28 30 31 32 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ (7) 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 30 31 32 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 (27) 28 30 31 32 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 (8) 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 35 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 35 (38) 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 (33) 35 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 33 35 (36) 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 33 (34) 35 36 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 33 34 (35) 36 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 (29) 30 31 32 33 34 35 36 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ (4) 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 4 7 (8) 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 38 39 ] iGPU P-States [ 30 ]
CPU P-States [ 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 (35) 36 38 39 ] iGPU P-States [ (27) 30 ]
CPU P-States [ 4 (6) 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 38 39 ] iGPU P-States [ 27 30 ]
CPU P-States [ 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 (31) 32 33 34 35 36 38 39 ] iGPU P-States [ 27 30 ]
CPU P-States [ 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 (31) 32 33 34 35 36 38 39 ] iGPU P-States [ 27 30 ]
CPU P-States [ 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 (37) 38 39 ] iGPU P-States [ 27 30 ]

