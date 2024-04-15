/*********************************************************************************
*                               Author: Mewtality                                *
*                            File Name: Teleporter.s                             *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*  Save the current location of the kart and teleport back to that location at   *
*                                     will.                                      *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "FUN_0EC99040", 0x0EC99040 # OSBlockSet

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x00000008 # "Activator" (X)
	.long 0x140F0100, 0x10014838 # "Code Data" (28 bytes)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                               Teleporter
 *?  Saves player coordinates at a specific memory space and stores it back
 *?  to player coordinates at will.
 *@param1 r3 "activator" int
 *@param2 r4 "code data" address
 *========================================================================**/
Teleporter:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	mr. r31, r3
	beq Teleporter_exit
	mr r30, r4

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq Teleporter_Clear
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq Teleporter_Clear
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq Teleporter_Clear

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq Teleporter_Clear

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt Teleporter_Clear

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r29, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne Teleporter_exit

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	lhz r6, 0x2 (r30)
	li r7, 0

	and r0, r31, r5
	cmpw r0, r31
	bne Teleporter_CheckReleaseTimer

	addi r7, r6, 0x1
	b Teleporter_UpdateTimer

Teleporter_CheckReleaseTimer:
	cmpwi r6, 0
	beq Teleporter_exit
	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::getPos"
	cmpwi r6, 0x20
	bge Teleporter_UpdateKartPos

	lbz r6, 0 (r30)
	cmpwi r6, 0
	beq Teleporter_UpdateTimer
	lfs f0, 0x4 (r30)
	stfs f0, 0 (r3)

	lfs f0, 0x8 (r30)
	stfs f0, 0x4 (r3)

	lfs f0, 0xC (r30)
	stfs f0, 0x8 (r3)

	lfs f0, 0x10 (r30)
	stfs f0, 0x24C (r3)
	stfs f0, 0x258 (r3)
	stfs f0, 0x264 (r3)

	lfs f0, 0x14 (r30)
	stfs f0, 0x250 (r3)
	stfs f0, 0x25C (r3)
	stfs f0, 0x268 (r3)

	lfs f0, 0x18 (r30)
	stfs f0, 0x254 (r3)
	stfs f0, 0x260 (r3)
	stfs f0, 0x26C (r3)
	
	lwz r3, 0x4 (r29)
	lwz r3, 0x14 (r3)
	GOTO_FUNC "object::KartVehicleMove::forceStop"

	b Teleporter_UpdateTimer

Teleporter_UpdateKartPos:
	lfs f0, 0 (r3)
	stfs f0, 0x4 (r30)

	lfs f0, 0x4 (r3)
	stfs f0, 0x8 (r30)

	lfs f0, 0x8 (r3)
	stfs f0, 0xC (r30)

	lfs f0, 0x24C (r3)
	stfs f0, 0x10 (r30)

	lfs f0, 0x250 (r3)
	stfs f0, 0x14 (r30)

	lfs f0, 0x254 (r3)
	stfs f0, 0x18 (r30)

	li r0, 1
	stb r0, 0 (r30)
	b Teleporter_UpdateTimer

Teleporter_Clear:
	mr r3, r30
	li r4, 0
	li r5, 28
	GOTO_FUNC "FUN_0EC99040"

Teleporter_UpdateTimer:
	sth r7, 0x2 (r30)

Teleporter_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr


length = $ - Teleporter

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
