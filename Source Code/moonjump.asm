/*
* File: moonjump.asm
* Author: Mewtality
* Date: 2022-09-09 18:40:44
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"
	.include "C:/devkitPro/devkitPPC/assembly/modules/coreinit.S"

	# SETTINGS
	enabler = "R"

	# MAKE SURE TO ADD "#" AT THE START OF THE FIRST TWO LINES IN THE MACHINE CODE.
	.long moonjump.asm, 0, hook, 0x38610008

	.func moonjumpHook
	hook = "object_KartVehicleMove_calcMove" + 0x98
	hookData = 0x0EC9DC90

		stackUpdate(0)

		lis r12, moonjump.asm@h
		lbz %a0, moonjump.asm@l (r12)
		cmpwi %a0, 0
		bne _end
		li %a0, 1
		stb %a0, moonjump.asm@l (r12)

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

		addi %a3, %sp, 0x8 # Restore orinal instruction from "getHookData".

		stackUpdate(1)
		push(29)
		mr r29, %a3

		isRaceReady("_skip")
		isRaceState("_skip")

		getDRCKartUnit("_skip")
		lwz %a3, 0x4 (%a3)

		lwz %a0, 0x14 (%a3)

		cmpw %a0, r30 # Check DRC player true/false.
		bne _skip

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (%a3)"
		lwz %a3, 0x1A4 (%a3)
		isActivator("_skip"), enabler

		lfs f5, 0x238 (r30)
		fneg f5, f5
		stfs f5, 0x238 (r30)

_skip:
		mr %a3, r29

		pop(29)
		stackReset()
		blr

	hookDataLength = $ - getHookDataData
	.endfunc
_abort: