/*********************************************************************************
*                               Author: Mewtality                                *
*                         File Name: BulletBillKiller.s                          *
*                            Creation Date: April 13                             *
*                             Last Updated: April 13                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*       Attempts to teleport the kart to the next checkpoint coordinates.        *
*********************************************************************************/

.include "./Turbo.rpx.s"

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

	.long 0x140F0000, 0x00000080 # "Activator" (Left Stick Button)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                            BulletBillKiller
 *?  Searches for the next checkpoint and stores the coordinates of it onto
 *?  player coordinates.
 *========================================================================**/
BulletBillKiller:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	mr. r31, r3
	beq BulletBillKiller_exit

	lis r30, "RaceDirector"@ha
	lwz r30, "RaceDirector"@l (r30)
	cmpwi r30, 0
	beq BulletBillKiller_exit
	lwz r30, 0x23C (r30)
	cmpwi r30, 0
	beq BulletBillKiller_exit
	lbz r0, 0x3E (r30)
	cmpwi r0, 0
	beq BulletBillKiller_exit

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq BulletBillKiller_exit

	bl DRCPlayer2Kart
	cmplwi r3, 0xB
	bgt BulletBillKiller_exit

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r29, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne BulletBillKiller_exit

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	and r0, r31, r5
	cmpw r0, r31
	bne BulletBillKiller_exit

	bl DRCPlayer2Kart

	mulli r11, r3, 0x6C

	lwz r12, 0x30 (r30)
	addi r12, r12, 0xC

	lwzx r11, r12, r11
	stw r11, 0x8 (r1)

	addi r3, r1, 0x8
	GOTO_FUNC "object::Sector_GetSector"
	mr r28, r3

	lwz r3, 0x3C (r28)
	GOTO_FUNC "nn::nex::Platform::GetRandomNumber"
	slwi r3, r3, 2

	lwz r12, 0x40 (r28)
	lwzx r12, r12, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::getPos"

	lfs f0, 0x74 (r12)
	stfs f0, 0 (r3)

	lfs f0, 0x78 (r12)
	stfs f0, 0x4 (r3)

	lfs f0, 0x7C (r12)
	stfs f0, 0x8 (r3)

	lfs f0, 0x8C (r12)
	stfs f0, 0x24C (r3)
	stfs f0, 0x258 (r3)
	stfs f0, 0x264 (r3)

	lfs f0, 0x90 (r12)
	stfs f0, 0x250 (r3)
	stfs f0, 0x25C (r3)
	stfs f0, 0x268 (r3)

	lfs f0, 0x94 (r12)
	stfs f0, 0x254 (r3)
	stfs f0, 0x260 (r3)
	stfs f0, 0x26C (r3)

BulletBillKiller_exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr

/**========================================================================
 **                             DRCPlayer2Kart
 *?  Returns the player ID corresponding to the Wii U GamePad Player.
 *@return r3 "player ID" int
 *========================================================================**/
DRCPlayer2Kart:
	GOTO_GLUE_FUNC "object::RaceIndex_::DRCPlayer2Kart"


length = $ - BulletBillKiller

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
