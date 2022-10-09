.data
str1: .asciz "Hello World!!"
str2: .asciz "WORL!"
.balign 4
res: .space 4
.text
main: ldr r0, =str1
bl loStr
mov r6, r5
mov r5, #0
ldr r0, =str2
bl loStr
ldr r0, =res
mov r7, r5
cmp r7,r6
bgt mayor
 mov r6,#2
 str r6,[r0]
b menor
mayor: mov r6,#1
menor: str r6,[r0]
stop: wfi
loStr: ldrb r2, [r0]
cmp r2,r3
beq finCic
add r5, #1
add r0, #1
b loStr
finCic: mov pc, lr
.end
