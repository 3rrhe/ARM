// Declaración de las funciones externas
extern "C" {
  /*
    Función externa 'lee_fecha'.
    Consulta las partes de la fecha actual del RTC y las devuelve en el vector indicado.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      unsigned int: contenido del registro RTC_CALR.
      int* fecha: vector de enteros de longitud 5.
  */
  unsigned int lee_fecha(int* fecha);
}
