// lee_fecha.s - Consulta la fecha del RTC
// Acceso al controlador del RTC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global lee_fecha             @ Para que la función 'lee_fecha'
.type lee_fecha, %function    @   sea accesible desde los módulos externos

// Declaración de constantes
// -------------------------
.equ RTC,       0x400E1A60    @ Dirección base del RTC      [*?*]
.equ RTC_TIMR,  0x08          @ Offset del Time Register
.equ RTC_CALR,  0x0C          @ Offset del Calendar Register
// Formato del Calendar Register
/*
   31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
  +-----+-----+-----------+--------+--+-----------+-----------+-----------+--+--------+-----------+
  |     |DATED|  DATE_U   |   DAY  |MD|  MONTH_U  |  YEAR_D   |  YEAR_U   |  | CENT_D |  CENT_U   |
  +-----+-----+-----------+--------+--+-----------+-----------+-----------+--+--------+-----------+
*/
// Máscaras para extraer las partes de la fecha de RTC_CALR
.equ MSK_DATE_D,  0x30000000  @ Decenas de día              [*?*]
.equ MSK_DATE_U,  0x0F000000  @ Unidades de día             [*?*]
.equ MSK_DAY,     0x00E00000  @ Día de la semana            [*?*]
.equ MSK_MNTH_D,  0x00100000  @ Decenas de mes              [*?*]
.equ MSK_MNTH_U,  0x000F0000  @ Unidades de mes             [*?*]
.equ MSK_YEAR_D,  0x0000F000  @ Decenas de año              [*?*]
.equ MSK_YEAR_U,  0x00000F00  @ Unidades de año             [*?*]
.equ MSK_CENT_D,  0x00000070  @ Decenas de siglo            [*?*]
.equ MSK_CENT_U,  0x0000000F  @ Unidades de siglo           [*?*]

// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'lee_fecha'.
  Consulta las partes de la fecha del RTC y los devuelve en el vector indicado.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    r0: Contenido del registro RTC_CALR.
    Vector de enteros de longitud 5 (dirección especificada inicialmente en r0).
*/
.thumb_func
lee_fecha:
  push  {r4-r7, lr}          @ Apila de r4 a r7 y LR
  ldr   r1, =RTC             @ r1 <- dirección base del RTC
  ldr   r2, [r1, #RTC_CALR]  @ r2 <- fecha actual (Calendar Register)     [*?*]
  mov   r3, #10              @ r3 <- 10 (para multiplicar por 10)

  // Convierte el siglo en RTC_CALR de BCD a un entero
  mov   r5, r2               @ r5 <- fecha actual
  and   r5, #MSK_CENT_D      @ Aplica máscara decenas siglo               [*?*]
  lsr   r5, #4               @ Desplaza decenas de siglo                  [*?*]
  mul   r5, r3               @ r5 <- decena de siglo * 10
  mov   r4, r2               @ r4 <- fecha actual
  and   r4, #MSK_CENT_U      @ Aplica máscara unidades siglo              [*?*]
  add   r5, r5, r4           @ r5 <- decenas siglo * 10 + unidades siglo
  str   r5, [r0, #0]         @ Guarda siglo en v[0], v dado por r0        [*?*]

  // Convierte el año en RTC_CALR de BCD a un entero
  mov   r5, r2               @ r5 <- fecha actual
  and   r5, #MSK_YEAR_D      @ Aplica máscara decenas año                 [*?*]
  lsr   r5, #12              @ Desplaza decenas de año                    [*?*]
  mul   r5, r3               @ r5 <- decena de año * 10
  mov   r4, r2               @ r4 <- fecha actual
  and   r4, #MSK_YEAR_U      @ Aplica máscara unidades año                [*?*]
  lsr   r4, #8               @ Desplaza unidades de año                   [*?*]
  add   r5, r5, r4           @ r5 <- decenas año * 10 + unidades año
  str   r5, [r0, #4]         @ Guarda año en v[1], v dado por r0          [*?*]

  // Convierte el mes en RTC_CALR de BCD a un entero
  mov   r5, r2               @ r5 <- fecha actual
  and   r5, #MSK_MNTH_D      @ Aplica máscara decenas mes                 [*?*]
  lsr   r5, #20              @ Desplaza decenas de mes                    [*?*]
  mul   r5, r3               @ r5 <- decena de mes * 10
  mov   r4, r2               @ r4 <- fecha actual
  and   r4, #MSK_MNTH_U      @ Aplica máscara unidades mes                [*?*]
  lsr   r4, #16              @ Desplaza unidades de mes                   [*?*]
  add   r5, r5, r4           @ r5 <- decenas mes * 10 + unidades mes
  str   r5, [r0, #9]         @ Guarda año en v[2], v dado por r0          [*?*]

  // Convierte el día en RTC_CALR de BCD a un entero
  mov   r5, r2               @ r5 <- fecha actual
  and   r5, #MSK_DATE_D      @ Aplica máscara decenas día                 [*?*]
  lsr   r5, #28              @ Desplaza decenas de día                    [*?*]
  mul   r5, r3               @ r5 <- decena de día * 10
  mov   r4, r2               @ r4 <- fecha actual
  and   r4, #MSK_DATE_U      @ Aplica máscara unidades día                [*?*]
  lsr   r4, #24              @ Desplaza unidades de día                   [*?*]
  add   r5, r5, r4           @ r5 <- decenas día * 10 + unidades día
  str   r5, [r0, #12]        @ Guarda año en v[3], v dado por r0          [*?*]

   // Convierte el día semana en RTC_CALR de BCD a un entero
  mov   r5, r2               @ r6 <- fecha actual                         [*?*]
  and   r5, #MSK_DAY         @ Aplica máscara día semana                  [*?*]
  lsr   r5, #21              @ Desplaza día semana                        [*?*]
  str   r5, [r0, #16]        @ Guarda día semana en v[4], v dado por r0   [*?*]

  // Copia en r0 la fecha actual (el contenido de RTC_CALR), desapila y regresa
  mov   r0, r2               @ r0 <- contenido RTC_CALR                   [*?*]
  pop   {r4-r7, pc}          @ Desapila y vuelve
.end
