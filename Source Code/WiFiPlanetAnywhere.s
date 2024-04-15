/*********************************************************************************
*                               Author: Mewtality                                *
*                        File Name: WiFiPlanetAnywhere.s                         *
*                            Creation Date: April 15                             *
*                             Last Updated: April 15                             *
*                              Source Language: asm                              *
*                                                                                *
*                            --- Code Description ---                            *
*        Forces the wifi planet background to show anywhere in the menu.         *
*********************************************************************************/

.include "./Turbo.rpx.s"

.equiv "Menu3DModelDirector", 0x1068A758
.equiv "UIEngine", 0x1068C38C
.equiv "FUN_0E6EDEF8", 0x0E6EDEF8

.macro GOTO_FUNC symbol
	lis r11, "\symbol"@h
	ori r11, r11, "\symbol"@l
	mtctr r11
	bctrl
.endm

	.word 0xC000, length >> 3 # Cafe code type "Execute ASM [C0]".

/**========================================================================
 **                         WiFiPlanetAnywhere
 *?  Executes various functions to run the UI WiFi planet background.
 *========================================================================**/
WiFiPlanetAnywhere:
	mflr r0
	stw r0, 0x4 (r1)
	stwu r1, -0x8 (r1)

	lis r12, "UIEngine"@ha
	lwz r12, "UIEngine"@l (r12)
	cmpwi r12, 0
	beq WiFiPlanetAnywhere_exit

	GOTO_FUNC "ui::GetBg"
	cmpwi r3, 0
	beq WiFiPlanetAnywhere_exit

	GOTO_FUNC "ui::Page_Bg::animKeepWiFi"

	lis r3, "Menu3DModelDirector"@ha
	lwz r3, "Menu3DModelDirector"@l (r3)
	cmpwi r3, 0
	beq WiFiPlanetAnywhere_exit

	lbz r0, 0x40 (r3)
	cmpwi r0, 0x2
	beq WiFiPlanetAnywhere_exit

	lbz r0, 0x41 (r3)
	cmpwi r0, 0x4
	beq WiFiPlanetAnywhere_exit

	li r4, 0x1
	GOTO_FUNC "FUN_0E6EDEF8"

WiFiPlanetAnywhere_exit:
	lwz r0, 0xC (r1)
	mtlr r0
	addi r1, r1, 0x8
	blr

length = $ - WiFiPlanetAnywhere

.if length >> 1 % 0x4 == 0
	.space 0x4
.endif
