/*
* File: bulletBillKiller.asm
* Author: Mewtality
* Date: 2022-09-07 13:08:18
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "LEFT_STICK_PRESS"

	.func bulletBillKiller
		stackUpdate(5)
	
		push(31); push(30); push(29); push(28)

		isRaceReady("_end")
		isRaceState("_end")
		isRacePaused("_end")

		getDRCPlayer("_end")
		mr r31, %a3

		call("object_KartInfoProxy_getKartUnit")
		lwz r30, 0x4 (%a3)
		lwz r29, 0x14 (%a3)

		call("object_KartInfoProxy_isJugemHang"), "lwz %a3, 0x20C (r29)"
		cmpwi %a3, 0
		bne _end

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r30)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_end"), enabler

		dereference("raceManagement"), 0x23C

		lwz %a5, 0x30 (r12)
		addi %a5, %a5, 0xC
		mulli %a6, r31, 0x6C
		lwzx %a0, %a5, %a6

		push(0)
		call("object_Sector_GetSector"), "addi %a3, %sp, push.GPR00"
		mr r28, %a3

		call("nn_nex_Platform_GetRandomNumber"), "lwz %a3, 0x3C (%a3)"

		rlwinm %a3, %a3, 2, 0, 29
		lwz r12, 0x40 (r28)
		lwzx r12, r12, %a3

		call("object_KartInfoProxy_getPos"), "lwz %a3, 0x20C (r29)"

		lfs f5, 0x74 (r12)
		stfs f5, 0 (%a3)

		lfs f5, 0x78 (r12)
		stfs f5, 0x4 (%a3)

		lfs f5, 0x7C (r12)
		stfs f5, 0x8 (%a3)

		lfs f5, 0x8C (r12)
		stfs f5, 0x24C (%a3)
		stfs f5, 0x258 (%a3)
		stfs f5, 0x264 (%a3)

		lfs f5, 0x90 (r12)
		stfs f5, 0x250 (%a3)
		stfs f5, 0x25C (%a3)
		stfs f5, 0x268 (%a3)

		lfs f5, 0x94 (r12)
		stfs f5, 0x254 (%a3)
		stfs f5, 0x260 (%a3)
		stfs f5, 0x26C (%a3)

_end:
		pop(28); pop(29); pop(30); pop(31)

		stackReset()
	.endfunc