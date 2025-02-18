; Sort an array using selection sort via stack

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
	ldr r0, =0x1
	ldr r1, =0x4
	ldr r2, =0x5
	ldr r3, =0x3
	ldr r4, =0x2
	stmia r13!, {r0-r4}
	mov r0, r13
outer
	mov r1, r0
	mov r2, r0
	sub r2, #4
	add r12, r11, #1
inner
	ldmdb r1, {r3}
	ldmdb r2, {r4}
	cmp r3, r4
	movlo r1, r2
	sub r2, #4
	add r12, #1
	cmp r12, #5
	bne inner
	ldmdb r1!, {r3}
	ldmdb r0!, {r4}
	stmia r0, {r3}
	stmia r1, {r4}
	add r11, #1
	cmp r11, #4
	bne outer
	
	end

/*
output:
R0: 0x40001004
R1: 0x40001004
R2: 0x40001000
R3: 0x00000002
R4: 0x00000002
R11: 0x00000004
R12: 0x00000005
stack:
addr      |       val
0x40001000 0x00000001
0x40001004 0x00000002
0x40001008 0x00000003
0x4000100C 0x00000004
0x40001010 0x00000005
*/