/*********************************************************************************
*                               Author: Mewtality                                *
*                         File Name: UnlockEverything.s                          *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                 Unlocks everything. This does not include DLC.                 *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "FUN_0EC99040", 0x0EC99040 # OSBlockSet

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

.macro GOTO_GLUE_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctr
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                            UnlockEverything
 *?  Writes various flags that correspond to various unlockables.
 *========================================================================**/
UnlockEverything:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	GOTO_FUNC "sys::SystemEngine::getEngine"
	cmpwi r3, 0
	beq UnlockEverything_exit

	lwz r3, 0x2C8 (r3)
	lwz r4, 0xE4 (r3)
	lbz r4, 0x15C (r4)
	GOTO_FUNC "sys::SaveDataManager::getUserSaveDataPtr"
	lwz r31, 0x158 (r3)

	addi r3, r31, 0x4CC
	li r30, 5

UnlockEverything_FillChunks:
	li r4, 0xC
	bl UnlockEverything_FillUnlock
	addi r3, r3, 0x20
	subic. r30, r30, 0x1
	bne UnlockEverything_FillChunks

	addi r3, r31, 0x5CC
	li r30, 5

UnlockEverything_FillChunks2:
	li r4, 0xC
	bl UnlockEverything_FillUnlock
	addi r3, r3, 0x20
	subic. r30, r30, 0x1
	bne UnlockEverything_FillChunks2

	addi r3, r31, 0x1A28
	li r4, 0x8
	bl UnlockEverything_FillUnlock

	addi r3, r31, 0x1A50
	li r4, 0x1E
	bl UnlockEverything_FillUnlock

	addi r3, r31, 0x1A90
	li r4, 0x1A
	bl UnlockEverything_FillUnlock

	addi r3, r31, 0x1AD0
	li r4, 0x12
	bl UnlockEverything_FillUnlock

	addi r3, r31, 0x1B10
	li r4, 0xC
	bl UnlockEverything_FillUnlock

	addi r3, r31, 0x1B5A
	li r4, 0x5A
	bl UnlockEverything_FillUnlock

UnlockEverything_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr

/**========================================================================
 **                      UnlockEverything_FillUnlock
 *?  Writes "@param2" amount of flags starting at "@param1"
 *@param1 r3 "flag" address
 *@param2 r4 "length" int
 *@return r3 "flag" address
 *========================================================================**/
UnlockEverything_FillUnlock:
	mr r5, r4
	li r4, 0x03
	GOTO_GLUE_FUNC "FUN_0EC99040"

length = $ - UnlockEverything

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
