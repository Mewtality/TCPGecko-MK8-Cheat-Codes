/*
* File: teleporter.asm
* Author: Mewtality
* Date: Wednesday, October 5, 2022 @ 04:56:52 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	enabler = "X"
	holdToEnable = 0x20
	data = teleporter.asm

	.func teleporter
		stackUpdate(3)
		push(31); push(30); push(29)

		lis r31, data@h

		isRaceReady("_reset")
		isRaceState("_reset")

		getDRCKartUnit("_reset")
		lwz r30, 0x4 (%a3)
		lwz r29, 0x14 (%a3)

		call("object::KartInfoProxy::isJugemHang()"), "lwz %a3, 0x20C (r29)"
		cmpwi r3, 0
		bne _end

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (r30)"
		lwz %a3, 0x1A4 (%a3)
		lwz %a7, data@l (r31)

		isActivator("_else"), enabler

		cmpwi %a7, holdToEnable
		addi %a7, %a7, 0x1
		stw %a7, data@l (r31)
		beq savePos

		b _end

savePos:
		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (r29)"
		lfs f5, 0 (%a3) # Kart Global X-Axis.
		stfs f5, data+0x4@l (r31)
		lfs f5, 0x4 (%a3) # Kart Global Y-Axis.
		stfs f5, data+0x8@l (r31)
		lfs f5, 0x8 (%a3) # Kart Global Z-Axis.
		stfs f5, data+0xC@l (r31)
		lfs f5, 0x24C (%a3) # Kart Global X-Rotation.
		stfs f5, data+0x10@l (r31)
		lfs f5, 0x250 (%a3) # Kart Global Y-Rotation.
		stfs f5, data+0x14@l (r31)
		lfs f5, 0x254 (%a3) # Kart Global Z-Rotation.
		stfs f5, data+0x18@l (r31)
        b _end

_else:
		cmpwi %a7, 0
		beq _resetTimer
		cmpwi %a7, holdToEnable
		bge _resetTimer
		call("object::KartInfoProxy::getPos()"), "lwz %a3, 0x20C (r29)"

		lfs f5, data+0x4@l (r31)
		lfs f6, data+0x8@l (r31)
		lfs f7, data+0xC@l (r31)
		lfs f8, data+0x10@l (r31)
		lfs f9, data+0x14@l (r31)
		lfs f10, data+0x18@l (r31)

		lis r12, _rodata + 0x20B64@h
		lfs f11, _rodata + 0x20B64@l (r12) # Min Value

		fadds f12, f5, f6
		fadds f12, f12, f7
		fcmpu cr0, f12, f11
		beq _resetTimer

		stfs f5, 0 (%a3) # Kart Global X-Axis.
		stfs f6, 0x4 (%a3) # Kart Global Y-Axis.
		stfs f7, 0x8 (%a3) # Kart Global Z-Axis.
		stfs f8, 0x24C (%a3) # Kart Global X-Rotation.
		stfs f8, 0x258 (%a3) # Kart Global X-Rotation.
		stfs f8, 0x264 (%a3) # Kart Global X-Rotation.
		stfs f9, 0x250 (%a3) # Kart Global Y-Rotation.
		stfs f9, 0x25C (%a3) # Kart Global Y-Rotation.
		stfs f9, 0x268 (%a3) # Kart Global Y-Rotation.
		stfs f10, 0x254 (%a3) # Kart Global Z-Rotation.
		stfs f10, 0x260 (%a3) # Kart Global Z-Rotation.
		stfs f10, 0x26C (%a3) # Kart Global Z-Rotation.
		b _resetTimer

_reset:
		reset(data+0x4), 2
		reset(data+0x10), 2, true

_resetTimer:
		reset(data)

_end:
		pop(29); pop(30); pop(31)
		stackReset()
	.endfunc