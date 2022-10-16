/*
  PIO_int
  Detecta la pulsación del pulsador en ensamblador mediante interrupciones
*/

#include "PIO_int.h"        // Para declarar las funciones externas

// Declaración de constantes
// -------------------------
#define  CAMBIO 0           // Interrupción por cambio
#define  NIVEL  1           // Interrupción por nivel
#define  FLANCO 2           // Interrupción por flanco
// ---
#define  BAJO   0           // Flanco de bajada/Nivel bajo
#define  ALTO   1           // Flanco de subida/Nivel alto


// Declaración de variables globales
// ---------------------------------
int PIOint = 0;            // Contador de interrupciones producidas


// Setup
// -----
void setup() {       
  Serial.begin(9600);      // Habilita la comunicación por el puerto serie
  
  Serial.println("\n");
  Serial.println("CONFIGURACIÓN INICIAL");
  Serial.println("---------------------");

  Serial.println("Inhibiendo las interrupciones del puerto PIOB...");
  NVIC_DisableIRQ(PIOB_IRQn);

  Serial.println("Borrando las interrupciones que hubieran pendientes del PIOB...");
  NVIC_ClearPendingIRQ(PIOB_IRQn);
  
  Serial.println("Estableciendo la prioridad de las peticiones de interrupción del PIOB...");
  NVIC_SetPriority(PIOB_IRQn, 0);  // 0 es la más alta

  Serial.println("Configurando el pin del pulsador como entrada con pull-up...");
  PIOB_pushbutton_setup();

  Serial.println("Configurando modo y polaridad de detección de una petición de interrupción del pulsador...");
  PIOB_pushbutton_setup_int(FLANCO, BAJO);

  Serial.println("Habilitando peticiones de interrupción del puerto PIOB...");
  NVIC_EnableIRQ(PIOB_IRQn);

  Serial.println("Configuración finalizada.");
  Serial.println("");

  Serial.println("");
  Serial.println("INICIO PROGRAMA");
  Serial.println("---------------");
  PIOint = 0;
}


// Loop
// ----
void loop() {
  Serial.print("Se han producido ");
  Serial.print(PIOint);
  Serial.println(" interrupciones");

  delay(2000);             // Espera 2 segundos antes de volver a comenzar
}
