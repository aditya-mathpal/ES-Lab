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
    mov R2, #0 
    mov R3, #0 
 
x 
    cmp R0, #10 
    bcc xx 
    sub R0, R0, #10 
    add R2, R2, #1 
    b x 
 
xx 
    mov R4, R0, LSL R3 
    add R3, R3, #4
    orr R1, R1, R4 
    mov R0, R2
    cmp R0, #0 
	ldr r5, =bcd
	str r1, [r5]
    beq stop
    mov R2, #0 
	b x
stop b stop

	AREA mydata, DATA, READONLY
hex dcd 0x774A ; equivalent bcd is 0x30538
	AREA mydata2, DATA, READWRITE
bcd dcd 0

    END

/*
output:

hex: addr: 0x00000048 val: 
bcd: addr: 0x10000000 val: 0x033337