/*
* File: forceDRCFullscreen.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func forceDRCFullscreen
		stack.update 1
		push "r31"

		is.onRace false, "_end"
		is.onPause true, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end

		get r12, _data + 0x9B8C
		load r12, "0x10, 0x4, 0x1A0"

		lwz r3, 0x2BC (r12)
		cmpwi r3, false
		beq _end
		bool r4, false
		bool r5, false
		bool r6, true
		mr r31, r3
		call "ui::Control_RaceDRC::setPushButton()"

		mr r3, r31
		call "ui::Control_RaceDRC::forceSetFullScreen()"

		mr r3, r31
		call "ui::Control_RaceDRC::quitDRCButtons()"

_end:
		pop "r31"
		stack.restore
	.endfunc