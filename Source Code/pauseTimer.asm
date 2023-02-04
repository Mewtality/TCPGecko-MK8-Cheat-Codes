/*
* File: pauseTimer.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func pauseTimer
		stack.update

		is.onRace false, "_end"

		get r12, _data + 0x7F2C
		load r12, "0x34"

		bool r0, true
		stb r0, 0x4C (r12)

_end:
		stack.restore
	.endfunc