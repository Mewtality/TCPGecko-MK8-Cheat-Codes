/*
* File: alwaysLightningEnvironment.asm
* Author: Mewtality
* Date: Wednesday, October 5, 2022 @ 07:22:31 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func alwaysLightningEnvironment
		stackUpdate(null)

		isRaceReady("_end")

		lis r12, _rodata + 0xBC@h
		lfs f5, _rodata + 0xBC@l (r12)

		lis r12, _bss + 0x18618@h
		lwz %a5, _bss + 0x18618@l (r12)

		dereference("courceInfoManagement")
		stw %a5, 0x2B4 (r12)
		stfs f5, 0x2B8 (r12)

_end:
		stackReset()
	.endfunc