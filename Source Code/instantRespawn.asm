/*
* File: instantRespawn.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func instantRespawn
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		load r3, "0x4, 0x4C, 0x14"

		lwz %a0, 0x34 (r3)
		stw %a0, 0x1C (r3)

		lwz %a0, 0x8C (r3) # object_KartJugemRecover_stateFinish
		stw %a0, 0x6C (r3) # object_KartJugemRecover_stateReplay

_end:
		stack.restore
	.endfunc