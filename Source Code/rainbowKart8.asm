/*
* File: rainbowKart8.asm
* Author: Mewtality
* Date: Saturday, February 4, 2023 @ 03:49:36 PM
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#8315
*/

	.include "C:/devkitPro/devkitPPC/assembly/lib.S"

	import AMKP01, "symbols, macros"
	import myStuff, "MK8Codes"

	.func rainbowKart8
		stack.update 2
		push "r31, r30"

		is.onRace false, "_end"
		is.onPause true, "_end"

		int r31, MK8Codes

		get r12, _data + 0x7F2C
		cmpwi r12, 0
		beq _reset
		lwz r12, 0x328 (r12)
		cmpwi r12, 0
		beq _reset
		lwz r12, 0xA4 (r12)
		cmpwi r12, 0
		beq _reset
		lis r5, 0x1
		addi r5, r5, 0xA300@l
		lwzx r12, r12, r5
		cmpwi r12, 0
		beq _reset
		lwz r12, 0 (r12)
		cmpwi r12, 0
		beq _reset
		mr r30, r12

		getf f5, _rodata + 0x20B64 # Min Value
		getf f6, _rodata + 0xBC # Max Value

		lbz r5, rainbowKart8.asm@l (r31) # get flag
		cmpwi r5, false
		bne _skip
		bool r0, true
		stb r0, rainbowKart8.asm@l (r31) # set flag

		stfs f6, 0xB4 (r30)
		stfs f5, 0xB8 (r30)
		stfs f5, 0xBC (r30)

_skip:
		getf f7, _rodata + 0x112C # RGB Cycle Speed
		getf f8, _rodata + 0xB0 # Brightness

		lfs f9, 0xB4 (r30) # R
		lfs f10, 0xB8 (r30) # G
		lfs f11, 0xBC (r30) # B

		lbz r5, rainbowKart8.asm+0x1@l (r31)
		cmplwi r5, 0x5
		bgt _reset
		rlwinm r5, r5, 0x2, 0x0, 0x1D
		bl switchD_0_caseD
		mfspr r0, %lr
		add r0, r0, r5
		mtspr %ctr, r0
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
		int r0, 1
		b updateState

switchD_0_caseD_1:
		fsubs f9, f9, f7
		fcmpu cr0, f9, f5
		bgt _update
		int r0, 2
		b updateState

switchD_0_caseD_2:
		fadds f11, f11, f7
		fcmpu cr0, f11, f6
		ble _update
		int r0, 3
		b updateState

switchD_0_caseD_3:
		fsubs f10, f10, f7
		fcmpu cr0, f10, f5
		bgt _update
		int r0, 4
		b updateState

switchD_0_caseD_4:
		fadds f9, f9, f7
		fcmpu cr0, f9, f6
		ble _update
		int r0, 5
		b updateState

switchD_0_caseD_5:
		fsubs f11, f11, f7
		fcmpu cr0, f11, f5
		bgt _update
		int r0, 0

updateState:
		stb r0, rainbowKart8.asm+0x1@l (r31)

_update:
		stfs f8, 0x108 (r30)
		stfs f9, 0xB4 (r30)
		stfs f10, 0xB8 (r30)
		stfs f11, 0xBC (r30)
		b _end

_reset:
		bool r0, false
		sth r0, rainbowKart8.asm@l (r31) # reset flag

_end:
		pop "r31, r30"
		stack.restore
	.endfunc