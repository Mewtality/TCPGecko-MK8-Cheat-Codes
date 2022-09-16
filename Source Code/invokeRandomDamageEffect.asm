/*
* File: invokeRandomDamageEffect.asm
* Author: Mewtality
* Date: 2022-09-16 10:48:40
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	enabler = "SHAKE_DOWN"

	.func invokeRandomDamageEffect
		stackUpdate(2)
		push(31); push(30)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)
		lwz r30, 0x14 (%a3)

		call("object_KartInfoProxy_isJugemHang"), "lwz %a3, 0x20C (r30)"
		cmpwi r3, 0
		bne _end

		call("object_KartInfoProxy_isKiller"), "lwz %a3, 0x20C (r30)"
		cmpwi r3, 0
		bne _end

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_end"), enabler

		li %a5, 0x4000
		lwz %a6, 0x144 (r31)
		or %a5, %a5, %a6
		rlwinm. %a6, %a6, 0x12, 0x1F, 0x1F
		bne _end
		stw %a5, 0x144 (r31)

		call("nn_nex_Platform_GetRandomNumber"), "li %a3, 0x14"
		stw %a3, 0x298 (r30)

		lwz r12, 0x20 (r31)
		li %a0, 0
		stw %a0, 0x1C (r12)
		stw %a3, 0xC (r12)

_end:
		pop(30); pop(31)
		stackReset()
	.endfunc