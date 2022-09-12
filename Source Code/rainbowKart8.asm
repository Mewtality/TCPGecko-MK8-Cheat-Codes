/*
* File: rainbowKart8.asm
* Author: Mewtality
* Date: 2022-09-07 15:40:30
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	brightness = _rodata + 0xB0
	RGBSpeed = _rodata + 0x112C

	.func rainbowKart8
		stackUpdate(2)

		push(31); push(30)

		isRacePaused("_end")

		lis r31, rainbowKart8.asm@h

		dereference("raceManagement")
		cmpwi r12, 0
		beq _reset
		lwz r12, 0x328 (r12)
		cmpwi r12, 0
		beq _reset
		lwz r12, 0xA4 (r12)
		cmpwi r12, 0
		beq _reset
		lis %a5, 0x1
		addi %a5, %a5, 0xA300@l
		lwzx r12, r12, %a5
		cmpwi r12, 0
		beq _reset
		lwz r12, 0 (r12)
		cmpwi r12, 0
		beq _reset
		mr r30, r12

		lis r12, _rodata + 0x20B64@h
		lfs f5, _rodata + 0x20B64@l (r12) # Min Value

		lis r12, _rodata + 0xBC@h
		lfs f6, _rodata + 0xBC@l (r12) # Max Value

		lbz %a5, rainbowKart8.asm@l (r31)
		cmpwi %a5, 0
		bne _skip
		li %a0, 0x1
		stb %a0, rainbowKart8.asm@l (r31)

		stfs f6, 0xB4 (r30)
		stfs f5, 0xB8 (r30)
		stfs f5, 0xBC (r30)

_skip:
		lis r12, RGBSpeed@h
		lfs f7, RGBSpeed@l (r12) # RGB Cycle Speed

		lis r12, brightness@h
		lfs f8, brightness@l (r12) # Brightness

		lfs f9, 0xB4 (r30) # R
		lfs f10, 0xB8 (r30) # G
		lfs f11, 0xBC (r30) # B

		lbz %a5, rainbowKart8.asm+0x1@l (r31)
		cmplwi %a5, 0x5
		bgt _reset
		rlwinm %a5, %a5, 0x2, 0x0, 0x1D
		bl switchD_0_caseD
		mfspr %a0, %lr
		add %a0, %a0, %a5
		mtspr %ctr, %a0
		bctr

switchD_0_caseD:
		blrl
		b switchD_0_caseD_0
		b switchD_0_caseD_1
		b switchD_0_caseD_2
		b switchD_0_caseD_3
		b switchD_0_caseD_4
		b switchD_0_caseD_5

switchD_0_caseD_0:
		fadds f10, f10, f7
		fcmpu cr0, f10, f6
		ble _update
		li %a0, 1
		b updateState

switchD_0_caseD_1:
		fsubs f9, f9, f7
		fcmpu cr0, f9, f5
		bgt _update
		li %a0, 2
		b updateState

switchD_0_caseD_2:
		fadds f11, f11, f7
		fcmpu cr0, f11, f6
		ble _update
		li %a0, 3
		b updateState

switchD_0_caseD_3:
		fsubs f10, f10, f7
		fcmpu cr0, f10, f5
		bgt _update
		li %a0, 4
		b updateState

switchD_0_caseD_4:
		fadds f9, f9, f7
		fcmpu cr0, f9, f6
		ble _update
		li %a0, 5
		b updateState

switchD_0_caseD_5:
		fsubs f11, f11, f7
		fcmpu cr0, f11, f5
		bgt _update
		li %a0, 0

updateState:
		stb %a0, rainbowKart8.asm+0x1@l (r31)

_update:
		stfs f8, 0x108 (r30)
		stfs f9, 0xB4 (r30)
		stfs f10, 0xB8 (r30)
		stfs f11, 0xBC (r30)
		b _end

_reset:
		li %a0, 0
		sth %a0, rainbowKart8.asm@l (r31)

_end:
		pop(30); pop(31)

		stackReset()
	.endfunc