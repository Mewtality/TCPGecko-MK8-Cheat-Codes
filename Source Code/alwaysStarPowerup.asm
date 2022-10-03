/*
* File: alwaysStarPowerup.asm
* Author: Mewtality
* Date: Monday, October 3, 2022 @ 11:31:18 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysStarPowerup
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")

		call(0x0E342CA0), "lwz %a3, 0x4 (%a3)"

_end:
		stackReset()
	.endfunc