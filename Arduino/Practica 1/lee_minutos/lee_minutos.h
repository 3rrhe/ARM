// Declaraciones de funciones externas
extern "C" {
  /*
    Función externa 'lee_minutos'.
    Consulta los minutos y segundos del RTC y los devuelve en el vector indicado.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      unsigned int: contenido del registro RTC_TIMR.    
      int* minutos: vector de enteros de longitud 2.
  */
  unsigned int lee_minutos(int* minutos);
}

