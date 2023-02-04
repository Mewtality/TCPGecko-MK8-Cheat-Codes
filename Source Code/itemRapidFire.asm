/*
* File: rapidfire.asm
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

	hook = "object::ItemDirector::calcKeyInput_EachPlayer_()" + 0x5A8
	hookData = 0x0EC9DE6C

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long rapidfire.asm, 0, hook, 0x880C0000

	.func rapidfire
		stack.update

		lis r12, rapidfire.asm@h
		lbz r0, rapidfire.asm@l (r12)
		cmpwi r0, false
		bne _skip
		bool r0, true
		stb r0, rapidfire.asm@l (r12)

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

_skip:
		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get r12, _data + 0x7F3C
		load r12, "0x7B8"

		bool r0, false
		stbx r0, r12, r3

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
		push "r31"
		mr r31, r12

		call "object::RaceIndex_::DRCPlayer2Kart()" 
		get r12, _data + 0x7F3C
		load r12, "0x7B0"

		add r12, r12, r3
		cmpw r12, r31
		bne _restore
		li r5, false
		b _exit

_restore:
		mr r12, r31
		lbz r5, 0 (r12)

_exit:
		pop "r31"
		stack.restore
		mr r0, r5
		blr

	hookDataLength = $ - getHookData
	.endfunc
_abort: