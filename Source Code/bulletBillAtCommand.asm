/*
* File: bulletBillAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func bulletBillAtCommand
		stack.update 2
		push "r31, r30"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)
		lwz r30, 0x14 (r3)

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r31)
		get.kart.activator

		is.activator false, "_else", "DRC.A, DRC.Y"

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isKiller()"
		cmpwi r3, false
		bne _end

		mr r3, r31
		call "object::KartVehicle::startKiller()"

		b _end

_else:
		is.activator false, "_end", "DRC.A, DRC.B"

		mr r3, r31
		call "object::KartVehicle::endKiller()"

_end:
		pop "r30, r31"
		stack.restore
	.endfunc