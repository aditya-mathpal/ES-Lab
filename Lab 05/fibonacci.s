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
	mov r2, #0
	mov r3, #1
	subs r1, #1
	bne x
	mov r5, r2
	str r5, [r0], #1
	b stop
x	subs r1, #1
	bne xx
	mov r5, r3
	str r5, [r0], #1
	b stop
xx	bl fibonacci
	b stop
stop
	b stop

fibonacci
	add r5, r2, r3
	str r5, [r0], #1
	mov r2, r3
	mov r3, r5
	subs r1, #1
	bne fibonacci

	AREA mydata, DATA, READONLY
n dcd 5
	AREA mydata2, DATA, READWRITE
dst dcd 0
	
	END

/*
output:
n:   addr: 0x00000050
dst: addr: 0x10000000