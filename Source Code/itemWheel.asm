/*
* File: itemWheel.asm
* Author: Mewtality
* Date: 2022-09-07 15:55:04
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	nextItem = "DPAD_RIGHT"
	previousItem = "DPAD_LEFT"

	.func itemWheel
		stackUpdate(2)

		push(31)
		push(30)

		isRaceReady("_end")
		isRaceState("_end")
		isRacePaused("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)
		lwz r31, 0xC (%a3)
		lwz r31, 0x5C (r31)
		lis r30, itemWheel.asm@h

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r12)"
		lwz %a3, 0x1A4 (%a3)
		isActivator("_elseif"), nextItem
		li %a5, 0x1
		b _calcItem

_elseif:
		isActivator("_else"), previousItem
		li %a5, -1
		b _calcItem

_else:
		li %a5, 0

_calcItem:
		lbz %a0, itemWheel.asm@l (r30)
		cmpwi %a0, 0
		stb %a5, itemWheel.asm@l (r30)

		lwz %a0, itemWheel.asm+0x4@l (r30)

		bne _initItemSet

		add %a7, %a0, %a5
		cmplwi %a7, 0x14
		ble 0x8
		xori %a7, %a0, 0x14

		mr %a0, %a7
		stw %a0, itemWheel.asm+0x4@l (r30)

_initItemSet:
		lwz %a5, 0x44 (r31)
		cmpwi %a5, 0
		blt _setItem
		cmpw %a5, %a0
		beq _end

		call("object_ItemOwnerProxy_clearItem"), "mr %a3, r31"

_setItem:
		lwz %a0, 0x84 (r31)
		cmpwi %a0, 0
		ble _end
		call("object_ItemOwnerProxy_setItemForce"), "mr %a3, r31; addi %a4, r30, itemWheel.asm+0x4@l"

_end:
		pop(30)
		pop(31)

		stackReset()
	.endfunc