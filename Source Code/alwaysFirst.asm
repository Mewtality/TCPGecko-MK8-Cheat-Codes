/*
* File: alwaysFirst.asm
* Author: Mewtality
* Date: 2022-09-10 16:18:04
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysFirst
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

        getDRCPlayer("_end")

		dereference("raceManagement"), 0x4C
		rlwinm %a0, %a3, 2, 0, 29
		lwzx r12, r12, %a0
        li %a0, 0
        stw %a0, 0x2C (r12)

_end:
		stackReset()
	.endfunc