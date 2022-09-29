/*
* File: ultraBrakes.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func ultraBrakes
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		lwz %a0, 0xFC (r12)
		rlwinm. %a0, %a0, 0, 30, 30
		beq _end

		lwz r12, 0x14 (r12)
		lwz %a5, 0x2E8 (r12)
		cmpwi %a5, 0
		ble _end

		mr r3, r12
		lis r12, _rodata + 0x20B64@h
		lfs f1, _rodata + 0x20B64@l (r12)

		call("object::KartVehicleMove::setSpeed()")

_end:
		stackReset()
	.endfunc