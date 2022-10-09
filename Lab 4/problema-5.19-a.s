.data
v: .word 50,1,10,20,3,30,40
long: .word 7 @Longitud del vector
res: .space 5 @Resultado de pares
.text
main: ldr r0, =v
ldr r1, =long
ldr r1, [r1]
ldr r2, =res
bl cantPar
stop: wfi
cantPar: cmp r1, r3
beq finCic
ldr r4, [r0]
mov r5, r4
lsl r5, #31
cmp r5, r3
bne esImp 
add r6, #1
esImp: add r0, #4
sub r1, #1
b cantPar
finCic: str r6, [r2]
mov pc, lr
