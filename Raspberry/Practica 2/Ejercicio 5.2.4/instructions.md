# 5.2.4 Reproductor de melodía sencilla

Escoge una melodía sencilla y trata de interpretarla. Emplea los LEDs a tu
gusto para que cambien según la nota que esté sonando. Implementa las siguientes
funciones en los pulsadores.

* Pulsador izquierdo. Cambio de tempo. La melodía debe comenzar a tempo
normal (llamémoslo 1), y variar desde tempo lento (0) y tempo rápido (2)
según la secuencia (0, 1, 2, 0...) cada vez que pulsemos dicho botón.
* Pulsador derecho. Iniciar/Parar/Reanudar. La melodía tiene una duración
determinada y cuando acaba deja de sonar, no suena en modo bucle todo el
tiempo. Si pulsamos dicho botón cuando está en silencio después que haya so-
nado la melodía, la función correspondiente sería la de iniciarla. Si lo pulsamos
durante la reproducción actuaría a modo de pause (los LEDs se quedan con-
gelados en el estado en el que estén), parando y reanudando la reproducción
de la música.

En este ejemplo puedes profundizar todo lo que quieras. Por ejemplo empieza
codificando los silencios, éstos son muy importantes y también forman parte de
la melodía. Un segundo paso sería codificar la duración de las notas, si no lo has
hecho ya. También es posible tener varios instrumentos sonando a la vez, aunque
sólo dispongamos de un altavoz, busca por internet 1-bit music o beeper music
si quieres saber cómo se hace.