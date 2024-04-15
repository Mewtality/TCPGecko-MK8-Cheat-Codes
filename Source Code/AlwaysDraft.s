/*********************************************************************************
*                               Author: Mewtality                                *
*                            File Name: AlwaysDraft.s                            *
*                            Creation Date: April 11                             *
*                             Last Updated: April 11                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                           Always have draft effect.                            *
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
 **                              AlwaysDraft
 *?  Forces the kart into a draft.
 *========================================================================**/
AlwaysDraft:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq AlwaysDraft_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq AlwaysDraft_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq AlwaysDraft_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq AlwaysDraft_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt AlwaysDraft_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r31, 0x4 (r3)

	lwz r0, 0xFC (r31)
	clrlwi. r0, r0, 31
	beq AlwaysDraft_exit

	lwz r3, 0x14 (r3)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne AlwaysDraft_exit

	lwz r3, 0x14 (r31)
	lwz r3, 0xF0 (r3)
	li r4, 0x3
	li r5, 0x1
	li r6, 0x1
	GOTO_FUNC "object::KartVehicleDash::executeOneLevel"

AlwaysDraft_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - AlwaysDraft

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
