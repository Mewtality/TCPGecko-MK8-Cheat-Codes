/*
* File: driveWhilePaused.asm
* Author: Mewtality
* Date: Monday, October 10, 2022 @ 01:39:26 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func driveWhilePaused
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		call("FUN_0E64E218:sys::SystemEngine::getEngine()")
		lwz %a3, 0 (%a3)
		lwz %a3, 0x200 (%a3)

		li %a0, false
		stb %a0, 0xCC (%a3)

_end:
		stackReset()
	.endfunc