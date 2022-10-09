.data
cadenaascii: .ascii "Esto es un problema" @cadena en ascii
cadenabyte: .byte
0x45,0x73,0x74,0x6F,0x20,0x65,0x73,0x20,0x75,0x6E,0x20,0x70,0x72,0x6F,0x62,0x6C,0x
65,0x6D,0x61 @cadena en byte
@cadena en word
cadenaword: .word 0x6F747345, 0x20736520,0x70206E75,0x6C626F72,0x616D65 
.text
ldr r2, =cadenaascii
bl printString
bl cls @limpiar lcs
mov r0, #0 @limpiar registros del 0-3
mov r1, #0 @limpiar registros del 0-3
mov r2, #0 @limpiar registros del 0-3
mov r3, #0 @limpiar registros del 0-3
ldr r2, =cadenabyte
bl printString
bl cls
mov r0, #0
mov r1, r0
mov r2, r1
mov r3, r2
ldr r2, =cadenaword
bl printString
stop: wfi
