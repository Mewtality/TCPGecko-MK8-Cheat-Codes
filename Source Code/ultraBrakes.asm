/*
* File: ultraBrakes.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func ultraBrakes
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r12, 0x4 (r3)

		lwz r0, 0xFC (r12)
		rlwinm. r0, r0, 0, 30, 30
		beq _end

		lwz r12, 0x14 (r12)
		lwz r5, 0x2E8 (r12)
		cmpwi r5, false
		ble _end

		mr r3, r12
		getf f1, _rodata + 0x20B64
		call "object::KartVehicleMove::setSpeed()"

_end:
		stack.restore
	.endfunc