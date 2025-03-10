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
    ldr r0, =bcd
    ldr r1, [r0]
    mov r3, #1
	mov r5, #10
l1  mov r2, r1 ; r2 <- bcd val
    and r2, #0xF ; taking least 4 signficant bits
    mla r4, r2, r3, r4 ; r4 += r2 x r3
    mul r3, r5 ; r3 *= 10
    lsrs r1, #4
    bne l1
    ldr r0, =hex
    str r4, [r0]
stop b stop

	AREA mydata, DATA, READONLY
bcd dcd 0x98989898 ; equivalent hex is 0x05E6774A
	AREA mydata2, DATA, READWRITE
hex dcd 0

	END

/*
output:
R0: 0x10000000
R1: 0x00000000
R2: 0x00000009
R3: 0x05F5E100
R4: 0x05E6774A
R5: 0x0000000A
bcd: addr: 0x00000034 val: 0x98989898
hex: addr: 0x10000000 val: 0x05E6774A
*/