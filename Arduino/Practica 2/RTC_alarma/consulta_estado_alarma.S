// consulta_estado_alarma.s - Mientras espera a la alarma, hace parpadear al LED azul.
//                              Cuando detecta que se ha activado, enciende el LED rojo,
//                              reactiva la alarma y vuelve.
// Acceso al controlador del RTC y al del puerto PIOC

// Directivas para el ensamblador
// ------------------------------
.syntax unified
.cpu cortex-m3

// Declaración de funciones externas y exportadas
// ----------------------------------------------
.extern delay                              @ delay es una función externa
.global consulta_estado_alarma             @ Para que la función 'consulta_estado_alarma'
.type   consulta_estado_alarma, %function  @   sea accesible desde los módulos externos

// Declaración de constantes
// -------------------------

// Dirección base y offsets del controlador del RTC
.equ RTC,       0x400E1A60                 @ Dirección base del RTC
.equ RTC_SR,    0x18                       @ Offet del Status Register
.equ RTC_SCCR,  0x1C                       @ Offset del Status Clear Command Register

// Máscara para detectar la activación de la alarma
.equ MSK_ALARM, 0x00000001                 @ Máscara del bit ALARM en RTC_SR      [*?*]

// Dirección base y offets del puerto PIOC
.equ PIOC,      0x400E1200                 @ Dirección base del puerto PIOC
.equ PIO_SODR,  0x030                      @ Offset Set Output Data Reg
.equ PIO_CODR,  0x034                      @ Offset Clear Output Data Reg

// Máscaras con los bits asociados a los LEDS rojo, verde y azul del LED RGB
.equ MSK_LEDB,  0x01000000                 @ El LED azul está asociado al bit 24
.equ MSK_LEDG,  0x00800000                 @ El LED verde está asociado al bit 23
.equ MSK_LEDR,  0x00400000                 @ El LED rojo está asociado al bit 22

// Tiempo de encendido/apagado del LED
.equ RETARDO,   300                        @ Milisegundos de retardo


// Comienzo de la zona de código
// -----------------------------
.text

/*
  Subrutina 'consulta_estado_alarma'.
  Consulta periódicamente el estado de la alarma. Mientras no detecte que ha saltado,
    hace parpadear el LED azul. Cuando detecta que ha saltado, la reactiva,
    enciende el LED rojo y regresa.
  Parámetros de entrada:
    No tiene.
  Parámetros de salida:
    No tiene
*/
.thumb_func
consulta_estado_alarma:

  // Apila los registros que se vayan a modificar
  push    {r4-r7, lr}          @ Apila r4 a r7 y LR

  // Inicializa registros r4 a r7 con las ctes. más frecuentemente usadas
  ldr    r4, =PIOC             @ r4 <- dir. base del puerto PIOC
  ldr    r5, =MSK_LEDB         @ r5 <- máscara del LED azul
  ldr    r6, =RETARDO          @ r6 <- tiempo encendido/apagado
  ldr    r7, =RTC              @ r0 <- dirección base del RTC

  // Apaga LED rojo
  ldr    r0, =MSK_LEDR         @ r0 <- máscara del LED rojo
  str    r0, [r4, #PIO_SODR]   @ Apaga el LED rojo escribiendo en SET

noalr:
  // Enciende y apaga el LED azul
  str    r5, [r4, #PIO_CODR]   @ Enciende el LED azul escribiendo en CLEAR
  mov    r0, r6                @ r0 <- tiempo encendido/apagado
  bl     delay                 @ Llama a la función delay
  str    r5, [r4, #PIO_SODR]   @ Apaga el LED azul escribiendo en SET
  mov    r0, r6                @ r0 <- tiempo encendido/apagado
  bl     delay                 @ Llama a la función delay

  // Consulta el estado de la alarma
  ldr    r0, [r7, #RTC_SR]     @ r0 <- RTC Status Register                         [*?*]
  mov    r1, #MSK_ALARM        @ r1 <- máscara del bit ALARM en RTC_SR             [*?*]
  ands   r0, r1                @ Aplica máscara
  beq    noalr                 @ Si no se ha activado la alarma, vuelve a 'noalr'  [*?*]

  // Una vez ha detectado que la alarma ha saltado...
  ldr    r0, =MSK_LEDR         @ r0 <- máscara del LED rojo
  str    r0, [r4, #PIO_CODR]   @ Enciende el LED rojo escribiendo en CLEAR
  str    r1, [r7, #RTC_SCCR]   @ Pone a 0 el bit ALARM de RTC_SR                   [*?*]

  // y retorna
  pop    {r4-r7, pc}           @ Desapila y retorna

.end
