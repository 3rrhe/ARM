/*
  pulsador
  Detecta la pulsación del pulsador en ensamblador.
*/
 
#include "pulsador.h"      // Para declarar la función externa pulsador

void setup() {                
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie

  Serial.println("\n");
  Serial.print("Configurando el pin del pulsador como entrada con pull-up...");
  PIOB_pushbutton_setup();
  Serial.println("  hecho!");
  Serial.println("");
}

void loop() {
  int chipid;              // Para almacenar el resultado de pulsador()

  Serial.println("Llamamos a pulsador()... ");
  chipid = pulsador();
  
  Serial.print("El identificador del microcontrolador de este Arduino es: ");
  Serial.println(chipid, HEX);
  Serial.println("");

  delay(1000);             // Espera 1 segundo antes de volver a comenzar
}

