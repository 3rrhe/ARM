/*
  blink_vect
  Enciende y apaga el LED en ensamblador tantas veces como la longitud de una cadena
  y muestra el valor de los registros r0-r7 antes de volver de la subrutina blink().
*/
 
#include "blink_vect.h"  // Para declarar la función externa blink
#define LED 6             // El LED azul está conectado al pin 6

void setup() {                
  pinMode(LED, OUTPUT);    // Configura el pin del LED como salida
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie
}

void loop() {
  char cadena[] = "mensaje";
  int long_cad;            // Para almacenar el resultado de blink()
  int regs[8];             // Para almacenar el valor de los registros al final de blink
  
  Serial.println("Llamamos a blink(cadena, 100 ms enc/apag, regs)...");
  long_cad = blink(cadena, 100, regs);

  Serial.print("La cadena tiene ");
  Serial.print(long_cad);
  Serial.println(" caracteres");
  Serial.println("");
  
  Serial.println("El contenido de los registros r0-r7 es:");
  Serial.print("r0: 0x");
  Serial.println(regs[0], HEX);
  Serial.print("r1: 0x");
  Serial.println(regs[1], HEX);
  Serial.print("r2: 0x");
  Serial.println(regs[2], HEX);
  Serial.print("r3: 0x");
  Serial.println(regs[3], HEX);
  Serial.print("r4: 0x");
  Serial.println(regs[4], HEX);
  Serial.print("r5: 0x");
  Serial.println(regs[5], HEX);
  Serial.print("r6: 0x");
  Serial.println(regs[6], HEX);
  Serial.print("r7: 0x");
  Serial.println(regs[7], HEX);
  Serial.println("");

  delay(5000);             // Espera 5 segundos antes de volver a empezar
}
