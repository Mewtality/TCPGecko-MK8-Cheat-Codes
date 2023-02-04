/*
* File: gliderAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func gliderAtCommand
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

		is.activator false, "_else", "DRC.A, DRC.DPAD.U"

		mr r3, r31
		int r4, null
		call "object::KartVehicle::isInWing()"
		cmpwi r3, false
		bne _end

		mr r3, r31
		call "object::KartVehicle::forceGlide()"
		b _end

_else:
		is.activator false, "_end", "DRC.A, DRC.DPAD.D"

		mr r3, r31
		call "object::KartVehicle::forceCloseWing()"

_end:
		pop "r31"
		stack.restore
	.endfunc