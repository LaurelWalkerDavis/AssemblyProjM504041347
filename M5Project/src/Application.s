/*	Application.s
 *
 *  Created on: Apr 3, 2023
 *      Author: laurelwalkerdavis
 */

/*============================================*/
/*		M5 Project Application
/*============================================*/

//	Subroutines from MidFunctions.s
//		IMPORT Delay
//		IMPORT DisplayCount
//		IMPORT CirclePattern
//		IMPORT OddEven


//	Subroutines from LEDDrivers.s
//		IMPORT InitLEDs
//		IMPORT LED_OffOn
//		IMPORT PinOn
//		IMPORT PinOff
//		IMPORT LEDsOff


//	Subroutines from ButtonDrivers.s
//		IMPORT InitButton
//		IMPORT CheckButton

//____________________________________


//	Discovery board LED #s
		.equ RED,		0			//Red		LED on PB6 = LED #0
		.equ BLUE,		1			//Blue		LED on PB6 = LED #0
		.equ ORANGE,	2			//Orange	LED on PB6 = LED #0
		.equ GREEN,		3			//Green		LED on PB6 = LED #0

//____________________________________


// Code section - to begin following startup code
//		.section .text.main
		.syntax unified
		.text
		.global  	main
		.global		Wait

//============================================
//	____Main____
main:
		// ~ INITIALIZE RCC & GPIO HARDWARE ~
		bl		InitButton
		bl		InitLEDs
		//initialize Count for binary
		ldr		r8, =Count
		mov		r9, #0
		str		r9, [r8]
		//initialize Cycle counts
		ldr		r9, =Cycle
		mov		r10, #0			//cycle tracker
		str		r10, [r9]

		// ~ WAIT ~ 1
		// (wait for user button to be pressed
Wait:
		bl		CheckButton		//see whether button is pressed
		cmp		r0, #1			//pressed?
		bne		Wait			//if not, repeat
		add		r10, #1			//if so, increment cycle count
		mov		r9, r10			//prep for OddEven
		bl		OddEven			//if odd, do cycle1; if even, do cycle0
		cmp		r9, #0
		beq		Cycle0
		bl		Cycle1
		b		Wait			//repeat wait


		// ~ COUNT UP ~
		// (when button is held down - count up from 0 to 15, changing and displaying Count on the LEDs
		// (every half second, then wrap around to start over. so numbers count 0, 1, 2, …, 14, 15, 0, 1...
		// (counting is to stop when the User Button is released.
Cycle1:
		ldr		r6, =Count		//prep for DisplayCount
		ldr		r0, [r6]
		bl		DisplayCount
		b		Wait



		// ~ BLINK IN ORDER ~
		// (while the button is held down, turn each LED on
		// (for one-half second and then off for one half second in the following order:
		// (Green-Orange-Blue-Red. at most one LED on at any one time.
		// (repeat this pattern until the user Button is released.
Cycle0:
		ldr		r6, =Cycle			//prep for CirclePattern
		ldr		r0, [r6]
		bl		CirclePattern
		b		Wait




//literal pool will be placed here by the assembler


// Data section - to begin at 0x20010000
// Initial values ignored for RAM (set with debug.ini file)
		.data
		.global	Gvalue
		.global	Ovalue
		.global	Bvalue
		.global	Rvalue
		.global	Button
		.global	Cycle


Count:	.byte	0
Gvalue:	.word	0
Ovalue:	.word	0
Bvalue:	.word	0
Rvalue:	.word	0
Button:	.word	0
Cycle:	.word	0

	    .end

//end of assembly language source file
