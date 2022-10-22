// pulsa.s - Espera la pulsación del pulsador y devuelve el identificador del chip.
// Acceso al controlador del puerto PIOB.
// Sincronización mediante consulta de estado.

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global pulsador               @ Para que la función 'pulsador' sea
.type pulsador, %function      @   accesible desde otros módulos

// Declaración de constantes
// -------------------------
.equ PIOB,      0x400E1000     @ Dirección base del puerto PIOB
.equ PIO_PDSR,  0x03C          @ Offset del Pin Data Status Register
// ---
.equ PULMSK,    0x08000000     @ El pulsador está en pin 13 -> bit 27 del puerto PIOB
// ---
.equ CHIPID,    0x400E0940     @ Dirección del CHIP ID Register

// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'pulsador'
     Espera la pulsación del pulsador y devuelve el identificador del chip.
   Parámetros de entrada:
     No tiene.
   Parámetro de salida:
     r0: Identificador del chip (contenido del registro CHIP_ID)
*/
.thumb_func
pulsador:
  // Apila los registros que se vayan a modificar
  push   {lr}                  @ Apila LR
  ldr    r0, =PIOB             @ r0 <- dir. base del puerto PIOB
  ldr    r1, =PULMSK           @ r1 <- máscara con el bit del pulsador activado

  // Consulta el estado del pulsador repetidamente hasta que detecta que se ha pulsado
consulta:
  ldr    r2, [r0, #PIO_PDSR]   @ Lee el registro de datos del puerto PIOB              [*?*]
  ands   r2, r1                @ Aplica una máscara para extraer el bit del pulsador   [*?*]
  beq    consulta              @ Y si no está pulsado, vuelve a consultar              [*?*]

  // Carga el contenido del CHIP ID Register en r0
  ldr    r0, =CHIPID           @ r0 <- dirección del CHIP ID Register
  ldr    r0, [r0]              @ r0 <- contenido del CHIP ID Register

  // Retorna
  pop    {pc}                  @ Regresa al invocador (PC <- LR)
.end
