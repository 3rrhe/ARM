# cambia.s - Cambia color LED RGB al pulsar y soltar

.syntax unified
.cpu cortex-m3
.text
.align  2
.thumb
.thumb_func
.global cambia      @ Para que la función 'cambia'
.type cambia, %function    @   sea accesible desde los módulos externos

.equ PIOB, 0x400E1000    @ Dir. base del PIO B
.equ PIOC, 0x400E1200    @ Dir. base del PIO C

.equ BMSK, 0x01000000    @ Es el pin 6, bit 24 de PIOC (azul)
.equ GMSK, 0x00800000    @ Es el pin 7, bit 23 de PIOC (verde)
.equ RMSK, 0x00400000    @ Es el pin 8, bit 22 de PIOC (rojo)
.equ TOPE, 0x02000000           @ Salida siguiente (no conectada)

.equ ALLMSK, RMSK + GMSK + BMSK @ Máscara conjunta

/* Offsets de los registros del controlador PIO */
.equ PIO_PER,   0x000    @ Offset Pio Enable Reg
.equ PIO_IDR,   0x044    @ Offset Interrupt Disable Reg
.equ PIO_PUDR,  0x060    @ Offset Pull Up Disable Reg
.equ PIO_PUER,  0x064    @ Offset Pull Up Enable Reg
.equ PIO_DIFSR, 0x084    @ Offset Debouncing Input Filter Select Register
.equ PIO_IFER,  0x020    @ Offset Glitch Input Filter Enable Reg
.equ PIO_OER,   0x010    @ Offset Output Enable Reg
.equ PIO_ODR,   0x014    @ Offset Output Disable Reg
.equ PIO_PDSR,  0x03C    @ Offset Pin Data Status Reg
.equ PIO_SODR,  0x030    @ Offset Set Output Data Reg
.equ PIO_CODR,  0x034    @ Offset Clear Output Data Reg

.equ ID_PIOB,  0x00C    @ ID del PIOB para el reloj
.equ PULMSK,  0x08000000  @ Es el pin 13, bit 27 de PIOB. Pulsador

/* void cambia(int veces) */
/* Enciende los colores del LED RGB secuencialmente con cada pulsación */
/* Acepta como parámetro el número de pulsaciones antes de regresar    */
.align  2
.thumb_func
cambia:
   // r0 - Dirección base del PIOB
   // r1 - Dirección base del PIOC
   // r2 - Lectura estado PIOB
   // r3 - Máscara del pulsador
   // r4 - Contador de pulsaciones
   // r5 - Primera salida sin conectar. Para volver al primer color
   // r6 - Máscaras a escribir en los registros
   // r7 - No usado

   push    {r4-r7, lr}    @ Salvaguardamos de r4 a r7
   mov    r4, r0      @ Número de iteraciones
   
   /* Configuración del pin del pulsador como entrada con pullup */
   ldr    r0, =ID_PIOB    @ Identificador de reloj del Controlador PIOB
   bl    pmc_enable_periph_clk  @ Habilitamos el reloj para la entrada
   ldr    r1, =PIOB    @ Direccion base del Controlador PIOB
   ldr    r6, =PULMSK    @ Vamos a configurar el pulsador
   str    r6, [r1, #PIO_IDR]  @ Deshabilitamos interrupciones asociadas al pin
   str    r6, [r1, #PIO_PUER]  @ Activamos el pull-up
   str    r6, [r1, #PIO_DIFSR]  @ Seleccionamos el debouncing
   str    r6, [r1, #PIO_IFER]  @ Activamos el filtro
   str    r6, [r1, #PIO_ODR]  @ La ponemos como entrada
   str    r6, [r1, #PIO_PER]  @ Habilitamos el bit en el PIO
   
   /* Configuración de las salidas del LED */
   ldr    r1, =PIOC    @ Direccion base del Controlador PIOC
   ldr    r6, =ALLMSK    @ Vamos a configurar los trea colores del LED RGB
   // ldr    r7, =0x01C00000
   str    r6, [r1, #PIO_SODR]  @ Ponemos las salidas a '1' para apagar los LED
   str    r6, [r1, #PIO_PUDR]  @ Desactivamos los pull-up
   str    r6, [r1, #PIO_OER]  @ Configuramos los pines como salida
   str    r6, [r1, #PIO_PER]  @ Habilitamos los bits en el PIO
   
   ldr    r5, =TOPE    @ Primera salida sin conectar   
   ldr    r6, =RMSK    @ Inicializamos LED activo (rojo)
   
   /* Preparamos la lectura del pulsador */
   ldr    r0, =PIOB    @ Dirección base de E/S del PIOB
   ldr    r3, =PULMSK    @ Máscara del pulsador      
   
   /* Apagamos el LED encendido y encendemos el siguiente */
cambiar:
   ldr    r1, =PIOC    @ Dirección base del PIO C
   str    r6, [r1, #PIO_SODR]  @ Apagamos el LED encendido escribiendo en ?????
   lsl    r6, #1      @ Desplazamos una posición a la izquierda
   cmp    r5, r6      @ A ver si nos hemos pasado
   bne    sigue      @ Si no nos hemos pasado, seguimos
   ldr    r6, =RMSK    @ Si nos hemos pasado, empezamos por el rojo
sigue:
   str    r6, [r1, #PIO_CODR]  @ Encendemos el LED escribiendo en ??????
   
esperapulsa:
   /* Leemos el estado del pulsador en el PIOB */
   ldr    r2, [r0, r1]  @ Leemos el registro de E/S del puerto B
   ands    r2, r3      @ Aplicamos la máscara del pulsador. ¡Ojo a la s!
   
   /* Decidimos qué hacer en función del estado del pulsador */
   beq    esperapulsa    @ Si no ha sido pulsado, esperamos   
esperasuelta:
   /* Leemos el estado del pulsador en el PIOB */
   ldr    r2, [r0, r1]  @ Leemos el registro de E/S del puerto B
   ands    r2, r3      @ Aplicamos la máscara del pulsador. ¡Ojo a la s!
   
   /* Decidimos qué hacer en función del estado del pulsador */
   beq    esperasuelta    @ Si sigue pulsado, esperamos   
   
   /* El pulsador ha sido pulsado y soltado. Cambiamos LED iluminado */
   subs    r4, #1      @ Resta uno al contador. ¡Ojo a la s!
   bne    volver      @ Si finalizado cuenta, regresamos
   b    cambiar      @ Si no, pasa al siguiente LED

  /* Regresamos */
volver:
   str    r6, [r1, #PIO_SODR]  @ Apagamos el LED encendido
   
   pop    {r4-r7, pc}     @ Desapila y regresa

.end
