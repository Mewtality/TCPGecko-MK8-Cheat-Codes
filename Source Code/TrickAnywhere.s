/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: TrickAnywhere.s                           *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*              The player is able to trick at any moment, anywhere.              *
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
 **                             TrickAnywhere
 *?  Sets a flag to allow character tricks.
 *========================================================================**/
TrickAnywhere:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq TrickAnywhere_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq TrickAnywhere_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq TrickAnywhere_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq TrickAnywhere_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt TrickAnywhere_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	li r0, 0x10
	stw r0, 0x1D0 (r12)

TrickAnywhere_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - TrickAnywhere

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
