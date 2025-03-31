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
	ldr r0, =n
	ldr r1, [r0] ; r1 <- n
	mla r1, r1, r1, r1 ; r1 <- n^2 + n
	mov r3, #0 ; counter
loop
	subs r1, r1, #2
	bcc break
	add r3, r3, #1
	bcs loop
break ; r3 -> (n^2 + n)/2
	ldr r0, =result
	str r3, [r0]
stop b stop

n dcd 0x00000004
	
	AREA data, DATA, READWRITE
result dcd 0
	END

/*
output:
R0: 0x10000000
R1: 0xFFFFFFFE
R3: 0x0000000A

n: addr: 0x00000024 val: 0x00000007
result: addr: 0x10000000 val: 0x0000000A
*/

