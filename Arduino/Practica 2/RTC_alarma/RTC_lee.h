/*
  RTC_lee.h - Declaración de funciones externas que consultan el RTC
*/
#ifndef RTC_LEE_H
#define RTC_LEE_H


extern "C" {

  /*
    Función externa 'lee_fecha_hora'.
    Consulta las partes de la fecha y hora actuales del RTC y las devuelve en los vectores indicados.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      int* fecha: vector de enteros de longitud 5.
      int* hora:  vector de enteros de longitud 4.
  */
  void lee_fecha_hora(int* fecha, int* hora);


  /*
    Función externa 'lee_alarma'.
    Consulta las partes de la fecha y hora y los bits de activación de la alarma y las devuelve en el vector indicado.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      int* cfgalarman: vector de enteros de longitud 11.
  */
  void lee_alarma(int* cfgalarma);

}

#endif
