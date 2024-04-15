/*********************************************************************************
*                               Author: Mewtality                                *
*                          File Name: SwitchFOVAtWill.s                          *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                        Changes the camera FOV at will.                         *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "SwitchFOVAtWill_Patcher_.data", 0x10014834
.equiv "SwitchFOVAtWill_Patcher_.text", 0x0ECA01EC

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0xC4000001, "object::KartCamera::calcFovy" + 0x25C # Cafe code type "ASM String Writes [C4]".
	bl "SwitchFOVAtWill_Patcher_.text" - ("object::KartCamera::calcFovy" + 0x25C)
	.long 0x0

	.word 0xC400, length >> 3 # Cafe code type "ASM String Writes [C4]".
	.long "SwitchFOVAtWill_Patcher_.text"

/**========================================================================
 **                        SwitchFOVAtWill_Patcher
 *?  Code that will run at "object::KartCamera::calcFovy()".
 *========================================================================**/
SwitchFOVAtWill_Patcher:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq SwitchFOVAtWill_Patcher_exit
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq SwitchFOVAtWill_Patcher_exit
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq SwitchFOVAtWill_Patcher_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq SwitchFOVAtWill_Patcher_exit

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt SwitchFOVAtWill_Patcher_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	lwz r3, 0x4 (r3)

	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lis r12, "SwitchFOVAtWill_Patcher_.data"@ha

	lbz r5, "SwitchFOVAtWill_Patcher_.data"@l (r12)
	lwz r6, 0x1A4 (r3)
	li r7, 0x40 # "Activator" (Right Stick Button)
	and r0, r7, r6
	cmpw r0, r7
	bne SwitchFOVAtWill_Patcher_ResetFlag

	lhz r7, "SwitchFOVAtWill_Patcher_.data" + 0x2@l (r12)
	subic. r7, r7, 0x1
	bge+ SwitchFOVAtWill_Patcher_AttemptNewFOV
	sth r7, "SwitchFOVAtWill_Patcher_.data" + 0x2@l (r12)

	xori r5, r5, 0x1
	stb r5, "SwitchFOVAtWill_Patcher_.data"@l (r12)
	b SwitchFOVAtWill_Patcher_AttemptNewFOV

SwitchFOVAtWill_Patcher_ResetFlag:
	li r0, 0
	sth r0, "SwitchFOVAtWill_Patcher_.data" + 0x2@l (r12)

SwitchFOVAtWill_Patcher_AttemptNewFOV:
	cmpwi r5, 0
	beq SwitchFOVAtWill_Patcher_exit

	lis r0, 0x4220
	stw r0, 0x8 (r1)
	lfs f5, 0x8 (r1)

	fadds f26, f26, f5

SwitchFOVAtWill_Patcher_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	fmr f2, f26
	blr


length = ($ - SwitchFOVAtWill_Patcher) + 0x4

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
