/*
* File: aimbot.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	toggle = "HOME"

	.func aimbot
		stackUpdate(3 + 3 + 12) # (Backup Non-Volatile Registers + Space For Kart Global Coordinates + Space For Vector Array)
		push(31); push(30); push(29)

		lis r31, aimbot.asm@h

		isRaceReady("_resetToggle")
		isRaceState("_resetToggle")

		getDRCKartUnit("_resetToggle")
		lwz r30, 0x4 (%a3)
		lwz r29, 0x14 (%a3)

		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (r29)"
		cmpwi r3, 0
		bne _resetToggle

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r30)"
		lwz %a3, 0x1A4 (%a3)

		isActivatorToggle("_resetFlag"), toggle, aimbot.asm

		flag = aimbot.asm + 2
		setFlag("_skip"), flag # Until "_skip", execute only for 1 frame.

		dereference("cameraManagement")
		lwz %a7, 0x25C (r12)
		cmpwi %a7, 0
		ble _end
		mtctr %a7
		addi %r9, %sp, 0x14 # 96-bit space for XYZ-Axis.
		addi %r8, %sp, 0x1C # Karts Vector Array. stfsu adds 0x4. Stack starts at <stack pointer>+0x20.

_pushVectorIntoArray:
		mr %a6, %a7
		subi %a7, %a7, 1
		
		call("object::KartInfoProxy::getKartUnit()"), "mr %a3, %a7"
		lwz %a3, 0x14 (%a3)

		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (%a3)"
		lfs f5, 0 (%a3) # Kart Global X-Axis.
		stfs f5, 0 (%r9)
		lfs f5, 0x4 (%a3) # Kart Global Y-Axis.
		stfs f5, 0x4 (%r9)
		lfs f5, 0x8 (%a3) # Kart Global Z-Axis.
		stfs f5, 0x8 (%r9)

		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (r29)" # DRC Kart Global Coordinates.
		call("ASM_VECDistance"), "mr %a4, %r9"

		stfsu f1, 0x4 (%r8) # Push vector into the array.

		mtctr %a6
		bdnz _pushVectorIntoArray

		lis r12, _rodata + 0x20B64@h
		lfs f5, _rodata + 0x20B64@l (r12) # Min Value (0)
		lis r12, _rodata + 0xD8D1C@ha
		lfs f8, _rodata + 0xD8D1C@l (r12) # Max Value (128)
		fmr f6, f8
		dereference("cameraManagement")
		lwz %a7, 0x25C (r12)
		addi %r8, %sp, 0x20 # Karts Vector Array.
		mtctr %a7

_searchNearestKartFromVectorArray:
		subi %a7, %a7, 1
		rlwinm %a0, %a7, 2, 0, 29

		lfsx f7, %r8, %a0 # Read vector from array.
		fcmpu cr0, f7, f5 # Exclude own kart.
		beq _invalidKart
		fcmpu cr0, f7, f6
		bge _invalidKart
		subi %a5, %a7, 0xB
		neg %a5, %a5
		fmr f6, f7

_invalidKart:
		bdnz _searchNearestKartFromVectorArray

		fcmpu cr0, f6, f8 # If no karts found > abort code.
		bge _resetToggle
		stw %a5, aimbot.asm+0x4@l (r31)

_skip:
		call("object::KartInfoProxy::getKartUnit()"), "lwz %a3, aimbot.asm+0x4@l (r31)"
		lwz %a3, 0x14 (%a3)

		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (%a3)" # Nearest Kart Global Coordinates.
		lfs f5, 0 (%a3)
		lfs f7, 0x8 (%a3)

		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (r29)" # DRC Kart Global Coordinates.
		mr %a5, %a3

		call("object::KartInfoProxy::isAntiG()"), "lwz %a3, 0x20C (r29)"
		cmpwi %a3, 0
		bne _resetToggle
		lfs f8, 0 (%a5)
		lfs f10, 0x8 (%a5)
		fsubs f5, f8, f5
		fsubs f7, f10, f7
		fmuls f8, f5, f5
		fmuls f10, f7, f7
		call("sqrtf"), "fadds f1, f8, f10"
		fdivs f8, f5, f1
		fdivs f10, f7, f1
		fneg f8, f8
		fneg f10, f10

		lis r12, _rodata + 0xC0@h
		lfs f9, _rodata + 0xC0@l (r12) # Min Value (-1)
		fcmpu cr0, f8, f9
		ble _end # abort if NaN
		fcmpu cr0, f10, f9
		ble _end # abort if NaN

		stfs f8, 0x24C (%a5)
		stfs f8, 0x258 (%a5)
		stfs f8, 0x264 (%a5)
		stfs f10, 0x254 (%a5)
		stfs f10, 0x260 (%a5)
		stfs f10, 0x26C (%a5)
		b _end

_resetFlag:
		resetFlag(flag)
		b _resetTarget

_resetToggle:
		reset(aimbot.asm)

_resetTarget:
		li %a0, -1
		stw %a0, aimbot.asm+0x4@l (r31)

_end:
		pop(29); pop(30); pop(31)
		stackReset()
	.endfunc