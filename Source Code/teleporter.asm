/*
* File: teleporter.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func teleporter
		stack.update 3
		push "r31, r30, r29"

		int r31, MK8Codes

		is.onRace false, "_reset"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _reset
		get.kart
		lwz r30, 0x4 (r3)
		lwz r29, 0x14 (r3)

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r30)
		get.kart.activator
		lwz r7, teleporter.asm@l (r31)

		is.activator false, "_else", "DRC.X"

		cmpwi r7, 0x20
		addi r7, r7, 0x1
		stw r7, teleporter.asm@l (r31)
		beq _savePos
		b _end

_savePos:
		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::getPos()"
		lfs f5, 0 (r3) # Kart Global X-Axis.
		stfs f5, teleporter.asm+0x4@l (r31)
		lfs f5, 0x4 (r3) # Kart Global Y-Axis.
		stfs f5, teleporter.asm+0x8@l (r31)
		lfs f5, 0x8 (r3) # Kart Global Z-Axis.
		stfs f5, teleporter.asm+0xC@l (r31)
		lfs f5, 0x24C (r3) # Kart Global X-Rotation.
		stfs f5, teleporter.asm+0x10@l (r31)
		lfs f5, 0x250 (r3) # Kart Global Y-Rotation.
		stfs f5, teleporter.asm+0x14@l (r31)
		lfs f5, 0x254 (r3) # Kart Global Z-Rotation.
		stfs f5, teleporter.asm+0x18@l (r31)
        b _end

_else:
		cmpwi r7, 0
		beq _resetTimer
		cmpwi r7, 0x20
		bge _resetTimer
		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::getPos()"

		lfs f5, teleporter.asm+0x4@l (r31)
		lfs f6, teleporter.asm+0x8@l (r31)
		lfs f7, teleporter.asm+0xC@l (r31)
		lfs f8, teleporter.asm+0x10@l (r31)
		lfs f9, teleporter.asm+0x14@l (r31)
		lfs f10, teleporter.asm+0x18@l (r31)

		getf f11, _rodata + 0x20B64 # Min Value

		fadds f12, f5, f6
		fadds f12, f12, f7
		fcmpu cr0, f12, f11
		beq _resetTimer

		stfs f5, 0 (r3) # Kart Global X-Axis.
		stfs f6, 0x4 (r3) # Kart Global Y-Axis.
		stfs f7, 0x8 (r3) # Kart Global Z-Axis.
		stfs f8, 0x24C (r3) # Kart Global X-Rotation.
		stfs f8, 0x258 (r3) # Kart Global X-Rotation.
		stfs f8, 0x264 (r3) # Kart Global X-Rotation.
		stfs f9, 0x250 (r3) # Kart Global Y-Rotation.
		stfs f9, 0x25C (r3) # Kart Global Y-Rotation.
		stfs f9, 0x268 (r3) # Kart Global Y-Rotation.
		stfs f10, 0x254 (r3) # Kart Global Z-Rotation.
		stfs f10, 0x260 (r3) # Kart Global Z-Rotation.
		stfs f10, 0x26C (r3) # Kart Global Z-Rotation.
		b _resetTimer

_reset:
		bool r0, false
		stw r0, teleporter.asm+0x4@l (r31)
		stw r0, teleporter.asm+0x8@l (r31)
		stw r0, teleporter.asm+0xC@l (r31)
		stw r0, teleporter.asm+0x10@l (r31)
		stw r0, teleporter.asm+0x14@l (r31)
		stw r0, teleporter.asm+0x18@l (r31)

_resetTimer:
		bool r0, false
		stw r0, teleporter.asm@l (r31)

_end:
		pop "r29, r30, r31"
		stack.restore
	.endfunc