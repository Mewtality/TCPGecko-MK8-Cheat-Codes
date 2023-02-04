/*
* File: dropItemsAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	subroutine = 0x0E2E47E4 # from "object::ItemObjThunder::_startThunderEffect()"

	.func dropItemsAtCommand
		stack.update 3
		push "r31, r30, r29"

		int r29, MK8Codes

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		mr r31, r3

		call "object::KartInfoProxy::getKartUnit()"
		lwz r12, 0x4 (r3)
		lwz r30, 0xC (r3)
		lwz r30, 0x5C (r30)

		lwz r3, 0x8 (r12)
		get.kart.activator
		
		is.activator false, "_else", "DRC.DPAD.D"
		lbz r0, dropItemsAtCommand.asm@l (r29)
		cmpwi r0, false
		bne _end
		li r0, true
		stb r0, dropItemsAtCommand.asm@l (r29)

		mr r3, r30
		call "subroutine"

		mr r3, r30
		call "object::ItemOwnerProxy::_clearItemSlot()"

		b _end

_else:
		bool r0, false
		stb r0, dropItemsAtCommand.asm@l (r29)

_end:
		pop "r29, r30, r31"
		isync
		stack.restore
	.endfunc