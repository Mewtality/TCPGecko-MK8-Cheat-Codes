/*
* File: waterAnywhere.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 08:22:08 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"
	.include "C:/devkitPro/devkitPPC/assembly/modules/coreinit.S"

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long waterAnywhere.asm, 0, hook, 0x2C030000

	.func waterAnywhere
	hook = "object::KartVehicle::calcWetAndWater()" + 0x58
	hookData = 0x0EC9DE6C

		stackUpdate(0)

		isSent("_end"), waterAnywhere.asm

		KernelCopyData("getHookDataData"), hookData, hookDataLength - 0x4
		KernelCopyData("getHookData"), hook, hookLength - 0x4

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
		push(30)

		mr r30, %a3

		isRaceReady("_skip")
		isRaceState("_skip")

		getDRCKartUnit("_skip")
		lwz r12, 0x4 (%a3)

		cmpw r12, r31
		bne _skip
		li %a3, 1
		b _newUnderWaterCheckResult

_skip:
		mr %a3, r30

_newUnderWaterCheckResult:
		pop(30)
		stackReset()
		cmpwi %a3, 0 # Original Instruction
		blr

	hookDataLength = $ - getHookDataData
	.endfunc
_abort: