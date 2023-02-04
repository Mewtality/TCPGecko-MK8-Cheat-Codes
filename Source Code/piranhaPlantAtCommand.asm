/*
* File: piranhaPlantAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	subroutine = 0x0E314878 # from "object::ItemObjPackun::stateInitEquip_Hang"

	.func piranhaPlantAtCommand
		stack.update 2
		push "r31, r30"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)

		load r3, "0x14"
		lwz r30, 0x20C (r3)

		mr r3, r30
		call "object::KartInfoProxy::isPackunItemActive()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r31)
		get.kart.activator

		is.activator false, "_end", "DRC.ZR"

		mr r3, r30
		call "subroutine"

_end:
		pop "r30, r31"
		stack.restore
	.endfunc