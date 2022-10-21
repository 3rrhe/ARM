// Declaraciones de funciones externas
extern "C" {
  /*
    Función externa 'blink'. Hace parpadear el LED.
    Parámetros de entrada:
      char* str:   Dirección de comienzo de una cadena.
      int   delay: Milisegundos que el LED permanecerá encendido/apagado.
    Devuelve:
      int: Longitud de la cadena str.
  */
  int blink(char* str, int delay);
}

