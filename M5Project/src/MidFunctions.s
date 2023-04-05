/*============================================*/
/*		Functions for Middle Layer
/*============================================*/

	.include "Equates.s"	//peripehral address offsets

//Functions in this file
	.global	Delay
	.global	DisplayCount
	.global CirclePattern
	.global ShowNumber
	.global OddEven


//Global variables defined in main file
	.global	Count
	.global Cycle

	.syntax unified
	.section	.text.MidFunctions

//============================================
//	____Delay____
//	Perform a one-half second delay by executing a “do-nothing” for loop some number of iterations.
//	The number of iterations will need to be determined experimentally.
// 	(	Inputs: r0 = # half seconds
// 	(	Output: none
// 	(	Alters: r0, r1

//Delay:	push	{r0, r1, lr}
		//ldr		r1, =0x20000000			//delay count for 1/2 sec
		//mov		r1, #3			//delay count for 1/2 sec
//Dloop1:	subs	r1, #1					//decrement delay count
		//bne		Dloop1					//repeat
		//subs	r0, #1					//# half seconds
		//bne		Delay					//repeat for each half second
		//pop		{r0, r1, lr}
		//bx		lr						//return to caller

Delay:
		push	{r0, r1, lr}
		ldr		r0, =0x7A1200		//equivalent to 5000000
delay_loop:
		subs	r0, r0, #1
		bne		delay_loop
		pop		{r0, r1, lr}
		bx		lr


//============================================
//	____DisplayCount____
//	Display the value of Count on the LEDs by calling subroutines to turn designated LEDs on or off.
// 	(	Inputs: r0 = value of count
// 	(	Output: PB9-6 lit in binary form
// 	(	Alters: r0-r3, r8, r11

DisplayCount:
	push 	{r0-r3, r8, lr}
	//mov		r11, r0
//____ready?
	//bl		CheckButton		//r0 = 1 or 0 to see whether button is pressed
	//cmp		r0, #1			//pressed?
	//bne		DisplayCount	//if not, repeat
	//sub		r0, #1			//restore to original r0 (CheckButton turns it to a 1. Must go back to 0 to start counting from 0.)



BeginCount:
//____i/o operation
	mov		r0, #0
	bl		CheckButton
	cmp		r0, #1
	bne		exit
	pop		{r0}			//pops 16 on 16th loop
	bl		ShowNumber
	bl		Delay
	bl		LEDsOff
	bl		Delay
	add		r0, #1			//increment counter
	push	{r0}
	cmp		r0, #15			//compare counter to 15
	ble		BeginCount		//if =< 15, repeat loop
else:
	pop		{r0}
	mov		r0, #0			//if counter > 15, reset to 0 and start BeginCount again
	push	{r0}
	b		BeginCount
exit:						//can only exit when button is no longer pressed
	pop		{r0-r3, r8, lr}
	bx		lr


//============================================
//	____ShowNumber____
//	Read binary number and turn on appropriate LEDs to represent binary number.
// 	(	Inputs: r0 = a binary number
// 	(	Output:
// 	(	Alters: r0, r1, r2, r3, r8

ShowNumber:
		push	{r0-r3, lr}
		mov		r8, r0
		//CheckButton here to make sure it's still down

red:	mov		r3, r8
		ands	r3, #0x01			//mask all but RED
		beq		blue				//if bit is 0, skip to blue
		mov		r0, #0				//prep for PinOn
		bl		PinOn

blue:	mov		r3, r8
		ands	r3, #0x02			//mask all but BLUE
		beq		orange				//if bit is 0, skip to orange
		mov		r0, #1				//prep for PinOn
		bl		PinOn

orange:	mov		r3, r8
		ands	r3, #0x04			//mask all but ORANGE
		beq		green				//if bit is 0, skip to green
		mov		r0, #2				//prep for PinOn
		bl		PinOn

green:	mov		r3, r8
		ands	r3, #0x08			//mask all but GREEN
		beq		done				//if bit is 0, skip to done
		mov		r0, #3				//prep for PinOn
		bl		PinOn

done:	pop		{r0-r3, lr}
		bx		lr



//============================================
//	____CirclePattern____
//	Create the circular pattern of individual LEDs on and off.
// 	(	Inputs:
// 	(	Output:
// 	(	Alters: r0-r3

CirclePattern:
		push	{r0-r3, lr}

	stCircle:
		gn:	mov		r0, #3				//prep for PinOn
			bl		PinOn				//turn on green
			bl		Delay
			bl		PinOff
			bl		Delay
			bl		CheckButton			//r0 = 1 or 0 to see whether button is pressed
			cmp		r0, #1				//pressed?
			bne		finish				//if not, finish

		og:	mov		r0, #2				//prep for PinOn
			bl		PinOn				//turn on orange
			bl		Delay
			bl		PinOff
			bl		Delay
			bl		CheckButton			//r0 = 1 or 0 to see whether button is pressed
			cmp		r0, #1				//pressed?
			bne		finish				//if not, finish

		bu:	mov		r0, #1				//prep for PinOn
			bl		PinOn				//turn on blue
			bl		Delay
			bl		PinOff
			bl		Delay
			bl		CheckButton			//r0 = 1 or 0 to see whether button is pressed
			cmp		r0, #1				//pressed?
			bne		finish				//if not, finish

		rd:	mov		r0, #0				//prep for PinOn
			bl		PinOn				//turn on red
			bl		Delay
			bl		PinOff
			bl		Delay
			bl		CheckButton			//r0 = 1 or 0 to see whether button is pressed
			cmp		r0, #1				//pressed?
			bne		finish				//if not, finish

			b		stCircle			//continue cycle until CheckButton exits to finish

	finish:	pop		{r0-r3, lr}
			bx		lr


//============================================
//	____OddEven____
//	Determines whether a number is odd or even.
// 	(	Inputs: r10 = #button presses
// 	(	Output: 0 (even) or 1 (odd) in r9
// 	(	Alters: r0, r1, r9

OddEven:push	{r0, r1, lr}
		mov		r0, r10					//move input number into r10
		and		r0, #1					//perform bitwise AND operation with 1
		cmp		r0, #0					//compare least sig digit with 0
		beq		even					//if even, jump to even

odd:	mov		r9, #1					//else, set to 1
		b		return					//return
even:	mov		r9, #0
return:	pop		{r0, r1, lr}
		bx		lr
