/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: InstantFinish.s                           *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                           The race ends right away.                            *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                             InstantFinish
 *?  Forces the race to end.
 *========================================================================**/
InstantFinish:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r31, "RaceDirector"@ha
	lwz r31, "RaceDirector"@l (r31)
	cmpwi r31, 0
	beq InstantFinish_exit
	lwz r12, 0x23C (r31)
	cmpwi r12, 0
	beq InstantFinish_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InstantFinish_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InstantFinish_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InstantFinish_exit

	lwz r12, 0x4C (r31)
	slwi r0, r3, 2

	li r4, 0
	lwzx r3, r12, r0
	GOTO_FUNC "object::RaceKartChecker::forceGoal"

InstantFinish_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - InstantFinish

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
