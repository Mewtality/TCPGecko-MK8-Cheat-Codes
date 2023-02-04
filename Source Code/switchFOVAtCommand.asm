/*
* File: switchFOVAtCommand.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"
	
	import AMKP01, "symbols, macros"
	import module, "coreinit.rpl"
	import myStuff, "MK8Codes"

	KernelCopyData = 0x2500

	hook = "object::KartCamera::calcFovy()" + 0x25C
	hookData = 0x0EC9DD6C

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long switchFOVAtCommand.asm, 0, hook, 0xFC40D090

	.func FOVPatcher
		stack.update

		lis r12, switchFOVAtCommand.asm@h
		lbz r0, switchFOVAtCommand.asm+0x2@l (r12) # get flag
		cmpwi r0, false
		bne _end
		bool r0, true
		stb r0, switchFOVAtCommand.asm+0x2@l (r12) # set flag

		int r3, hookData
		li r4, hookDataLength - 0x4
		call "DCFlushRange"
		bl getHookData
		mfspr r3, %lr
		call "EffectiveToPhysical"
		mr r4, r3
		int r3, hookData|0x80000000
		li r5, hookDataLength - 0x4
		call "KernelCopyData"

		int r3, hook
		li r4, hookLength - 0x4
		call "DCFlushRange"
		bl getHook
		mfspr r3, %lr
		call "EffectiveToPhysical"
		mr r4, r3
		int r3, hook|0x80000000
		li r5, hookLength - 0x4
		call "KernelCopyData"

_end:
		stack.restore
		b _abort
	.endfunc

	.func FOVHook
getHook:
		blrl

		bl hookData - hook

	hookLength = $ - getHook
	.endfunc

	.func FOVHookData
getHookData:
		blrl

		stack.update 1
		push "r31"

		int r31, MK8Codes
		is.onRace false, "_skip"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		load r3, "0x4, 0x8"
		get.kart.activator

		lbz r7, switchFOVAtCommand.asm+0x1@l (r31)

		is.activator false, "_reset", "DRC.RSTICK.P"
		lbz r0, switchFOVAtCommand.asm@l (r31)
		cmpwi r0, false
		li r0, true
		stb r0, switchFOVAtCommand.asm@l (r31)
		bne _resume
		xori r7, r7, 0x1
		stb r7, switchFOVAtCommand.asm+0x1@l(r31)
		b _resume

_reset:
		li r0, false
		stb r0, switchFOVAtCommand.asm@l (r31)

_resume:
		cmpwi r7, false
		beq _skip
		getf f5, _rodata + 0x13C
		fadds f26, f26, f5

_skip:
		fmr f2, f26

		pop "r31"
		stack.restore
		blr

	hookDataLength = $ - getHookData
	.endfunc
_abort: