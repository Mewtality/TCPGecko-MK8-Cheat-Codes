/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: InstantRespawn.s                           *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*              Lakitu instantly places the player back on the map.               *
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
 **                             InstantRespawn
 *?  Patches a couple of pointers in the player data.
 *========================================================================**/
InstantRespawn:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq InstantRespawn_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq InstantRespawn_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq InstantRespawn_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq InstantRespawn_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt InstantRespawn_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
    lwz r12, 0x4 (r3)
    lwz r12, 0x4C (r12)
    lwz r12, 0x14 (r12)

	lwz r0, 0x34 (r12)
	stw r0, 0x1C (r12)

	lwz r0, 0x8C (r12) # object_KartJugemRecover_stateFinish
	stw r0, 0x6C (r12) # object_KartJugemRecover_stateReplay

InstantRespawn_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - InstantRespawn

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
