// lee_minutos.s - Consulta los minutos y segundos del RTC
// Acceso al controlador del RTC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global lee_minutos           @ Para que la función 'lee_minutos'
.type lee_minutos, %function  @   sea accesible desde otros módulos

// Declaración de constantes
// -------------------------
.equ RTC,        0x400E1A60   @ Dirección base del RTC   [*?*]
.equ RTC_TIMR,   0x08         @ Offset Time Register
.equ RTC_CALR,   0x0C         @ Offset Calendar Register
// Formato del Time Register
/*
   31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
  +--------------------------+--+-----+-----------+--+--------+-----------+--+--------+-----------+
  |                          |AP| HD  |  HOUR_U   |  | MIN_D  |   MIN_U   |  | SEC_D  |   SEC_U   |
  +--------------------------+--+-----+-----------+--+--------+-----------+--+--------+-----------+
*/
// Máscaras para extraer las partes de la hora de RTC_TIMR
.equ MSK_MIN_D,   0x00007000  @ Decenas de minuto        [*?*]
.equ MSK_MIN_U,   0x00000F00  @ Unidades de minuto       [*?*]
.equ MSK_SEC_D,   0x00000070  @ Decenas de segundo       [*?*]
.equ MSK_SEC_U,   0x0000000F  @ Unidades de segundo      [*?*]

// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'lee_minutos'.
  Consulta los minutos y segundos del RTC y los devuelve en el vector indicado.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    r0: Contenido del registro RTC_TIMR.
    Vector de enteros de longitud 2 (dirección especificada inicialmente en r0)
*/
.thumb_func
lee_minutos:
  push  {r4-r7, lr}          @ Apila de r4 a r7 y LR
  ldr   r1, =RTC             @ r1 <- dirección base del RTC
  ldr   r2, [r1, #RTC_TIMR]  @ r2 <- hora actual (Time Register)      [*?*]
  mov   r3, #10              @ r3 <- 10 (para multiplicar por 10)

  // Convierte los minutos en RTC_TIMR de BCD a un entero
  mov  r5, r2               @ r5 <- hora actual
  and  r5, #MSK_MIN_D       @ Aplica máscara decenas minuto           [*?*]
  lsr  r5, #12              @ Desplaza decenas de minuto              [*?*]
  mul  r5, r3               @ r5 <- decenas de minuto * 10
  mov  r4, r2               @ r4 <- hora actual
  and  r4, #MSK_MIN_U       @ Aplica máscara unidades minuto          [*?*]
  lsr  r4, #8               @ Desplaza unidades de minuto             [*?*]
  add  r5, r5, r4           @ r5 <- decenas minuto * 10 + unidades
  str  r5, [r0, #0]         @ Guarda minutos en v[0], v dado por r0   [*?*]
   
  // Convierte los segundos en RTC_TIMR de BCD a un entero
  mov  r5, r2               @ r5 <- hora actual
  and  r5, #MSK_SEC_D       @ Aplica máscara decenas segundo          [*?*]
  lsr  r5, #4               @ Desplaza decenas de segundo             [*?*]
  mul  r5, r3               @ r5 <- decenas de segundo * 10
  mov  r4, r2               @ r4 <- hora actual
  and  r4, #MSK_SEC_U       @ Aplica máscara unidades segundo         [*?*]
  add  r5, r5, r4           @ r5 <- decenas segundo * 10 + unidades
  str  r5, [r0, #4]         @ Guarda segundos en v[1], v dado por r0  [*?*]

  // Copia en r0 la hora actual (el contenido de RTC_TIMR), desapila y regresa
  mov  r0, r2               @ r0 <- contenido RTC_TIMR
  pop  {r4-r7, pc}          @ Desapila y vuelve
.end

   
   
