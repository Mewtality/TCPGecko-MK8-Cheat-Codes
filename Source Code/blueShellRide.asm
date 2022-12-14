/*
* File: blueShellRide.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func blueShellRide
		stackUpdate(1 + 3) # (Backup Non-Volatile Registers + Space For "object::ItemDirector::getPosKouraB()" 96-bit return value)
		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCPlayer("_end")
		mr r31, %a3

		lis %a3, itemDirector@ha
		lwz %a3, itemDirector@l (%a3)
		addi %a4, %sp, 0xC
		call("object::ItemDirector::getPosKouraB()")

		lwz %a0, 0x174 (r12)
		cmpw %a0, r31 # Is Item Holder DRC Player
		bne _end

		lwz %a0, 0x2C (r12)
		rlwinm. %a0, %a0, 16, 31, 31 # Is Item State
		bne _end

		dereference("raceManagement"), 0x4C
		rlwinm %a0, r31, 2, 0, 29
		lwzx r12, r12, %a0
		lwz %a0, 0x2C (r12)
		cmpwi %a0, 0 # Is First Place
		beq _end

		call("object::KartInfoProxy::getKartUnit()"), "mr %a3, r31"
		lwz %a3, 0x4 (%a3)
		lwz %a3, 0x14 (%a3)

		lfs f5, 0xC (%sp)
		stfs f5, 0x24 (%a3)

		lfs f5, 0x10 (%sp)
		stfs f5, 0x28 (%a3)

		lfs f5, 0x14 (%sp)
		stfs f5, 0x2C (%a3)

		call("object::KartVehicleMove::forceStop()")

_end:
		pop(31)
		stackReset()
	.endfunc