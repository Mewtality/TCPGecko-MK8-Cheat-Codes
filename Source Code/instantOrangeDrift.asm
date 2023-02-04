/*
* File: instantOrangeDrift.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func instantOrangeDrift
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart

		load r3, "0x4, 0x14"
		getf f1, _rodata + 0xC4
		call "object::KartVehicleMove::forceSetMiniTurboCounter()"

_end:
		stack.restore
	.endfunc