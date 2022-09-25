/*
* File: noVoiceClipLimit.asm
* Author: Mewtality
* Date: 2022-09-15 19:13:53
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func noVoiceClipLimit
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz %a3, 0x14 (%a3)

		li %a0, -1
		stw %a0, 0x27C (%a3)

_end:
		stackReset()
	.endfunc