 .data
palabra1: .word 0x19202122
reserva1: .space 4
byte: .byte 0x60
reserva2: .space 1
palabra2: .word 0x70808190
reserva3: .space 4
aling: .align 2 @reserva multiplo de memoria de 2^n
@alinea espacios multiplos de 2² = 4 en memoria RAM
.text
stop: wfi
