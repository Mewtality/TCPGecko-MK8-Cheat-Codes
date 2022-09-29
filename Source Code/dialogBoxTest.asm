/*
* File: dialogBoxTest.asm
* Author: Mewtality
* Date: Thursday, September 29, 2022 @ 12:59:30 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	enabler = "R" | "ZR"

	data = dialogBoxTest.asm
	string[unicode], "mainBodyText", "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/common.bin", 0, 32
	string[unicode], "mainButtonText", "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/common.bin", 32, 6

	.func dialogBoxTest
_start:
		stackUpdate(2)
		push(30); push(31)

		lis r31, data@h

		isRaceReady("_resetFlag")
		isRaceState("_resetFlag")
		getDRCKartUnit("_resetFlag")
		lwz %a3, 0x4 (%a3)

		call("object::KartVehicleControl::getRaceController()"), "lwz %a3, 0x8 (%a3)"
		lwz %a3, 0x1A4 (%a3)

		isActivator("_resetFlag"), enabler
		setFlag("_end"), data

		prepareDialogPage(30)
		isDialogPageClosed("_resetFlag")

		requestDialogPage()

		printDialogBodyText getString("mainBodyText");
		printDialogButtonText getString("mainButtonText"); 

		b _end

_resetFlag:
		resetFlag(data)

_end:
		pop(30); pop(31)
		stackReset()
	.endfunc