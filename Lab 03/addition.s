	AREA RESET, DATA, READONLY
		EXPORT __Vectors
			
__Vectors
	dcd 0x40001000
	dcd Reset_Handler
	ALIGN
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

Reset_Handler
	ldr r0, =value1
	ldr r1, [r0]
	ldr r0, =value2
	ldr r3, [r0]
	adds r6, r1, r3
	ldr r2, =result
	str r6, [r2]
stop b stop

value1 dcd 0x12345678
value2 dcd 0xabcdef12
	
	AREA data, DATA, READWRITE
result dcd 0
	END
		
/*
output:
R0: 0x0000001C
R1: 0x12345678
R2: 0x10000000
R3: 0xABCDEF12
R6: 0xBE02458A

value1: addr: 0x00000018 val: 0x12345678
value2: addr: 0x0000001C val: 0xABCDEF12
result: addr: 0x10000000 val: 0xBE02458A
*/