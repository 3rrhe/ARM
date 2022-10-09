.data
v: .word 2,7,6,3,10
long: .word 5 @Longitud del vector v
res: .space 4 @Var resultado
.text
main: ldr r0, =v
ldr r1, =long
ldr r1, [r1]
ldr r2, =res
ciclo:cmp r1, r3
beq finCic @r1==r3?
ldr r4, [r0]
mov r5, r4
lsl r5, #31
cmp r5, r3
bne impar @N esta activo?
add r6, r4
impar:add r0, #4
sub r1, #1
b ciclo
finCic:str r6, [r2]
stop: wfi
