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
	mov r5, #4
	ldr r0, =num
	ldr r3, =result
up	ldrb r1, [r0], #1 ; load bcd number into reg r1
	and r2, r1, #0x0F ; mask upper 4 bits
	add r2, #0x30 ; add 0x30 to the number, ascii value of first digit
	str r2, [r3], #4
	and r4, r1, #0xF0 ; mask the second digit
	mov r4, r4, lsr #04 ; shift right by 4 bits
	add r4, #0x30 ; ascii value of second digit
	str r4, [r3], #4
	subs r5, #1
	bne up ; repeat 4 times
stop b stop

num dcd 0x12345678
	
	AREA data, DATA, READWRITE
result dcd 0
	END

/*
output:
R0: 0x0000003C
R1: 0x00000012
R2: 0x00000032
R3: 0x10000020
R4: 0x00000031
R5: 0x00000000
num: 	addr: 0x00000038 val: 0x12345678
result: addr: 0x10000000 val: 0x0000003100000032000000330000003400000035000000360000003700000038
*/