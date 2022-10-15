/*
* File: ability2ChangeDriftDirection.asm
* Author: Mewtality
* Date: Saturday, October 15, 2022 @ 11:32:06 AM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func ability2ChangeDriftDirection
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz %a3, 0x4 (%a3)
		lfs f5, 0x104 (%a3)

		lis r12, _rodata + 0x20B64@h
		lfs f6, _rodata + 0x20B64@l (r12)

		dereference(null), 0x14, 0xEC

		fcmpu cr0, f5, f6
        beq _end

        stfs f5, 0x64 (r12)

_end:
		stackReset()
	.endfunc