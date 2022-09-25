/*
* File: coinRandomizer.asm
* Author: Mewtality
* Date: 2022-09-07 13:13:31
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func coinRandomizer
		stackUpdate(1)

		push(31)

		isRaceReady("_end")
		isRaceState("_end")
		isRacePaused("_end")

		getDRCPlayer("_end")

		dereference("raceManagement"), 0x23C
		addi r12, r12, 0x80
		rlwinm %a3, %a3, 0x2, 0x0, 0x1D
		lwzx r31, r12, %a3

		call("nn_nex_Platform_GetRandomNumber"), "li %a3, 0x64"
		stw %a3, 0x40 (r31)

_end:
		pop(31)

		stackReset()
	.endfunc