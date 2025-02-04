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
	ldr r5, =hex
	ldr r0, [r5]
    mov r1, #0 
    mov r2, #0 
    mov r3, #0 
 
x 
    cmp r0, #10 
    bcc xx 
    sub r0, r0, #10 
    add r2, r2, #1 
    b x 
 
xx 
    mov r4, r0, LSL r3 
    add r3, r3, #4
    orr r1, r1, r4 
    mov r0, r2
    cmp r0, #0 
	ldr r5, =bcd
	str r1, [r5]
    beq stop
    mov r2, #0 
	b x
stop b stop

	AREA mydata, DATA, READONLY
hex dcd 0x774A ; equivalent bcd is 0x30538
	AREA mydata2, DATA, READWRITE
bcd dcd 0

    END

/*
output:
R0: 0x00000000
R1: 0x00030538
R2: 0x00000000
R3: 0x00000014
R4: 0x00030000
R5: 0x10000000
hex: addr: 0x0000004C val: 0x774A
bcd: addr: 0x10000000 val: 0x030538
*/