// RTC_lee_fecha_hora.s - Extrae la fecha y hora del RTC en sendos vectores
// Acceso al controlador del RTC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global lee_fecha_hora                   @ Para que la función 'lee_fecha_hora'
.type   lee_fecha_hora, %function        @   sea accesible desde los módulos externos


// Declaración de constantes
// -------------------------

// Dirección base y offsets del controlador del RTC
.equ RTC,         0x400E1A60  @ Dirección base del RTC
.equ RTC_TIMR,    0x08        @ Offset del Time Register
.equ RTC_CALR,    0x0C        @ Offset del Calendar Register

// Máscaras para extraer las partes de la fecha de RTC_CALR
.equ MSK_DATE_D,  0x30000000  @ Decenas de día
.equ MSK_DATE_U,  0x0F000000  @ Unidades de día
.equ MSK_DAY,     0x00E00000  @ Día de la semana
.equ MSK_MNTH_D,  0x00100000  @ Decenas de mes
.equ MSK_MNTH_U,  0x000F0000  @ Unidades de mes
.equ MSK_YEAR_D,  0x0000F000  @ Decenas de año
.equ MSK_YEAR_U,  0x00000F00  @ Unidades de año
.equ MSK_CENT_D,  0x00000070  @ Decenas de siglo
.equ MSK_CENT_U,  0x0000000F  @ Unidades de siglo

// Máscaras para extraer las partes de la hora de RTC_TIMR
.equ MSK_AMPM,    0x00400000  @ AM/PM
.equ MSK_HOUR_D,  0x00300000  @ Decenas de hora
.equ MSK_HOUR_U,  0x000F0000  @ Unidades de hora
.equ MSK_MIN_D,   0x00007000  @ Decenas de minuto
.equ MSK_MIN_U,   0x00000F00  @ Unidades de minuto
.equ MSK_SEC_D,   0x00000070  @ Decenas de segundo
.equ MSK_SEC_U,   0x0000000F  @ Unidades de segundo


// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'lee_fecha_hora'.
  Consulta las partes de la fecha y hora actuales del RTC y las devuelve en los vectores indicados.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    Vector de enteros de longitud 5 para la fecha (dirección especificada inicialmente en r0).
    vector de enteros de longitud 4 para la hora (dirección especificada inicialmente en r1).
