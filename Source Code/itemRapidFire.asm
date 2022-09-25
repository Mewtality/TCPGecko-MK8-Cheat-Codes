/*
* File: rapidfire.asm
* Author: Mewtality
* Date: 2022-09-09 02:20:29
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"
	.include "C:/devkitPro/devkitPPC/assembly/modules/coreinit.S"

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long rapidfire.asm, 0, hook, 0x880C0000

	.func rapidfire
	hook = "object_ItemDirector_calcKeyInput_EachPlayer" + 0x5A8
	hookData = 0x0EC9DE6C

		stackUpdate(0)

		lis r12, rapidfire.asm@h
		lbz %a0, rapidfire.asm@l (r12)
		cmpwi %a0, 0
		bne _skip
		li %a0, 1
		stb %a0, rapidfire.asm@l (r12)

		KernelCopyData("getHookDataData"), hookData, hookDataLength - 0x4
		KernelCopyData("getHookData"), hook, hookLength - 0x4

_skip:
		isRaceReady("_end")
		isRaceState("_end")
		isRacePaused("_end")

		getDRCPlayer("_end")
		dereference("itemDirector"), 0x7B8

		li %a0, 0
		stbx %a0, r12, %a3

_end:
		stackReset()
		b _abort
	.endfunc

	.func hook
getHookData:
		blrl

		bl hookData - hook

	hookLength = $ - getHookData
	.endfunc

	.func hookData
getHookDataData:
		blrl

		stackUpdate(1)
		push(31)
		mr r31, r12

		call("object_RaceIndex__DRCPlayer2Kart")
		dereference("itemDirector"), 0x7B0

		add r12, r12, %a3
		cmpw r12, r31
		bne _restore
		li %a5, 0
		b _exit

_restore:
		mr r12, r31
		lbz %a5, 0 (r12)

_exit:
		pop(31)
		stackReset()
		mr %a0, %a5
		blr

	hookDataLength = $ - getHookDataData
	.endfunc
_abort: