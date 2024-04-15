/*********************************************************************************
*                               Author: Mewtality                                *
*                        File Name: TouchScreenFreefly.s                         *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*             Updates kart coordinates based on touch screen input.              *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "RaceDirector", 0x1068A72C
.equiv "UIEngine", 0x1068C38C

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.long 0x140F0000, 0x10014854 # "Code Data" (8 bytes)

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                           TouchScreenFreefly
 *?  Writes touch pad coordinates to player coordinates. This also forces
 *?  the gamepad UI into "gameplay fullscreen".
 *========================================================================**/
TouchScreenFreefly:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0xC (r1)

	mr r31, r3

	li r0, 0
	stw r0, 0x8 (r1)
	lfs f31, 0x8 (r1)

	lis r12, "RaceDirector"@ha
	lwz r12, "RaceDirector"@l (r12)
	cmpwi r12, 0
	beq TouchScreenFreefly_Clear
	lwz r12, 0x23C (r12)
	cmpwi r12, 0
	beq TouchScreenFreefly_Clear
	lbz r0, 0x3E (r12)
	cmpwi r0, 0
	beq TouchScreenFreefly_Clear

	GOTO_FUNC "object::IsRaceState"
	cmpwi r3, 0
	beq TouchScreenFreefly_Clear

	GOTO_FUNC "object::RaceIndex_::DRCPlayer2Kart"
	cmplwi r3, 0xB
	bgt TouchScreenFreefly_Clear

	GOTO_FUNC "object::KartInfoProxy::getKartUnit"
	mr r30, r3

	lis r12, "UIEngine"@ha
	lwz r12, "UIEngine"@l (r12)
	lwz r12, 0x10 (r12)
	lwz r12, 0x4 (r12)
	lwz r12, 0x1A0 (r12)
	lwz r3, 0x2BC (r12)
	mr. r29, r3
	beq TouchScreenFreefly_Exit
	li r4, 0
	li r5, 0
	li r6, 1
	GOTO_FUNC "ui::Control_RaceDRC::setPushButton"

	mr r3, r29
	GOTO_FUNC "ui::Control_RaceDRC::forceSetFullScreen"

	lwz r3, 0x14 (r30)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isJugemHang"
	cmpwi r3, 0
	bne TouchScreenFreefly_Clear

	lwz r3, 0x14 (r30)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::isAntiG"
	cmpwi r3, 0
	bne TouchScreenFreefly_Clear

	lwz r3, 0x4 (r30)
	lwz r3, 0x8 (r3)
	GOTO_FUNC "object::KartVehicleControl::getRaceController"

	lwz r5, 0x1A4 (r3)
	rlwinm. r5, r5, 17, 31, 31 # Touch Screen
	lfs f5, 0x110 (r3) # Current Touch Screen X
	lfs f6, 0x114 (r3) # Current Touch Screen Y
	beq TouchScreenFreefly_Clear

	lwz r3, 0x4 (r30)
	lwz r3, 0x14 (r3)
	GOTO_FUNC "object::KartVehicleMove::forceStop"

	lfs f7, 0 (r31) # 1 Frame Old Touch Screen X
	lfs f8, 0x4 (r31) # 1 Frame Old Touch Screen Y
	fadds f9, f7, f8

	stfs f5, 0 (r31)
	stfs f6, 0x4 (r31)

	fcmpu cr0, f9, f31
	beq TouchScreenFreefly_Exit

	fsubs f5, f5, f7 # Current - Old X = Velocity X
	fsubs f6, f6, f8 # Current - Old Y = Velocity Y

	lis r0, 0x4080
	stw r0, 0x8 (r1)
	lfs f7, 0x8 (r1)

	fmuls f5, f5, f7
	fmuls f6, f6, f7

	lwz r3, 0x14 (r30)
	lwz r3, 0x20C (r3)
	GOTO_FUNC "object::KartInfoProxy::getPos"

	lfs f7, 0 (r3) # Kart X-coordinate
	lfs f8, 0x8 (r3) # Kart Z-coordinate
	fadds f5, f7, f5
	fadds f6, f8, f6

	lis r0, 0xBF80
	stw r0, 0x8 (r1)
	lfs f7, 0x8 (r1)

	stfs f5, 0 (r3)
	stfs f6, 0x8 (r3)
	stfs f31, 0x24C (r3)
	stfs f31, 0x258 (r3)
	stfs f31, 0x264 (r3)
	stfs f31, 0x250 (r3)
	stfs f31, 0x25C (r3)
	stfs f31, 0x268 (r3)
	stfs f7, 0x254 (r3)
	stfs f7, 0x260 (r3)
	stfs f7, 0x26C (r3)
	b TouchScreenFreefly_Exit

TouchScreenFreefly_Clear:
	stfs f31, 0 (r31)
	stfs f31, 0x4 (r31)

TouchScreenFreefly_Exit:
	lwz r0, 0x10 (r1)
	mtlr r0
	addi r1, r1, 0xC
	blr


length = $ - TouchScreenFreefly

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
