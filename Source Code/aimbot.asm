/*
* File: aimbot.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func aimbot
		stack.update 18 # (Backup 3x Non-Volatile Registers + 3x Space For Kart Global Coordinates + 12x Space For Vector Array)
		push "r31, r30, r29"

		int r31, MK8Codes

		is.onRace false, "_resetToggle"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _resetToggle
		get.kart
		lwz r30, 0x4 (r3)
		lwz r29, 0x14 (r3)

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _resetToggle

		lwz r3, 0x8 (r30)
		get.kart.activator

		lbz r7, aimbot.asm+0x1@l (r31)
		is.activator false, "_resetToggleFlag", "DRC.FLICK.D"

		lbz r6, aimbot.asm@l (r31) # get toggle flag
		cmpwi r6, false
		bool r6, true
		stb r6, aimbot.asm@l (r31) # set toggle flag
		bne _toggleChecker

		xori r7, r7, 0x1
		stb r7, aimbot.asm+0x1@l (r31) # invert toggle state
		b _toggleChecker

_resetToggleFlag:
		bool r6, false
		stb r6, aimbot.asm@l (r31) # reset toggle flag

_toggleChecker:
		cmpwi r7, false
		beq _resetFlag

		lbz r0, aimbot.asm+0x2@l (r31) # get flag
		cmpwi r0, false
		bne _skip
		bool r0, true
		stb r0, aimbot.asm+0x2@l (r31) # set flag

		get r12, _data + 0x820
		lwz r7, 0x25C (r12)
		cmpwi r7, false
		ble _end
		mtctr r7
		addi r9, %sp, push.progress * 0x4 + 0x8 # 96-bit space for XYZ-Axis.
		addi r8, %sp, push.progress * 0x4 + 0x10 # Karts Vector Array. stfsu adds 0x4. Stack starts at <stack pointer>+0x20.

_pushVectorIntoArray:
		mr r6, r7
		subi r7, r7, 1

		mr r3, r7
		call "object::KartInfoProxy::getKartUnit()"

		load r3, "0x14, 0x20C"
		call "object::KartInfoProxy::getPos()"
		lfs f5, 0 (r3) # Kart Global X-Axis.
		stfs f5, 0 (r9)
		lfs f5, 0x4 (r3) # Kart Global Y-Axis.
		stfs f5, 0x4 (r9)
		lfs f5, 0x8 (r3) # Kart Global Z-Axis.
		stfs f5, 0x8 (r9)

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::getPos()" # DRC Kart Global Coordinates.
		mr r4, r9
		call "ASM_VECDistance"

		stfsu f1, 0x4 (r8) # Push vector into the array.

		mtctr r6
		bdnz _pushVectorIntoArray

		getf f5, _rodata + 0x20B64 # Min Value (0)
		getf f8, _rodata + 0xD8D1C # Max Value (128)
		fmr f6, f8
		get r12, _data + 0x820
		lwz r7, 0x25C (r12)
		subi r9, r7, 1
		addi r8, %sp, push.progress * 0x4 + 0x14 # Karts Vector Array.
		mtctr r7

_searchNearestKartFromVectorArray:
		subi r7, r7, 1
		rlwinm r0, r7, 2, 0, 29

		lfsx f7, r8, r0 # Read vector from array.
		fcmpu cr0, f7, f5 # Exclude own kart.
		beq _invalidKart
		fcmpu cr0, f7, f6
		bge _invalidKart
		sub r5, r7, r9
		neg r5, r5
		fmr f6, f7

_invalidKart:
		bdnz _searchNearestKartFromVectorArray

		fcmpu cr0, f6, f8 # If no karts found > abort code.
		bge _resetToggle
		stw r5, aimbot.asm+0x4@l (r31)

_skip:
		lwz r3, aimbot.asm+0x4@l (r31)
		call "object::KartInfoProxy::getKartUnit()"
		load r3, "0x14, 0x20C"

		call "object::KartInfoProxy::getPos()" # Nearest Kart Global Coordinates.
		lfs f5, 0 (r3)
		lfs f7, 0x8 (r3)

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::getPos()" # DRC Kart Global Coordinates.
		mr r5, r3

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::isAntiG()"
		cmpwi r3, false
		bne _resetToggle
		lfs f8, 0 (r5)
		lfs f10, 0x8 (r5)
		fsubs f5, f8, f5
		fsubs f7, f10, f7
		fmuls f8, f5, f5
		fmuls f10, f7, f7
		fadds f1, f8, f10
		call "sqrtf"
		fdivs f8, f5, f1
		fdivs f10, f7, f1
		fneg f8, f8
		fneg f10, f10

		getf f9, _rodata + 0xC0 # Min Value (-1)
		fcmpu cr0, f8, f9
		ble _end # abort if NaN
		fcmpu cr0, f10, f9
		ble _end # abort if NaN

		stfs f8, 0x24C (r5)
		stfs f8, 0x258 (r5)
		stfs f8, 0x264 (r5)
		stfs f10, 0x254 (r5)
		stfs f10, 0x260 (r5)
		stfs f10, 0x26C (r5)
		b _end

_resetFlag:
		bool r0, false
		stb r0, aimbot.asm+0x2@l (r31) # reset flag
		b _resetTarget

_resetToggle:
		bool r0, false
		stw r0, aimbot.asm@l (r31) # reset flags

_resetTarget:
		int r0, null
		stw r0, aimbot.asm+0x4@l (r31)

_end:
		pop "r29, r30, r31"
		stack.restore
	.endfunc