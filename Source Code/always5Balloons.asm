/*
* File: always5Balloons.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func always5Balloons
		stack.update

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		mr r4, r3

		get r12, _data + 0x7F2C
		load r12, "0x23C"
		addi r12, r12, 0x80
		rlwinm r3, r3, 0x2, 0x0, 0x1D

		lwzx r3, r12, r3
		call "object::RaceKartCheckerBattle::incBalloon()"

_end:
		stack.restore
	.endfunc