/*
* File: bulletBillAtCommand.asm
* Author: Mewtality
* Date: 2022-09-07 12:57:02
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "A" | "Y"
	disabler = "A" | "B"

	.func bulletBillAtCommand
		stackUpdate(1)

		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		call("object_KartInfoProxy_isJugemHang"), "lwz %a3, 0x20C (%a3)"
		cmpwi %a3, 0
		bne _end

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_else"), enabler
		call("object_KartVehicle_startKiller"), "mr %a3, r31"

		b _end

_else:
		isActivator("_end"), disabler
		call("object_KartVehicle_endKiller"), "mr %a3, r31"

_end:
		pop(31)

		stackReset()
	.endfunc