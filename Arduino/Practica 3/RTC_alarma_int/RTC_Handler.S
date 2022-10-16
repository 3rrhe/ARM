/*
  RTC_Handler.s - Implementa la rutina de tratamiento del RTC
*/


// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones exportadas
// -----------------------------------
.global RTC_Handler                   @ Para que la función 'RTC_Handler'
.type   RTC_Handler, %function        @   sea accesible desde los módulos externos


// Declaración de constantes
// -------------------------
// Dirección base y offsets del controlador del RTC
.equ RTC,         0x400E1A60  @ Dir. base del RTC
.equ RTC_SR,      0x18        @ Status Register
.equ RTC_SCCR,    0x1C    @ Status Clear Command Register

// Dirección base y offsets del controlador del PIOC
.equ PIOC,        0x400E1200  @ Dir. base del puerto C
.equ PIO_SODR,    0x030       @ OFFSET Set Output Data Reg
.equ PIO_CODR,    0x034       @ OFFSET Clear Output Data Reg

// Máscaras
.equ MSK_ALARM,     0x00000001  @ Máscara con el bit ALARM activo                      [*?*]
.equ MSK_SCCRCLEAR, 0x0000001F  @ Para restablecer condiciones interrupción
// ---
.equ LEDBLU,    0x01000000  @ El LED azul está en el pin 24
.equ LEDGRN,    0x00800000  @ El LED verde está en el pin 23
.equ LEDRED,    0x00400000  @ El LED rojo está en el pin 22


// Comienzo de la zona de datos
// ----------------------------
.data
msg:  .asciz "Alarma detectada por interrupciones el:         "


// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'RTC_Handler'.
    Rutina de servicio de la interrupción del RTC.  Almacena un 1 en la variable global 'alarma'
    para avisar de que se ha detectado la activación de la alarma.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    No tiene.
*/
.thumb_func
RTC_Handler:
  push   {lr}                 @ Apila LR

  // Comprueba si la interrupción la ha provocado la alarma   
  ldr    r1, =RTC             @ r1 <- dirección base del RTC
  mov    r2, #MSK_ALARM       @ r2 <- máscara con bit ALARM activo                     [*?*]
  ldr    r3, [r1, #RTC_SR]    @ r3 <- Status Register                                  [*?*]
  ands   r3, r2               @ Aplica máscara
  beq    finint               @ Si no es por la alarma, regresa

  // Si que ha saltado la alarma, apaga el LED azul y enciende el LED rojo 
  ldr    r1, =PIOC            @ r1 <- dirección base de PIOC
  mov    r2, #LEDBLU          @ r2 <- máscara LED azul
  str    r2, [r1, #PIO_SODR]  @ Apaga LED azul
  mov    r2, #LEDRED          @ r2 <- máscara LED rojo
  str    r2, [r1, #PIO_CODR]  @ Enciende LED rojo

  // Almacena un 1 en la variable global 'alarma'
  ldr    r0, =alarma          @ r0 <- dirección variable global 'alarma'
  mov    r3, #1               @ r3 <- 1
  str    r0, [r3]             @ Almacena r3 en la variable global 'alarma'             [*?*]

  // Muestra mensaje detección
  ldr    r0, =msg
  bl     printString
  bl     muestra_fecha_hora

  // Rehabilita la alarma
finint:
  ldr    r1, =RTC             @ r1 <- dirección base del RTC
  mov    r2, #MSK_SCCRCLEAR   @ r2 <- máscara para restablecer bits RTC_SR             [*?*]
  str    r2, [r1, #RTC_SCCR]  @ Restablece bits RTC_SR                                 [*?*]

  pop    {pc}                 @ Retorna (PC <- LR)

.end
