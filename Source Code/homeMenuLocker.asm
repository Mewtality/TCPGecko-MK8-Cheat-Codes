/*
* File: homeMenuLocker.asm
* Author: Mewtality
* Date: 2022-09-07 15:28:54
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	IsLockHomeMenu = false

	.func homeMenuLocker
		stackUpdate(0)

		call("sys_SystemEngine_getEngine")
		cmpwi %a3, 0
		beq _end

		lwz r12, 0x2CC (%a3)
		li %a0, IsLockHomeMenu
		stw %a0, 0x2C (r12)

_end:
		stackReset()
	.endfunc