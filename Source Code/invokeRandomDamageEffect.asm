/*
* File: invokeRandomDamageEffect.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"

	.func invokeRandomDamageEffect
		stack.update 2
		push "r31, r30"

		is.onRace false, "_end"

		get.DRC.ID
		cmplwi r3, 0xB
		bgt _end
		get.kart
		lwz r31, 0x4 (r3)
		lwz r30, 0x14 (r3)

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isJugemHang()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x20C (r30)
		call "object::KartInfoProxy::isKiller()"
		cmpwi r3, false
		bne _end

		lwz r3, 0x8 (r31)
		get.kart.activator

		is.activator false, "_end", "DRC.FLICK.U"

		int r5, 0x4000
		lwz r6, 0x144 (r31)
		or r5, r5, r6
		rlwinm. r6, r6, 0x12, 0x1F, 0x1F
		bne _end
		stw r5, 0x144 (r31)

		int r3, 0x14
		call "nn::nex::Platform::GetRandomNumber()"
		stw r3, 0x298 (r30)

		lwz r12, 0x20 (r31)
		
		int r0, 0
		stw r0, 0x1C (r12)
		stw r3, 0xC (r12)

_end:
		pop "r30, r31"
		stack.restore
	.endfunc