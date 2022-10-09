.data
cad:	
.asciz "Texto de prueba: Cuantas letras distintas hay?"
.text
/***/
main:	
ldr r0, =cad
bl difletras

fin:	
wfi

.equ NLETRAS, 26

/***/
difletras:
push {r4 - r6, lr}
sub sp, sp, #(NLETRAS * 4)
mov r4, r0
add r5, sp, #0
mov r6, #0
mov r0, #0
for:
str r6, [r5, r0]
add r0, r0, #4
cmp r0, #(NLETRAS * 4)
bne for
add r6, r6, #1
dowhile:
ldrb r0, [r4]
tst r0, r0
beq cuenta
add r4, r4, #1
bl  numletra
cmp r0, #0
blt dowhile
lsl r0, #2
str r6, [r5, r0]
b dowhile
cuenta:
mov r0, #0
mov r1, #0
for2:
ldr r3, [r5, r1]
cmp r3, #0
beq nosuma
add r0, r0, #1
nosuma:
add r1, r1, #4
cmp r1, #(NLETRAS * 4)
bne for2
add sp, sp, #(NLETRAS * 4)
pop {r4 - r6, pc}

/***/
numletra:
mov r1, #0xDF
and r0, r1
cmp r0, #'A'
blt noletra
cmp r0, #'Z'
bgt noletra
sub r0, #'A'
mov pc, lr
noletra:
ldr r0, =-1
mov pc, lr
.end
