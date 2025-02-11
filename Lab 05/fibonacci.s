; Given n, generate n numbers in the Fibonacci series

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
	ldr r0, =dst
	mov r2, #0 ; f(1)
	mov r3, #1 ; f(2)
	subs r1, #1 ; r1--
	beq stop ; stop if r1 == 0
	str r2, [r0], #1 ; store 0 in dst
	subs r1, #1 ; r--
	beq stop; stop if r1 == 0
	str r3, [r0], #1 ; store 1 in dst
	b fibonacci
stop
	b stop

fibonacci
	add r5, r2, r3
	str r5, [r0], #1
	mov r2, r3
	mov r3, r5
	subs r1, #1
	bne fibonacci
	b stop

	AREA mydata, DATA, READONLY
n dcd 5
	AREA mydata2, DATA, READWRITE
dst dcd 0, 0
	
	END

/*
output:
R0: 0x10000005
R1: 0x00000000
R2: 0x00000002
R3: 0x00000003
R5: 0x00000003

n: addr: 0x00000044 val: 0x00000005
dst:
addr      |       val
0x10000000 0x00000000
0x10000001 0x00000001
0x10000002 0x00000001
0x10000003 0x00000002
0x10000004 0x00000003
*/