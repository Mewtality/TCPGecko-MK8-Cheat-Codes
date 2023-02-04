/*
* File: turboAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func turboAtCommand
		stack.update 1
		push "r31"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)

		load r3, "0x14, 0x20C"
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r31)
		get.kart.activator

		is.activator false, "_end", "DRC.Y"

		lwz r3, 0x14 (r31)
		int r4, 0x8
		bool r5, true
		int r6, 1
		call "object::KartVehicleMove::forceDash()"

_end:
		pop "r31"
		stack.restore
	.endfunc