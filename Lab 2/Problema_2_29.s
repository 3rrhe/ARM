.data
vector: .byte 10, 20
space: .space 2
.text
main: ldr r0, =vector
ldr r4, =space
ldrb r1, [r0]
ldrb r2, [r0, #1]
add r3, r1, r2
strh r3, [r4]
end: wfi
.end
