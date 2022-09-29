/*
* File: infiniteItems.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func infiniteItems
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCPlayer("_end")
		mr %a4, %a3

		lis %a3, itemDirector@ha
		lwz %a3, itemDirector@l (%a3)

		call("object::ItemDirector::slot_StartSlot()")

_end:
		stackReset()
	.endfunc