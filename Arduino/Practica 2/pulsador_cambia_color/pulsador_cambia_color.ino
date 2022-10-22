// PROGRAMA: cambia
// Enciende los LED cíclicamente en ensamblador con cada pulsación
 
#include "pulsador_cambia_color.h"  // Para declarar la función que contiene el código ensamblador
 
void setup() {                
  Serial.begin(9600);    // Habilita la comunicación por el puerto serie
}

void loop() {
  Serial.print("Llamamos al programa ensamblador ... ");
  cambia(6); // Invocamos al programa ensamblador
  Serial.println("Regresado");
  Serial.println("Esperando siguiente invocacion ... ");
  Serial.println(" ");
  delay(1000);
}
