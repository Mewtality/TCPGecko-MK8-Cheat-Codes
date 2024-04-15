/*********************************************************************************
*                               Author: Mewtality                                *
*                        File Name: PiranhaPlantAtWill.s                         *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*        The player gains the ability to summon a piranha plant at will.         *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00000020 # "Activator" (ZR)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                           PiranhaPlantAtWill
 *?  Calls a function to spawn the piranha plant on the player when certain
 *?  criteria has been met.
 *========================================================================**/
PiranhaPlantAtWill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq PiranhaPlantAtWill_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq PiranhaPlantAtWill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq PiranhaPlantAtWill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq PiranhaPlantAtWill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq PiranhaPlantAtWill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt PiranhaPlantAtWill_exit
	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r30, 0x4 (r3)

	lwz r12, 0x14 (r3)
	lwz r29, 0x20C (r12)

	mr r3, r29
	GOTO_FUNC "object::KartInfoProxy::isPackunItemActive"
	cmpwi r3, 0
	bne PiranhaPlantAtWill_exit

	lwz r3, 0x8 (r30)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r5, r31, r5
	cmpw r5, r31
	bne PiranhaPlantAtWill_exit

	mr r3, r29
	GOTO_FUNC "object::KartInfoProxy::startPackun"

PiranhaPlantAtWill_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - PiranhaPlantAtWill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
