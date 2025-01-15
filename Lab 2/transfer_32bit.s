	AREA RESET, DATA, READONLY
		EXPORT __Vectors
			
__Vectors
	dcd 0x10001000
	dcd Reset_Handler
		
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
	
Reset_Handler
	ldr r0, =src
	ldr r1, =dst
	ldr r2, [r0]
	str r2, [r1]
	
STOP B STOP
	
	AREA mydata, DATA, READONLY
src dcd 0x12345678
	AREA mydata2, DATA, READWRITE
dst dcd 0
	END
		
/*
output:
R0: 0x0000001C
R1: 0x10000000
R2: 0x12345678
src: addr: 0x0000001C val: 0x12345678
dst: addr: 0x00000020 val: 0x12345678
*/