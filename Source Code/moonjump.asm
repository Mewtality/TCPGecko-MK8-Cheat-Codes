/*
* File: moonjump.asm
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

	hook = "object::KartVehicleMove::calcMove()" + 0x98
	hookData = 0x0EC9DC90

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long moonjump.asm, 0, hook, 0x38610008

	.func moonjumpHook
		stack.update

		lis r12, moonjump.asm@h
		lbz r0, moonjump.asm@l (r12)
		cmpwi r0, false
		bne _end
		li r0, true
		stb r0, moonjump.asm@l (r12)

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

		addi r3, %sp, 0x8 # Restore orinal instruction from "getHookData".

		stack.update 1
		push "r29"
		mr r29, r3

		is.onRace false, "_skip"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		load r3, "0x4"

		lwz r0, 0x14 (r3)

		cmpw r0, r30 # Check DRC player true/false.
		bne _skip

		load r3, "0x8"
		get.kart.activator

		is.activator false, "_skip", "DRC.R"

		lfs f5, 0x238 (r30)
		fneg f5, f5
		stfs f5, 0x238 (r30)

_skip:
		mr r3, r29

		pop "r29"
		stack.restore
		blr

	hookDataLength = $ - getHookData
	.endfunc
_abort: