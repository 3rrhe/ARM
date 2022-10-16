/*
  muestra_fecha.cpp - Muestra por el puerto serie la fecha y hora actuales o la de la alarma
*/

#include "Arduino.h"
#include "RTC_lee.h"
#include "muestra_fecha.h"

/*
  serial_print_2d
    Envía por el puerto serie un número utilizando el formato '%2d'.
    Si el número es -1 enviará 'xx' en su lugar.
  Parámetros de entrada:
  int num: el número que debe representarse con dos decimales
*/
void serial_print_2d(int num) {
  if (num == -1) Serial.print("xx");
  else {
    if (num < 10) Serial.print("0");
    Serial.print(num);
  }
}


/*
  muestra_fecha
  Muestra la fecha y hora actual (o la de la alarma) en el formato:
    «DD de MES de AAAA HH:MM:SS AM/PM».
  Parámetros de entrada:
    int tipo: indica que fecha mostrar:
                  0: Muestra fecha y hora actuales
                  1: Muestra fecha y hora configurada en la alarma
*/
void muestra_fecha(int tipo)
{
  int fecha[5];                       // Vector para almacenar las partes de la fecha
  int hora[4];                        // Vector para almacenar las partes de la hora
  int cfgalarma[11];                  // Vector para almacenar las partes de la alarma

  char* meses[] = {"xxxxxxxx",
                   "enero", "febrero", "marzo", "abril",
                   "mayo", "junio", "julio", "agosto",
                   "septiembre", "octubre", "noviembre", "diciembre"};
  char* am_pm[] = {"AM", "PM", "xx"};
  
  if (tipo == 0)
    lee_fecha_hora(fecha, hora);
  else {
    lee_alarma(cfgalarma);
    // Día
    if (cfgalarma[0]) fecha[3] = cfgalarma[1];
    else              fecha[3] = -1;
    // Mes
    if (cfgalarma[2]) fecha[2] = cfgalarma[3];
    else              fecha[2] =  0;
    // No hay año en la alarma
    // Hora
    if (cfgalarma[4]) hora[1] = cfgalarma[5];
    else              hora[1] = -1;
    // Minuto
    if (cfgalarma[6]) hora[2] = cfgalarma[7];
    else              hora[2] = -1;
    // Segundo
    if (cfgalarma[8]) hora[3] = cfgalarma[9];
    else              hora[3] = -1;
    // AM/PM
    if (cfgalarma[4]) hora[0] = cfgalarma[10];
    else              hora[0] = 2;
  }
   
  // Muestra día
  serial_print_2d(fecha[3]);
  
  // Muestra mes
  Serial.print(" de ");
  Serial.print(meses[fecha[2]]);

  // Muestra año (solo en el caso de la fecha actual, no puede fijarse en la alarma)
  if (tipo == 0) {
    Serial.print(" de ");
    Serial.print(fecha[0]); // 19 o 20
    serial_print_2d(fecha[1]);
  }

  // Muestra hora
  Serial.print (" ");
  serial_print_2d(hora[1]);

  // Muestra minutos
  Serial.print(":");
  serial_print_2d(hora[2]);

  // Muestra segundos
  Serial.print(":");
  serial_print_2d(hora[3]);

  // Muestra AM/PM
  Serial.print(" ");
  Serial.print(am_pm[hora[0]]);
  
  // Envía retorno de carro
  Serial.println("");
}


// Alias para muestra_fecha()
extern "C" void muestra_fecha_hora()    { muestra_fecha(0); }
extern "C" void muestra_fecha_alarma()  { muestra_fecha(1); }


// printNL - prints a newline
extern "C" void printNL() {
  Serial.print("\n");
}

// printInt - prints an integer (in decimal)
extern "C" void printInt(int num) {
  Serial.print(num);
}

// printString - prints a string
extern "C" void printString(char* str) {
  Serial.print(str);
}

