/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: Always5Balloons.s                          *
*                            Creation Date: April 11                             *
*                             Last Updated: April 11                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                     Always have 5 balloons in battle mode.                     *
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
 **                            Always5Balloons
 *?  Forces the amount of balloons the player is holding to 5.
 *========================================================================**/
Always5Balloons:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r31, "RaceDirector"@ha
	lwz r31, "RaceDirector"@l (r31)
	cmpwi r31, 0
	beq Always5Balloons_exit
	lwz r31, 0x23C (r31)
	cmpwi r31, 0
	beq Always5Balloons_exit
	lbz r0, 0x3E (r31)
	cmpwi r0, 0
	beq Always5Balloons_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq Always5Balloons_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt Always5Balloons_exit
	mr r4, r3

	addi r12, r31, 0x80
	slwi r3, r3, 2

	lwzx r3, r12, r3
	GOTO_FUNC "object::RaceKartCheckerBattle::incBalloon"

Always5Balloons_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - Always5Balloons

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
