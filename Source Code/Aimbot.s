/*********************************************************************************
*                               Author: Mewtality                                *
*                              File Name: Aimbot.s                               *
*                            Creation Date: April 11                             *
*                             Last Updated: April 11                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*                Automatically aim the nearest kart when enabled.                *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "AudSceneRace", 0x10683020
.equiv "RaceDirector", 0x1068A72C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

.macro GOTO_GLUE_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctr
.endm

	.long 0x140F0100, 0x00001200 # "Activator" ( Select (-) ).
	.long 0x150F0000; .float 200 # "Max Distance".

	.long 0x140F0000, 0x10014800 # "Persistent Data" address. | 0xC (12) bytes

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                                 Aimbot
 *?  Forces a player to always face at a target (another player) at will.
 *@param1 r3 "persistent data" address
 *@param2 r4 "activator" value
 *@param3 f1 "max distance" float
 *========================================================================**/
Aimbot:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	mr r31, r3
	mr. r30, r4
	beq Aimbot_Clear

	lis r0, 0
	stw r0, 0x8 (r1)
	lfs f31, 0x8 (r1)

	fmr f30, f1

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq Aimbot_Clear
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq Aimbot_Clear
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq Aimbot_Clear

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq Aimbot_Clear

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt Aimbot_Clear

	bl getKartUnit
	mr r29, r3

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r5, r30, r5
	cmpw r5, r30
	lwz r6, 0x0 (r31)
	lwz r7, 0x4 (r31)
	bne Aimbot_TryExecute
	cmpwi r6, 0
	bne Aimbot_TryExecute
	xor r7, r7, r5
	stw r7, 0x4 (r31)

Aimbot_TryExecute:
	stw r5, 0x0 (r31)
	cmpwi r7, 0
	beq Aimbot_ClearResult

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	bl getPos
	mr r28, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne Aimbot_Clear

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isAntiG"
	cmpwi r3, 0
	bne Aimbot_Clear

	lwz r12, 0x8 (r31)
	cmpwi r12, 0
	bne Aimbot_CalcAimVector

	lis r12, "AudSceneRace"@ha
	lwz r12, "AudSceneRace"@l (r12)
	lwz r12, 0xF0 (r12)
	lwz r6, 0x94 (r12)

	fmr f29, f30

Aimbot_CalcKart2KartVector:
	subi r3, r6, 0x1
	bl getKartUnit
	lwz r3, 0x14 (r3)
	lwz r3, 0x20C (r3)
	bl getPos

	mr r4, r3
	mr r3, r28
	GOTO_FUNC "ASM_VECDistance"

	fcmpu cr0, f1, f31 # If no distance, go next
	beq Aimbot_CalcKart2KartVector_Next
	fcmpu cr0, f1, f30
	bge Aimbot_CalcKart2KartVector_Next
	subi r7, r6, 0x1
	fmr f30, f1

Aimbot_CalcKart2KartVector_Next:
	subic. r6, r6, 0x1
	bne Aimbot_CalcKart2KartVector

	fcmpu cr0, f30, f29 # Check if any karts found
	bge Aimbot_Clear

	mr r3, r7
	bl getKartUnit
	stw r3, 0x8 (r31)
	mr r12, r3

Aimbot_CalcAimVector:
	lwz r3, 0x14 (r12)
	lwz r3, 0x20C (r3)
	bl getPos
	lfs f5, 0 (r3)
	lfs f6, 0x8 (r3)
	lfs f7, 0 (r28)
	lfs f8, 0x8 (r28)

	fsubs f5, f7, f5
	fsubs f6, f8, f6
	fmuls f7, f5, f5
	fmuls f8, f6, f6
	fadds f1, f7, f8
	GOTO_FUNC "sqrtf"
	fdivs f7, f5, f1
	fdivs f8, f6, f1
	fneg f5, f7
	fneg f6, f8

	lis r0, 0xBF80
	stw r0, 0x8 (r1)
	lfs f7, 0x8 (r1)

	fcmpu cr0, f5, f7
	ble Aimbot_Exit # abort if NaN
	fcmpu cr0, f6, f7
	ble Aimbot_Exit # abort if NaN
	stfs f5, 0x24C (r28)
	stfs f5, 0x258 (r28)
	stfs f5, 0x264 (r28)
	stfs f6, 0x254 (r28)
	stfs f6, 0x260 (r28)
	stfs f6, 0x26C (r28)
	b Aimbot_Exit

Aimbot_Clear:
	li r7, 0
	stw r7, 0x0 (r31)
	stw r7, 0x4 (r31)

Aimbot_ClearResult:
	stw r7, 0x8 (r31)

Aimbot_Exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr

/**========================================================================
 **                              getKartUnit
 *?  Converts a player ID to a memory address pointing to player data.
 *@param1 r3 "player ID" int
 *@return r3 "player data" address
 *========================================================================**/
getKartUnit:
	GOTO_GLUE_FUNC "object::KartInfoProxy::getKartUnit"

/**========================================================================
 **                                 getPos
 *?  Returns a memory address pointing to kart coordinates.
 *@param1 r3 "player data" address
 *@return r3 "player coordinates" address
 *========================================================================**/
getPos:
	GOTO_GLUE_FUNC "object::KartInfoProxy::getPos"


length = $ - Aimbot

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
