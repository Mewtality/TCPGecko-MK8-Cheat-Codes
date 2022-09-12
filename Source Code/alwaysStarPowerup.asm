/*
* File: alwaysStarPowerup.asm
* Author: Mewtality
* Date: 2022-09-07 12:45:12
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysStarPowerup
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		li %a0, 0x10
		stw %a0, 0x160 (r12)

_end:
		stackReset()
	.endfunc