/*
* File: dropItemsAtCommand.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	enabler = "DPAD_DOWN"

	.func dropItemsAtCommand
		stackUpdate(3)
		push(31); push(30); push(29)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCPlayer("_end")
		mr r31, %a3

		call("object::KartInfoProxy::getKartUnit()")
		lwz r12, 0x4 (%a3)
		lwz r30, 0xC (%a3)
		lwz r30, 0x5C (r30)
		lis r29, dropItemsAtCommand.asm@h

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r12)"
		lwz %a3, 0x1A4 (%a3)
		isActivator("_else"), enabler
		lbz %a0, dropItemsAtCommand.asm@l (r29)
		cmpwi %a0, 0
		bne _end
		li %a0, 1
		stb %a0, dropItemsAtCommand.asm@l (r29)

		call(0x0E2E47E4), "mr %a3, r30" # SUBROUTINE from "object::ItemObjThunder::_startThunderEffect()"
		call("object::ItemOwnerProxy::_clearItemSlot()"), "mr %a3, r30"

		b _end

_else:
		li %a0, 0
		stb %a0, dropItemsAtCommand.asm@l (r29)

_end:
		pop(29); pop(30); pop(31)
		isync
		stackReset()
	.endfunc