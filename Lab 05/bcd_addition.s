; BCD addition on two 32-bit numbers

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
    ldr r0, =num1
    ldr r1, =num2
    ldr r2, =dst
    mov r3, #0 ; result to be stored in r3
    mov r4, #1 ; multiplier
    mov r5, #0 ; carry storage
    mov r6, #4 ; counter (4 bytes = 8 digits)
process_byte
    ldrb r7, [r0], #1 ; load byte from num1
    ldrb r8, [r1], #1 ; load byte from num2
    and r9, r7, #0x0F ; extract lower nibble from num1
    and r10, r8, #0x0F ; extract lower nibble from num2
    add r11, r9, r10 ; add nibbles
    add r11, r11, r5 ; add carry
    mov r5, #0 ; clear carry
    cmp r11, #9
    ble lower_adjust ; branch if r11 <= 9
    add r11, r11, #6
    mov r5, #1 ; set carry
lower_adjust
    mla r3, r11, r4, r3
    mov r4, r4, lsl #4 ; shift left by one byte
    mov r9, r7, lsr #4 ; extract upper nibble from num1
    and r9, #0x0F
    mov r10, r8, lsr #4 ; extract upper nibble from num2
    and r10, #0x0F
    add r11, r9, r10 ; add nibbles
    add r11, r11, r5 ; add carry
    mov r5, #0 ; clear carry
    cmp r11, #9
    ble upper_adjust
    add r11, r11, #6
    mov r5, #1 ; set carry
upper_adjust
    mla r3, r11, r4, r3
    mov r4, r4, lsl #4
    subs r6, #1 ; r6--
    bne process_byte
    str r3, [r2]
stop
    b stop

    AREA mydata, DATA, READONLY
num1 dcd 0x00000145     ; BCD 145
num2 dcd 0x00000123     ; BCD 123

    AREA result, DATA, READWRITE
dst dcd 0              ; Result storage

    END

/*
output:
R0: 0x00000098
R1: 0x0000009C
R2: 0x10000000
R3: 0x00000268
R4-11: 0x00000000
num1: addr: 0x00000094 val: 0x00000145
num2: addr: 0x00000098 val: 0x00000123
dst:  addr: 0x10000000 val: 0x00000268
*/