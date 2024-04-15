/*********************************************************************************
*                               Author: Mewtality                                *
*                         File Name: AlwaysStarPowerUp.s                         *
*                            Creation Date: April 12                             *
*                             Last Updated: April 12                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                           Always have star powerup.                            *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "FUN_0E342CA0", 0x0E342CA0

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                           AlwaysStarPowerUp
 *?  Forces the kart into star powerup.
 *========================================================================**/
AlwaysStarPowerUp:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq AlwaysStarPowerUp_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq AlwaysStarPowerUp_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq AlwaysStarPowerUp_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq AlwaysStarPowerUp_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt AlwaysStarPowerUp_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r3, 0x4 (r3)

	GOTO_FUNC "FUN_0E342CA0"

AlwaysStarPowerUp_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - AlwaysStarPowerUp

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
