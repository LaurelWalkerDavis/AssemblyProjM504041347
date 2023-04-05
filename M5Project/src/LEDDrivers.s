/*============================================*/
/*		Functions for LEDs on PB9-6
/*============================================*/

	.include "Equates.s"	//peripehral address offsets

//Functions in this file
	.global	InitLEDs
	.global	LED_OffOn
	.global PinOn
	.global PinOff
	.global LEDsOff



//Global variables defined in main file

	.syntax unified
	.section	.text.LEDDrivers

//============================================
//	____InitLEDs____
//	GPIO initialization for LEDs: PB9-6
//	Initialize the RCC and GPIOB, configuring PB9-PB8-PB7-PB6 as outputs, to drive the LEDs
// 	(	Inputs:
// 	(	Output:
// 	(	Alters: converts PB9-6 to outputs to drive LEDs

InitLEDs:
	// enable clock to GPIOB
	ldr  	r0,=RCC				// RCC register block
	ldr  	r1,[r0,#AHBENR]		// read RCC_AHBENR
	orr  	r1,#GPIOBEN			// enable GPIOB clock (bit 18)
	str  	r1,[r0,#AHBENR]		// update AHBENR

	// configure PB9-6 as output pins
	ldr  	r0,=GPIOB			// GPIOD register block
	ldr  	r1,[r0,#MODER]		// current mode register
	bic  	r1,#0x000FF000		// MODER[19:12]=00000000
	orr  	r1,#0x00055000		// MODER[19:12]=01010101,PB9-6 outputs
	str  	r1,[r0,#MODER]		// update mode register

	// set initial output values to 0
	ldr  	r1,[r0,#ODR]		// output data register
	bic  	r1,#0x03C0			// PB9-6 = 0000 (all LEDs off)
	str  	r1,[r0,#ODR]		// update output data register
	bx   	lr					// return


//============================================
//	____LED_OffOn____
//	Turn an individual LED on or off by changing the output data register of GPIOB,
//	or by using bit set/reset instructions.
// 	(	Inputs:
//				r0 = bit for LED# 3-0, corresponds to PB9-6
//				r1 = 0 for off, 1 for on
// 	(	Output:
// 	(	Alters:

LED_OffOn:
	push	{r0-r4}				//note registers
	add		r0, #6				//change 3:0 to 9:6 for PB9-6
	mov		r4,#1				//on value
	lsl		r4, r4, r0			//shift 1 to position in 9:6
	ldr		r2, =GPIOB			//GPIO port B
	ldrh	r3, [r2, #ODR]		//read current ODR value
	bic		r3, r4				//clear bit for PBx
	cmp		r1, #1				//ON?
	bne		L1					//skip if ON
	orr		r3, r4				//set bit for PBx
L1:	strh	r3, [r2, #ODR]		//write new ODR value
	pop		{r0-r4}				//restore registers
	bx		lr					//return to caller

//============================================
//	____PinOn____
//	Turn an individual pin on by changing the output data register of GPIOB,
//	or by using bit set/reset instructions.
// 	(	Inputs:
//				r0 = bit to set, corresponds to PB9-6
// 	(	Output:
// 	(	Alters: r0, r1, r2, r3
PinOn:
	push	{r0-r3, lr}
	add		r0,#6				// change 3:0 to 9:6 for PB9-6
	mov		r1,#1				// mask bit
	lsl		r1,r1,r0			// shift 1 to position in 9:6
	ldr		r2,=GPIOB			// GPIO port B
	ldrh	r3,[r2,#ODR]		// read current ODR value
	orr		r3,r1				// set bit for PBx
	strh	r3,[r2,#ODR]		// write new ODR value
	pop		{r0-r3, lr}
	bx		lr					// return


//============================================
//	____PinOff____
//	Turn an individual pin off by changing the output data register of GPIOB,
//	or by using bit set/reset instructions.
// 	(	Inputs:
//				r0 = bit to clear, corresponds to PB9-6
// 	(	Output:
// 	(	Alters: r0, r1, r2, r3
PinOff:
	push	{r0-r3, lr}
	add		r0,#6				// change 3:0 to 9:6 for PB9-6
	mov		r1,#1				// mask bit
	lsl		r1,r1,r0			// shift 1 to position in 9:6
	ldr		r2,=GPIOB			// GPIO port B
	ldrh	r3,[r2,#ODR]		// read current ODR value
	bic		r3,r1				// clear bit for PBx
	strh	r3,[r2,#ODR]		// write new ODR value
	push	{r0-r3, lr}
	bx		lr					// return


//============================================
//	____LEDsOff____
//	Turn all LEDs off.
// 	(	Inputs:
// 	(	Output:
// 	(	Alters: r0, r1, r2
LEDsOff:
	push	{r0, r1, r2, lr}
	ldr		r2, =GPIOB			// GPIO port B
	ldr  	r1,[r2,#ODR]		// output data register
	bic  	r1,#0x03C0			// PB9-6 = 0000 (all LEDs off)
	str  	r1,[r2,#ODR]		// update output data register
	pop		{r0, r1, r2, lr}
	bx   	lr					// return

