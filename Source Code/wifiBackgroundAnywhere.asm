/*
* File: wifiBackgroundAnywhere.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func wifiBackgroundAnywhere
		stack.update

		call "FID_conflict:ui::GetBg()"
		cmpwi r3, false
		beq _end
		call "ui::Page_Bg::animKeepWiFi()"
		get r12, _data + 0x7F58
		cmpwi r12, 0
		beq _end
		lbz r5, 0x40 (r12)
		cmpwi r5, 0x2
		beq _end
		lbz r5, 0x41 (r12)
		cmpwi r5, 0x4
		beq _end

		bool r4, true
		mr r3, r12
		call "object::Menu3DModelDirector::informBeginWiFi()"

_end:
		stack.restore
	.endfunc