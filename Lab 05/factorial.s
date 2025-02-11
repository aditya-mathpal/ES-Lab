; Given n, find factorial of n

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
    ldr r0, =n
    ldr r1, [r0] ; r1 <- n
    ldr r0, =dst
    mov r2, #1 ; r2 <- 0
x   cmp r1, #0
    beq store ; if r1 == 0, store result
    mul r2, r1 ; r2 *= r1
    sub r1, #1 ; r1--
    b x
store
    str r2, [r0]
stop
    b stop

    AREA mydata1, DATA, READONLY
n dcd 5
    AREA mydata2, DATA, READWRITE
dst dcd 0

    END

/*
output:
R0: 0x10000000
R1: 0x00000000
R2: 0x00000078

n:   addr: 0x0000002C val: 0x00000005
dst: addr: 0x10000000 val: 0x00000078
*/