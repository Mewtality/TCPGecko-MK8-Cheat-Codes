/*
* File: respawnAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func respawnAtCommand
		stack.update 1
		push "r31"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)

		lwz r3, 0x8 (r31)
		get.kart.activator

		is.activator false, "_end", "DRC.SELECT"

		lwz r3, 0x4C (r31)
		call "object::KartJugemRecover::startRecover()"

_end:
		pop "r31"
		stack.restore
	.endfunc