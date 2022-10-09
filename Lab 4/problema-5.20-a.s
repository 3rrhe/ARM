.data
str: .asciz "Hello WORLD!!"
.balign 4
n: .space 4
.text
main: ldr r0, =str
ldr r1, =n
bl loStr
stop: wfi
loStr: ldrb r2, [r0]
cmp r2,r3
beq finCic
 add r6, #1
 add r0, #1
b loStr
finCic: str r6,[r1]
mov pc, lr
.end
