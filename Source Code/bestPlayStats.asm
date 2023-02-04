/*
* File: bestPlayStats.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func bestPlayStats
		stack.update

		call "FUN_0E64E218:sys::SystemEngine::getEngine()"
		cmpwi r3, false
		beq _end

		load r3, 0x2C8
		lwz r4, 0xE4 (r3)
		lbz r4, 0x15C (r4)
		call "sys::SaveDataManager::getUserSaveDataPtr()"
		load r3, 0x158

		int r0, 9999999
		stw r0, 0x14E8 (r3)
		stw r0, 0x14F0 (r3)
		stw r0, 0x14F4 (r3)
		stw r0, 0x14FC (r3)
		stw r0, 0x1500 (r3)
		stw r0, 0x1504 (r3)
		stw r0, 0x1A18 (r3)

		int r0, 0
		stw r0, 0x1508 (r3)
		stw r0, 0x1A1C (r3)

		int r0, 99999
		stw r0, 0x1A20 (r3)
		stw r0, 0x1A24 (r3)

_end:
		stack.restore
	.endfunc