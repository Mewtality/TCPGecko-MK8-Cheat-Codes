/*
* File: piranhaPlantAtCommand.asm
* Author: Mewtality
* Date: 2022-09-07 15:37:59
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "ZR"

	.func piranhaPlantAtCommand
		stackUpdate(2)

		push(31); push(30)

		isRaceReady("_end")
		isRaceState("_end")
		isRacePaused("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		lwz r30, 0x20C (%a3)

		call("object_KartInfoProxy_isPackunItemActive"), "mr %a3, r30"
		cmpwi %a3, 0
		bne _end

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_end"), enabler

		call(0x0E314878), "mr %a3, r30"

_end:
		pop(30); pop(31)

		stackReset()
	.endfunc