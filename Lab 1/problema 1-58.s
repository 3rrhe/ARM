.data @ Comienzo de la zona de datos
valor1: .word 0x3
reserva1: .space 4
valor2: .byte 0x10
reserva2: .space 1
reserva3: .space 4
valor3: .byte 0x4
reserva4: .space 1
aling: .align 2
.text
stop: wfi
