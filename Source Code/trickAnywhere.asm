/*
* File: trickAnywhere.asm
* Author: Mewtality
* Date: 2022-09-07 15:59:57
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func trickAnywhere
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		li %a0, 0x10
		stw %a0, 0x1D0 (r12)

_end:
		stackReset()
	.endfunc