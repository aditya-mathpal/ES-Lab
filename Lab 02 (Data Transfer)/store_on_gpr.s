	AREA RESET, DATA, READONLY
		EXPORT __Vectors

__Vectors
	DCD 0x10001000 ;SP
	DCD Reset_Handler
	
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

Reset_Handler
	ldr r0, =src
	ldr r1, [r0]

STOP B STOP
	
src dcd 0x12345678
	AREA mydata, DATA, READWRITE
	
	END

	
/*
output:
R0: 0x00000010
R1: 0x12345678
src: addr: 0x00000010 val: 0x12345678
*/