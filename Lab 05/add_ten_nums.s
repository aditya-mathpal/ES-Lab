; Add ten 32-bit numbers

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
	ldr r0, =src
	ldr r1, =dst
	mov r2, #10 ; r2: counter
	mov r3, #0 ; lower 32-bit
	mov r5, #0 ; upper 32-bit
x	ldr r4, [r0] ; load each number to r4
	add r0, #4 ; move r0 to next number
	adds r3, r4 ; add each number to r3
	bcc xx
	add r5, #1 ; if carry is generated, increment r5
xx	subs r2, #1 ; decrement counter
	bne x
	str r3, [r1] ; store lower half
	str r5, [r1, #4] ; store upper half
stop b stop

	AREA mydata, DATA, READONLY
src dcd 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999, 0x99999999
	AREA mydata2, DATA, READWRITE
dst dcd 0, 0

	END

/*
output:
R0: 0x00000060
R1: 0x10000000
R2: 0x00000000
R3: 0xFFFFFFFA
R4: 0x99999999
R5: 0x00000005

src:
addr      |       val
0x00000038 0x99999999
0x0000003C 0x99999999
0x00000040 0x99999999
0x00000044 0x99999999
0x00000048 0x99999999
0x0000004C 0x99999999
0x00000050 0x99999999
0x00000054 0x99999999
0x00000058 0x99999999
0x0000005C 0x99999999

dst: addr: 0x10000000 val: 0x5FFFFFFFA
*/