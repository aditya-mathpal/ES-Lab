Reset_Handler
    ldr r0, =bcd
    ldr r1, [r0]
    mov r3, #1
l1  mov r2, r1
    and r2, #0xF
    mla r4, r2, r3, r4
    mul r3, #10
    lsrs R1, #4
    bne l1
    ldr r0, =hex
    str r4, [r0]