/*
  RTC_actualiza_fecha_hora
  Actualiza la fecha y hora del RTC y luego muestra la fecha y hora actuales cada 5 segundos
*/

#include "RTC_actualiza_fecha_hora.h" // Para declarar las funciones externas

void setup() {
  int error;                          // Para almacenar el resultado de 'actualiza_fecha_hora()'
  
  Serial.begin(9600);                 // Habilita la comunicación por el puerto serie
  Serial.println("");

  Serial.println("Actualizando la fecha y la hora...");
  error = actualiza_fecha_hora();     // Actualiza la fecha y la hora del RTC
  
  // Muestra el resultado de la actualización de la fecha y hora
  if (error == 0)       Serial.println(" ...fecha y hora actualizadas correctamente.");
  else if (error == 1)  Serial.println(" ...ha ocurrido un error al actualizar la fecha.");
  else if (error == 2)  Serial.println(" ...ha ocurrido un error al actualizar la hora.");
}

void loop() {
  int fecha[5];                       // Vector para almacenar las partes de la fecha
  int hora[4];                        // Vector para almacenar las partes de la hora
  char dia_semana[] = "LMXJVSD";      // Letra para el día de la semana (lunes a domingo)
  char* am_pm[] = {"AM", "PM"};       // Vector con cadenas "AM" y "PM"
  
  Serial.println("Llamamos a lee_fecha_hora()...");
  lee_fecha_hora(fecha, hora);

  // Muestra la fecha
  Serial.print  ("  Fecha: ");
  Serial.print  (fecha[3]);
  Serial.print  ("/");
  Serial.print  (fecha[2]);
  Serial.print  ("/");
  Serial.print  (fecha[0]);
  Serial.print  (fecha[1]);
  Serial.print  (" (");
  Serial.print  (dia_semana[fecha[4]-1]);
  Serial.print  (")");
  Serial.println("");
  
  // Muestra la hora
  Serial.print  ("   Hora: ");
  Serial.print  (hora[1]);
  Serial.print  (":");
  Serial.print  (hora[2]);
  Serial.print  (":");
  Serial.print  (hora[3]);
  Serial.print  (" ");
  Serial.print  (am_pm[hora[0]]);
  Serial.println("");
  Serial.println("");
  
  delay(5000);                        // Espera 5 segundos antes de volver a empezar
  
}

