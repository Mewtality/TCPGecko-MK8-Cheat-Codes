/*
* File: driveWhilePaused.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func driveWhilePaused
		stack.update

		is.onRace false, "_end"

		call "FUN_0E64E218:sys::SystemEngine::getEngine()"
		load r3, "0, 0x200"

		bool r0, false
		stb r0, 0xCC (r3)

_end:
		stack.restore
	.endfunc