/*
* File: instantFinish.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func instantFinish
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end

		get r12, _data + 0x7F2C
		load r12, "0x4C"
		rlwinm r0, r3, 2, 0, 29

		bool r4, false
		lwzx r3, r12, r0
		call "object::RaceKartChecker::forceGoal()"

_end:
		stack.restore
	.endfunc