*/
.thumb_func
lee_fecha_hora:

  push  {r4-r7, lr}          @ Apila de r4 a r7 y LR
  ldr   r2, =RTC             @ r2 <- dirección base del RTC
  
  // Comienza a procesar la fecha actual (RTC_CALR)  
  ldr   r3, [r2, #RTC_CALR]  @ r3 <- fecha actual (Calendar Register)
  mov   r4, #10              @ r4 <- 10 (para multiplicar por 10)

  // Convierte el siglo en RTC_CALR de BCD a un entero
  mov   r6, r3               @ r6 <- fecha actual
  and   r6, #MSK_CENT_D      @ Aplica máscara decenas siglo
  lsr   r6, #4               @ Desplaza decenas de siglo
  mul   r6, r4               @ r6 <- decena de siglo * 10
  mov   r5, r3               @ r5 <- fecha actual
  and   r5, #MSK_CENT_U      @ Aplica máscara unidades siglo
  add   r6, r6, r5           @ r6 <- decenas siglo * 10 + unidades siglo
  str   r6, [r0, #0]         @ Guarda siglo en v[0], v dado por r0

  // Convierte el año en RTC_CALR de BCD a un entero
  mov   r6, r3               @ r6 <- fecha actual
  and   r6, #MSK_YEAR_D      @ Aplica máscara decenas año
  lsr   r6, #12              @ Desplaza decenas de año
  mul   r6, r4               @ r6 <- decena de año * 10
  mov   r5, r3               @ r5 <- fecha actual
  and   r5, #MSK_YEAR_U      @ Aplica máscara unidades año
  lsr   r5, #8               @ Desplaza unidades de año
  add   r6, r6, r5           @ r6 <- decenas año * 10 + unidades año
  str   r6, [r0, #4]         @ Guarda año en v[1], v dado por r0

  // Convierte el mes en RTC_CALR de BCD a un entero
  mov   r6, r3               @ r6 <- fecha actual
  and   r6, #MSK_MNTH_D      @ Aplica máscara decenas mes
  lsr   r6, #20              @ Desplaza decenas de mes
  mul   r6, r4               @ r6 <- decena de mes * 10
  mov   r5, r3               @ r5 <- fecha actual
  and   r5, #MSK_MNTH_U      @ Aplica máscara unidades mes
  lsr   r5, #16              @ Desplaza unidades de mes
  add   r6, r6, r5           @ r6 <- decenas mes * 10 + unidades mes
  str   r6, [r0, #8]         @ Guarda año en v[2], v dado por r0

  // Convierte el día en RTC_CALR de BCD a un entero
  mov   r6, r3               @ r6 <- fecha actual
  and   r6, #MSK_DATE_D      @ Aplica máscara decenas día
  lsr   r6, #28              @ Desplaza decenas de día
  mul   r6, r4               @ r6 <- decena de día * 10
  mov   r5, r3               @ r5 <- fecha actual
  and   r5, #MSK_DATE_U      @ Aplica máscara unidades día
  lsr   r5, #24              @ Desplaza unidades de día
  add   r6, r6, r5           @ r6 <- decenas día * 10 + unidades día
  str   r6, [r0, #12]        @ Guarda año en v[3], v dado por r0

  // Convierte el día semana en RTC_CALR de BCD a un entero
  mov   r6, r3               @ r6 <- fecha actual
  and   r6, #MSK_DAY         @ Aplica máscara día semana
  lsr   r6, #21              @ Desplaza día semana
  str   r6, [r0, #16]        @ Guarda día semana en v[4], v dado por r0

  // Comienza a procesar la hora actual (RTC_TIMR)
  ldr   r3, [r2, #RTC_TIMR]  @ r3 <- hora actual (Time Register)
  mov   r4, #10              @ r4 <- 10 (para multiplicar por 10)

  // Extrae el valor del bit AM/PM
  mov  r5, r3                @ r5 <- hora actual
  and  r5, #MSK_AMPM         @ Aplica máscara AM/PM
  lsr  r5, #22               @ Desplaza AM/PM
  str  r5, [r1, #0]          @ Guarda AM/PM en v[0], v dado por r1

  // Convierte las horas en RTC_TIMR de BCD a un entero
  mov  r6, r3                @ r6 <- hora actual
  and  r6, #MSK_HOUR_D       @ Aplica máscara decenas hora
  lsr  r6, #20               @ Desplaza decenas de hora
  mul  r6, r4                @ r6 <- decenas de minuto * 10
  mov  r5, r3                @ r5 <- hora actual
  and  r5, #MSK_HOUR_U       @ Aplica máscara unidades hora
  lsr  r5, #16               @ Desplaza unidades de hora
  add  r6, r6, r5            @ r6 <- decenas hora * 10 + unidades
  str  r6, [r1, #4]          @ Guarda minutos en v[1], v dado por r1

  // Convierte los minutos en RTC_TIMR de BCD a un entero
  mov  r6, r3                @ r6 <- hora actual
  and  r6, #MSK_MIN_D        @ Aplica máscara decenas minuto
  lsr  r6, #12               @ Desplaza decenas de minuto
  mul  r6, r4                @ r6 <- decenas de minuto * 10
  mov  r5, r3                @ r5 <- hora actual
  and  r5, #MSK_MIN_U        @ Aplica máscara unidades minuto
  lsr  r5, #8                @ Desplaza unidades de minuto
  add  r6, r6, r5            @ r6 <- decenas minuto * 10 + unidades
  str  r6, [r1, #8]          @ Guarda minutos en v[2], v dado por r1

  // Convierte los segundos en RTC_TIMR de BCD a un entero
  mov  r6, r3                @ r6 <- hora actual
  and  r6, #MSK_SEC_D        @ Aplica máscara decenas segundo
  lsr  r6, #4                @ Desplaza decenas de segundo
  mul  r6, r4                @ r6 <- decenas de segundo * 10
  mov  r5, r3                @ r5 <- hora actual
  and  r5, #MSK_SEC_U        @ Aplica máscara unidades segundo
  add  r6, r6, r5            @ r6 <- decenas segundo * 10 + unidades
  str  r6, [r1, #12]         @ Guarda segundos en v[3], v dado por r1

  // Retorna
  pop    {r4-r7, pc}         @ Desapila y retorna
.end

