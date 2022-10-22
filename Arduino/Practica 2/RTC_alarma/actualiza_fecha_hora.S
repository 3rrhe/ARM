// actualiza_fecha_hora.s - Actualiza la fecha y hora del RTC
// Acceso al controlador del RTC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global actualiza_fecha_hora             @ Para que la función 'actualiza_fecha_hora'
.type   actualiza_fecha_hora, %function  @   sea accesible desde los módulos externos

// Declaración de constantes
// -------------------------

// Dirección base y offsets del controlador del RTC
.equ RTC,         0x400E1A60  @ Dirección base del RTC
.equ RTC_CR,      0x00        @ Offset del Control Register
.equ RTC_MR,      0x04        @ Offset del Mode Register
.equ RTC_TIMR,    0x08        @ Offset del Time Register
.equ RTC_CALR,    0x0C        @ Offset del Calendar Register
.equ RTC_TIMALR,  0x10        @ Offset del Time Alarm Register
.equ RTC_CALALR,  0x14        @ Offset del Calendar Alarm Register
.equ RTC_SR,      0x18        @ Offset del Status Register
.equ RTC_SCCR,    0x1C        @ Offset del Status Clear Command Register
.equ RTC_IER,     0x20        @ Offset del Interrupt Enable Register
.equ RTC_IDR,     0x24        @ Offset del Interrupt Disable Register 
.equ RTC_IMR,     0x28        @ Offset del Interrupt Mask Register
.equ RTC_VER,     0x2C        @ Offset del Valid Entry Register
.equ RTC_WPMR,    0xE4        @ Offset del Write Protect Mode Register

// Máscaras para la configuración del RTC
.equ MSK_12H,     0x00000001  @ Para configurar modo de 12 horas
.equ MSK_STOP,    0x00000003  @ Para detener actualización contadores         [*00000003*]
.equ MSK_GO,      0xFFFFFFFC  @ Para reanudar actualización contadores        [*FFFFFFFC*]
.equ MSK_ACKUPD,  0x00000001  @ Para confirmar bloqueo de los contadores      [*00000001*]
.equ MSK_NVCAL,   0x00000002  @ Para ver si la fecha introducida no es válida [*00000002*]
.equ MSK_NVTIM,   0x00000001  @ Para ver si la hora introducida no es válida  [*00000001*]

// Fecha y hora que se quieren escribir
.equ RTC_FECHA,   0x01631720  @ Miércoles 1 de marzo de 2017                  [*01631720*]
.equ RTC_HORA,    0x00441825  @ 04:18:25 PM                                   [*441825*]

// Códigos de error: 0 (todo bien), 1 (error en fecha), o 2 (error en hora)
.equ ERR_NOERR,   0x00000000  @ Código de error: No error                     [*00000000*]
.equ ERR_FECHA,   0x00000001  @ Código de error: Error en fecha               [*00000001*]
.equ ERR_HORA,    0x00000002  @ Código de error: Error en hora                [*00000002*]


// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'actualiza_fecha_hora'.
  Actualiza la fecha y hora del RTC y devuelve un código de error.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    r0: código de error: 0 (todo bien), 1 (error en fecha), o 2 (error en hora)
  */
.thumb_func
actualiza_fecha_hora:

  // Apila los registros que se vayan a modificar
  push   {lr}                 @ Apila LR

  // Dirección base del RTC
  ldr    r1, =RTC             @ r1 <- dirección base del RTC

  // Configura modo de 12 horas (AM/PM)
  ldr    r2, =MSK_12H         @ r2 <- máscara modo 12 horas
  str    r2, [r1, #RTC_MR]    @ Configura modo 12 horas

  // Detiene los contadores de fecha y hora, poniendo un 1 en los bits 1 y 0 del RTC_CR
  mov    r2, #MSK_STOP        @ r2 <- máscara para detener actualización
  ldr    r3, [r1, #RTC_CR]    @ r3 <- contenido del Control Register                [*ldr*]
  orr    r3, r2               @ Aplica máscara                                      [*orr*]
  str    r3, [r1, #RTC_CR]    @ Detiene contadores sobrescribiendo Control Register [*str*]
   
  // Espera hasta que el RTC confirma que ha detenido los contadores
  mov    r2, #MSK_ACKUPD      @ r2 <- máscara para confirmar contadores bloqueados  [*ACKUPD*]
nodetenido:
  ldr    r3, [r1, #RTC_SR]    @ r3 <- RTC Status Register                           [*SR*]
  ands   r3, r2               @ Comprueba bit confirmación registros bloqueados
  beq    nodetenido           @ Bit a 0, volver a comprobar                         [*beq*]
   
  // Pone a 0 el bit de confirmación de contadores bloqueados
  mov    r2, #MSK_ACKUPD      @ r2 <- máscara para confirmar contadores bloqueados  [*ACKUPD*]
  str    r2, [r1, #RTC_SCCR]  @ Escribe r2 en el Status Clear Command Register      [*SCCR*]
   
  // Configura fecha actual
  mov    r0, #ERR_FECHA       @ r0 <- código de error en fecha (por si acaso)       [*FECHA*]
  ldr    r3, =RTC_FECHA       @ r3 <- fecha a escribir
  str    r3, [r1, #RTC_CALR]  @ Escribe fecha actual                                [*CALR*]
  ldr    r3, [r1, #RTC_VER]   @ r3 <- Valid Entry Register                          [*VER*]
  mov    r2, #MSK_NVCAL       @ r2 <- máscara para ver si la fecha no es válida     [*NVCAL*]
  ands   r3, r2               @ Aplica máscara
  bne    vuelve               @ Bit a 1, fecha no válida, volver con error          [*bne*]

  // Configura hora actual
  mov    r0, #ERR_HORA        @ r0 <- código de error en hora (por si acaso)        [*HORA*]
  ldr    r3, =RTC_HORA        @ r3 <- hora a escribir
  str    r3, [r1, #RTC_TIMR]  @ Escribe hora actual                                 [*TIMR*]
  ldr    r3, [r1, #RTC_VER]   @ r3 <- Valid Entry Register                          [*VER*]
  mov    r2, #MSK_NVTIM       @ r2 <- máscara para ver si la hora no es válida      [*NVTIM*]
  ands   r3, r2               @ Aplica máscara
  bne    vuelve               @ Bit a 1, hora no válida, volver con error           [*bne*]
   
  // Todo bien, indicar en r0 que no hay errores
  mov    r0, #ERR_NOERR       @ r0 <- código para no hay errores                    [*NOERR*]

vuelve:
  // Reanuda los contadores, poniendo un 0 en los bits 1 y 0 del RTC_CR
  ldr    r2, =MSK_GO          @ r2 <- máscara para reanudar los contadores
  ldr    r3, [r1, #RTC_CR]    @ r3 <- contenido del Control Register                [*ldr*]
  and    r3, r2               @ Aplica máscara reactivar                            [*and*]
  str    r3, [r1, #RTC_CR]    @ Reanuda contadores sobrescribiendo Control Register [*str*]

  // Retorna
  pop    {pc}                 @ Regresa al invocador (PC <- LR)
.end
