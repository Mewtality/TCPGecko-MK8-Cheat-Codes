/*
* File: pauseTimer.asm
* Author: Mewtality
* Date: 2022-09-07 15:33:46
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

		li %a0, 0x1
		stb %a0, 0x4C (r12)

_end:
		stackReset()
	.endfunc