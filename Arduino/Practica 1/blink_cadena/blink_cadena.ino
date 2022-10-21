/*
  blink_cadena
  Enciende y apaga el LED en ensamblador tantas veces como la longitud de una cadena.
*/
 
#include "blink_cadena.h"  // Para declarar la función externa blink
#define LED 6              // El LED azul está conectado al pin 6

void setup() {                
  pinMode(LED, OUTPUT);    // Configura el pin del LED como salida
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie
}

void loop() {
  char cadena[] = "mensaje";
  int long_cad;            // Para almacenar el resultado de blink()
  
  Serial.println("Llamamos a blink(cadena, 500 ms encendido/apagado)...");
  long_cad = blink(cadena, 500);

  Serial.print("La cadena tiene ");
  Serial.print(long_cad);
  Serial.println(" caracteres");
  Serial.println("");
  
  delay(5000);             // Espera 5 segundos antes de volver a empezar
}
