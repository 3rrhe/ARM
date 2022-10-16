/*
  RTC_alarma
  Esta aplicación realiza lo siguiente:
    * En la etapa de inicialización (setup):
      + Actualiza la fecha y hora del RTC y la muestra.
      + Configura y muestra una alarma para 5 segundos después de la fecha fijada en el paso anterior.
    * Durante el bucle de trabajo (loop):
      + Mientras no detecte que ha saltado la alarma, hará parpadear al LED azul.
      + En cuanto detecte que ha saltado la alarma, encenderá el LED rojo, la reactivará 
          y mostrará el instante en el que se ha detectado su activación.
*/

#include "RTC_alarma_int.h"
#include "RTC_lee.h"
#include "muestra_fecha.h"

// Declaración de constantes
#define LEDR 8                        // LED rojo del LED RGB
#define LEDG 7                        // LED verde del LED RGB
#define LEDB 6                        // LED azul del LED RGB

// Variables globales
int alarma = 0;


// Setup
// -----
void setup() {
  int error;                          // Para almacenar el resultado de 'actualiza_fecha_hora()'
  
  pinMode(LEDB, OUTPUT);              // Configura pin del LED azul como salida
  pinMode(LEDG, OUTPUT);              // Configura pin del LED verde como salida
  pinMode(LEDR, OUTPUT);              // Configura pin del LED rojo como salida
  Serial.begin(9600);                 // Habilita la comunicación por el puerto serie

  Serial.println("\n");

  Serial.println("Actualizando la fecha y la hora...");
  error = actualiza_fecha_hora();     // Actualiza la fecha y la hora del RTC
  
  // Muestra el resultado de la actualización de la fecha y hora
  if (error == 0)        Serial.println(" ...fecha y hora actualizadas correctamente.");
  else if (error == 1)   Serial.println(" ...ha ocurrido un error al actualizar la fecha.");
  else if (error == 2)   Serial.println(" ...ha ocurrido un error al actualizar la hora.");
  Serial.print("Fecha actualizada a:     ");
  muestra_fecha_hora();               // Muestra la fecha y hora actual

  Serial.println("");

  Serial.println("Configurando la alarma y activando las interrupciones...");
  NVIC_DisableIRQ(RTC_IRQn);          // Inhibe generación interrupciones RTC
  NVIC_ClearPendingIRQ(RTC_IRQn);     // Elimina interrupciones pendientes RTC
  NVIC_SetPriority(RTC_IRQn, 0);      // Establece prioridad interrupción RTC
  configura_alarma_int();             // Configura la alarma y activa la solicitud de interrupciones
  NVIC_EnableIRQ(RTC_IRQn);           // Habilita generación interrupciones RTC

  Serial.print("Alarma configurada para: ");
  muestra_fecha_alarma();             // Muestra fecha y hora de configuración de la alarma
  Serial.println("");
}


// Loop
// ----
void loop() {
  Serial.println("Consultando el estado de la alarma ... ");
  consulta_estado_alarma();           // Espera a que la variable global alarma pase a valer 1

  Serial.print("Alarma detectada por consulta de estado el:     ");
  muestra_fecha_hora();               // Muestra la fecha y hora actual
  Serial.println("");

  delay(5000);                        // Espera 5 segundos antes de volver a empezar
}

