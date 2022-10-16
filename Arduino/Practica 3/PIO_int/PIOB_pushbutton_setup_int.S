// PIOB_pushbutton_setup_int.s - Implementa la rutina PIOB_pushbutton_setup_int
// Acceso al controlador del puerto PIOB.

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global PIOB_pushbutton_setup_int            @ Para que la función 'PIOB_pushbutton_setup_int'
.type PIOB_pushbutton_setup_int, %function   @   sea accesible desde otros módulos

// Declaración de constantes
// -------------------------
.equ PIOB,       0x400E1000    @ Dirección base del puerto PIOB
.equ PIO_IER,    0x040         @ Interrupt enable Reg
.equ PIO_IDR,    0x044         @ Interrupt Disable Reg
.equ PIO_AIMER,  0x0B0         @ Additional Interrupt Modes Enable Register   
.equ PIO_AIMDR,  0x0B4         @ Additional Interrupt Modes Disable Register   
.equ PIO_ESR,    0x0C0         @ Edge Select Register   
.equ PIO_LSR,    0x0C4         @ Level Select Register   
.equ PIO_FELLSR, 0x0D0         @ Falling Edge/Low Level Select Register   
.equ PIO_REHLSR, 0x0D4         @ Rising Edge/High Level Select Register   
// ---
.equ PULMSK,    0x08000000     @ El pulsador está en el pin 13 -> bit 27 del puerto PIOB


// Comienzo de la zona de código
// -----------------------------
.text

/*
   Subrutina 'PIOB_pushbutton_setup_int'
     Configura la señal del pin al que está conectado el pulsador como una señal de petición
       de interrupción y fija el modo y polaridad que determinarán ante qué variación o estado
       de esta señal se producirá una petición de interrupción.
   Parámetros de entrada:
     r0: modo de interrupción (0: cambio, 1: nivel, 2: flanco)
     r1: polaridad (0: flanco de bajada/nivel bajo, 1: flanco de subida/nivel alto)
   Parámetro de salida:
     No tiene.
*/
.thumb_func
PIOB_pushbutton_setup_int:
  // Apila los registros que se vayan a modificar
  push   {lr}                  @ Apila LR
  // ----------------------
  // Inicialización
  // ----------------------
  ldr    r2, =PIOB             @ r2 <- dir. base del puerto PIOB
  ldr    r3, =PULMSK           @ r3 <- máscara con el bit del pulsador activado
  str    r3, [r2, #PIO_IDR]    @ Deshabilita interrupciones                  [*?*]
  // ----------------------
  // Configuración del modo
  // ----------------------
  cmp    r0, #0                @ Si el modo no es CAMBIO, es uno de los adicionales,
  bne    adicionales           @  salta a modos adicionales
  // Modo cambio
  str    r3, [r2, #PIO_AIMER]  @ Deshabilita modos adicionales               [*?*]
  b      habilita              @  y salta a habilita interrupciones
adicionales:
  str    r3, [r2, #PIO_AIMDR]  @ Habilita modos adicionales                  [*?*]
  cmp    r0, #1                @ Si el modo no es NIVEL,
  bne    esflanco              @  salta a esflanco
  // Modo nivel
  str    r3, [r2, #PIO_LSR]    @ Selecciona modo de interrupción por nivel   [*?*]
  b    polaridad               @  y salta a polaridad
esflanco:
  cmp    r0, #2                @ Si el modo no es FLANCO, el parámetro r0
  bne    finmal                @  está mal, sale sin habilitar interr.
  // Modo flanco
  str    r3, [r2, #PIO_ESR]    @ Selecciona modo de interrupción por flanco  [*?*]
  // ------------------------------
  //  Configuración de la polaridad
  // ------------------------------
polaridad:
  cmp    r1, #0                @ Si la polaridad no es BAJO
  bne    esalto                @  salta a configurar ALTO
  // Polaridad flanco de bajada/nivel bajo
  str    r3, [r2, #PIO_FELLSR] @ Selecciona flanco de bajada/nivel bajo      [*?*]
  b      habilita              @  y salta a habilita interrupciones
esalto:
  cmp    r1, #1                @ Si el modo no es FLANCO, el parámetro r0
  bne    finmal                @  está mal, sale sin habilitar interr.
  // Polaridad flanco de subida/nivel alto
  str    r3, [r2, #PIO_REHLSR] @ Selecciona flanco de subida/nivel alto      [*?*]
  // ------------------------------
  //  Salida
  // ------------------------------
habilita:
  str    r3, [r2, #PIO_IER]    @ Habilita interrupciones                     [*?*]
finmal:
  pop    {pc}                  @ Regresa al invocador (PC <- LR)
.end
