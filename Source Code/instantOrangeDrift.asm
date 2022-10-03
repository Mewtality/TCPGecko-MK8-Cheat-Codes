/*
* File: instantOrangeDrift.asm
* Author: Mewtality
* Date: Monday, October 3, 2022 @ 09:00:58 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantOrangeDrift
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz %a3, 0x4 (%a3)
		lwz %a3, 0x14 (%a3)

		const = _rodata + 0xC4 # 1000 (float)
		lis r12, const@h
		lfs f1, const@l (r12)
		call("object::KartVehicleMove::forceSetMiniTurboCounter()")

_end:
		stackReset()
	.endfunc