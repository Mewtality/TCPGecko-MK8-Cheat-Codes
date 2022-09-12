/*
* File: always5Balloons.asm
* Author: Mewtality
* Date: 2022-09-07 11:55:18
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func always5Balloons
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCPlayer("_end")
		mr %a4, %a3

		dereference("raceManagement"), 0x23C
		addi r12, r12, 0x80
		rlwinm %a3, %a3, 0x2, 0x0, 0x1D
		lwzx %a3, r12, %a3

		call("object_RaceKartCheckerBattle_incBalloon")

_end:
		stackReset()
	.endfunc