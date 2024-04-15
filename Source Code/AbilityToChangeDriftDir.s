/*********************************************************************************
*                               Author: Mewtality                                *
*                      File Name: AbilityToChangeDriftDir.s                      *
*                            Creation Date: April 11                             *
*                             Last Updated: April 11                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*         Steering the kart while drifting affects the drift direction.          *
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
 **                        AbilityToChangeDriftDir
 *?  Modifies the drift direction based on a emulation of a analog stick
 *?  position.
 *========================================================================**/
AbilityToChangeDriftDir:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq AbilityToChangeDriftDir_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq AbilityToChangeDriftDir_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq AbilityToChangeDriftDir_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq AbilityToChangeDriftDir_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt AbilityToChangeDriftDir_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	lis r0, 0
	stw r0, 0x8 (r1)
	lfs f5, 0x8 (r1)

	lfs r6, 0x104 (r12)
	fcmpu cr0, f6, f5
	beq AbilityToChangeDriftDir_exit

	lwz r12, 0x14 (r12)
	lwz r12, 0xEC (r12)
	stfs f6, 0x64 (r12)

AbilityToChangeDriftDir_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = $ - AbilityToChangeDriftDir

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
