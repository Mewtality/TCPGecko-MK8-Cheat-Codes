/*
* File: earthMenuAnywhere.asm
* Author: Mewtality
* Date: 2022-09-07 01:59:05
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func earthMenuAnywhere
		stackUpdate(0)

		call("FID_conflict_ui_GetBg")
		cmpwi %a3, 0
		beq _end
		call("ui_Page_Bg_animKeepWiFi")
		dereference("menuManagement")
		cmpwi r12, 0
		beq _end
		lbz %a5, 0x40 (r12)
		cmpwi %a5, 0x2
		beq _end
		lbz %a5, 0x41 (r12)
		cmpwi %a5, 0x4
		beq _end
		call("object_Menu3DModelDirector_informBeginWiFi"), "mr %a3, r12; li %a4, 1"

_end:
		stackReset()
	.endfunc