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
    ldr r0, =hex
    ldr r1, [r0]
    
loop
    
    bne loop
    ldr r0, =bcd
    str r2, [r0]
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