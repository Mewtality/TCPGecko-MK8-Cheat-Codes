/*
* File: freefly.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func freefly
		stack.update 3
		push "r31, r30, r29"

		int r29, MK8Codes

		is.onRace false, "_reset"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _reset
		get.kart
		lwz r31, 0x4 (r3)
		lwz r30, 0x14 (r3)

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _reset

		lwz r3, 0x8 (r31)
		call "object::KartVehicleControl::getRaceController()"
		lfs f5, 0x110 (r3) # Current Touch Screen X
		lfs f6, 0x114 (r3) # Current Touch Screen Y
		load r3, "0x1A4"

		activator = DRC.SCREEN.P
		lis r5, activator@h
		ori r5, r5, activator@l
		and r6, r3, r5
		cmpw r5, r6
		bne _reset

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isAntiG()"
		cmpwi r3, false
		bne _reset

		lwz r3, 0x14 (r31)
		call "object::KartVehicleMove::forceStop()"

		lfs f10, freefly.asm@l (r29) # 1 Frame Old Touch Screen X
		lfs f11, freefly.asm+0x4@l (r29) # 1 Frame Old Touch Screen Y

		stfs f5, freefly.asm@l (r29)
		stfs f6, freefly.asm+0x4@l (r29)

		getf f0, _rodata + 0x20B64 # Min Value

		fcmpu cr0, f10, f0
		beq _end

		fsubs f10, f5, f10 # Current - Old X = Velocity X
		fsubs f11, f6, f11 # Current - Old Y = Velocity Y

		getf f0, _rodata + 0x2654 # Velocity Multiplier

		fmuls f10, f10, f0
		fmuls f11, f11, f0

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::getPos()"
		lfs f7, 0 (r3) # Kart X
		lfs f9, 0x8 (r3) # Kart Z
		fadds f7, f7, f10
		fadds f9, f9, f11

		stfs f7, 0 (r3)
		stfs f9, 0x8 (r3)

		getf f5, _rodata + 0x20B64
		getf f6, _rodata + 0xC0

		stfs f5, 0x24C (r3)
		stfs f5, 0x258 (r3)
		stfs f5, 0x264 (r3)
		stfs f5, 0x250 (r3)
		stfs f5, 0x25C (r3)
		stfs f5, 0x268 (r3)
		stfs f6, 0x254 (r3)
		stfs f6, 0x260 (r3)
		stfs f6, 0x26C (r3)
		b _end

_reset:
		int r0, 0
		stw r0, freefly.asm@l (r29) # Reset 1 Frame Old Touch Screen X
		stw r0, freefly.asm+0x4@l (r29) # Reset 1 Frame Old Touch Screen Y

_end:
		pop "r29, r30, r31"
		stack.restore
	.endfunc