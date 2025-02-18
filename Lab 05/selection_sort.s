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
l	ldrb r3, [r0], #1 ; load number from src
	strb r3, [r2], #1 ; store number to dst
	subs r1, #1 ; decrement counter
	bne l ; repeat till all numbers are transferred from src to dst
	ldr r0, =dst
	mov r1, #0 ; i ~ r1 <- 0
outer
	mov r3, r1 ; minIndex ~ r3 <- i
	add r4, r0, r1 ; r4 <- &arr[i]
	ldrb r5, [r4] ; r5 <- arr[minIndex]
	add r2, r1, #1 ; j ~ r2 <- i+1
inner
	add r6, r0, r2 ; r6 <- &arr[j]
	ldrb r7, [r6] ; r7 <- arr[j]
	cmp r5, r7 ; if(arr[minIndex] > arr[j])
    bls skip
	mov r3, r2 ; then minIndex = j
	ldrb r5, [r6] ; then r5 <- arr[minIndex]
skip
	add r2, #1 ; r2++
	cmp r2, #10 ; if(r2 > 10) array end
	bne inner ; then repeat
	add r6, r0, r3 ; r6 <- &arr[minIndex]
	ldrb r8, [r4] ; r8 <- arr[i]
	ldrb r9, [r6] ; r9 <- arr[minIndex]
	strb r8, [r6] ; arr[minIndex] <- r8
	strb r9, [r4] ; arr[i] <- r9
	add r1, #1 ; r1++
	cmp r1, #9 ; if(r1 < n-1)
	bne outer ; then repeat
stop b stop

arr dcb 0x10, 0x05, 0x33, 0x24, 0x56, 0x77, 0x21, 0x04, 0x87, 0x01
	AREA mydata, data, readwrite
dst dcb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
	end

/*
output:
arr:
addr      |       val
0x00000060

dst:
addr      |       val
0x10000000