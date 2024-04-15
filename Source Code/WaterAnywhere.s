/*********************************************************************************
*                               Author: Mewtality                                *
*                           File Name: WaterAnywhere.s                           *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*              Kart behaves as if it were underwater at all times.               *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "WaterAnywhere_Patcher_.text", 0x0ECA02E4

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0xC4000001, "object::KartVehicle::calcWetAndWater" + 0x58 # Cafe code type "ASM String Writes [C4]".
	bl "WaterAnywhere_Patcher_.text" - ("object::KartVehicle::calcWetAndWater" + 0x58)
	.long 0x0

	.word 0xC400, length >> 3 # Cafe code type "ASM String Writes [C4]".
	.long "WaterAnywhere_Patcher_.text"

/**========================================================================
 **                         WaterAnywhere_Patcher
 *?  Code that will run at "object::KartVehicle::calcWetAndWater".
 *========================================================================**/
WaterAnywhere_Patcher:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)
	stw r30, 0x8 (r1)

	mr r30, r3

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq WaterAnywhere_Patcher_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq WaterAnywhere_Patcher_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq WaterAnywhere_Patcher_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq WaterAnywhere_Patcher_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt WaterAnywhere_Patcher_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r12, 0x4 (r3)

	cmpw r12, r31
	bne WaterAnywhere_Patcher_SetDefault
	li r3, 0x1
	b WaterAnywhere_Patcher_exit

WaterAnywhere_Patcher_SetDefault:
	mr r3, r30

WaterAnywhere_Patcher_exit:
	lwz r30, 0x8 (r1)
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	cmpwi r3, 0 # Original Instruction
	blr


length = ($ - WaterAnywhere_Patcher) + 0x4

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
