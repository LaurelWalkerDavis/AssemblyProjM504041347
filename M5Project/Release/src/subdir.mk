################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../src/Application.s \
../src/ButtonDrivers.s \
../src/LEDDrivers.s \
../src/MidFunctions.s 

OBJS += \
./src/Application.o \
./src/ButtonDrivers.o \
./src/LEDDrivers.o \
./src/MidFunctions.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Assembler'
	@echo $(PWD)
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


