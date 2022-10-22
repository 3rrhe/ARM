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

#include "RTC_alarma.h"
#include "RTC_lee.h"
#include "muestra_fecha.h"

// Declaración de constantes
#define LEDR 8                        // LED rojo del LED RGB
#define LEDG 7                        // LED verde del LED RGB
#define LEDB 6                        // LED azul del LED RGB

void setup() {
  int error;                          // Para almacenar el resultado de 'actualiza_fecha_hora()'
  
  pinMode(LEDB, OUTPUT);              // Configura pin del LED azul como salida
  pinMode(LEDG, OUTPUT);              // Configura pin del LED verde como salida
  pinMode(LEDR, OUTPUT);              // Configura pin del LED rojo como salida
  Serial.begin(9600);                 // Habilita la comunicación por el puerto serie
  Serial.println("");

  Serial.println("Actualizando la fecha y la hora...");
  error = actualiza_fecha_hora();     // Actualiza la fecha y la hora del RTC
  
  // Muestra el resultado de la actualización de la fecha y hora
  if (error == 0)        Serial.println(" ...fecha y hora actualizadas correctamente.");
  else if (error == 1)   Serial.println(" ...ha ocurrido un error al actualizar la fecha.");
  else if (error == 2)   Serial.println(" ...ha ocurrido un error al actualizar la hora.");
  Serial.print("Fecha actualizada a:     ");
  muestra_fecha_hora();               // Muestra fecha y hora actuales

  Serial.println("");

  Serial.println("Configurando la alarma...");
  configura_alarma();                 // Configura la alarma

  Serial.print("Alarma configurada para: ");
  muestra_fecha_alarma();             // Muestra fecha y hora de configuración de la alarma
  Serial.println("");
}

void loop() {
  Serial.println("Consultando el estado de la alarma ... ");
  consulta_estado_alarma();           // Espera que se produzca la alarma

  Serial.print("Alarma detectada el:     ");
  muestra_fecha_hora();               // Muestra fecha y hora de activación de la alarma
  Serial.println("");

  delay(5000);                        // Espera 5 segundos antes de volver a empezar
}

