.data
v: .word 5,3,8,5,6,8,10,4,8,7,5,7
long: .word 12
res1: .space 4
res2: .space 4
res: .space 4
n: .space 7
.text
main: ldr r0, =v
ldr r1, =long
ldr r1,[r1]
ldr r2, =n
ldr r2, [r2]
ldr r7, =res1
bl numIgQue
ldr r0, =res1
ldr r0,[r0]
ldr r1, =res2
ldr r1,[r1]
add r0,r1
ldr r2, =res
str r0,[r2]
stop: wfi
numIgQue: ldr r4,[r0]
cmp r1, r3
beq finCic
sub r1, #1
cmp r4,r2
ble esMeIg
b noMeIg
esMeIg: add r5, #1
noMeIg: add r0, #4
b numIgQue
finCic: str r5, [r7]
mov pc, lr
.end
