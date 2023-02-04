/*
* File: alwaysLightningEnvironment.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func alwaysLightningEnvironment
		stack.update

		is.onRace false, "_end"

		getf f5, _rodata + 0xBC
		get r5, _bss + 0x1861
		get r12, _data + 0x7F30

		stw r5, 0x2B4 (r12)
		stfs f5, 0x2B8 (r12)

_end:
		stack.restore
	.endfunc