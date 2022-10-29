# 5.2.3 Tope de secuencia y limitar sonido

Partiendo de inter5.s (o del resultado del ejercicio anterior) haz las siguientes
modificaciones. Si te resulta más cómodo, realízalas por orden.

* Hasta ahora si llegamos al límite de la secuencia hemos comenzado por el
principio, haciendo que la secuencia sea circular tanto en un sentido como en
otro. Pues bien, ahora tienes que detectar dichos límites (tanto superior como
inferior), poniendo una especie de tope al llegar al límite, que impida avanzar
más. En caso de intentar avanzar en el sentido prohibido al llegar a un tope, en
lugar de sacar el sonido que corresponda por el altavoz, auméntalo una escala
(tope superior) o disminúyelo también una escala (tope inferior).
* Como habrás observado el sonido continuo resulta un tanto molesto después
de un tiempo. Y con la indicación de los LEDs tenemos información suficiente
para saber en qué posición de la secuencia estamos. Altera el programa para
que sólamente suene el altavoz mientras el botón está pulsado, o lo que es lo
mismo, para el sonido del altavoz cuando detectes un flanco de bajada en la
señal GPIO correspondiente.