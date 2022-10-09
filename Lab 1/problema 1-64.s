.data
bytes: .byte 0x10, 0x20, 0x30, 0x40
espacio: .space 4
.text
main: ldr r0, =bytes
ldr r2, =espacio
ldr r1,[r0]
str r1,[r2]
fin: wfi
.end
