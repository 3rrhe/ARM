     ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00000000000000000001000000000000
        str     r1, [r0, #GPFSEL0]  @ Configura GPIO 4
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000000000010000
        ldr     r2, =STBASE

bucle:  bl      espera        @ Salta a rutina de espera
        str     r1, [r0, #GPSET0]
        bl      espera        @ Salta a rutina de espera
        str     r1, [r0, #GPCLR0]
        b       bucle

/* rutina que espera 1136 microsegundos */
espera: ldr     r3, [r2, #STCLO]  @ Lee contador en r3
        ldr     r4, =1136
        add     r4, r3            @ r4= r3 + 1350 DO
        ldr     r4, =1136
        add     r4, r3            @ r4= r3 + 1701 MI
        ldr     r4, =1136
        add     r4, r3            @ r4= r3 + 2023 SOL
ret1:   ldr     r3, [r2, #STCLO]
        cmp     r3, r4            @ Leemos CLO hasta alcanzar
        bne     ret1              @ el valor de r4
        bx      lr