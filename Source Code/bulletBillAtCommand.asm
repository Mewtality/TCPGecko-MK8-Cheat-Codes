/*
* File: bulletBillAtCommand.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "A" | "Y"
	disabler = "A" | "B"

	.func bulletBillAtCommand
		stackUpdate(1)
		push(31); push(30)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)
		lwz r30, 0x14 (%a3)

		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (r30)"
		cmpwi %a3, 0
		bne _end

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_else"), enabler
		call("object::KartInfoProxy::isKiller()"), "lwz %a3, 0x20C (r30)"
		cmpwi %a3, 0
		bne _end

		call("object::KartVehicle::startKiller()"), "mr %a3, r31"

		b _end

_else:
		isActivator("_end"), disabler
		call("object::KartVehicle::endKiller()"), "mr %a3, r31"

_end:
		pop(30); pop(31)
		stackReset()
	.endfunc