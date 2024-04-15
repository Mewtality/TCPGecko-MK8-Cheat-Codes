/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: InfiniteItems.s                           *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*   After the player uses an item, the item roulette will begin to spin again.   *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "ItemDirector", 0x1068A73C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                             InfiniteItems
 *?  Forces the item roulette to spin again if the player has no items.
 *========================================================================**/
InfiniteItems:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq InfiniteItems_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq InfiniteItems_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InfiniteItems_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InfiniteItems_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InfiniteItems_exit

	mr r4, r3
	lis r3, "ItemDirector"@ha
	lwz r3, "ItemDirector"@l (r3)
	GOTO_FUNC "object::ItemDirector::slot_StartSlot"

InfiniteItems_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - InfiniteItems

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
