/*
* File: itemWheel.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func itemWheel
		stack.update 2
		push "r31, r30"

		int r30, MK8Codes

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r12, 0x4 (r3)
		lwz r31, 0xC (r3)
		load r31, "0x5C"

		lwz r3, 0x8 (r12)
		get.kart.activator

		is.activator false, "_elseif", "DRC.DPAD.R"
		bool r5, true
		b _calcItem

_elseif:
		is.activator false, "_else", "DRC.DPAD.L"
		int r5, null
		b _calcItem

_else:
		bool r5, false

_calcItem:
		lbz r0, itemWheel.asm@l (r30)
		cmpwi r0, false
		stb r5, itemWheel.asm@l (r30)
		lwz r0, itemWheel.asm+0x4@l (r30)
		bne _initItemSet

		add r7, r0, r5
		cmplwi r7, 0x14
		ble 0x8
		xori r7, r0, 0x14

		mr r0, r7
		stw r0, itemWheel.asm+0x4@l (r30)

_initItemSet:
		lwz r5, 0x44 (r31)
		cmpwi r5, 0
		blt _setItem
		cmpw r5, r0
		beq _end

		mr r3, r31
		call "object::ItemOwnerProxy::clearItem()"

_setItem:
		lwz r0, 0x84 (r31)
		cmpwi r0, 0
		ble _end
		addi r4, r30, itemWheel.asm+0x4@l
		mr r3, r31
		call "object::ItemOwnerProxy::setItemForce()"

_end:
		pop "r30, r31"
		stack.restore
	.endfunc