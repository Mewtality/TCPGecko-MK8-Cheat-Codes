/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: InstantRecovery.s                          *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*    Player becomes immune to crushing and lightning. After getting hit, the     *
*                          player can react instantly.                           *
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
 **                            InstantRecovery
 *?  Calls a function that forces all negative ailments of a player to be
 *?  cleared.
 *========================================================================**/
InstantRecovery:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq InstantRecovery_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq InstantRecovery_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InstantRecovery_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InstantRecovery_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InstantRecovery_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r31, 0x4 (r3)

	lwz r3, 0x14 (r3)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isAccident"
	cmpwi r3, 0
	beq InstantRecovery_exit

	mr r3, r31
	GOTO_FUNC "object::KartVehicle::forceClearAccident"

InstantRecovery_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - InstantRecovery

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
