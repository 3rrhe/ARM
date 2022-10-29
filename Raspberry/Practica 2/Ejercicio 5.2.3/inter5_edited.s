/* Agrego vectores de interrupción */
        ADDEXC  0x18, irq_handler
        ADDEXC  0x1c, fiq_handler

/* Inicializo la pila en modos FIQ, IRQ y SVC */
        mov     r0, #0b11010001   @ Modo FIQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x4000
        mov     r0, #0b11010010   @ Modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0b11010011   @ Modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000

/* Configuro GPIOs 4, 9, 10, 11, 17, 22 y 27 como salida */
        ldr     r0, =GPBASE
        ldr     r1, =0b00001000000000000001000000000000
        str     r1, [r0, #GPFSEL0]
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        ldr     r1, =0b00000000001000000000000001000000
        str     r1, [r0, #GPFSEL2]

/* Enciendo LEDs       10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]

/* Habilito pines GPIO 2 y 3 (botones) para interrupciones*/
        mov     r1, #0b00000000000000000000000000001100
        str     r1, [r0, #GPFEN0]

/* Programo C1 para dentro de 2 microsegundos */
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2
        str     r1, [r0, #STC1]

/* Habilito GPIO para IRQ */
        ldr     r0, =INTBASE
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000100000000000000000000
        str     r1, [r0, #INTENIRQ2]

/* Habilito C1 para FIQ */
        mov     r1, #0b10000001
        str     r1, [r0, #INTFIQCON]

/* Habilito interrupciones globalmente */
        mov     r0, #0b00010011   @modo SVC, FIQ&IRQ activo
        msr     cpsr_c, r0
/* Rutina de tratamiento de interrupción FIQ */
fiq_handler:
        ldr     r8, =GPBASE
        ldr     r9, =bitson

/* Hago sonar altavoz invirtiendo estado de bitson */
        ldr     r10, [r9]
        eors    r10, #1
        str     r10, [r9], #4

/* Leo cuenta y luego elemento correspondiente en secuen */
        ldr     r10, [r9]
        ldr     r9, [r9, +r10, LSL #3]

/* Pongo estado altavoz según variable bitson */
        mov     r10, #0b10000     @ GPIO 4 (altavoz)
        streq   r10, [r8, #GPSET0]
        strne   r10, [r8, #GPCLR0]

/* Reseteo estado interrupción de C3 */
        ldr     r8, =STBASE
        mov     r10, #0b1000
        str     r10, [r8, #STCS]

/* Programo retardo según valor leído en array */
        ldr     r10, [r8, #STCLO]
        add     r10, r9
        str     r10, [r8, #STC3]

/* Salgo de la RTI */
        subs    pc, lr, #4

/* Repetir para siempre */
bucle:  b       bucle