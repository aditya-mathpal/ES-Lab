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
    mov r1, #2 ; counter
    ldr r4, =dst
l1  ldrb r2, [r0], #1
    ldrb r3, [r0], #1
    lsl r3, #4
    add r2, r3
    strb r2, [r4], #1
    subs r1, #1
    bne l1
stop b stop

	AREA mydata, DATA, READONLY
src dcd 0x01020304
	AREA mydata2, DATA, READWRITE
dst dcd 0

	END

/*
output:
R0: 0x00000034
R1: 0x00000000
R2: 0x00000012
R3: 0x00000010
R4: 0x10000002
src: addr: 0x00000030 val: 0x01020304
dst: addr: 0x10000000 val: 0x1234
*/