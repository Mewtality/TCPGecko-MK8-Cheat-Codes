/*
* File: rocketBill.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func rocketBill
		stack.update 1
		push "r31"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)

		load r3, "0x14, 0x20C"
		call "object::KartInfoProxy::isKiller()"
		cmpwi r3, false
		beq _end

		mr r3, r31
		load r3, "0x8"
		get.kart.activator
		
		is.activator false, "_end", "DRC.A, DRC.Y"

		lwz r12, 0x14 (r31)
		lfs f5, 0x3B8 (r12)
		mr r3, r12

		getf f6, _rodata + 0xD4

		fmuls f1, f5, f6
		call "object::KartVehicleMove::setSpeed()"

_end:
		pop "r31"
		stack.restore
	.endfunc