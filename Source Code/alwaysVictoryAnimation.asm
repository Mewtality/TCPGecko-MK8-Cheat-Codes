/*
* File: alwaysVictoryAnimation.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func alwaysVictoryAnimation
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r12, 0x4 (%a3)

		lwz r0, 0x148 (r12)
		cmpwi r0, false
		bne _end

		load r3, 0x8
		bool r4, true
		call "object::DriverKart::startGoalAnim()"

_end:
		stack.restore
	.endfunc