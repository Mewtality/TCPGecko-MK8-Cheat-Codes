/*
* File: ability2ChangeDriftDirection.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func ability2ChangeDriftDirection
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		load r3, "0x4"

		lfs f5, 0x104 (r3)
		getf f6, _rodata + 0x20B64

		fcmpu cr0, f5, f6
		beq _end

		load r3, "0x14, 0xEC"
		stfs f5, 0x64 (r3)

_end:
		stack.restore
	.endfunc