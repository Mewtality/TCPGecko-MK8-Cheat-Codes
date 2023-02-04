/*
* File: coinRandomizer.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func coinRandomizer
		stack.update 1
		push "r31"

		is.onRace false, "_end"
		is.onPause true, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end

		get r12, _data + 0x7F2C
		load r12, "0x23C"
		addi r12, r12, 0x80
		rlwinm r3, r3, 0x2, 0x0, 0x1D
		lwzx r31, r12, r3

		int r3, 100
		call "nn::nex::Platform::GetRandomNumber()"
		stw r3, 0x40 (r31)

_end:
		pop "r31"
		stack.restore
	.endfunc