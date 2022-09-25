/*
* File: instantRecovery.asm
* Author: Mewtality
* Date: 2022-09-07 15:17:05
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantRecovery
		stackUpdate(1)

		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a3, 0x14 (%a3)
		call("object_KartInfoProxy_isAccident"), "lwz %a3, 0x20C (%a3)"
		cmpwi %a3, 0
		beq _end

		call("object_KartVehicle_forceClearAccident"), "mr %a3, r31"

_end:
		pop(31)

		stackReset()
	.endfunc