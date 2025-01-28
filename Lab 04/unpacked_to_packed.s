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