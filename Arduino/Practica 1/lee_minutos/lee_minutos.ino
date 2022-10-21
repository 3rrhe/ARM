/*
  lee_minutos
  Lee el valor de los minutos y segundos del RTC.
*/

#include "lee_minutos.h"


void setup() {
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie
}

void loop() {
  int minutos[2];          // Vector para almacenar los minutos y segundos como enteros
  unsigned int rtc_timr;   // Entero sin signo para almacenar el contenido de RTC_TIMR
  
  Serial.println("Llamamos a lee_minutos()...");
  rtc_timr = lee_minutos(minutos);

  Serial.println("Contenido del RTC_TIMR:");
  Serial.print("  0x");
  Serial.print(rtc_timr, HEX);
  Serial.print("  (0b");
  Serial.print(rtc_timr, BIN);
  Serial.println(")");
  
  Serial.println("Minutos y segundos:");
  Serial.print("  ");
  Serial.print(minutos[0]);
  Serial.print(":");
  Serial.println(minutos[1]);
  Serial.println("");

  delay(5000);             // Espera 5 segundos antes de volver a empezar
}

