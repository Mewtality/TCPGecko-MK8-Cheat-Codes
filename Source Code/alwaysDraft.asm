/*
* File: alwaysDraft.asm
* Author: Mewtality
* Date: Monday, October 3, 2022 @ 10:45:49 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysDraft
		stackUpdate(1)
		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		lwz %a0, 0xFC (r31)
		clrlwi. %a0, %a0, 31
		beq _end

		lwz %a3, 0x14 (%a3)
		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (%a3)"
		cmpwi r3, 0
		bne _end

		call("object::KartVehicleMove::forceDash()"), "lwz %a3, 0x14 (r31); li %a4, 0x3; li %a5, 1; li %a6, 1"

_end:
		pop(31)
		stackReset()
	.endfunc