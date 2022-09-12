/*
* File: respawnAtCommand.asm
* Author: Mewtality
* Date: 2022-09-07 15:46:19
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	# SETTINGS
	enabler = "SELECT"

	.func respawnAtCommand
		stackUpdate(1)

		push(31)

		isRaceReady("_end")
		isRaceState("_end")

		getDRCKartUnit("_end")
		lwz r31, 0x4 (%a3)

		call("object_KartVehicleControl_getRaceController"), "lwz %a3, 0x8 (r31)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_end"), enabler

		call("object_KartJugemRecover_startRecover"), "lwz r3, 0x4C (r31)"

_end:
		pop(31)

		stackReset()
	.endfunc