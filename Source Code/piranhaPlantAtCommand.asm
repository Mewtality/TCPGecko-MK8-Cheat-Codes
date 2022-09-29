/*
* File: piranhaPlantAtCommand.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "ZR"

	.func piranhaPlantAtCommand
		stackUpdate(2)
		push(31); push(30)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		lwz r30, 0x20C (%a3)

		call("object::KartInfoProxy::isPackunItemActive()"), "mr %a3, r30"
		cmpwi %a3, 0
		bne _end

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_end"), enabler

		call(0x0E314878), "mr %a3, r30" # SUBROUTINE from "object::ItemObjPackun::stateInitEquip_Hang"

_end:
		pop(30); pop(31)
		stackReset()
	.endfunc