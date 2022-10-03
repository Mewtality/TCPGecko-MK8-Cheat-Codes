/*
* File: pauseTimer.asm
* Author: Mewtality
* Date: Monday, October 3, 2022 @ 10:02:38 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func pauseTimer
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		dereference("raceManagement"), 0x34

		li %a0, true
		stb %a0, 0x4C (r12)

_end:
		stackReset()
	.endfunc