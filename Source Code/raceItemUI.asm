/*
* File: raceItemUI.asm
* Author: Mewtality
* Date: 2022-09-05 10:58:04
* YouTube: https://www.youtube.com/c/Mewtality
* Discord: Mewtality#0666
*/

	.include "C:/devkitPro/devkitPPC/assembly/common.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/tools.S"
	.include "C:/devkitPro/devkitPPC/assembly/titles/AMKP01/codes.S"

	# SETTINGS
	codehandler = "v2.51.custom"
	isRawASM = false

	# CODE START
	IOStart(), 0

		lis r31, blank.asm@h

		isRaceReady("_reset")
		isRacePaused("IOEnd")

		getDRCUIRaceWindow("IOEnd")

		getUIRaceItem()

		li %a5, 0 # Min Value
		li %a6, 0xFF # Max Value

		li %r9, 0x7F # Alpha

		lbz %a0, blank.asm@l (r31)
		cmpwi %a0, 0
		bne _skip
		stb %a6, blank.asm@l (r31)

		stb %a6, UIRaceItem.image.blendRGBA.gradient.TL (r12) # R
		sth %a5, UIRaceItem.image.blendRGBA.gradient.TL+1 (r12) # GB
		stb %a6, UIRaceItem.image.blendRGBA.gradient.TL+3 (r12) # A

		stb %a5, UIRaceItem.image.blendRGBA.gradient.TR (r12) # R
		stb %a6, UIRaceItem.image.blendRGBA.gradient.TR+1 (r12) # G
		stb %a5, UIRaceItem.image.blendRGBA.gradient.TR+2 (r12) # B
		stb %a6, UIRaceItem.image.blendRGBA.gradient.TR+3 (r12) # A

		sth %a5, UIRaceItem.image.blendRGBA.gradient.BL (r12) # RG
		stb %a6, UIRaceItem.image.blendRGBA.gradient.BL+2 (r12) # B
		stb %r9, UIRaceItem.image.blendRGBA.gradient.BL+3 (r12) # A

		stb %a6, UIRaceItem.image.blendRGBA.gradient.BR (r12) # R
		sth %a5, UIRaceItem.image.blendRGBA.gradient.BR+1 (r12) # GB
		stb %r9, UIRaceItem.image.blendRGBA.gradient.BR+3 (r12) # A

_skip:
		lbz %a0, blank.asm+1@l (r31)
		cmplwi %a0, 0x5
		bgt _reset
		rlwinm %r8, %a0, 0x2, 0x0, 0x1D
		bl switchD_0_caseD
		mfspr r11, %lr
		add r11, r11, %r8
		mtspr %ctr, r11
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
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL+1 (r12)
		addi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR+1 (r12)

		cmpw %a7, %a6
		bne IOEnd
		li %a0, 1
		b updateState

switchD_0_caseD_1:
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL (r12)
		subi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR (r12)

		cmpw %a7, %a5
		bne IOEnd
		li %a0, 2
		b updateState

switchD_0_caseD_2:
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL+2 (r12)
		addi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR+2 (r12)

		cmpw %a7, %a6
		bne IOEnd
		li %a0, 3
		b updateState

switchD_0_caseD_3:
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL+1 (r12)
		subi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR+1 (r12)

		cmpw %a7, %a5
		bne IOEnd
		li %a0, 4
		b updateState

switchD_0_caseD_4:
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL (r12)
		addi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR (r12)

		cmpw %a7, %a6
		bne IOEnd
		li %a0, 5
		b updateState

switchD_0_caseD_5:
		lbz %a7, UIRaceItem.image.blendRGBA.gradient.TL+2 (r12)
		subi %a7, %a7, 0x1
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TL+2 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.TR (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BL+1 (r12)
		stb %a7, UIRaceItem.image.blendRGBA.gradient.BR+2 (r12)

		cmpw %a7, %a5
		bne IOEnd
		li %a0, 0
		b updateState

_reset:
		li %a0, 0
		stb %a0, blank.asm@l (r31)

updateState:
		stb %a0, blank.asm+0x1@l (r31)

	IOEnd()