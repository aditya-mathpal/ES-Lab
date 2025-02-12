; Calculate factorial of a number via recursion

	AREA RESET, data, readonly
		export __Vectors

__Vectors
	dcd 0x40001000
	dcd Reset_Handler
	align
	AREA mycode, code, readonly
	ENTRY
	export Reset_Handler

Reset_Handler
	ldr r0, =n
	ldr r1, =ans
	ldr r2, [r0]
	bl factorial
	str r2, [r1]
stop
	b stop

factorial
	push {r3, lr}
	mov r3, r2
	cmp r2, #0
	bne x
	mov r2, #1
	b xx
x	sub r2, #1
 	bl factorial
	mul r2, r3
xx	pop {r3, lr}
	bx lr

	AREA mydata, data, readonly
n dcd 6
	AREA mydata2, data, readwrite
ans dcd 0
	end

/*
output:
R0: 0x00000040
R1: 0x10000000
R2: 0x000002D0
R3: 0x00000000
n:	 addr: 0x00000040 val: 0x00000006
ans: addr: 0x10000000 val: 0x000002D0
*/