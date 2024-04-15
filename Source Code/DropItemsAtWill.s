/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: DropItemsAtWill.s                          *
*                            Creation Date: April 12                             *
*                             Last Updated: April 12                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*             Drop the current item(s) in possession on the ground.              *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "FUN_0E2E47E4", 0x0E2E47E4
.equiv "object::ItemOwnerProxy::_clearItemSlot", 0x0E2E3A88

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0100, 0x00020000 # "Activator" (D-Pad Down)
	.long 0x140F0000, 0x10014814 # Flag address.

	.llong 0x000200000E353814, 0x4182004000000000 # Patch this address.

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                            DropItemsAtWill
 *?  Drops items in a specific state from a player to the floor.
 *========================================================================**/
DropItemsAtWill:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr r31, r3
	mr. r30, r4
	beq DropItemsAtWill_exit

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq DropItemsAtWill_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq DropItemsAtWill_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq DropItemsAtWill_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq DropItemsAtWill_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt DropItemsAtWill_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r29, r3

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	lwz r6, 0 (r31)
	and r5, r30, r5
	cmpw r30, r5
	stw r5, 0 (r31)
	bne DropItemsAtWill_exit
	cmpwi r6, 0
	bne DropItemsAtWill_exit

	lwz r3, 0xC (r29)
	lwz r3, 0x5C (r3)
	GOTO_FUNC "FUN_0E2E47E4"

	lwz r3, 0xC (r29)
	lwz r3, 0x5C (r3)
	GOTO_FUNC "object::ItemOwnerProxy::_clearItemSlot"

DropItemsAtWill_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - DropItemsAtWill

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
