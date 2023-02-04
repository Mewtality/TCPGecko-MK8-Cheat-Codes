/*
* File: infiniteItems.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func infiniteItems
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end

		mr r4, r3
		get r3, _data + 0x7F3C
		call "object::ItemDirector::slot_StartSlot()"

_end:
		stack.restore
	.endfunc