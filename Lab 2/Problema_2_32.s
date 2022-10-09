.text
main: ldr r0, =0x00000003
mov r1, r0
mov r2, r0
mov r3, #32
mul r2, r3 @ r2 <- r2x32
lsl r0, #5 @ r0 <- r0x32
end: wfi
.end
