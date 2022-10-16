// configura_alarma_int.s - Implementa la rutina configura_alarma_int
// Acceso al controlador del RTC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global configura_alarma_int             @ Para que la función 'configura_alarma_int'
.type   configura_alarma_int, %function  @   sea accesible desde los módulos externos

// Declaración de constantes
// -------------------------

// Dirección base y offsets del controlador del RTC
.equ RTC,         0x400E1A60  @ Dirección base del RTC
.equ RTC_TIMALR,  0x10        @ Offset del Time Alarm Register
.equ RTC_CALALR,  0x14        @ Offset del Calendar Alarm Register
.equ RTC_IER,     0x20        @ Interrupt Enable Register
.equ RTC_IDR,     0x24        @ Interrupt Disable Register 


// Fecha y hora de la alarma 
.equ ALR_FECHA, 0x01631720    @ 1 de marzo                                      [*?*]
.equ ALR_HORA,  0x00441830    @ 04:18:30 PM (actualiza_fecha_hora + 5 segundos) [*?*]
// ---
.equ MSK_ALARM, 0x00000001    @ Máscara con el bit ALARM activo                 [*?*]


// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'configura_alarma_int'.
  Configura la fecha y hora de la alarma del RTC en base a ALR_FECHA y ALR_HORA.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    No tiene.
*/
.thumb_func
configura_alarma_int:

  ldr    r0, =RTC                @ r0 <- dirección base del RTC

  ldr    r1, =ALR_FECHA          @ r1 <- fecha de la alarma               [*?*]
  str    r1, [r0, #RTC_CALALR]   @ Configura la fecha de la alarma        [*?*]

  ldr    r2, =ALR_HORA           @ r1 <- hora de la alarma                [*?*]
  str    r2, [r0, #RTC_TIMALR]   @ Configura la hora de la alarma         [*?*]

  mov    r1, #MSK_ALARM          @ r1 <- máscara con el bit ALARM activo  [*?*]
  str    r1, [r0, #RTC_IER]      @ Activa generación interrupciones       [*?*]

  mov    pc, lr    @ Retorno

.end
