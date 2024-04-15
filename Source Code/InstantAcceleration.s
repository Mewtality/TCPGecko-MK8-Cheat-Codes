/*********************************************************************************
*                               Author: Mewtality                                *
*                        File Name: InstantAcceleration.s                        *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*              The player will accelerate to max speed immediately.              *
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
 **                          InstantAcceleration
 *?  Sets the kart speed to a specific value.
 *========================================================================**/
InstantAcceleration:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq InstantAcceleration_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq InstantAcceleration_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InstantAcceleration_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InstantAcceleration_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InstantAcceleration_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"

	lwz r3, 0x4 (r3)
	lwz r5, 0xFC (r3)
	clrlwi r5, r5, 30

	lwz r3, 0x14 (r3)

	cmpwi r5, 0x1
	beq InstantAcceleration_getMaxAcceleration
	cmpwi r5, 0x2
	beq InstantAcceleration_getMinAcceleration
	cmpwi r5, 0x3
	beq InstantAcceleration_fullStop
	b InstantAcceleration_exit

InstantAcceleration_getMaxAcceleration:
	lfs f5, 0x2E8 (r3)
	lfs f1, 0x3B8 (r3)
	fcmpu cr0, f5, f1
	bgt InstantAcceleration_exit
	b InstantAcceleration_updateKartSpeed

InstantAcceleration_getMinAcceleration:
	lis r0, 0xC080
	b InstantAcceleration_setImmediateFloat

InstantAcceleration_fullStop:
	lis r0, 0

InstantAcceleration_setImmediateFloat:
	stw r0, 0x8 (r1)
	lfs f1, 0x8 (r1)

InstantAcceleration_updateKartSpeed:
	GOTO_FUNC "object::KartVehicleMove::setSpeed"

InstantAcceleration_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = $ - InstantAcceleration

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
