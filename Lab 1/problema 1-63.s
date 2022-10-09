.data
palabra: .word 0x10203040
.text
main: ldr r0, =palabra
ldrh r1,[r0]
ldrh r2,[r0,#2]
strh r2,[r0]
strh r1,[r0,#2]
fin: wfi
.end
