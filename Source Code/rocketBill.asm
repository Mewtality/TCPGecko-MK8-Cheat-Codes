/*
* File: rocketBill.asm
* Author: Mewtality
* Date: 2022-09-07 15:54:20
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "A" | "Y"
	speedMultiplier = _rodata + 0xD4

	.func rocketBill
		stackUpdate(1)

		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		call("object_KartInfoProxy_isKiller"), "lwz %a3, 0x20C (%a3)"
		cmpwi %a3, 0
		beq _end

		mr %a3, r31
		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (%a3)"
		lwz %a3, 0x1A4 (%a3)
		isActivator("_end"), enabler

		lwz r12, 0x14 (r31)
		lfs f5, 0x3B8 (r12)
		mr %a3, r12

		lis r12, speedMultiplier@h
		lfs f6, speedMultiplier@l (r12)
		fmuls f1, f5, f6

		call("object_KartVehicleMove_setSpeed")

_end:
		pop(31)

		stackReset()
	.endfunc