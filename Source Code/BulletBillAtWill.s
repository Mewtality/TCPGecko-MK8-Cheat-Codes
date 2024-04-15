/*********************************************************************************
*                               Author: Mewtality                                *
*                         File Name: BulletBillAtWill.s                          *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*              Transform kart into and out of bullet bill at will.               *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00000011 # "Activator" (A + Y)
	.long 0x140F0100, 0x00000003 # "Deactivator" (A + B)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                            BulletBillAtWill
 *?  Forces the kart to transform into and out of a Bullet Bill at command.
 *========================================================================**/
BulletBillAtWill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq BulletBillAtWill_exit
	mr. r30, r4
	beq BulletBillAtWill_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq BulletBillAtWill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq BulletBillAtWill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq BulletBillAtWill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq BulletBillAtWill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt BulletBillAtWill_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r29, 0x4 (r3)
	lwz r28, 0x14 (r3)

	lwz r3, 0x20C (r28)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne BulletBillAtWill_exit

	lwz r3, 0x8 (r29)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r0, r31, r5
	cmpw r0, r31
	bne BulletBillAtWill_AttemptDisable

	lwz r3, 0x20C (r28)
	GOTO_FUNC "object::KartInfoProxy::isKiller"
	cmpwi r3, 0
	bne BulletBillAtWill_exit

	mr r3, r29
	GOTO_FUNC "object::KartVehicle::startKiller"

	b BulletBillAtWill_exit

BulletBillAtWill_AttemptDisable:
	and r0, r30, r5
	cmpw r0, r30
	bne BulletBillAtWill_exit

	mr r3, r29
	GOTO_FUNC "object::KartVehicle::endKiller"

BulletBillAtWill_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - BulletBillAtWill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
