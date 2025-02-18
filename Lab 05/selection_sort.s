; Sort an array using selection sort

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
	ldr r0, =arr
	ldr r2, =dst
	mov r1, #10 ; counter
l	ldr r3, [r0], #1 ; load number from src
	str r3, [r2], #1 ; store number to dst
	subs r1, #1 ; decrement counter
	bne l ; repeat till all numbers are transferred from src to dst
	ldr r0, =dst
	mov r1, #0 ; i ~ r1 <- 0
	mov r2, #0
	mov r3, #0
	mov r4, #0
outer
	mov r3, r1 ; minIndex ~ r3 <- i
	mov r4, [r0] ; 
	ldrb r5, [r0], #1 ; r5 = 
	add r2, r1, #1 ; j ~ r2 <- i+1
	mov r6, r0
inner
	mov r7, r6
	ldrb r8, [r6], #1
	cmp r5, r8
	movhi r3, r7
	add r2, #1
	cmp r2, #10
	bne inner
	ldrb r9, [r3]
	ldrb r10, [r4]
	strb r9, [r4]
	strb r10, [r3]
	add r1, #1
	cmp r1, #9
	bne outer
stop b stop

arr dcb 0x10, 0x05, 0x33, 0x24, 0x56, 0x77, 0x21, 0x04, 0x87, 0x01
	AREA mydata, data, readwrite
dst dcb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
	end

/*
output:
arr:
addr      |       val
0x00000070

dst:
addr      |       val
0x10000000