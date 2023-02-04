/*
* File: instantAcceleration.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func instantAcceleration
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r12, 0x4 (r3)

		lwz r0, 0xFC (r12)
		clrlwi. r0, r0, 31
		beq _end

		load r12, "0x14"

		lfs f5, 0x2E8 (r12)
		lfs f6, 0x3B8 (r12)
		fcmpu cr0, f5, f6
		bgt _end

		mr r3, r12
		lfs f1, 0x3B8 (r12)
		call "object::KartVehicleMove::setSpeed()"

_end:
		stack.restore
	.endfunc