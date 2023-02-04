/*
* File: waterAnywhere.asm
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

	hook = "object::KartVehicle::calcWetAndWater()" + 0x58
	hookData = 0x0EC9DED0

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long waterAnywhere.asm, 0, hook, 0x2C030000

	.func waterAnywhere
		stack.update

		lis r12, waterAnywhere.asm@h
		lbz r0, waterAnywhere.asm@l (r12) # get flag
		cmpwi r0, false
		bne _end
		bool r0, true
		stb r0, waterAnywhere.asm@l (r12) # set flag

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

	.func hook
getHook:
		blrl

		bl hookData - hook

	hookLength = $ - getHook
	.endfunc

	.func hookData
getHookData:
		blrl

		stack.update 1
		push "r30"

		mr r30, r3

		is.onRace false, "_skip"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r12, 0x4 (r3)

		cmpw r12, r31
		bne _skip
		li r3, true
		b _newUnderWaterCheckResult

_skip:
		mr r3, r30

_newUnderWaterCheckResult:
		pop "r30"
		stack.restore
		cmpwi r3, false # Original Instruction
		blr

	hookDataLength = $ - getHookData
	.endfunc
_abort: