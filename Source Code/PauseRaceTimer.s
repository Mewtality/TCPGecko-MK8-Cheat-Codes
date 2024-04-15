/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: PauseRaceTimer.s                           *
*                            Creation Date: April 14                             *
*                             Last Updated: April 14                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                            Pauses game mode timers.                            *
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
 **                             PauseRaceTimer
 *?  Sets a flag to stop race timers.
 *========================================================================**/
PauseRaceTimer:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r31, "RaceDirector"@ha
	lwz r31, "RaceDirector"@l (r31)
	cmpwi r31, 0
	beq PauseRaceTimer_exit
	lwz r12, 0x23C (r31)
	cmpwi r12, 0
	beq PauseRaceTimer_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq PauseRaceTimer_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq PauseRaceTimer_exit

	lwz r12, 0x34 (r31)

	li r0, 0x1
	stb r0, 0x4C (r12)

PauseRaceTimer_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - PauseRaceTimer

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
