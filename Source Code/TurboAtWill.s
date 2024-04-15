/*********************************************************************************
*                               Author: Mewtality                                *
*                            File Name: TurboAtWill.s                            *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                   Kart engine goes into turbo mode at will.                    *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "FUN_0E35ABB4", 0x0E35ABB4

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

    .long 0x140F0000, 0x00000010 # "Activator" (Y)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                              TurboAtWill
 *?  Calls a specific function so the player is able to run turbo at any
 *?  time.
 *@param1 r3 "Activator" int
 *========================================================================**/
TurboAtWill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq TurboAtWill_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq TurboAtWill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq TurboAtWill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq TurboAtWill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq TurboAtWill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt TurboAtWill_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r30, 0x4 (r3)

	lwz r3, 0x14 (r3)
	lwz r3, 0x20C (r3)
	mr r29, r3
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne TurboAtWill_exit

	mr r3, r29
	GOTO_FUNC "object::KartInfoProxy::isAccident"
	cmpwi r3, 0
	bne TurboAtWill_exit

	lwz r3, 0x8 (r30)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r0, r31, r5
	cmpw r0, r31
	bne TurboAtWill_exit

	lwz r3, 0x14 (r30)
	li r4, 0x8
	li r5, 1
	li r6, 1
	GOTO_FUNC "FUN_0E35ABB4"

TurboAtWill_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - TurboAtWill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
