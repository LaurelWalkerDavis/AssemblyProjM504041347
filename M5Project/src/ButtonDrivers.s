/*============================================*/
/*		Functions for Input Button on PA0
/*============================================*/

	.include "Equates.s"	//peripehral address offsets

//Functions in this file

	.global	InitButton
	.global	CheckButton


//Global variables defined in main file

	.syntax unified
	.section	.text.ButtonDrivers

//============================================
//	____InitButton____
//	GPIO initialization for button
//	Initialize the RCC and GPIOA, configuring PA0 as an input to access the User Button.
// 	(	Inputs:
// 	(	Output:
// 	(	Alters:	converts (PA0) to an input to receive button state

InitButton:
	ldr 	r0, =RCC			// RCC register block
	ldr		r1, [r0,#AHBENR]	// read RCC_AHB1ENR
	orr		r1, #GPIOAEN		// enable GPIOA clock (bit 17)
	str		r1, [r0,#AHBENR]	// update AHB1ENR
	ldr		r0, =GPIOA			// GPIOA register block
	ldr		r1, [r0,#MODER]		// current mode register
	bic		r1, #0x03			// MODER[1:0] = 00 for PA0 input
	str		r1, [r0,#MODER]		// update mode register
	bx		lr					// return


//============================================
//	____CheckButton____
//	Read and return the state of the User Button, which can be determined by reading the
//	input data register of GPIOA and checking the appropriate bit.
// 	(	Inputs:
// 	(	Output:	r0 = state of push putton (PA0), (0 or 1)
// 	(	Alters: r0

CheckButton:
	ldr		r0, =GPIOA			// GPIO port A
	ldr		r0, [r0,#IDR]		// Read PA15-PA0
	and		r0, #0x01			// Mask all but PA0
	bx		lr					// return value of PA0 in r0



