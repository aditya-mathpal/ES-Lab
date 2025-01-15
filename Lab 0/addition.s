	AREA RESET, DATA, READONLY
		EXPORT  __Vectors
__Vectors
	DCD 0x10001000
	DCD Reset_Handler
	ALIGN
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	mov r0, #5
	mov r1, #2
	add r2, r0, r1
STOP B STOP
	end