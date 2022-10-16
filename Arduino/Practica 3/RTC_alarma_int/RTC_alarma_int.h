extern "C" {

  /*
    Función externa 'RTC_Handler'.
      Rutina de servicio de la interrupción del RTC.  Almacena un 1 en la variable global 'alarma'
      para avisar de que se ha detectado la activación de la alarma.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      No tiene.
  */

  void RTC_Handler();

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
    Función externa 'configura_alarma_int'.
    Configura la fecha y hora de la alarma a un valor prefijado y activa las interrupciones.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      No tiene.
  */
  void configura_alarma_int();

  /*
    Función externa 'consulta_estado_alarma'.
    Mientras espera a la alarma, hace parpadear al LED azul. Cuando detecta que se ha activado,
      enciende el LED rojo, reactiva la alarma y vuelve.
    Parámetros de entrada:
      No tiene.
    Parámetros de salida:
      No tiene.
  */
  void consulta_estado_alarma();

}
