/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: CoinRandomizer.s                           *
*                            Creation Date: April 12                             *
*                             Last Updated: April 12                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*    Changes the coin amount every frame to a random value between 0 and 99.     *
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
 **                             CoinRandomizer
 *?  Modifies the acoin amount to a random value between 0 and 99.
 *========================================================================**/
CoinRandomizer:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r31, "RaceDirector"@ha
	lwz r31, "RaceDirector"@l (r31)
	cmpwi r31, 0
	beq CoinRandomizer_exit
	lwz r31, 0x23C (r31)
	cmpwi r31, 0
	beq CoinRandomizer_exit
	lbz r0, 0x3E (r31)
	cmpwi r0, 0
	beq CoinRandomizer_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq CoinRandomizer_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt CoinRandomizer_exit

	addi r12, r31, 0x80
	slwi r3, r3, 2
	lwzx r30, r12, r3

	li r3, 100
	GOTO_FUNC "nn::nex::Platform::GetRandomNumber"
	stw r3, 0x40 (r30)

CoinRandomizer_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - CoinRandomizer

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
