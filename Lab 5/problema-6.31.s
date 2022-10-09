	.data
subr1: 	.word 7, 6, 5, 4, 3, 2
subr2: 	.word 8, 9
dim: 	.word 6
 	.text
@ Programa invocador
main: 	ldr r0, =subr1
	ldr r2, =subr2 @en esta parte es donde ambas matrices empiezan su proceso
	ldr r4, =dim
	ldr r1, [r4]

fin: 	wfi

push {r4, r5, r6, lr}
sub sp, sp, #32
add r4, sp, #0
str r0, [sp, #24]
str r1, [sp, #28]
mov r5, r0
mov r6, r1

for1: cmp r6, #0
beq finfor1
 @ --- 2 ---
str r2, [r4]
 @ --- 3 ---
 add r4, r4, #4
 add r5, r5, #4
 sub r6, r6, #1
 mov r0, r5
mov r1, r6
 b for1

finfor1: @ --- 4 ---
ldr r0, [sp, #24]
ldr r1, [sp, #28]
add r4, sp, #0

for2: cmp r1, #0
beq finfor2
ldr r5, [r4]
str r5, [r0]
add r4, r4, #4
 add r0, r0, #4
 sub r1, r1, #1
b for2

finfor2: @ --- 5 ---
add sp, sp, #32
pop {r4, r5, r6, pc}

@Aqui se hacen las sumatorias de matrices para devolver el vector
push {r5, r6, r7, lr}
mov r2, #0
mov r6, r1
mov r5, r0
for3: cmp r6, #0
beq finfor3
ldr r7, [r5]
add r5, r5, #4
add r2, r2, r7
sub r6, r6, #1
b for3
finfor3: pop {r5, r6, r7, pc}
	 .end @Fin del problema
