	AREA RESET, DATA, READONLY
		EXPORT __Vectors

__Vectors
	dcd 0x40001000
	dcd Reset_Handler
	align
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

Reset_Handler
	ldr r0, =dividend
	ldr r1, [r0] ; r1 = dividend
	ldr r0, =divisor
	ldr r2, [r0] ; r2 = divisor
	mov r3, #0 ; counter
loop
	subs r1, r1, r2
	bcc break
	add r3, r3, #1
	bcs loop
break
	ldr r0, =quotient
	str r3, [r0]
	ldr r0, =remainder
	add r1, r1, r2
	str r1, [r0]
stop b stop

dividend dcd 0xAAAAAAAA
divisor dcd 0x09999999

	AREA data, DATA, READWRITE
quotient dcd 0
remainder dcd 0
	END

/*
output:
R0: 0x10000004
R1: 0x07777781
R2: 0x09999999
R3: 0x00000011

dividend: addr: 0x0000002C val: 0xAAAAAAAA
divisor: addr 0x00000030 val: 0x09999999
quotient: addr: 0x10000000 val: 0x00000011
remainder: addr: 0x10000004 val: 0x07777781
*/