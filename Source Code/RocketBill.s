/*********************************************************************************
*                               Author: Mewtality                                *
*                            File Name: RocketBill.s                             *
*                            Creation Date: April 11                             *
*                             Last Updated: April 11                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*               Multiplies the Bullet Bill's speed by x10 at will.               *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00000010 # "Activator" (Y)
	.long 0x140F0100, 0x00000002 # "Activator" (B)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                              Rocket Bill
 *?  Multiplies kart speed by 10 if certain criteria has been met.
 *@param1 r3 "Rocket Activator" int
 *@param2 r4 "Full Stop Activator" int
 *========================================================================**/
RocketBill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	mr. r31, r3
	beq RocketBill_exit
	mr. r30, r4
	beq RocketBill_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq RocketBill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq RocketBill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq RocketBill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq RocketBill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt RocketBill_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r29, 0x4 (r3)

	lwz r3, 0x14 (r3)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isKiller"
	cmpwi r3, 0
	beq RocketBill_exit

	lwz r3, 0x8 (r29)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)

	lwz r3, 0x14 (r29)
	lfs f5, 0x3B8 (r3)

	and r0, r31, r5
	cmpw r0, r31
	bne RocketBill_TryFullStop

	lis r0, 0x4120
	b RocketBill_SetSpeed

RocketBill_TryFullStop:
	and r0, r30, r5
	cmpw r0, r30
	bne RocketBill_exit

	li r0, 0

RocketBill_SetSpeed:
	stw r0, 0x8 (r1)

	lfs f6, 0x8 (r1)
	fmuls f1, f5, f6
	GOTO_FUNC "object::KartVehicleMove::setSpeed"

RocketBill_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = $ - RocketBill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
