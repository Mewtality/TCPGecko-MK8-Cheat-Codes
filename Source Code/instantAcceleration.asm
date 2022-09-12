/*
* File: instantAcceleration.asm
* Author: Mewtality
* Date: 2022-09-07 15:08:30
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantAcceleration
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		lwz %a0, 0xFC (r12)
		clrlwi. %a0, %a0, 31
		beq _end

		lwz r12, 0x14 (r12)
		lwz %a5, 0x2E8 (r12)
		lwz %a6, 0x3B8 (r12)
		cmpw %a5, %a6
		bgt _end
		call("object_KartVehicleMove_setSpeed"), "mr %a3, r12; lfs f1, 0x3B8 (r12)"

_end:
		stackReset()
	.endfunc