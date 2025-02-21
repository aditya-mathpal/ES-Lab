; Batch C2 Q2
; You are given two hexadecimal numbers n1, n2 in the code memory
; Calculate the sum of the products of every corresponding digit
; Store the result in the data memory
; e.g. n1 = 0x12345678, n2 = 0x11111111 then result = 1 * 1 + 2 * 1 + 3 * 1 + ... 8 * 1 = 0x00000024

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
    ldr r0, =n1
    ldr r1, =n2
    mov r4, #4 ; counter
    mov r8, #0 ; r8: result
loop
    ldrb r2, [r0], #1
    ldrb r3, [r1], #1
    and r5, r2, #0x0F
    and r6, r3, #0x0F
    mul r7, r5, r6
    add r8, r7
    and r5, r2, #0xF0
    and r6, r3, #0xF0
    lsr r5, #4
    lsr r6, #4
    mul r7, r5, r6
    add r8, r7
    subs r4, #1 ; counter--
    bne loop ; if(r4 > 0) loop again
    ldr r0, =dst
    str r8, [r0]
stop b stop

n1 dcd 0x12345678
n2 dcd 0x11111111
    
    AREA mydata, DATA, READWRITE
dst dcd 0 ; should be 24
    
    END