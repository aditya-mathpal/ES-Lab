	AREA RESET, DATA, READONLY
		EXPORT __Vectors

__Vectors
	dcd 0x10001000
	dcd Reset_Handler
	
	AREA mycode, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
		
Reset_Handler
	ldr r0, =arr ; start of the array
	mov r1, #0
	add r1, r0, #36 ; r1 stores the address of the end of the array
	mov r2, #5 ; counter
loop
	ldr r3, [r0]
	ldr r4, [r1]
	str r3, [r1]
	str r4, [r0]
	add r0, #4
	sub r1, #4
	subs r2, #1
	bne loop

STOP B STOP

	AREA mydata, DATA, READWRITE
arr dcd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; the array should be initialized during execution
	
	END
		
/*
output:
R0: 0x10000014
R1: 0x10000010
R2: 0x00000000
R3: 0x55555555
R4: 0x66666666

arr:
addr       ||       val
0x10000000    0x12121212
0x10000004    0x99999999
0x10000008    0x88888888
0x1000000C    0x77777777
0x10000010    0x66666666
0x10000014    0x55555555
0x10000018    0x44444444
0x1000001C    0x33333333
0x10000020    0x22222222
0x10000024    0x11111111
*/