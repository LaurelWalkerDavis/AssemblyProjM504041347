//================================================
//  STM32F3xx Register Addresses and Constants
//================================================

// Peripheral register addresses/offsets
    .equ   RCC,0x40021000
	.equ   AHBENR,0x14				//ABBENR offset
	.equ   APB1ENR,0x1C				//APB1ENR offset
	.equ   GPIOAEN,0x00020000		//Bit 17 to enable GPIOA clock
	.equ   GPIOBEN,0x00040000		//Bit 18 to enable GPIOB clock
	.equ   TIM6EN,0x10				//TIM6 enable = bit 4 of APB1ENR

//GPIO registers
	.equ   GPIOA,0x48000000			//GPIOA base address
	.equ   GPIOB,0x48000400			//GPIOB base address
	.equ   MODER,0x00				//mode selection register
	.equ   IDR, 0x10				//input data register
	.equ   ODR, 0x14				//output data register
	.equ   BSRRL, 0x18				//bits 15-0 of BSSR set pins
	.equ   BSRRH, 0x1A				//bits 31-16 of BSSR reset pins

//NVIC Registers
	.equ   NVIC_ISER0,	0xE000E100	//Interrupt Set-Enable (0-7)
	.equ   NVIC_ICER0,	0xE000E180	//Interrupt Clear-Enable (0-7)
	.equ   NVIC_ISPR0,	0xE000E200	//Interrupt Set-Pending (0-7)
	.equ   NVIC_ICPR0,	0xE000E280	//Interrupt Clear-Pending (0-7)
	.equ   NVIC_IABR0,	0xE000E300	//Interrupt Active Bit (0-7)
	.equ   NVIC_IPR1,	0xE000E404	//Interrupt Priority (0-59)

//System Configuration Registers
	.equ   SYSCFG, 0x40010000		//base address
	.equ   EXTICR1, 0x08			//External Interrupt Control Reg 1

//External Interrupt Registers
	.equ   EXTI,	0x40010400   	//Base address
	.equ   IMR,	0x00				//Interrupt Mask Register
	.equ   EMR,	0x04				//Event Mask Register
	.equ   RTSR,	0x08			//Rising Trigger Select
	.equ   FTSR,	0x0C			//Falling Trigger Select
	.equ   SWIR,	0x10			//Software Interrupt Event
	.equ   PR,	0x14				//Pending Register

//TIM6 Interrupt Setup
	.equ   TIM6IRQ, 54				//TIM6 IRQ number (IRQ54)
	.equ   TIM6_OFF, 4				//Offset to ISER1/ICER1/ISPR1/ICPR1/IABR1 (54/32 = 1) x 4
	.equ   TIM6_BIT, 22				//Bit# 22 in the above registers (54%32 = 22)
	.equ   TIM6_PBIT, 16			//Byte start within IPR13 (54%4 = 2) x 8
	.equ   TIM6_POFF, 52			//Offset to IPR13 (54/4 = 13) x 4

//Timer base addresses
	.equ   TIM2,	0x40000000		//TIM2 base address
	.equ   TIM3,	0x40000400		//TIM3 base address
	.equ   TIM6,	0x40001000		//TIM6 base address
	.equ   TIM7,	0x40001400		//TIM7 base address

//Timer register offsets
	.equ   CR1,	0x00				//Control register 1
	.equ   CR2,	0x04				//Control register 2
	.equ   DIER,0x0C				//DMA/interrupt enable register
	.equ   SR,	0x10				//Status register
	.equ   EGR,	0x14				//Event generation register
	.equ   CNT,	0x24				//Counter
	.equ   PSC,	0x28				//Prescaler
	.equ   ARR,	0x2C				//Auto-Reload Register

//Discovery board LED #s
	.equ   RED,		0				//Red    LED on PB6 = LED #0
	.equ   BLUE,	1				//Blue   LED on PB7 = LED #1
	.equ   ORANGE,	2				//Orange LED on PB8 = LED #2
	.equ   GREEN,	3				//Green  LED on PB8 = LED #3

