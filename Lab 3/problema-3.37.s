.data
n1: .byte 8 @primera nota
n2: .byte 6 @segunda nota
.balign 4
res:.space 16 @tamanio mensaje
.text
main: ldr r0, =n1 @r0 <- dir n1
ldrb r0, [r0] @r0 <- cont n1
ldr r1, =n2 @r1 <- dir n2
ldrb r1, [r1] @r1 <- cont n2
add r0, r1 @r0 <- r0+r1
lsr r0, #1 @r0 <- r0/2
ldr r2, =res @r2 <- direccion del mensaje
cmp r0, #5 @r0-5
bge MI5 @r0>=5?
ldr r4, =0x50535553 @PSUS => SUSP
ldr r5, =0x4F534E45 @OSNE => ENSO
b finSi @ir a finSi
MI5: ldr r4, =0x4f525041 @ORPA => APRO
ldr r5, =0x4f444142 @ODAB => BADO
finSi: str r4,[r2] @Memoria <- r4
str r5,[r2,#4] @Memoria <- r5
stop: wfi
