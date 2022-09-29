/*
* File: gliderAtCommand.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	enabler = "A" | "DPAD_UP"
	disabler = "A" | "DPAD_DOWN"

	.func gliderAtCommand
		stackUpdate(1)
		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (%a3)"
		cmpwi r3, 0
		bne _end

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_else"), enabler

		call("object::KartVehicle::isInWing()"), "mr %a3, r31; li %a4, null"
		cmpwi r3, 0
		bne _end

		call("object::KartVehicle::forceGlide()"), "mr %a3, r31"

		b _end

_else:
		isActivator("_end"), disabler

		call("object::KartVehicle::forceCloseWing()"), "mr %a3, r31"

_end:
		pop(31)
		stackReset()
	.endfunc