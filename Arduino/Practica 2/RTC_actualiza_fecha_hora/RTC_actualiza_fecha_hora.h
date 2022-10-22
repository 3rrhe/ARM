// Declaración de las funciones externas
extern "C" {

  /*
    Función externa 'actualiza_fecha_hora'.
    Actualiza la fecha y hora del RTC y devuelve un código de error.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      int: código de error: 0 (todo bien), 1 (error en fecha), o 2 (error en hora)
  */
  int actualiza_fecha_hora();

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

}
