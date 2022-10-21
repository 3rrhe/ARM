// blink_cadena.s - Parpadeo en ensamblador en función de una cadena
// Acceso al controlador del puerto PIOC

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
.equ PIOC,     0x400E1200   @ Dirección base del puerto PIOC         [*?*]
.equ PIO_SODR, 0x030        @ Offset del Set Output Data Register
.equ PIO_CODR, 0x034        @ Offset del Clear Output Data Register
.equ LEDMSK,   0x01000000   @ El LED azul está en el pin 24          [*?*]

// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'blink'
   Parámetros de entrada:
     r0: Cadena cuya longitud fijará el número de veces que parpadeará el LED
     r1: Tiempo encendido/apagado (en milisegundos)
   Parámetro de salida:
     r0: Longitud de la cadena referida por r0
*/
.thumb_func
blink:
  push  {r4-r7, lr}          @ Apila de r4 a r7 y LR
  mov   r3, r0               @ r3 <- dirección de comienzo de la cadena
  mov   r4, #0               @ r4 <- contador de caracteres
  mov   r5, r1               @ r5 <- tiempo encendido/apagado
  ldr   r6, =PIOC            @ r6 <- dir. base del puerto PIOC
  ldr   r7, =LEDMSK          @ r7 <- máscara con el bit 24 a 1
principio:
  ldrb  r2, [r3, r4]         @ r2 <- siguiente carácter de la cadena    [*?*]
  cmp   r2, #0               @ Compara carácter con 0
  beq   fin                  @ Si es el carácter es 0, termina          [*?*]
  str   r7, [r6, #PIO_CODR]  @ Enciende el LED escribiendo en CLEAR     [*?*]
  push  {r3}                 @ Apila r3, ya que delay puede modificarlo
  mov   r0, r5               @ r0 <- tiempo encendido/apagado
  bl    delay                @ Llama a la función delay
  str   r7, [r6, #PIO_SODR]  @ Apaga el LED escribiendo en SET          [*?*]
  mov   r0, r5               @ r0 <- tiempo encendido/apagado
  bl    delay                @ Llama a la función delay
  pop   {r3}                 @ Recupera r3 <- dir. comienzo cadena
  add   r4, r4, #1           @ Incrementa contador de caracteres
  b     principio            @ Continúa con el siguiente carácter
fin:
  mov   r0, r4               @ Copia número de caracteres en r0         [*?*]
  pop   {r4-r7, pc}          @ Desapila r4 a r7 y vuelve
.end
