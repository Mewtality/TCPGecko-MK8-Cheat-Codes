/*********************************************************************************
*                               Author: Mewtality                                *
*                         File Name: AlwaysVictoryAnim.s                         *
*                            Creation Date: April 12                             *
*                             Last Updated: April 12                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                  Always have the victory character animation.                  *
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
 **                           AlwaysVictoryAnim
 *?  Forces the character victory animation.
 *========================================================================**/
AlwaysVictoryAnim:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq AlwaysVictoryAnim_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq AlwaysVictoryAnim_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq AlwaysVictoryAnim_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq AlwaysVictoryAnim_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt AlwaysVictoryAnim_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	lwz r0, 0x148 (r12)
	cmpwi r0, 0
	bne AlwaysVictoryAnim_exit

	lwz r3, 0x8 (r3)
	li r4, 0x1

	GOTO_FUNC "object::DriverKart::startGoalAnim"

AlwaysVictoryAnim_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - AlwaysVictoryAnim

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
