	AREA RESET, DATA, READONLY
		EXPORT __Vectors
__Vectors
	DCD 0x10001000 ;SP
	DCD Reset_Handler

	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	ldr r0, =src ; r0 = 0x10
	ldr r1, [r0]
	ldr r2, =dst
	str r1, [r2]
src dcd 0x12345678
	AREA mydata, DATA, READWRITE
dst dcd 0
	END