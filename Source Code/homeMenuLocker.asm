/*
* File: homeMenuLocker.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	IsLockHomeMenu = false

	.func homeMenuLocker
		stackUpdate(1)
		push(31)

		lis r31, homeMenuLocker.asm@h

		isRaceReady("_reset")

		setFlag("_end"), homeMenuLocker.asm
		call("ui::LockHome()"), "li %a3, IsLockHomeMenu@l"
		b _end

_reset:
		resetFlag(homeMenuLocker.asm)

_end:
		pop(31)
		stackReset()
	.endfunc