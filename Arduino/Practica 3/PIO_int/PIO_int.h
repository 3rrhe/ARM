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
    Función externa 'PIOB_pushbutton_setup_int'
      Configura la señal del pin al que está conectado el pulsador como una señal de petición
        de interrupción y fija el modo y polaridad que determinarán ante qué variación o estado
        de esta señal se producirá una petición de interrupción.
    Parámetros de entrada:
      int mode: modo de interrupción (0: cambio, 1: nivel, 2: flanco)
      int polarity: polaridad (0: flanco de bajada/nivel bajo, 1: flanco de subida/nivel alto)
    Parámetro de salida:
      No tiene.
  */
  void PIOB_pushbutton_setup_int(int mode, int polarity);

  /*
    Función externa 'PIOB_handler'
      Rutina de tratamiento de las interrupciones generadas por el PIOB,
        comprueba que el motivo de la interrupción esté relacionado con el
        pulsador y si es así, incrementa la variable global PIOBint.
    Parámetros de entrada:
      No tiene.
    Devuelve:
      Nada.
  */
  /*void PIOB_Handler(); */
  }
