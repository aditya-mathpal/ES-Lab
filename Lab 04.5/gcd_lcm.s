; Find gcd and lcm of two numbers

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
    ; gcd
    ldr r0, =num1
    ldr r1, =num2
    ldr r2, [r0] ; r2 <- num1
    ldr r3, [r1] ; r3 <- num2
x   cmp r2, r3
    beq store_gcd ; if r2 == r3, store result
    subhi r2, r3 ; r2 -= r3
    sublo r3, r2 ; r3 -= r2
    b x
store_gcd
    ldr r4, =gcd
    str r2, [r4] ; store gcd
    ; lcm
    ldr r3, [r0] ; r3 <- num1
    ldr r4, [r1] ; r4 <- num2
    ; gcd is stored in r2
    ; use formula lcm = (num1 * num2)/gcd
    mul r3, r4 ; r3 *= r4 ; r3 == num1 * num2
    mov r5, #0 ; counter
xx  cmp r3, r2
    bcc store_lcm
    sub r3, r2
    add r5, #1
    b xx
store_lcm
    ldr r6, =lcm
    str r5, [r6] ; store lcm
stop
    b stop

    AREA mydata1, DATA, READONLY
num1 dcd 0x8
num2 dcd 0xC
    AREA mydata2, DATA, READWRITE
gcd dcd 0
lcm dcd 0

    END

/*
output:
R0: 0x00000054
R1: 0x00000058
R2: 0x00000004
R3: 0x00000000
R4: 0x0000000C
R5: 0x00000018
R6: 0x10000004
num1: addr: 0x00000054 val: 0x00000008
num2: addr: 0x00000058 val: 0x0000000C
gcd:  addr: 0x10000000 val: 0x00000004
lcm:  addr: 0x10000004 val: 0x00000018
*/