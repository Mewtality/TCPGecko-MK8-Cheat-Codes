/*
* File: noVoiceClipLimit.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func noVoiceClipLimit
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		load r3, 0x14

		int r0, null
		stw r0, 0x27C (r3)

_end:
		stack.restore
	.endfunc