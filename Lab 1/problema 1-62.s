.data
palabra: .word 0x10203040
espacio: .space 4
.text
main: ldr r0, =palabra
mov r1,#3
ldr r2, =espacio
mov r3, #0
loop: ldrb r4, [r0,r1]
strb r4, [r2,r3]
add r3, #1
sub r1, #1
bpl loop
fin: wfi
