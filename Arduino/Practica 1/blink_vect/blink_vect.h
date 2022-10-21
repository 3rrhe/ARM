// Declaración de las funciones externas
extern "C" {
  /*
    Función externa 'blink'. Hace parpadear el LED y devuelve el contenido de r0-r7.
    Parámetros de entrada:
      char* str:   Dirección de comienzo de una cadena.
      int   delay: Milisegundos que el LED permanecerá encendido/apagado.
    Devuelve:
      int: Longitud de la cadena str.
      int* r: vector de enteros de longitud 8.
  */
  int blink(char* str, int delay, int* r);
}

