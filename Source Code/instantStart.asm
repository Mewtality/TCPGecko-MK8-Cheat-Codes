/*
* File: instantStart.asm
* Author: Mewtality
* Date: 2022-09-07 15:24:34
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantStart
		stackUpdate(0)

		dereference("raceManagement")
		cmpwi r12, 0
		beq _end

		lwz r12, 0x238 (r12)
		cmpwi r12, 0
		beq _end

		lwz %a0, 0x28 (r12)
		cmpwi %a0, 0x5
		bne _end
		li %a0, 0x6
		stw %a0, 0x28 (r12)

_end:
		stackReset()
	.endfunc