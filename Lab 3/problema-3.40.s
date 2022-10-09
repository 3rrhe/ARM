.data
v: .word 2,4,6,3,10,1,4 @ Definimos los valores del vector
long: .word 7 @Definimos la longitud del vector
n: .word 5 @Numero que sera comparado
k: .space 4 @Suma de los numeros mayores a n
.text
main: ldr r0, =v
ldr r1, [r0]
ldr r2, =long
ldr r2, [r2]
ldr r3, =n
ldr r3, [r3]
ldr r6, =k
ciclo:cmp r2,r4
beq finCic
cmp r1,r3
bpl mayores
b menores
mayores: add r5, r1
menores: add r0, #4
ldr r1, [r0]
sub r2, #1
b ciclo
finCic:str r5,[r6]
stop: wfi
