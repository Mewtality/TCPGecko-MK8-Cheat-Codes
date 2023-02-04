/*
* File: homeMenuLocker.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func homeMenuLocker
		stack.update 1
		push "r31"

		int r31, homeMenuLocker.asm

		is.onRace false, "_reset"

		lbz r5, 0 (r31) # get flag
		cmpwi r5, false
		bne _end

		bool r5, true
		stb r5, 0 (r31) # set flag

		bool r3, true
		call "ui::LockHome()"
		b _end

_reset:
		bool r5, false
		stb r5, 0 (r31) # reset flag

_end:
		pop "r31"
		stack.restore
	.endfunc