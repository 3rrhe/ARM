// Acceso al controlador del puerto PIOB

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones externas y exportadas
// ----------------------------------------------
.extern  delay              @ delay es una función externa
.global divi               @ Para que la función 'blink' sea
.type divi, %function      @   accesible desde otros módulos


// Declaración de constantes
// -------------------------
//.equ PIOB,     0x400E1000   @ Dirección base del puerto PIOB
//.equ PIO_SODR, 0x030        @ Offset del Set Output Data Register
//.equ PIO_CODR, 0x034        @ Offset del Clear Output Data Register
//.equ LEDMSK,   0x08000000   @ El LED está en el pin 27
//.equ CHIPID,   0x400E0940   @ Dirección del CHIP ID Register

// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'divi'
   Parámetros de entrada:
     r0: numero 1
     r1: numero 2
   Parámetro de salida:
     r0: resultado
*/
.thumb_func
divi:
  push  {r4-r5, lr}          @ Apila de r4 a r7 y LR
  mov   r4, r0               @ r4 <- número 1
  mov   r5, r1               @ r5 <- número 2
  udiv   r3, r4, r5
  add   r0, r3, #0x30
 // ldr   r0, [r0]
  pop   {r4-r5, pc}          @ Desapila r4 a r7 y vuelve
.end
