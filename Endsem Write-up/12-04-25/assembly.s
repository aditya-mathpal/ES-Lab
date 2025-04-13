; given an array of numbers, use a stack (fully decrementing) to find the second highest number and find its factorial via subroutine

    AREA RESET, data, readonly
        export __Vectors
            
__Vectors
    dcd 0x10001000
    dcd Reset_Handler
    align
    area mycode, code, readonly
    entry
    export Reset_Handler
        
Reset_Handler
    ldr r1, =src
    ldr r7, =num
    ldr r3, [r7]
fill_stack
    ldr r6, [r1], #4
    stmfd sp!, {r6}
    subs r3, #1
    bne fill_stack
    mov r4, #0
    mov r5, #0
    ldr r3, [r7]
loop
    ldmfd sp!, {r6}    
    cmp r6, r4
    ble skip_max1
    mov r5, r4
    mov r4, r6
    b skip_max2
skip_max1
    cmp r6, r5
    ble skip_max2
    mov r5, r6
skip_max2
    subs r3, #1
    bne loop
    bl factorial

factorial
    mov r6, #1
xx  mul r6, r5
    subs r5, #1
    bne xx
    ldr r1, =fact
    str r6, [r1]
stop
    b stop

    AREA mydata, data, readonly
src dcd 3, 7, 8, 2, 9
num dcd 5

    AREA mydata2, data, readwrite
fact dcd 0
    
    end

;output:
;fact = 9D80