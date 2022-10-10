/*
* File: switchFOVAtCommand.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"
	.include "C:/devkitPro/devkitPPC/assembly/modules/coreinit.S"

	# SETTINGS
	toggle = "RIGHT_STICK_PRESS"

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long switchFOVAtCommand.asm, 0, hook, 0xFC40D090

	.func FOVPatcher
	hook = "object::KartCamera::calcFovy()" + 0x25C
	hookData = 0x0EC9DD70

		stackUpdate(0)

		lis r12, switchFOVAtCommand.asm@h
		lbz %a0, switchFOVAtCommand.asm+0x2@l (r12)
		cmpwi %a0, 0
		bne _end
		li %a0, 1
		stb %a0, switchFOVAtCommand.asm+0x2@l (r12)

		KernelCopyData("getFOVHookData"), hookData, FOVHookDataLen - 0x4
		KernelCopyData("getFOVHook"), hook, FOVHookLen - 0x4

_end:
		stackReset()
		b _abort
	.endfunc

	.func FOVHook
getFOVHook:
		blrl

		bl hookData - hook

	FOVHookLen = $ - getFOVHook
	.endfunc

	.func FOVHookData
getFOVHookData:
		blrl

		stackUpdate(1)

		push(31)

		lis r31, switchFOVAtCommand.asm@h
		isRaceReady("_skip")

		getDRCKartUnit("_skip")
		lwz %a3, 0x4 (%a3)

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (%a3)"
		lwz %a3, 0x1A4 (%a3)

		lbz %a7, switchFOVAtCommand.asm+0x1@l (r31)

		isActivator("_reset"), toggle
		lbz %a0, switchFOVAtCommand.asm@l (r31)
		cmpwi %a0, 0
		li %a0, 0x1
		stb %a0, switchFOVAtCommand.asm@l (r31)
		bne _resume
		xori %a7, %a7, 0x1
		stb %a7, switchFOVAtCommand.asm+0x1@l(r31)
		b _resume

_reset:
		li %a0, 0
		stb %a0, switchFOVAtCommand.asm@l (r31)

_resume:
		cmpwi %a7, 0
		beq _skip
		lis r12, _rodata + 0x13C@h
		lfs f5, _rodata + 0x13C@l (r12)
		fadds f26, f26, f5

_skip:
		fmr f2, f26

		pop(31)
		stackReset()
		blr

	FOVHookDataLen = $ - getFOVHookData
	.endfunc
_abort: