/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: SuperItemWheel.s                           *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                             Select items at will.                              *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00040000 # "Next Item Activator" (D-Pad Right)
	.long 0x140F0100, 0x00080000 # "Previous Item Activator" (D-Pad Left)
	.long 0x140F0200, 0x10014818 # code data

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                             SuperItemWheel
 *?  Forces the player to have a certain item.
 *@param1 r3 "next item activator" int
 *@param2 r4 "previous item activator" int
 *@param3 r5 "code data" address
 *========================================================================**/
SuperItemWheel:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq SuperItemWheel_exit
	mr. r30, r4
	beq SuperItemWheel_exit
	mr r29, r5

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq SuperItemWheel_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq SuperItemWheel_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq SuperItemWheel_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq SuperItemWheel_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt SuperItemWheel_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r28, r3

	lwz r3, 0x4 (r28)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	li r6, 0

	and r7, r31, r5
	cmpw r7, r31
	bne SuperItemWheel_TryIncItemID
	subi r6, r6, 0x1
	b SuperItemWheel_TrySetItemID

SuperItemWheel_TryIncItemID:
	and r7, r30, r5
	cmpw r7, r30
	bne SuperItemWheel_TrySetItemID
	addi r6, r6, 0x1

SuperItemWheel_TrySetItemID:
	lwz r8, 0 (r29)
	cmpwi r8, 0
	stw r7, 0 (r29)
	lwz r5, 0x4 (r29)
	bne SuperItemWheel_TryUpdateItem

	add r6, r5, r6
	cmplwi r6, 0x14
	ble 0x8
	xori r6, r5, 0x14

	mr r5, r6
	stw r5, 0x4 (r29)

SuperItemWheel_TryUpdateItem:
	lwz r12, 0xC (r28)
	lwz r12, 0x5C (r12)
	lwz r6, 0x44 (r12)
	cmpwi r6, 0
	blt SuperItemWheel_SetItem
	cmpw r5, r6
	beq SuperItemWheel_exit

	mr r3, r12
	GOTO_FUNC "object::ItemOwnerProxy::clearItem"
	b SuperItemWheel_exit

SuperItemWheel_SetItem:
	mr r3, r12
	addi r4, r29, 0x4
	GOTO_FUNC "object::ItemOwnerProxy::setItemForce"

SuperItemWheel_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - SuperItemWheel

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
