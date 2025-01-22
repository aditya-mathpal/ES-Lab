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
	ldr r1, [r0]
	ldr r0, =value2
	ldr r2, [r0]
	umull r3, r4, r1, r2
	ldr r0, =result
	str r3, [r0]
	str r4, [r0, #4]
stop b stop

value1 dcd 0x22222222
value2 dcd 0x33333333

	AREA data, DATA, READWRITE
result dcd 0
	END
		
/*
output:
R0: 0x10000000
R1: 0x22222222
R2: 0x33333333
R3: 0x2C5F92C6
R4: 0x06D3A06D

value1: addr: 0x0000001C val: 0x22222222
value2: addr: 0x00000020 val: 0x33333333
result: addr: 0x00000010 val: 0x06D3A06D2C5F92C6
/*