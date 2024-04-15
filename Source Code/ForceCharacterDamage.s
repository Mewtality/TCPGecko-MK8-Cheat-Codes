/*********************************************************************************
*                               Author: Mewtality                                *
*                       File Name: ForceCharacterDamage.s                        *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*             It forces a random damage animation to occur at will.              *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x02000000 # "Activator" (Flick Down)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                          ForceCharacterDamage
 *?  Forces the player to get damaged.
 *========================================================================**/
ForceCharacterDamage:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq ForceCharacterDamage_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq ForceCharacterDamage_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq ForceCharacterDamage_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq ForceCharacterDamage_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq ForceCharacterDamage_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt ForceCharacterDamage_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r30, 0x4 (r3)
	lwz r29, 0x14 (r3)

	lwz r3, 0x20C (r29)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne ForceCharacterDamage_exit

	lwz r3, 0x20C (r29)
	GOTO_FUNC "object::KartInfoProxy::isKiller"
	cmpwi r3, 0
	bne ForceCharacterDamage_exit

	lwz r3, 0x8 (r30)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r0, r31, r5
	cmpw r0, r31
	bne ForceCharacterDamage_exit

	li r5, 0x4000
	lwz r6, 0x144 (r30)
	or r5, r5, r6
	rlwinm. r6, r6, 0x12, 0x1F, 0x1F
	bne ForceCharacterDamage_exit
	stw r5, 0x144 (r30)

	li r3, 0x14
	GOTO_FUNC "nn::nex::Platform::GetRandomNumber"
	stw r3, 0x298 (r29)

	lwz r12, 0x20 (r30)

	li r0, 0
	stw r0, 0x1C (r12)
	stw r3, 0xC (r12)

ForceCharacterDamage_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - ForceCharacterDamage

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
