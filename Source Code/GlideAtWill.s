/*********************************************************************************
*                               Author: Mewtality                                *
*                            File Name: GlideAtWill.s                            *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                       Enable and disable glider at will.                       *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00010001 # "Activator" (A + D-Pad Up)
	.long 0x140F0100, 0x00020001 # "Deactivator" (A + D-Pad Down)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                              GliderAtWill
 *?  Forces the kart glider to appear/disappear.
 *========================================================================**/
GliderAtWill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr r31, r3
	mr r30, r4

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq GliderAtWill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq GliderAtWill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq GliderAtWill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq GliderAtWill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt GliderAtWill_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r29, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne GliderAtWill_exit

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isKiller"
	cmpwi r3, 0
	bne GliderAtWill_exit

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"
	
	lwz r5, 0x1A4 (r3)
	and r0, r31, r5
	cmpw r0, r31
	bne GliderAtWill_TryClose

	lwz r3, 0x4 (r29)
	li r4, -1
	GOTO_FUNC "object::KartVehicle::isInWing"
	cmpwi r3, 0
	bne GliderAtWill_exit

	lwz r3, 0x4 (r29)
	GOTO_FUNC "object::KartVehicle::forceGlide"
	b GliderAtWill_exit

GliderAtWill_TryClose:
	and r0, r30, r5
	cmpw r0, r30
	bne GliderAtWill_exit

	lwz r3, 0x4 (r29)
	GOTO_FUNC "object::KartVehicle::forceCloseWing"

GliderAtWill_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - GliderAtWill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
