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
	ldr r0, =value1
	ldr r1, [r0] ; r1 = op1
	ldr r0, =value2
	ldr r2, [r0] ; r2 = op2
	subs r3, r1, r2
	ldr r0, =result
	str r3, [r0]
stop b stop

value1 dcd 0x55555555
value2 dcd 0x44444444

	AREA data, DATA, READWRITE
result dcd 0
	END

/*
output:
R0: 0x10000000
R1: 0x55555555
R2: 0x44444444
R3: 0x11111111

value1: addr: 0x00000018 val: 0x55555555
value1: addr: 0x0000001C val: 0x44444444
result: addr: 0x10000000 val: 0x11111111
*/