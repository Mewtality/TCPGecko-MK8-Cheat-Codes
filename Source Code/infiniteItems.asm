/*
* File: infiniteItems.asm
* Author: Mewtality
* Date: 2022-09-12 21:47:25
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
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

		call("object_ItemDirector_slot_StartSlot")

_end:
		stackReset()
	.endfunc