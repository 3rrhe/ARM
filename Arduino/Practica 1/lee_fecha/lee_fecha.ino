/*
  lee_fecha
  Lee la fecha del RTC y la convierte a números enteros.
*/

#include "lee_fecha.h"

void setup() {
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie
}

void loop() {
  int fecha[5];            // Vector para almacenar las partes de la fecha
  unsigned int rtc_calr;   // Entero sin signo para almacenar el contenido de RTC_CALR

  Serial.println("Llamamos a lee_fecha()...");
  rtc_calr = lee_fecha(fecha);

  Serial.println("Contenido del RTC_CALR:");
  Serial.print("  0x");
  Serial.print(rtc_calr, HEX);
  Serial.print("  (0b");
  Serial.print(rtc_calr, BIN);
  Serial.println(")");

  Serial.print ("Siglo:   ");
  Serial.println(fecha[0]);
  Serial.print ("Anyo:    ");
  Serial.println(fecha[1]);
  Serial.print ("Mes:     ");
  Serial.println(fecha[2]);
  Serial.print ("Día:     ");
  Serial.println(fecha[3]);
  Serial.print ("Día sem: ");
  Serial.println(fecha[4]);
  Serial.println(" ");
  
  //delay(60000);
  delay(3000);// Espera 1 minuto antes de volver a empezar (la fecha no va a cambiar)
  
}
