// PIOB_Handler.s - Implementa la rutina PIOB_Handler

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global PIOB_Handler           @ Para que la función 'PIOB_Handler'
.type PIOB_Handler, %function  @   sea accesible desde otros módulos

// Declaración de constantes
// -------------------------
.equ PIOB,      0x400E1000     @ Dirección base del puerto PIOB
.equ PIO_ISR,   0x04C          @ Interrupt Status Reg
// ---
.equ PULMSK,    0x08000000     @ El pulsador está en el pin 13 -> bit 27 del puerto PIOB


// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'PIOB_handler'
     Rutina de tratamiento de las interrupciones generadas por el PIOB,
       comprueba que el motivo de la interrupción esté relacionado con el
       pulsador y si es así, incrementa la variable global PIOBint.
   Parámetros de entrada:
     No tiene.
   Parámetro de salida:
     No tiene.
*/
.thumb_func
PIOB_Handler:
  // Apila los registros que se vayan a modificar
  push   {lr}                  @ Apila LR

  ldr    r0, =PIOB             @ r0 <- dir. base del puerto PIOB
  ldr    r1, =PULMSK           @ r1 <- máscara con el bit del pulsador activado
  
  ldr    r2, [r0, #PIO_ISR]    @ r2 <- interrupciones pendientes

  ands   r2, r2, r1            @ Aplica máscara
  beq    finHandler            @ Si no se está aquí por el pulsador, acaba

  // Incrementa la variable global PIOint
  ldr    r1, =PIOint
  ldr    r0, [r1]
  add    r0, r0, #1
  str    r0, [r1]

finHandler:
  pop    {pc}                  @ Regresa al invocador (PC <- LR)
.end

