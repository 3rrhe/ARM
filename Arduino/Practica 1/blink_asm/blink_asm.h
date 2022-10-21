// Declaraciones de funciones externas


extern "C" {
  
  /*
    Función externa 'blink'. Hace parpadear el LED.
    Parámetros de entrada:
      int times: Número de veces que parpadeará el LED.
      int delay: Milisegundos que el LED permanecerá encendido/apagado.
    Devuelve:
      int: Identificador del chip.
  */
  int blink(int times, int delay);
}
