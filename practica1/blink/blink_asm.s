// blink_asm.s - Parpadeo en ensamblador
// Acceso al controlador del puerto PIOB

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones externas y exportadas
// ----------------------------------------------
.extern  delay              @ delay es una función externa
.global blink               @ Para que la función 'blink' sea
.type blink, %function      @   accesible desde otros módulos


// Declaración de constantes
// -------------------------
.equ PIOB,     0x400E1000   @ Dirección base del puerto PIOB
.equ PIO_SODR, 0x030        @ Offset del Set Output Data Register
.equ PIO_CODR, 0x034        @ Offset del Clear Output Data Register
.equ LEDMSK,   0x08000000   @ El LED está en el pin 27
.equ CHIPID,   0x400E0940   @ Dirección del CHIP ID Register

// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'blink'
   Parámetros de entrada:
     r0: Número de veces que parpadeará el LED
     r1: Tiempo encendido/apagado (en milisegundos)
   Parámetro de salida:
     r0: Identificador del chip (contenido del registro CHIP_ID)
*/
.thumb_func
blink:
  push  {r4-r7, lr}          @ Apila de r4 a r7 y LR
  mov   r4, r0               @ r4 <- número de parpadeos
  mov   r5, r1               @ r5 <- tiempo encendido/apagado
  ldr   r6, =PIOB            @ r6 <- dir. base del puerto PIOB
  ldr   r7, =LEDMSK          @ r7 <- máscara con el bit 27 a 1
parpadeo:
  str   r7, [r6, #PIO_SODR]  @ Enciende el LED escribiendo en SET
  mov   r0, r5               @ r0 <- tiempo encendido/apagado
  bl    delay                @ Llama a la función delay
  str   r7, [r6, #PIO_CODR]  @ Apaga el LED escribiendo en CLEAR
  mov   r0, r5               @ r0 <- tiempo encendido/apagado
  bl    delay                @ Llama a la función delay
  subs  r4, r4, #1           @ r4 <- parpadeos - 1 (¡Ojo la s!)
  bne   parpadeo             @ Si no es cero, otro parpadeo.
  ldr   r0, =CHIPID          @ r0 <- dirección del CHIP ID Register
  ldr   r0, [r0]             @ r0 <- contenido del CHIP ID Register
  pop   {r4-r7, pc}          @ Desapila r4 a r7 y vuelve
.end

