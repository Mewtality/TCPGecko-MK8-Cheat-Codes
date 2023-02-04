/*
* File: bulletBillKiller.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func bulletBillKiller
		stack.update 5
		push "r31, r30, r29, r28"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		mr r31, r3

		get.kart
		lwz r30, 0x4 (r3)
		lwz r29, 0x14 (r3)

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r30)
		get.kart.activator

		is.activator false, "_end", "DRC.LSTICK.P"

		get r12, _data + 0x7F2C
		load r12, "0x23C"

		lwz r5, 0x30 (r12)
		addi r5, r5, 0xC
		mulli r6, r31, 0x6C
		lwzx r0, r5, r6

		stw r0, push.progress * 0x4 + 0x8 (%sp)
		addi r3, %sp, push.progress * 0x4 + 0x8
		call "object::Sector_GetSector()"
		mr r28, r3

		load r3, "0x3C"
		call "nn::nex::Platform::GetRandomNumber()"

		rlwinm r3, r3, 2, 0, 29
		lwz r12, 0x40 (r28)
		lwzx r12, r12, r3

		lwz r3, 0x20C (r29)
		call "object::KartInfoProxy::getPos()"

		lfs f5, 0x74 (r12)
		stfs f5, 0 (r3)

		lfs f5, 0x78 (r12)
		stfs f5, 0x4 (r3)

		lfs f5, 0x7C (r12)
		stfs f5, 0x8 (r3)

		lfs f5, 0x8C (r12)
		stfs f5, 0x24C (r3)
		stfs f5, 0x258 (r3)
		stfs f5, 0x264 (r3)

		lfs f5, 0x90 (r12)
		stfs f5, 0x250 (r3)
		stfs f5, 0x25C (r3)
		stfs f5, 0x268 (r3)

		lfs f5, 0x94 (r12)
		stfs f5, 0x254 (r3)
		stfs f5, 0x260 (r3)
		stfs f5, 0x26C (r3)

_end:
		pop "r28, r29, r30, r31"
		stack.restore
	.endfunc