/*
* File: instantFinish.asm
* Author: Mewtality
* Date: Monday, October 3, 2022 @ 09:48:23 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func instantFinish
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCPlayer("_end")

		dereference("raceManagement"), 0x4C
		rlwinm %a0, %a3, 2, 0, 29

		call("object::RaceKartChecker::forceGoal()"), "lwzx %a3, r12, %a0; li %a4, false"

_end:
		stackReset()
	.endfunc