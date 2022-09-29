/*
* File: forceDRCFullscreen.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func forceDRCFullscreen
		stackUpdate(1)
		push(31)

		isRaceReady("_end")
		isRacePaused("_end")

		getDRCPlayer("_end")
		dereference("GUIManagement"), 0x10, 0x4, 0x1A0
		lwz %a3, 0x2BC (r12)
		cmpwi %a3, 0
		beq _end
		mr r31, %a3

		li r4, 0
		li r5, 0
		li r6, 1
		call("ui::Control_RaceDRC::setPushButton()")
		mr %a3, r31
		call("ui::Control_RaceDRC::forceSetFullScreen()")
		mr %a3, r31
		call("ui::Control_RaceDRC::quitDRCButtons()")

_end:
		pop(31)
		stackReset()
	.endfunc