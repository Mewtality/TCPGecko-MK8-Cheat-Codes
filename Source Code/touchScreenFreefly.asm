/*
* File: freefly.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	.func freefly
		stackUpdate(3)
		push(31); push(30); push(29)

		lis r29, freefly.asm@h

		isRaceReady("_reset")
		isRaceState("_reset")

		getDRCKartUnit("_reset")
		lwz r31, 0x4 (%a3)
		lwz r30, 0x14 (%a3)

		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (r30)"
		cmpwi r3, 0
		bne _reset

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r31)"
		lfs f5, 0x110 (%a3) # Current Touch Screen X
		lfs f6, 0x114 (%a3) # Current Touch Screen Y
		lwz %a3, 0x1A4 (%a3)

		isActivator("_reset"), "TOUCH_SCREEN"

		call("object::KartInfoProxy::isAntiG()"), "lwz %a3, 0x20C (r30)"
		cmpwi %a3, 0
		bne _reset

		call("object::KartVehicleMove::forceStop()"), "lwz %a3, 0x14 (r31)"

		lfs f10, freefly.asm@l (r29) # 1 Frame Old Touch Screen X
		lfs f11, freefly.asm+0x4@l (r29) # 1 Frame Old Touch Screen Y

		stfs f5, freefly.asm@l (r29)
		stfs f6, freefly.asm+0x4@l (r29)

		lis r12, _rodata + 0x20B64@h
		lfs f0, _rodata + 0x20B64@l (r12) # Min Value

		fcmpu cr0, f10, f0
		beq _end

		fsubs f10, f5, f10 # Current - Old X = Velocity X
		fsubs f11, f6, f11 # Current - Old Y = Velocity Y

		lis r12, _rodata + 0x2654@h
		lfs f0, _rodata + 0x2654@l (r12) # Velocity Multiplier

		fmuls f10, f10, f0
		fmuls f11, f11, f0

		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (r30)"
		lfs f7, 0 (%a3) # Kart X
		lfs f9, 0x8 (%a3) # Kart Z
		fadds f7, f7, f10
		fadds f9, f9, f11

		stfs f7, 0 (%a3)
		stfs f9, 0x8 (%a3)

		lis r12, _rodata + 0x20B64@h
		lfs f5, _rodata + 0x20B64@l (r12)
		lis r12, _rodata + 0xC0@h
		lfs f6, _rodata + 0xC0@l (r12)

		stfs f5, 0x24C (%a3)
		stfs f5, 0x258 (%a3)
		stfs f5, 0x264 (%a3)
		stfs f5, 0x250 (%a3)
		stfs f5, 0x25C (%a3)
		stfs f5, 0x268 (%a3)
		stfs f6, 0x254 (%a3)
		stfs f6, 0x260 (%a3)
		stfs f6, 0x26C (%a3)
		b _end

_reset:
		li %a0, 0
		stw %a0, freefly.asm@l (r29) # Reset 1 Frame Old Touch Screen X
		stw %a0, freefly.asm+0x4@l (r29) # Reset 1 Frame Old Touch Screen Y

_end:
		pop(29); pop(30); pop(31)
		stackReset()
	.endfunc