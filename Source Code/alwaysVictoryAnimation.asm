/*
* File: alwaysVictoryAnimation.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysVictoryAnimation
		stackUpdate(0)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r12, 0x4 (%a3)

		lwz %a0, 0x148 (r12)
		cmpwi %a0, 0
		bne _end

		call("object::DriverKart::startGoalAnim()"), "lwz %a3, 0x8 (%a3); li %a4, 0x1"

_end:
		stackReset()
	.endfunc