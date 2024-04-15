/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: ItemRapidFire.s                           *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*       Automatically throw items when holding down the "use item" button.       *
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
 **                             ItemRapidFire
 *?  Sets a specific byte to 0.
 *========================================================================**/
ItemRapidFire:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq ItemRapidFire_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq ItemRapidFire_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq ItemRapidFire_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq ItemRapidFire_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt ItemRapidFire_exit

	lis r12, "ItemDirector"@ha
	lwz r12, "ItemDirector"@l (r12)
	lwz r12, 0x7B8 (r12)

	li r0, 0
	stbx r0, r12, r3

ItemRapidFire_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - ItemRapidFire

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif


	.word 0xC200, length2 >> 3 # Cafe code type "Patch ASM via LR [C2]".
	.long "object::ItemDirector::calcKeyInput_EachPlayer_" + 0x5A8

/**========================================================================
 **                         ItemRapidFire_Patcher
 *?  This code will be executed in:
 *?  "object::ItemDirector::calcKeyInput_EachPlayer_"
 *========================================================================**/
ItemRapidFire_Patcher:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)
	stw r31, 0x8 (r1)

	mr r31, r12

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart" 

	lis r12, "ItemDirector"@ha
	lwz r12, "ItemDirector"@l (r12)
	lwz r12, 0x7B0 (r12)

	add r12, r12, r3
	cmpw r12, r31
	bne ItemRapidFire_Patcher_restore
	li r5, 0
	b ItemRapidFire_Patcher_exit

ItemRapidFire_Patcher_restore:
	lbz r5, 0 (r31)

ItemRapidFire_Patcher_exit:
	lwz r31, 0x8 (r1)
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	mr r0, r5
	blr


length2 = ($ - ItemRapidFire_Patcher) + 0x4

.if length2 >> 1 % 0x4 == 0
	.space 0x4
.endif
