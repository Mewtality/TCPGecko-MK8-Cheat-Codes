/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: BestPlayStats.s                           *
*                            Creation Date: April 12                             *
*                             Last Updated: April 12                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*            Play stats are modified to the best possible play stats.            *
*********************************************************************************/

.include "./Turbo.rpx.s"

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                             BestPlayStats
 *?  Rewrites various memory addresses that correspond to save data.
 *========================================================================**/
BestPlayStats:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	GOTO_FUNC "sys::SystemEngine::getEngine"
	cmpwi r3, 0
	beq BestPlayStats_Exit

	lwz r3, 0x2C8 (r3)
	lwz r4, 0xE4 (r3)
	lbz r4, 0x15C (r4)
	GOTO_FUNC "sys::SaveDataManager::getUserSaveDataPtr"
	lwz r3, 0x158 (r3)

	lis r0, 9999999@h
	ori r0, r0, 9999999@l
	stw r0, 0x14E8 (r3)
	stw r0, 0x14F0 (r3)
	stw r0, 0x14F4 (r3)
	stw r0, 0x14FC (r3)
	stw r0, 0x1500 (r3)
	stw r0, 0x1504 (r3)
	stw r0, 0x1A18 (r3)

	li r0, 0
	stw r0, 0x1508 (r3)
	stw r0, 0x1A1C (r3)

	lis r0, 99999@h
	ori r0, r0, 99999@l
	stw r0, 0x1A20 (r3)
	stw r0, 0x1A24 (r3)

BestPlayStats_Exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - BestPlayStats

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
