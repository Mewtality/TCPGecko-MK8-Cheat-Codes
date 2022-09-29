/*
* File: instantRespawn.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantRespawn
		stackUpdate(0)

		isRaceReady("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		dereference(null), 0x4C, 0x14

		lwz %a0, 0x34 (r12)
		stw %a0, 0x1C (r12)

		lwz %a0, 0x8C (r12) # object_KartJugemRecover_stateFinish
		stw %a0, 0x6C (r12) # object_KartJugemRecover_stateReplay

_end:
		stackReset()
	.endfunc