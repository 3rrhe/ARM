/*
  blink_asm
  Enciende y apaga el LED en ensamblador
*/

#include "blink_asm.h"    // Para declarar la función externa blink
#define LED 13            // El LED está conectado al pin 13

void setup() {
  pinMode(LED, OUTPUT);   // Configura el pin del LED como salida
  Serial.begin(9600);     // Habilita la comunicación por el puerto serie
}

void loop() {
  int chip_id;            // Para almacenar el resultado de blink()

  Serial.println("Llamamos a blink(5 parpadeos, 500 ms enc/apag)...");
  chip_id = blink(5, 500);

  Serial.print("El identificador del microcontrolador de este Arduino es: ");
  Serial.println(chip_id, HEX);
  Serial.println("");
  
  delay(5000);            // Espera 5 segundos antes de volver a empezar
}
