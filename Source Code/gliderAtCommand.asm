/*
* File: gliderAtCommand.asm
* Author: Mewtality
* Date: 2022-09-07 15:04:57
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
		isRacePaused("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		call("object_KartInfoProxy_isJugemHang"), "lwz %a3, 0x20C (%a3)"
		cmpwi r3, 0
		bne _end

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_else"), enabler

		call("object_KartVehicle_isInWing"), "mr %a3, r31; li %a4, null"
		cmpwi r3, 0
		bne _end

		call("object_KartVehicle_forceGlide"), "mr %a3, r31"

		b _end

_else:
		isActivator("_end"), disabler

		call("object_KartVehicle_forceCloseWing"), "mr %a3, r31"

_end:
		pop(31)

		stackReset()
	.endfunc