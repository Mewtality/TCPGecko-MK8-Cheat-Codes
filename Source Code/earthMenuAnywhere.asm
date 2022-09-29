/*
* File: earthMenuAnywhere.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func earthMenuAnywhere
		stackUpdate(0)

		call("FID_conflict:ui::GetBg()")
		cmpwi %a3, 0
		beq _end
		call("ui::Page_Bg::animKeepWiFi()")
		dereference("menuManagement")
		cmpwi r12, 0
		beq _end
		lbz %a5, 0x40 (r12)
		cmpwi %a5, 0x2
		beq _end
		lbz %a5, 0x41 (r12)
		cmpwi %a5, 0x4
		beq _end
		call("object::Menu3DModelDirector::informBeginWiFi()"), "mr %a3, r12; li %a4, 1"

_end:
		stackReset()
	.endfunc