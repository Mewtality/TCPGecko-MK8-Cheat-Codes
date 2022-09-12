/*
* File: bestPlayStats.asm
* Author: Mewtality
* Date: 2022-09-07 11:39:14
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"

	.func bestPlayStats
		stackUpdate(0)

		call("sys_SystemEngine_getEngine")
		cmpwi %a3, 0x0
		beq _end
		lwz %a3, 0x2C8 (%a3)
		lwz %a4, 0xE4 (%a3)
		lbz %a4, 0x15C (%a4)
		call("sys_SaveDataManager_getUserSaveDataPtr")
		lwz r12, 0x158 (%a3)

		lis %a0, 0x98967F@h
		ori %a0, %a0, 0x98967F@l
		stw %a0, 0x14E8 (r12)
		stw %a0, 0x14F0 (r12)
		stw %a0, 0x14F4 (r12)
		stw %a0, 0x14FC (r12)
		stw %a0, 0x1500 (r12)
		stw %a0, 0x1504 (r12)
		stw %a0, 0x1A18 (r12)

		li %a0, 0
		stw %a0, 0x1508 (r12)
		stw %a0, 0x1A1C (r12)

		lis %a0, 0x1869F@h
		ori %a0, %a0, 0x1869F@l
		stw %a0, 0x1A20 (r12)
		stw %a0, 0x1A24 (r12)

_end:
		stackReset()
	.endfunc