/*
* File: pauseTimer.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func pauseTimer
		stackUpdate(null)

		dereference("raceManagement")
		cmpwi r12, 0
		beq _end

		lwz r12, 0x34 (r12)
		cmpwi r12, 0
		beq _end

		li %a0, true
		stb %a0, 0x4C (r12)

_end:
		stackReset()
	.endfunc