/*********************************************************************************
*                               Author: Mewtality                                *
*                              File Name: RGBMap.s                               *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*       The main light source of maps cycles through red, green and blue.        *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "RGBCycler_Patcher_.text", 0x0ECA00DC
.equiv "FUN_0EC821E0", 0x0EC821E0 # OSBlockMove

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x150F0000; .float 0.015 # Cycle Speed
	.long 0x140F0000, 0x10014820 # Code specific data. (20 bytes)

	.word 0xC400, length >> 3 # Cafe code type "ASM String Writes [C4]".
	.long "RGBCycler_Patcher_.text"

/**========================================================================
 **                           RGBCycler_Patcher
 *?  Updates an array of RGB buffers.
 *@param1 r3 "RGB buffer" address
 *@param2 f1 "cycle speed" float
 *@return r3 "RGB buffer" address
 *========================================================================**/
RGBCycler_Patcher:
	lis r12, "RGBCycler_Patcher_.text" + (RGBCycler_Data - RGBCycler_Patcher)@ha
	lfs f5, "RGBCycler_Patcher_.text" + (RGBCycler_Data - RGBCycler_Patcher) + 0x4@l (r12)
	lfs f6, "RGBCycler_Patcher_.text" + (RGBCycler_Data - RGBCycler_Patcher)@l (r12)

	lwz r0, 0 (r3)
	cmplwi r0, 0x5
	bgtlr
	mulli r0, r0, 0x24
	lis r11, "RGBCycler_Patcher_.text" + (Case_RGBCycler_Patcher_ID - RGBCycler_Patcher)@h
	ori r11, r11, "RGBCycler_Patcher_.text" + (Case_RGBCycler_Patcher_ID - RGBCycler_Patcher)@l
	add r11, r11, r0
	mtctr r11
	bctr

Case_RGBCycler_Patcher_ID:
	lfs f0, 0x8 (r3)
	fadds f0, f0, f1
	fcmpu cr0, f0, f6
	blt RGBCycler_Patcher_R2Y_Resume
	li r0, 1
	fmr f0, f6
	stw r0, 0 (r3)

RGBCycler_Patcher_R2Y_Resume:
	stfs f0, 0x8 (r3)
	blr

	lfs f0, 0x4 (r3)
	fsubs f0, f0, f1
	fcmpu cr0, f0, f5
	bgt RGBCycler_Patcher_Y2G_Resume
	li r0, 2
	fmr f0, f5
	stw r0, 0 (r3)

RGBCycler_Patcher_Y2G_Resume:
	stfs f0, 0x4 (r3)
	blr

	lfs f0, 0xC (r3)
	fadds f0, f0, f1
	fcmpu cr0, f0, f6
	blt RGBCycler_Patcher_G2C_Resume
	li r0, 3
	fmr f0, f6
	stw r0, 0 (r3)

RGBCycler_Patcher_G2C_Resume:
	stfs f0, 0xC (r3)
	blr

	lfs f0, 0x8 (r3)
	fsubs f0, f0, f1
	fcmpu cr0, f0, f5
	bgt RGBCycler_Patcher_C2B_Resume
	li r0, 4
	fmr f0, f5
	stw r0, 0 (r3)

RGBCycler_Patcher_C2B_Resume:
	stfs f0, 0x8 (r3)
	blr

	lfs f0, 0x4 (r3)
	fadds f0, f0, f1
	fcmpu cr0, f0, f6
	blt RGBCycler_Patcher_B2M_Resume
	li r0, 5
	fmr f0, f6
	stw r0, 0 (r3)

RGBCycler_Patcher_B2M_Resume:
	stfs f0, 0x4 (r3)
	blr

	lfs f0, 0xC (r3)
	fsubs f0, f0, f1
	fcmpu cr0, f0, f5
	bgt RGBCycler_Patcher_M2R_Resume
	li r0, 0
	fmr f0, f5
	stw r0, 0 (r3)

RGBCycler_Patcher_M2R_Resume:
	stfs f0, 0xC (r3)
	blr

RGBCycler_Data:
	.float 1, 0


length = ($ - RGBCycler_Patcher) + 0x4

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif


	.word 0xC000, length2 >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                                RGB Map
 *?  Modifies the map lightning color.
 *@param1 r3 "code data" address
 *@param2 f1 "cycle speed" float
 *========================================================================**/
RGBMap:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x10 (r1)

	mr r31, r3
	fmr f31, f1

	lis r30, "RaceDirector"@ha
	lwz r30, "RaceDirector"@l (r30)
	cmpwi r30, 0
	beq RGBMap_Exit
	lwz r30, 0x328 (r30)
	cmpwi r30, 0
	beq RGBMap_Exit
	lwz r30, 0xA4 (r30)
	cmpwi r30, 0
	beq RGBMap_Exit
	lis r0, 0
	ori r0, r0, 0xA300
	lwzx r30, r30, r0
	cmpwi r30, 0
	beq RGBMap_Exit
	lwz r30, 0 (r30)
	cmpwi r30, 0
	beq RGBMap_Exit

	li r5, 0
	lis r6, 0x3F80
	stw r5, 0x8 (r1)
	stw r6, 0xC (r1)

	lhz r6, 0 (r31)
	subic. r6, r6, 0x1
	bge+ RGBMap_Update
	sth r6, 0 (r31)

	lfs f5, 0x8 (r1)
	lfs f6, 0xC (r1)

	stw r5, 0x4 (r31)
	stfs f6, 0x8 (r31)
	stfs f5, 0xC (r31)
	stfs f5, 0x10 (r31)

RGBMap_Update:
	GOTO_FUNC "sys::SystemEngine::getEngine"
	lwz r3, 0 (r3)
	lwz r3, 0x200 (r3)
	lwz r3, 0xCC (r3)
	rlwinm. r3, r3, 8, 31, 31
	bne RGBMap_Exit

	fmr f1, f31
	addi r3, r31, 0x4
	GOTO_FUNC "RGBCycler_Patcher_.text"

	addi r4, r3, 0x4
	addi r3, r30, 0xB4
	li r5, 0xC
	li r6, 0x1
	GOTO_FUNC "FUN_0EC821E0"

	lfs f5, 0xC (r1)
	fadds f5, f5, f5
	stfs f5, 0x108 (r30)

RGBMap_Exit:
	lwz r0, 0x14 (r1)
	mtlr r0
	addi r1, r1, 0x10
	blr


length2 = $ - RGBMap

.if length2 >> 1 % 0x4 == 0
	.space 0x4
.endif
