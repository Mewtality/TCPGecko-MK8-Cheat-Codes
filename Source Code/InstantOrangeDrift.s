/*********************************************************************************
*                               Author: Mewtality                                *
*                        File Name: InstantOrangeDrift.s                         *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*  When the player drifts the kart, the orange drift is immediately triggered.   *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "FUN_0E35AB84", 0x0E35AB84

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                           InstantOrangeDrift
 *?  Adds a large value to the drift counter?
 *========================================================================**/
InstantOrangeDrift:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq InstantOrangeDrift_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq InstantOrangeDrift_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InstantOrangeDrift_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InstantOrangeDrift_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InstantOrangeDrift_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	lis r0, 0x447A
	stw r0, 0x8 (r1)

	lfs f1, 0x8 (r1)
	lwz r3, 0x14 (r12)
	GOTO_FUNC "FUN_0E35AB84"

InstantOrangeDrift_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = $ - InstantOrangeDrift

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
