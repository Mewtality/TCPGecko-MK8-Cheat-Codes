/*
* File: unlockEverything.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func unlockEverything
		stack.update

		call "FUN_0E64E218:sys::SystemEngine::getEngine()"
		cmpwi r3, false
		beq _end
		load r3, "0x2C8"
		lwz r4, 0xE4 (r3)
		lbz r4, 0x15C (r4)
		call "sys::SaveDataManager::getUserSaveDataPtr()"
		lwz r12, 0x158 (r3)

		int r0, 0x03030303
		stw r0, 0x4CC (r12)
		stw r0, 0x4D0 (r12)
		stw r0, 0x4D4 (r12)
		stw r0, 0x4EC (r12)
		stw r0, 0x4F0 (r12)
		stw r0, 0x4F4 (r12)
		stw r0, 0x50C (r12)
		stw r0, 0x510 (r12)
		stw r0, 0x514 (r12)
		stw r0, 0x52C (r12)
		stw r0, 0x530 (r12)
		stw r0, 0x534 (r12)
		stw r0, 0x54C (r12)
		stw r0, 0x550 (r12)
		stw r0, 0x554 (r12)
		stw r0, 0x5CC (r12)
		stw r0, 0x5D0 (r12)
		stw r0, 0x5D4 (r12)
		stw r0, 0x5EC (r12)
		stw r0, 0x5F0 (r12)
		stw r0, 0x5F4 (r12)
		stw r0, 0x60C (r12)
		stw r0, 0x610 (r12)
		stw r0, 0x614 (r12)
		stw r0, 0x62C (r12)
		stw r0, 0x630 (r12)
		stw r0, 0x634 (r12)
		stw r0, 0x64C (r12)
		stw r0, 0x650 (r12)
		stw r0, 0x654 (r12)
		stw r0, 0x1A28 (r12)
		stw r0, 0x1A2C (r12)
		stw r0, 0x1A50 (r12)
		stw r0, 0x1A54 (r12)
		stw r0, 0x1A58 (r12)
		stw r0, 0x1A5C (r12)
		stw r0, 0x1A60 (r12)
		stw r0, 0x1A64 (r12)
		stw r0, 0x1A68 (r12)
		sth r0, 0x1A6C (r12)
		stw r0, 0x1A90 (r12)
		stw r0, 0x1A94 (r12)
		stw r0, 0x1A98 (r12)
		stw r0, 0x1A9C (r12)
		stw r0, 0x1AA0 (r12)
		stw r0, 0x1AA4 (r12)
		sth r0, 0x1AA8 (r12)
		stw r0, 0x1AD0 (r12)
		stw r0, 0x1AD4 (r12)
		stw r0, 0x1AD8 (r12)
		stw r0, 0x1ADC (r12)
		sth r0, 0x1AE0 (r12)
		stw r0, 0x1B10 (r12)
		stw r0, 0x1B14 (r12)
		stw r0, 0x1B18 (r12)
		sth r0, 0x1B5A (r12)
		stw r0, 0x1B5C (r12)
		stw r0, 0x1B60 (r12)
		stw r0, 0x1B64 (r12)
		stw r0, 0x1B68 (r12)
		stw r0, 0x1B6C (r12)
		stw r0, 0x1B70 (r12)
		stw r0, 0x1B74 (r12)
		stw r0, 0x1B78 (r12)
		stw r0, 0x1B7C (r12)
		stw r0, 0x1B80 (r12)
		stw r0, 0x1B84 (r12)
		stw r0, 0x1B88 (r12)
		stw r0, 0x1B8C (r12)
		stw r0, 0x1B90 (r12)
		stw r0, 0x1B94 (r12)
		stw r0, 0x1B98 (r12)
		stw r0, 0x1B9C (r12)
		stw r0, 0x1BA0 (r12)
		stw r0, 0x1BA4 (r12)
		stw r0, 0x1BA8 (r12)
		stw r0, 0x1BAC (r12)
		stw r0, 0x1BB0 (r12)

_end:
		stack.restore
	.endfunc