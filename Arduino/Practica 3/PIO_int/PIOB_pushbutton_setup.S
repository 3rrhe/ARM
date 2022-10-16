// PIOB_pushbutton_setup.s - Implementa la rutina PIOB_pushbutton_setup
// Acceso al controlador del puerto PIOB.

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global PIOB_pushbutton_setup            @ Para que la función 'PIOB_pushbutton_setup'
.type PIOB_pushbutton_setup, %function   @   sea accesible desde otros módulos

// Declaración de constantes
// -------------------------
.equ PIOB,      0x400E1000     @ Dirección base del puerto PIOB
.equ PIO_PER,   0x000          @ Offset del PIO Enable Register
.equ PIO_IER,   0x040          @ Offset del Interrupt Enable Register
.equ PIO_IDR,   0x044          @ Offset del Interrupt Disable Register
.equ PIO_PUER,  0x064          @ Offset del Pull Up Enable Register
.equ PIO_DIFSR, 0x084          @ Offset del Debouncing Input Filter Select Register
.equ PIO_IFER,  0x020          @ Offset del Glitch Input Filter Enable Register
.equ PIO_ODR,   0x014          @ Offset del Output Disable Register
.equ PIO_PDSR,  0x03C          @ Offset del Pin Data Status Register
// ---
.equ PULMSK,    0x08000000     @ El pulsador está en el pin 13 -> bit 27 del puerto PIOB  [*?*]
// ---
.equ ID_PIOB,   0x00C          @ Identificador del puerto PIOB (para activar su reloj)


// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'PIOB_pushbutton_setup'
     Configura el pin al que está conectado el pulsador como entrada con pull-up.
   Parámetros de entrada:
     No tiene.
   Parámetro de salida:
     No tiene.
*/
.thumb_func
PIOB_pushbutton_setup:
  // Apila los registros que se vayan a modificar
  push   {lr}                  @ Apila LR

  // Activa el reloj asociado al puerto PIOB (necesario si se va a utilizar alguna entrada)
  ldr    r0, =ID_PIOB          @ r0 <- Identificador del controlador del PIOB
  bl     pmc_enable_periph_clk @ Activa el reloj asociado al dispositivo indicado en r0

  // Configuración del pin del pulsador como entrada con pull-up
  ldr    r0, =PIOB             @ r0 <- dir. base del puerto PIOB
  ldr    r1, =PULMSK           @ r1 <- máscara con el bit del pulsador activado
  str    r1, [r0, #PIO_IDR]    @ Deshabilita interrupciones asociadas al pin           [*?*]
  str    r1, [r0, #PIO_PUER]   @ Activa el pull-up                                     [*?*]
  str    r1, [r0, #PIO_DIFSR]  @ Selecciona el filtrado de rebotes (debouncing filter) [*?*]
  str    r1, [r0, #PIO_IFER]   @ Activa el filtrado de espurios (glitch filter)        [*?*]
  str    r1, [r0, #PIO_PER]    @ Marca el pin como entrada                             [*?*]
  str    r1, [r0, #PIO_IER]    @ Habilita el bit como parte del PIO                    [*?*]

  // Retorna
  pop    {pc}                  @ Regresa al invocador (PC <- LR)
.end
