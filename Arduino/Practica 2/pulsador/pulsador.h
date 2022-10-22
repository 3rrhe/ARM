// Declaraciones de funciones externas
extern "C" {
  /*
    Función externa 'PIOB_pushbutton_setup'.
      Configura el pin al que está conectado el pulsador como entrada con pull-up.
    Parámetros de entrada:
      No tiene.
    Devuelve:
      Nada.
  */    
  int PIOB_pushbutton_setup();

  /*
    Función externa 'pulsador'.
      Espera a que se pulse el pulsador de la tarjeta de E/S.
    Parámetros de entrada:
      No tiene.
    Devuelve:
      int: Identificador del microcontrolador de la tarjeta Arduino.
  */    
  int pulsador();
}

