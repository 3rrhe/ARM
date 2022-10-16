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
  ***    r0, =0x400E1A60           @ r0 <- dirección de la variable global alarma      [*?*]
  ***    r1, [r0]              @ r1 <- contenido de la variable global alarma      [*?*]
  cmp    r1, #0                @ Compara r1 con 0
  ***    *****                 @ Si no se ha activado la alarma, vuelve a 'noalr'  [*?*]

  // Una vez ha detectado que la alarma ha saltado, pone a 0 la variable alarma
  mov    r1, #0                @ r1 <- 0
  str    r1, [r0]              @ Escribe un 0 en la variable alarma

  // y retorna
  pop    {r4-r7, pc}           @ Desapila y retorna

.end
