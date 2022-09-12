/*
* File: forceDRCFullscreen.asm
* Author: Mewtality
* Date: 2022-09-07 14:50:52
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func forceDRCFullscreen
		stackUpdate(1)

        push(31)

		isRaceReady("_end")
		isRacePaused("_end")

		getDRCPlayer("_end")
		dereference("GUIManagement"), 0x10, 0x4, 0x1A0
        lwz %a3, 0x2BC (r12)
        cmpwi %a3, 0
        beq _end
        mr r31, %a3

        li r4, 0
        li r5, 0
        li r6, 1
        call("ui_Control_RaceDRC_setPushButton")
        mr %a3, r31
		call("ui_Control_RaceDRC_forceSetFullScreen")
        mr %a3, r31
        call("ui_Control_RaceDRC_quitDRCButtons")

_end:
        pop(31)

		stackReset()
	.endfunc