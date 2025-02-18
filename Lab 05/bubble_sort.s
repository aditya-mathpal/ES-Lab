; Sort an array using bubble sort

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
	mov r0, #0
	mov r1, #10
	ldr r2, =src
	ldr r4, =dst
x	ldr r3, [r2, r0] ; load number from src
	str r3, [r4, r0] ; store number to dst
	add r0, #4 ; r0+=4
	sub r1, #1 ; r1--
	cmp r1, #0
	bhi x ; repeat till all numbers are transferred from src to dst
	ldr r2, =dst
	mov r3, #9 ; inner counter
	mov r5, r3 ; r5: number of passes
outer
	mov r6, r2
	mov r0, r3 ; r0: number of comparisions
inner
	ldr r7, [r6], #4
	ldr r8, [r6]
	cmp r8, r7
	strls r7, [r6]
	strls r8, [r6, #-4]
	subs r0, #1
	bne inner
	sub r3, #1
	subs r9, #1
	bne outer
stop b stop

	AREA mydata, data, readonly
src dcd 0x10, 0x05, 0x33, 0x24, 0x56, 0x77, 0x21, 0x04, 0x87, 0x01
	AREA mydata2, data, readwrite
dst dcd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	end

/*
output:
src:
addr      |       val
0x00000060 0x00000010
0x00000064 0x00000005
0x00000068 0x00000033
0x0000006C 0x00000024
0x00000070 0x00000056
0x00000074 0x00000077
0x00000078 0x00000021
0x0000007C 0x00000004
0x00000080 0x00000087
0x00000084 0x00000001

dst:
addr      |       val
0x10000000 0x00000001
0x10000004 0x00000004
0x10000008 0x00000005
0x1000000C 0x00000010
0x10000010 0x00000021
0x10000014 0x00000024
0x10000018 0x00000033
0x1000001C 0x00000056
0x10000020 0x00000077
*/