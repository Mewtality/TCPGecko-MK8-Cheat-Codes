/*********************************************************************************
*                               Author: Mewtality                                *
*                             File Name: Moonjump.s                              *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                     Inverts the player's gravity at will.                      *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "Moonjump_Patcher_.text", 0x0ECA0000

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0xC4000001, "object::KartVehicleMove::calcMove" + 0x98 # Cafe code type "ASM String Writes [C4]".
	bl "Moonjump_Patcher_.text" - ("object::KartVehicleMove::calcMove" + 0x98)
	.long 0x0

	.word 0xC400, length >> 3 # Cafe code type "ASM String Writes [C4]".
	.long "Moonjump_Patcher_.text"

/**========================================================================
 **                            Moonjump_Patcher
 *?  This code will be executed in:
 *?  "object::KartVehicleMove::calcMove"
 *========================================================================**/
Moonjump_Patcher:
	addi r3, r1, 0x8 # Orinal Instruction.

	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)
	stw r31, 0x8 (r1)
	mr r31, r3

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq Moonjump_Patcher_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq Moonjump_Patcher_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq Moonjump_Patcher_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq Moonjump_Patcher_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt Moonjump_Patcher_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	lwz r0, 0x14 (r12)
	cmpw r0, r30
	bne Moonjump_Patcher_exit

	lwz r3, 0x8 (r12)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	li r6, 0x4000 # Activator (R)
	and r0, r6, r5
	cmpw r6, r0
	bne Moonjump_Patcher_exit

	lfs f5, 0x238 (r30)
	fneg f5, f5
	stfs f5, 0x238 (r30)

Moonjump_Patcher_exit:
	mr r3, r31
	lwz r31, 0x8 (r1)
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = ($ - Moonjump_Patcher) + 0x4

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
