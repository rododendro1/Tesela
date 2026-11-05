# Cambios

## Sin publicar

### Modulaciones desde una tonalidad y escalas parecidas

- `armonia tonalidad Do mayor --modulaciones` da, para cada tono vecino, la manera más suave de llegar (por acorde
  común, por una séptima disminuida enarmónica o directa), con el acorde pivote y una progresión de ejemplo;
  `--modulaciones Sol mayor` da todas las maneras de llegar a esa. La vista de análisis las muestra para la
  tonalidad de la progresión, para escucharlas (`PresentacionDeModulaciones`).
- `Escala.masParecidas(tipos:limite:)`: las escalas del catálogo, en cualquier tónica y con cualquier número de
  notas, que comparten más notas con una dada, de la que menos cambia a la que más y sin sus modos.
  `armonia escala Do mayor --parecidas` las lista con las notas que se van y las que llegan («Do lidio: Notas
  comunes: 6 · −Fa · +Fa♯»), y la vista de escalas tiene su sección (`PresentacionDeEstudioDeEscala.parecidas`).

### Más ventanas de quintas

- `VentanaDeQuintas.masSimple` (Re♭–Fa♯, las de `enarmonicaMasSimple`), `.habitual` (Mi♭–Sol♯: Do♯, Mi♭, Fa♯, Sol♯
  y Si♭) y `.armadura(_:)`, la de la tonalidad mayor con esa armadura (La♭–Do♯ sin alteraciones).
- `Escala.ventanaDeQuintas` y `Tonalidad.ventanaDeQuintas`: la ventana que contiene las notas de la escala y nombra
  las demás como ella (`Escala("La menor armónica").ventanaDeQuintas` va de Si♭ a Re♯), para pasarla a
  `OpcionesDeDiagrama(ventana:)` o a `Altura(midi:ventana:)`.

### Dos escalas comparadas nota a nota

`armonia escala Do mayor --contra Do dórico` dibuja en una hoja SVG las dos escalas comparadas nota a nota: los dos
pentagramas, una tabla grado a grado con los grados que cambian sombreados, un reloj con las dos escalas encima y la
leyenda de las notas comunes y de las que solo están en una. Las comunes van en azul; las de la primera, en verde, y
las de la segunda, en rojo. En la app, la sección de comparar de la vista de escalas la muestra debajo de la
comparación en texto y la exporta con la barra (`PresentacionDeEstudioDeEscala.comparacionNotaANota`).

### Ventanas de quintas para nombrar una altura sin contexto

- `VentanaDeQuintas`: doce quintas seguidas de la línea de quintas, una escritura para cada clase de altura.
  `.sostenidos` (Fa–La♯) y `.bemoles` (Sol♭–Si) son las de `preferirBemoles`; `.centrada(en:)` pone la tónica casi en
  medio (Re♭–Fa♯ alrededor de Do), y `VentanaDeQuintas(desde:)` empieza en cualquier nota.
- `Altura(midi:ventana:)`; `Altura(midi:preferirBemoles:)` usa ahora `.sostenidos` o `.bemoles`, con el mismo resultado.
- `OpcionesDeDiagrama.ventana` elige cómo se nombran las notas en los teclados, el piano y el reloj;
  `preferirBemoles` sigue funcionando y equivale a `ventana == .bemoles`.
- `TecladoCuadrado.altura(en:ventana:)`, `TecladoIsomorfico.altura(en:ventana:)`, `Mastil.altura(en:ventana:)` y
  `Mastil.alturaSiExiste(en:ventana:)`.

### La hoja de estudio de un acorde

- `armonia hoja --acorde Sol7` (`sheet --chord`) escribe la hoja de estudio de un acorde en SVG: sus notas y otros
  nombres, el pentagrama, las disposiciones cerrada, drop 2 y de fundamental, tercera y séptima, las digitaciones de
  guitarra más cómodas en diagramas, las escalas compatibles con sus tensiones y las sustituciones.
  `armonia grabar hoja --acorde …` la pasa a PDF.
- `PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de:notacion:)`; en la app, la pestaña de acordes la exporta.

### La hoja de estudio de una progresión

- `armonia hoja --acordes Rem7 Sol7 Do7M --en Do mayor` (`sheet --chords`) escribe la hoja de estudio de una
  progresión en SVG: los acordes y su tonalidad, el pentagrama con una disposición de cada uno, el análisis (grado, función y
  escala), las cadencias y las líneas de notas guía. `armonia grabar hoja --acordes …` la pasa a PDF.
- `PresentacionDeAnalisis.hojaDeEstudio(_:disposicion:notacion:)`; en la app, la vista de análisis la exporta con la
  disposición elegida.

### El mapa de brillo del catálogo

- `Escala.mapaDeBrillo(tonica:numeroDeNotas:tipos:)` da las escalas del catálogo con el mismo número de notas, de la
  más oscura a la más brillante, y los pares que están a una nota de distancia (`MapaDeBrillo`).
- `PresentacionDeEstudioDeEscala.mapaDeBrillo(numeroDeNotas:resaltada:notacion:)` lo dibuja en SVG: una columna por
  brillo por quintas y una línea entre las vecinas.
- `armonia escalas --mapa [Re dórico] [--notas 5]` (`--map`) escribe el SVG, y `armonia grabar escalas --mapa` lo pasa
  a PDF; en la app, la pestaña de escalas lo muestra con la escala elegida resaltada y lo exporta.

### La hoja de estudio en la app, con las secciones que se elijan

- En la app, la pestaña de escalas muestra la hoja de estudio antes de exportarla, con un interruptor para cada
  sección (pentagrama, estadísticas, reloj, teclados, acordes y escalera de brillo); se exporta con las elegidas.
- `PresentacionDeEstudioDeEscala.hojaDeEstudio(de:notacion:secciones:)` y `SeccionDeLaHoja` eligen las secciones, y
  `tamano(deUnSVG:)` da su ancho y su alto para verla con su proporción.

### `armonia escalas`: comparar en una tabla y buscar por intervalos

- `armonia escalas --comparar Do mayor, Do lidio, Do dórico` (`--compare`) pone varias escalas en una tabla, una por
  fila: las notas, el brillo por quintas, los pasos, el vector interválico, el número de Forte y los rasgos.
- `--con-intervalo tritono` y `--sin-intervalo semitono` (`--with-interval`, `--without-interval`; también un número
  del 1 al 6) filtran el catálogo por las clases de intervalo que forman sus notas, y `--con-paso 3` (`--with-step`)
  por los pasos entre notas vecinas.
- `PresentacionDeEstudioDeEscala.tablaDeEstadisticas(_:notacion:)` da la tabla con sus encabezados.

### La hoja de estudio de una escala

- `armonia hoja Re dórico` (`sheet`) escribe una hoja de estudio para imprimir, en SVG del ancho de un A4: el nombre y
  las notas, el pentagrama, el reloj, las estadísticas, el teclado de piano con los dedos de cada mano, los acordes de
  los grados y la escalera de brillo. `armonia grabar hoja Re dórico > dorico.pdf` la pasa a PDF con `rsvg-convert`.
- `PresentacionDeEstudioDeEscala.hojaDeEstudio(de:notacion:)` la da, y la app la exporta desde la barra de la pestaña
  de escalas («Hoja de estudio Re dórico.svg»).

### La escalera de brillo

- `Escala.escaleraDeBrillo()` (`EscaleraDeBrillo`) da las escalas con la misma tónica de la más oscura a la más
  brillante, cada una a una nota de la siguiente: desde Do mayor, bajando, Do mixolidio, Do dórico, Do menor natural,
  Do frigio, Do locrio…, y subiendo, Do lidio…; en cada paso, la vecina más habitual (`vecinasPorBrillo()`, las que
  suben o bajan una nota sin cambiar de tónica). `subidas` dice qué nota sube en cada peldaño.
- `armonia escala Do mayor --escalera` (`--brightness-ladder`) la escribe, con el brillo por quintas, la nota que sube
  y «←» en la de partida; con `--json`, la clave `escaleraDeBrillo`. La pestaña de escalas de la app la muestra en la
  sección «Escalera de brillo», y cada peldaño se abre al tocarlo.

### `armonia escalas`: ordenar y filtrar por las estadísticas

- `escalas --orden brillo` (`--sort brightness`) ordena cada grupo de la más brillante a la más oscura, por el brillo
  por quintas, y lo escribe al final de cada línea («lidio: Do Re Mi Fa♯ Sol La Si · +3»); `--orden notas`, de menos
  a más notas. `--sin-semitonos` (`--anhemitonic`) deja solo las anhemitónicas y `--regulares` (`--maximally-even`),
  las máximamente regulares. Se combinan con `--notas`, `--uso`, `--tradicion` y la búsqueda por el nombre.

### `armonia escala --estadisticas`, y las estadísticas en la app

- `escala Do mayor --estadisticas` (`--statistics`) escribe lo que se mide de la escala (`EstadisticasDeEscala`), un
  dato por línea: el número de notas con su cardinal, el brillo (en las de siete notas), el brillo por quintas, los
  pasos, el vector interválico, el número de Forte, las transposiciones distintas y sus rasgos (anhemitónica,
  cohemitónica, máximamente regular, medida aproximando los microtonos). Con `--json`, la clave `estadisticas`, con
  los valores sin escribir (números y booleanos) y el cardinal por su nombre.
- `PresentacionDeEstudioDeEscala.estadisticas(de:notacion:)` da esos datos con su nombre (`DatoDeEscalaPresentado`),
  en los quince idiomas, y la pestaña de escalas de la app los muestra en la sección «Estadísticas».

### Escalas: cardinal y estadísticas

- `CardinalDeEscala` nombra las escalas por su número de notas (de monotónica a dodecatónica), en los quince
  idiomas, y `TipoDeEscala` tiene `numeroDeNotas`, `cardinal` y `todos(numeroDeNotas:)`.
- `EstadisticasDeEscala` (`escala.estadisticas`) reúne el número de notas y su cardinal, el brillo de los modos de
  siete notas, `brilloPorQuintas` (la posición media en el círculo de quintas respecto a la tónica, que sirve para
  cualquier número de notas: 2 en la mayor y en la pentatónica mayor, 3 en la lidia, −3 en la locria), los pasos en
  semitonos, el vector interválico, si es anhemitónica o cohemitónica, las transposiciones distintas, el número de
  Forte, si es máximamente regular y si se ha medido aproximando notas microtonales.
- `armonia escalas --notas 5` (`--notes`) deja solo las escalas de ese número de notas.

### `armonia escala --json`, con las opciones del texto

- `escala … --json` admite las mismas opciones que el texto, y cada una añade su clave a las de siempre:
  `--acordes` (`acordesQueCaben` y, con `--doce`, `acordesEnLasDoceTonalidades`), `--secuencia` (`secuencia`, con
  sus notas y sus números MIDI, a lo largo de `--octavas` y hacia abajo con `--bajando`), `--piano` (`piano`, cada
  mano con sus notas y sus dedos), `--modos` (`modosParalelos` y `modosRelativos`), `--simetria`, `--vecinas`,
  `--doce` (`doceTonalidades`) y `--comparar` (`comparacion`). Antes daban «opción desconocida». Sin opciones, el
  JSON no cambia. El texto y el JSON leen las opciones con la misma función (`pedidoDeEscala`).

### `armonia`: un solo camino para los errores de uso

- `ErrorDeUso` es un `Error`, y las órdenes lo lanzan (`throw ErrorDeUso.faltaEscala`) en lugar de devolver el
  resultado de `uso(_:_:)`; `ejecutar` lo recoge y lo escribe, como antes hacía con `FalloDeUso`, que desaparece. Así
  una lectura puede servir igual para el texto y para `--json`. `leerDibujo` lanza también sus errores. Nada cambia
  en lo que se acepta ni en los mensajes.

### `armonia`: las opciones con valor, en una línea

- Las órdenes leen cada opción con valor con `Argumentos.valor(_:siFalta:)` (y `valorConPalabras`), que da el valor
  o `nil` y lanza el error de uso si a la opción le falta el valor, en lugar de repetir en cada orden los tres casos
  de `quitarOpcion`. `leerRecorrido` y `leerMastil` lanzan su error como las demás lecturas. Nada cambia en lo que
  se acepta ni en los mensajes.

### Las pruebas de la documentación, sin números de línea

- Las pruebas que salen de los ejemplos del README y de DocC (`EjemplosDeDocumentacionTests.swift`) nombran cada
  ejemplo por su fichero, su bloque y su renglón dentro del bloque, y ya no por su línea: cambiar el texto de un
  artículo no cambia sus pruebas, y el diff de un pull request muestra solo los ejemplos que cambian. Al fallar, la
  línea se busca en el fichero (`BloqueDeDocumentacion`).

### `armonia`: las opciones de cada orden, declaradas

- Cada entrada de la ayuda declara las opciones que explica (`EntradaDeAyuda.opciones`), y cada orden, lo que da con
  `--json` (`Orden.json`). El autocompletado y la propuesta ante una opción mal escrita salen de ahí, y no de leer
  los textos de la ayuda; las partituras y `grabar` dicen en su declaración qué opciones comparten. Una prueba
  comprueba que lo declarado y lo que explica la ayuda coinciden. Nada cambia en lo que se completa ni se propone.

### `armonia`: la ayuda se ajusta sola

- Las descripciones y las notas de la ayuda se cortan solas, por palabras, a la columna de los ejemplos, igual en los
  quince idiomas (antes cada idioma las cortaba a mano, y algunos pasaban de las cien columnas). En los textos, cada
  salto de línea abre un párrafo («--escalas: …», «opciones: …»), y una descripción nueva se escribe en una línea.

### La identidad de una escala

- Las tablas del catálogo que dicen algo de una escala concreta (su tradición y su categoría, el mēḷa de un janya, sus
  usos, sus afinaciones microtonales, el temperamento sugerido y sus nombres en otros idiomas) se buscan ahora por
  `TipoDeEscala.identidad` (el nombre y los intervalos juntos), en lugar de buscar por el nombre y comprobar después
  los intervalos en cada sitio. `esIdentico(a:)` la compara. Nada cambia en lo público: `==` sigue comparando solo el
  contenido.

## 0.3.5 (2026-11-05)

### `armonia`: `-o fichero` y las notas en el idioma elegido

- `-o fichero` (`--salida`, `--output`) escribe en ese fichero lo que da cualquier orden, también un MIDI, un PDF o un
  PNG, y sirve en la sesión y con `armonia < ejercicios.txt`, donde no hay `>`. Con `-o -`, va a la salida estándar
  aunque sea la terminal. Si la orden falla, el fichero no se toca; si no se puede escribir, sale con código 1.
- Con `--idioma`, las notas se leen también en ese idioma: `armonia acorde H7 --idioma de` es Si7, `Fis7` es Fa♯7 y
  `B` es Si♭; `ré7 --idioma fr` y `ре7 --idioma ru`, Re7. Lo que ya se leía sigue igual (`Do7 --idioma de` es Do7).

### `armonia`: órdenes de un fichero, el manual completo y las escalas al completar

- `armonia < ejercicios.txt` ejecuta una orden por línea, como la sesión, y sale con el mayor código de todas: sirve
  para corregir muchos ejercicios con `revisar`. Las líneas que empiezan por `#` no cuentan. En la sesión y en un
  fichero, una línea con solo opciones generales (`--idioma eu`, `--json`) las deja puestas para las siguientes.
  `LineaDeComandos.lote(entorno:salidaEsTerminal:leerLinea:escribir:)` lo ejecuta.
- Un fichero de `--archivo` que no se puede leer sale con código 1, el de lo que no se lee, y ya no remite a la
  ayuda como si la orden estuviera mal escrita (era el 2).
- El manual tiene los apartados ENTORNO (`ARMONIA_IDIOMA` y las variables de los programas de grabado) y ESTADO DE
  SALIDA (los códigos del 0 al 3), en los quince idiomas.
- El autocompletado propone los nombres de las escalas del catálogo tras `escala`, `posiciones`, `teclado` y `reloj`,
  sin tildes y con guiones (`menor-armonica`, `harmonic-minor`), que se leen igual.

### Las afinaciones de las escalas occidentales

- `UsoDeEscala.afinacionSugerida`: Werckmeister III en la música clásica y el temperamento igual en el jazz, el
  blues, el siglo XX, la música popular y las sintéticas. `TipoDeEscala.afinacionSugerida` la usa en las escalas
  occidentales, salvo en los modos y el hexacordo, que van en mesotónico, como en la polifonía del Renacimiento.
- La escala de blues tiene versión microtonal (`TipoDeEscalaMicrotonal.occidentales`), con sus blue notes: la
  tercera neutra (350 cents) y la séptima armónica (7/4, 969 cents), con la cuarta y la quinta puras.

### Las escalas y sus afinaciones

- Una escala puede tener varias versiones microtonales: `TipoDeEscala.afinaciones`, cada una con su `fuente`
  (`TipoDeEscalaMicrotonal.fuente`; `microtonal` sigue siendo la primera, la de su teoría de hoy). Los echoi
  diatónicos tienen además la de Chrysanthos de Madytos (1832), en los 68 moria de su teoría, en cents.
  `Escala.notasMicrotonales(sentido:afinacion:)` escribe la escala en cualquiera de ellas.
- `Escala.afinacion(la4:microtonal:sentido:)` da una `AfinacionDeEscala`: la escala suena con sus microtonos (el
  Mi𝄳 de Bayātī, 50 cents sobre Mi♭) y las notas que no son suyas, en temperamento igual.
- `Escala.cents(en:sentido:)` da los cents de cada grado en una `AfinacionHistorica`, que dependen de la tónica
  en los temperamentos circulares (la tercera de Do mayor mide 390 cents en Werckmeister III; la de Re♭ mayor, 408).
- `Tradicion.afinacionSugerida` (y `TipoDeEscala.afinacionSugerida`): la pitagórica en el canto gregoriano, la
  Grecia antigua, Mesopotamia y China; la justa en la India.

### El nombre completo de una escala

- `TipoDeEscala.nombreCompleto` (y `nombreCompleto(en:)`) antepone al nombre la palabra de su categoría cuando es
  un préstamo y el nombre no la lleva ya: «thāṭ Kāfī», «mēḷa Māyāmālavagauḷa», «rāga Mohanam» (los janya van con
  «rāga»), «maqām Bayātī», «drómos Hitzáz». «jins Ḥijāz» y «Rast makamı» se quedan como están, y también las
  categorías que se traducen (tetracordo, harmonía, afinación, escala…) y las occidentales.
- Los nombres de las categorías llevan sus diacríticos: «maqām» (ALA-LC), «drómos» y «échos» (con el acento de
  la palabra griega) y «muğam» (como se escribe en azerbaiyano), en español y en los idiomas de alfabeto latino que
  los toman prestados; «makam», «jins», «laras» o «pathet» no tienen. El inglés sigue diciendo «mugham». En la
  línea de comandos se siguen escribiendo sin ellos (`--categoria maqam`).
- Los echoi bizantinos se llaman «échos prótos», «échos plágios prótos»… (antes «echos»); se siguen
  encontrando sin el acento.

### Los colores de Aristóxeno y los adwār de Ṣafī al-Dīn

- Grecia antigua: los colores de Aristóxeno que faltaban (`TipoDeEscala.coloresDeAristoxeno`), en doceavos de
  tono: el cromático blando (4 + 4 + 22), el hemiólico (4½ + 4½ + 21) y el diatónico blando (6 + 9 + 15), con sus
  cents. El tetracordo cromático y el diatónico se encuentran también como «cromático tónico» y «diatónico tenso de
  Aristóxeno».
- Mundo árabe: cuatro de los doce shudūd de Ṣafī al-Dīn al-Urmawī (`TipoDeEscala.adwar`: shadd ʿUshshāq, Nawā,
  Abū Salīk y Rāst), en su sistema de diecisiete notas pitagóricas, con sus cents.

### El canto georgiano

- Folklore europeo: la escala del canto polifónico de Georgia (`TipoDeEscala.georgiana`, Do Re Mi♭ Fa Sol La Si♭
  en doce notas), con los cents medidos en Svaneti por Scherbaum, Mzhavanadze, Rosenzweig y Müller: pasos de 163 a
  185 cents, cuartas y quintas casi puras y una tercera neutra de 332.

### Glareano, la kora, la mbira, el arpa birmana, Vietnam y Brasil

- Los modos 9 a 12 de Glareano (`TipoDeEscala.modosDeGlareano`: aeolius, hypoaeolius, ionicus e hypoionicus), en
  la tradición del canto gregoriano, como escalas.
- África: las cuatro afinaciones de la kora (hardino, sauta, tomora ba y tomora mesengo), con los cents que midió
  Roderic Knight, y la nyamaropa de la mbira, cercana al mixolidio.
- El sudeste asiático: el saung, el arpa birmana, con los pasos medios de 182 y 327 cents que da Jay Rahn.
- **Tradiciones nuevas:** `Tradicion.vietnam` (Bắc y vọng cổ, con los cents de Keefe, Burns y Nguyen) y
  `Tradicion.brasil` (mixolídio, lídio y dórico nordestinos), con su nombre en los quince idiomas y
  `--tradicion vietnam` y `--tradicion brasil` en la línea de comandos.

### Clásica, jazz, blues: el uso de cada escala

- `UsoDeEscala` (clásica, jazz, blues, siglo XX, popular y sintética, con su nombre en los quince idiomas) y
  `TipoDeEscala.usos`: en qué música se usa cada escala de `todos`, una o varias (el dórico es clásico y de jazz; la
  disminuida, de jazz y del siglo XX). Las de otras tradiciones no tienen. `TipoDeEscala.todos(uso:)` da las de un uso.
- `armonia escalas --uso jazz` (o `--use`, con `clasica`, `blues`, `siglo-xx`, `popular`, `sintetica` o sus nombres
  ingleses) lista solo las habituales de ese uso, y propone el más parecido si no lo encuentra.
### El folklore europeo, y la menor bachiana

- **Tradición nueva, `Tradicion.europa`** («Folklore europeo», con su nombre en los quince idiomas y
  `--tradicion europa` en la línea de comandos), con `TipoDeEscala.europeas`: el dórico ucraniano (Do Re Mi♭ Fa♯
  Sol La Si♭), la escala podhalańska de los górales de los Tatras (Do Re Mi Fa♯ Sol La Si♭), la pentatónica húngara
  de Bartók y Kodály (la–do–re–mi–sol), el cuerno alpino (los armónicos del 8.º al 15.º) y la gaita escocesa (un
  mixolidio). Las dos últimas tienen versión microtonal en cents: el «fa del cuerno» (11/8, 551 cents) y la 7ª
  natural de la gaita (7/4, 969 cents).
- «dórico ucraniano» deja de ser un alias del dórico ♯4 (en español y en los otros idiomas) y pasa a ser el nombre
  de la escala europea, con las mismas notas. «menor rumana» sigue siendo el dórico ♯4.
- Alias nuevos con los nombres de los conservatorios españoles: «bachiana», «menor bachiana» y «de Bach» (la menor
  melódica de jazz, que sube y baja igual), «menor dórica» (el dórico) y «menor antigua» (la menor natural).

### `armonia`: una ayuda corta, sesiones, el idioma del entorno y códigos para las faltas

- `armonia ayuda` (y `armonia` a secas fuera de la terminal) da un índice: una línea por orden, por grupos, y cómo
  pedir más. La ayuda completa de antes es `armonia ayuda --todo` (o `--all`), y la de una orden,
  `armonia ayuda <orden>`.
- `revisar` y `contrapunto` salen con código 3 si encuentran faltas, para usarlos en un script o en un hook.
- `--json` también en `armonizar`, `realizar`, `revisar`, `contrapunto` y `transponer`. Cada falta lleva su tipo como
  clave fija (`quintasParalelas`, `notaRepetida`…). Si la salida no es la terminal, el JSON va en una sola línea.
- `ARMONIA_IDIOMA` da el idioma como `--idioma` (que la anula); con `ARMONIA_IDIOMA=sistema`, el de `LC_ALL`,
  `LC_MESSAGES` o `LANG`. Un idioma que no se conoce es un error de uso.
- `armonia` sin argumentos y en la terminal abre una sesión: una orden por línea, sin «armonia», hasta `salir`.
  `LineaDeComandos.sesion(entorno:leerLinea:escribir:)` la ejecuta, y `ejecutar` recibe el `entorno`.

### Los últimos lectores que daban `nil` dicen por qué fallan

- **Cambio incompatible:** `Tonalidad.acorde(romano:)` y `acordes(romanos:)` lanzan en lugar de devolver `nil`:
  `ErrorDeLectura` (`.textoVacio`) si no hay nada que leer, y `ErrorDeLecturaDeTeoria` en el carácter donde empieza
  lo que no se lee, con dos motivos nuevos: `.cifradoRomanoNoValido` y `.destinoNoTonicalizable`, si lo que va tras la
  barra no es una tríada mayor o menor en estado fundamental («V/vii°»).
- **Cambio incompatible:** `Tonalidad.acorde(sobre:cifras:)` y `acordes(bajoCifrado:)` también lanzan:
  `.cifrasNoValidas` en el carácter que no es una cifra (o en la segunda de dos alteraciones seguidas),
  `.cifrasSinAcorde` si las cifras no forman acorde sobre el bajo, y el error de la nota si el bajo no se lee.
  `Coral.realizar(bajoCifrado:en:soprano:)` lanza lo mismo, y sigue dando `nil` si no hay realización sin faltas.
- **Cambio incompatible:** `TipoDeEscala.buscar(nombre:)`, `Encordado(nombre:)` e `Idioma(nombre:)` son ahora
  `init(leyendo:)` y lanzan: `.tipoDeEscalaNoReconocido`, `.nombreNoReconocido` con los nombres de
  `Encordado.todos`, y `ErrorDeLectura.Motivo.idiomaNoReconocido` (nuevo) con los códigos de los quince idiomas.
  Donde se escribía `TipoDeEscala.buscar(nombre: texto)`, ahora `try? TipoDeEscala(leyendo: texto)`.
- Los cinco motivos nuevos tienen su explicación en los quince idiomas.
- `Idioma(codigo:)` y `ColorRGB(hexadecimal:)` siguen dando `nil`: buscan un código o leen un formato fijo, sin
  más motivo que dar.

### Girar y reflejar un teclado, igual en todos

- **Cambio incompatible:** `TecladoIsomorfico.rotado(grados:nombre:)` lanza `ErrorDeUIL.rotacionNoValida` si los
  grados no son un múltiplo de 30, como ya hacía `FormatoUIL.rotado(grados:)`, en lugar de devolver `nil`.
- **Cambio incompatible:** `FormatoUIL.reflejado` ya no es opcional: el reflejo de un formato válido siempre lo es.
- **Cambio incompatible:** `TecladoCuadrado.girado(nombre:)` y `girado(cuartos:)` son ahora
  `rotado(cuartos:nombre:)`, con un cuarto de vuelta si no se dice otra cosa, como `TecladoIsomorfico` y
  `MapaHexagonal`, que ya decían `rotado`. `cuartas.girado()` es `cuartas.rotado()`.

### Guardar en JSON

- `Tempo`, `Encabezado`, `AcordeConDuracion`, `AcordeConInicio`, `RitmoArmonico`, `Coral`, `Contrapunto` y
  `Contrapunto.Especie` son `Codable`. Al leer se comprueba lo mismo que al crearlos: un tempo que no es positivo, un
  acorde que no dura nada, un coral con acordes de distintas voces o un contrapunto que no dura una redonda por nota
  del cantus dan un `DecodingError` en lugar de un valor imposible. Un `Coral` se guarda como sus acordes
  (`[["Do3", "Mi4"], …]`) y un `Contrapunto`, con el cantus, los eventos del contrapunto y la especie (1 a 5).
- `Partitura` no es todavía `Codable`: lleva dentro análisis, claves y tablaturas que no lo son. Se guarda lo que la
  hace (la voz, el coral o el contrapunto) y se vuelve a hacer.

### Documentación

- Las convenciones (`Convenciones`) dicen qué tipos cumplen cada protocolo, cuándo un nombre lleva `con…` o un
  participio (`rotado`, `reflejado`, `desplazado`; nunca `girado`) y cuándo un lector lanza (`init(leyendo:)`) o da
  `nil` (`init?(comprobando:)`).
- Todo lo público que no la tenía lleva documentación, salvo lo que solo cumple un protocolo.
- `Tonalidad` y `Escala` ya no repiten `init?(texto:)`: el de `LegibleDesdeTexto` hace lo mismo.

### Los acordes que se comparan, también en una `Partitura`

- **Cambio incompatible:** `DisposicionDeAcorde.svgPentagrama(_:titulo:cifrados:grados:bajoCifrado:digitos:tablatura:opciones:)`
  ya no existe. En su lugar, `Partitura(acordes:titulo:porEvento:tablatura:)` hace la partitura de esos acordes, una
  redonda por columna, y `svg(opciones:)` la dibuja igual que antes. Donde se escribía
  `DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I", cifrados: progresion, opciones: opciones)`, ahora
  `Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(cifrados: .enOrden(progresion))).svg(opciones: opciones)`.
  Así lo que se anota en un pentagrama (cifrados, grados, bajo cifrado, dedos y tablatura) pasa siempre por una `Partitura`, y la
  misma progresión se escribe también en MusicXML, MEI, LilyPond, ABC o MIDI.
- `Partitura.dibujaElRitmo` (nuevo, `true` por omisión): con `false`, un pentagrama de una voz se dibuja con cada evento en
  su columna, sin plicas, cifra de compás ni barras. Es lo que pone `Partitura(acordes:…)`.
- `escala.svgPentagrama()`, `acorde.svgPentagrama()` y `arpegio.svgPentagrama()` siguen: son los dibujos de una
  escala, un acorde o un arpegio solos.

### Lo que se toca en el mástil, también en una `Partitura`

- `Escala.partitura(tocadaEn:titulo:ritmo:porEvento:tablatura:)` y
  `Acorde.partitura(arpegiadoEn:titulo:ritmo:porEvento:tablatura:)` (nuevos) hacen la partitura de unas alturas
  tocadas, que se puede escribir en MusicXML, MIDI y los demás formatos. `svgPentagrama(tocadaEn:)` y
  `svgPentagrama(arpegiadoEn:)` la dibujan como antes. Las escalas microtonales siguen con su propio dibujo, que
  lleva el signo de cada nota de su sistema.
- `Partitura.Pentagrama.armadura` (nuevo): una armadura propia, como la de una escala (Re dórico, con la de Do
  mayor), que se escribe si las opciones dejan la armadura en `.automatica`.
- `Partitura.Linea.tonica` (nuevo): la nota desde la que se cuentan los intervalos de las notas donde no suena ningún
  acorde.

### Opciones del pentagrama por grupos

- **Cambio incompatible:** `OpcionesDePentagrama` ya no repite las opciones de sus grupos. Se quitan las propiedades
  sueltas (`opciones.clave`, `opciones.nombresDeLasNotas`, `opciones.marcarTonica`, `opciones.color`…) y el `init` con
  todas planas. Ahora se escribe `opciones.maquetacion.clave`, `opciones.marcas.nombresDeLasNotas`,
  `opciones.marcas.tonica` y `opciones.colores.dibujo`, y se crean con
  `OpcionesDePentagrama(armadura:notacion:maquetacion:marcas:colores:)`:
  `OpcionesDePentagrama(notacion: .inglesASCII, marcas: .init(nombresDeLasNotas: true))`. `Maquetacion`, `Marcas` y
  `Colores` tienen su `init` con todo por omisión. Los nombres cambian donde el grupo ya lo dice: `marcarSemitonos`
  es `marcas.semitonos`, `marcarTonica` es `marcas.tonica`, `marcarNotasAjenas` es `marcas.notasAjenas`, `color` es
  `colores.dibujo` y `colorDeLaTonica` es `colores.tonica`.
- `OpcionesDePentagrama`, sus grupos, `Disposicion` y `Pentagramas` son `Hashable` y `Sendable`.

### Una partitura entera en JSON

- `Partitura`, `Partitura.Linea` y `Partitura.Pentagrama` son `Codable`, y con ellos `Notacion`, `EscrituraDeNotas`,
  `EscrituraDeLaOctava`, `Idioma`, `Tipografia`, `Clave`, `AcordeAnalizado` (y su `Categoria`), `FuncionTonal`,
  `Tablatura` y `Tablatura.Pulsacion`. Una `EscrituraDeNotas` se guarda por su idioma, si va con palabras y su
  tipografía, y al leerla se busca entre `EscrituraDeNotas.allCases`. Si no está, da un `DecodingError`.
- `Clave`, `FuncionTonal` y `EscrituraDeLaOctava` tienen ahora `rawValue` (el nombre del caso), que es lo que se
  guarda.

### Razones de frecuencias

- **Cambio incompatible:** `SistemaMicrotonal.razonesDeLosSruti` es un `[RazonDeFrecuencias]` en lugar de una tupla
  `[(numerador: Int, denominador: Int)]`. `numerador` y `denominador` siguen ahí, como `Double`, y además están
  `valor`, `cents` y `description` («256/243»).
- `RazonDeFrecuencias` pasa de ArmoniaRepresentaciones a ArmoniaNucleo y es `Codable`. Con `import Armonia` no cambia
  nada.

### Cada nota microtonal sabe en qué sistema se escribe

- `Evento.Nota` tiene `sistema` (`SistemaMicrotonal?`) y `ajuste`, los pasos de ese sistema que se aparta, como
  `NotaMicrotonal.ajuste`: `Evento.Nota("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)` es el Mi koron de un
  dastgāh. En texto va tras los cents, `Mi♭4(50¢,persa,1):4`, y así se guarda en JSON. Una nota que no se aparta no
  tiene sistema, y una sin sistema (las escritas a mano) lleva, como antes, el signo que dan sus cents.
- `Escala.voz()` da sus notas con su sistema, así que el *koron* y el *sori* de un dastgāh salen como tales en
  MusicXML (`<accidental>koron</accidental>`) y en MEI (`accid="koron"`), y la flecha de Helmholtz-Ellis de un
  śruti, en MusicXML (con su glifo SMuFL) y en el pentagrama de cualquier voz. MEI, que no tiene la flecha, escribe
  la koma que dan los cents, como antes.
- `Escala.partitura(tocadaEn:)` también sirve para las escalas microtonales: sus notas llevan su microtono y su
  sistema, y `svgPentagrama(tocadaEn:)` y `svgPentagrama(secuencia:)` dibujan esa partitura en todas las escalas, sin
  un camino aparte para las microtonales.
- Una `Partitura` sin ritmo (`dibujaElRitmo: false`) dibuja los microtonos de sus notas, que antes se quedaban sin signo.

### Una sola notación por partitura, y títulos que la siguen

- `Partitura.notacion` vale también al dibujarla: `svg()` escribe en ella los cifrados, los nombres de las notas y
  el título, salvo que las opciones fijen otra. `OpcionesDePentagrama` tiene `notacionFijada` (`nil` si no se da):
  `OpcionesDePentagrama(notacion:)` la fija, y sin ella cada dibujo usa la de lo que dibuja, o la española compacta
  fuera de una partitura. `opciones.notacion` sigue dando la que se usa.
- `Encabezado` tiene `tema` (`.escala(_:)` o `.acorde(_:)`) y `titulo(en:)`: sin `titulo`, el título es el nombre del
  tema en la notación con que se dibuja o se exporta. `Escala.partitura(tocadaEn:)` y
  `Acorde.partitura(arpegiadoEn:)` ya no fijan un título en español: ponen su tema. Un título escrito a mano se
  queda como está.
- MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI escriben el título con `titulo(en: partitura.notacion)`.

### Las mismas opciones en todos los diagramas

- **Cambio incompatible:** `OpcionesDeDiagrama` (la notación, si se prefieren bemoles, el título y la escala) es la
  misma en el Tonnetz, la tabla armónica, los teclados isomórficos y cuadrados, el teclado de piano y el reloj de
  clases, y sustituye a sus parámetros sueltos:
  - `Tonnetz.svg` y `TablaArmonica.svg` son `svg(opciones:margen:leyenda:)`; `paso` es ahora `opciones.escala`
    (1, el de siempre).
  - `TecladoCuadrado.svg` es `svg(_:marcadas:primeras:contorno:margen:opciones:)`, sin `lado`, `notacion` ni
    `preferirBemoles`; `TecladoIsomorfico.svg` es `svg(_:marcadas:opciones:)`, sin `tamano`.
  - `TecladoDePiano.svg` es `svg(marcadas:primeras:opciones:)` y `RelojDeClases.svg`, `svg(rotulos:opciones:)`: el
    título va en `opciones.titulo`.
- **Cambio incompatible:** las notas marcadas de los teclados son unas `MarcasDeDiagrama`: `[60, 64, 67]` las marca
  y `[60: "1", 64: "3"]`, con un rótulo. En los teclados isomórficos y cuadrados el rótulo se escribe en lugar del
  nombre de la nota; en el de piano, una nota se puede marcar sin rótulo. Un `Set<Int>` se pasa como
  `MarcasDeDiagrama(notas)` y un `[Int: String]`, como `MarcasDeDiagrama(rotulos:)`.
- Los teclados isomórficos y cuadrados pueden llevar título (`opciones.titulo`); por defecto, ninguno, como antes.

### La tablatura cuenta las cuerdas como el mástil

- **Cambio incompatible:** `Tablatura.Pulsacion.cuerda` se cuenta ahora desde la más grave (la 0), como
  `PosicionEnElMastil.cuerda`; antes se contaba desde la más aguda, la línea de arriba del dibujo, que sigue
  poniendo la más aguda arriba. Una pulsación escrita a mano (o guardada en JSON) en la cuenta de antes cambia de
  cuerda: la cuerda `c` de antes es la `cuerdas - 1 - c` de ahora. Ya no hay una cuenta que convertir:
  `Tablatura(_:posiciones:)` toma las posiciones del mástil tal cual.

### Todo lo que se dibuja en un pentagrama sale de una partitura

- `Escala.partitura(octava:octavas:sentido:digitacion:)`, `Escala.partitura(secuencia:octava:octavas:sentido:)`,
  `Acorde.partitura(octava:disposicion:)` y `Arpegio.partitura(octava:)` dan la `Partitura` de lo que dibuja su
  `svgPentagrama(…)`, que ahora es `partitura(…).svg(opciones:)`. Así lo que se ve se exporta igual:
  `Acorde("Sol7").partitura().musicXML()`. Los dibujos no cambian.
- `Encabezado.Tema` tiene tres casos nuevos: `.secuencia(_:de:)` («Do mayor · por terceras»), `.arpegio(_:)` y
  `.progresion(_:)` («Rem7 – Sol7 – Do7M»), con su nombre en la notación con que se dibuja o se exporta.
  `Arpegio` (con `Arpegio.Patron` y `Arpegio.Aproximacion`) y `SecuenciaDeEscala` son `Codable`.
- `OpcionesDePentagrama.Marcas.cifrados` (`true` por omisión) quita los cifrados de encima en cualquier partitura;
  los acordes siguen contando para los intervalos y las notas ajenas. Es lo que hacen
  `Acorde.svgPentagrama(cifrado: false)` y `Arpegio.svgPentagrama()`.

### Título opcional en las progresiones

- `Partitura(acordes:titulo:porEvento:tablatura:)` ya no pide el título: sin él, la partitura se titula con sus cifrados
  (`Encabezado.Tema.progresion`), en la notación con que se dibuja o se exporta.

### El título y el tamaño del pentagrama, como en los diagramas

- **Cambio incompatible:** `OpcionesDePentagrama.Maquetacion.tamano` ya no existe. Su lugar lo ocupa
  `OpcionesDePentagrama.escala`, un factor del tamaño de siempre (10 píxeles por espacio): donde se escribía
  `maquetacion: .init(tamano: 20)`, ahora `escala: 2`.
- `OpcionesDePentagrama.titulo` cambia el título de lo que se dibuja; con `""`, el SVG va sin `<title>` y con
  `aria-labelledby="descripcion"`.

### El piano y el reloj nombran las notas

- El teclado de piano escribe en las teclas marcadas sin rótulo el nombre de su nota, y el reloj de clases, en las
  horas sin rótulo, el de su clase, en `OpcionesDeDiagrama.notacion` y con bemoles si `preferirBemoles`.
  `OpcionesDeDiagrama.nombresDeLasNotas: false` vuelve a lo de antes: el piano las marca sin texto y el reloj escribe
  los números del 0 al 11.

### La importación guarda el sistema de cada microtono

- `NotaDeLaPieza.sistema` y `ajuste` dicen en qué sistema se escribe un microtono importado, como
  `Evento.Nota.sistema`: el koron y el sori persas, las comas de Arel-Ezgi-Uzdilek, los moria de Wyschnegradsky y
  las flechas de Helmholtz-Ellis. Se leen de `<accidental>` en MusicXML (con su atributo `smufl`) y de `accid` y
  `glyph.name` en MEI. Un medio bemol no dice sistema: sus cents bastan. `NotaDeLaPieza.nota` da la nota como la
  de un evento, con su microtono y su sistema.

### De la pieza importada a una partitura

- `PiezaImportada.partitura()` hace de lo importado una `Partitura`, para dibujarla o exportarla otra vez: un
  pentagrama por parte, con el título, la tonalidad, el tempo y el compás del fichero; las notas que empiezan y
  acaban a la vez, en un acorde; las que se solapan de otra forma, en otra voz, y silencios en los huecos. Cada nota
  lleva su microtono y su sistema, su dinámica y sus articulaciones.

### Los diagramas nombran las notas como se escriben

- `MarcasDeDiagrama(_:)` acepta alturas, que se nombran como se escriben en el piano y en los teclados isomórficos
  y cuadrados (`MarcasDeDiagrama.alturas`, `altura(de:)`): el Si♭ de Fa mayor ya no sale como La♯.
- `RelojDeClases(notas:tonica:orden:)` hace un reloj con notas, y sus horas se nombran como ellas
  (`RelojDeClases.ortografia`).

### Ritmo en la partitura de una escala o de un arpegio

- `Escala.partitura(octava:octavas:sentido:digitacion:ritmo:)` y `Arpegio.partitura(octava:ritmo:)` admiten un
  ritmo, como `partitura(tocadaEn:ritmo:)`: con `.uniforme(.corchea)`, la escala o el arpegio en corcheas, con la
  última nota en negra.

### El signo de un microtono, público

- `SignoMicrotonal` es público, con sus nombres en cada formato (`smufl`, `musicXML`, `mei`, `lilypond`, `abc`), la
  lectura de vuelta (`init(smufl:)`, `init(musicXML:smufl:)`, `init(mei:)`), `todos` y `sistemaYAjuste(altura:desvio:)`.
  `Evento.Nota.signo(semitonos:)` dice con qué signo se escribe una nota.

### Del mástil a la partitura, con la tablatura

- `ArmoniaTrastes` usa ahora `ArmoniaPartitura` (como `ArmoniaFormatos`; ninguno de los dos usa al otro), y lo que se
  toca en el mástil sale en una `Partitura` con la tablatura debajo:
  - `Digitacion.partitura(de:titulo:)` y `Digitacion.partitura(_:acordes:titulo:)` (nuevos): una o varias
    digitaciones, en redondas, escritas con la ortografía de su acorde y con el cifrado encima.
  - `EscalaEnElMastil.partitura(de:titulo:ritmo:)` y `ArpegioEnElMastil.partitura(de:titulo:ritmo:)` (nuevos): la
    posición o el arpegio en el orden en que se tocan, con sus dedos en el arpegio y, con `ritmo`, con ritmo. Sin
    escala ni acorde, las notas van como las da el mástil.
  - `Tablatura(_:posiciones:)` (nuevo): la tablatura con las posiciones del mástil.

### Lo que se toca en el mástil sabe qué es

- `EscalaEnElMastil.escala`, `ArpegioEnElMastil.acorde` y `Digitacion.acorde` (nuevos): la escala o el acorde de
  que salieron (`posicionesCAGED(de:)`, `posicionesPorCuerda(de:)`, `arpegios(de:)`, `arpegiosCAGED(de:)`,
  `arpegiosDeUnaNotaPorCuerda(de:)`, `digitaciones(de:)` y `disposiciones(de:_:cuerdas:)`), o `nil` si se hicieron
  a mano. Sus `partitura()` los usan si no se da otro: `posicion.partitura()` basta.
- Dos digitaciones siguen siendo iguales si se tocan igual, aunque solo una sepa de qué acorde es.

### El ritmo, aparte de la figura

- `Partitura.Ritmo` (nuevo): `.libre` (redondas, sin ritmo) o `.uniforme(.corchea)` (todas con esa duración, y la
  última, una negra si es más corta). Sustituye al `figura: Duracion?` que decidía a la vez si había ritmo
  y cuál en `Escala.partitura(octava:…)`, `partitura(tocadaEn:…)`, `svgPentagrama(tocadaEn:…)`,
  `Arpegio.partitura(octava:)`, `Acorde.partitura(arpegiadoEn:…)`, `svgPentagrama(arpegiadoEn:…)` y las partituras
  del mástil.

### Lo que se anota, evento a evento

- `Partitura.AnotacionesPorEvento` (nuevo): los cifrados, el análisis, los marcadores, los grados, el bajo cifrado, los
  dedos y las pulsaciones por el índice de cada nota, la forma en que los dan las escalas, los arpegios y el mástil.
  `Partitura.Linea(_:porEvento:nombre:plicaArriba:tonica:)` los lleva a los inicios con que los guarda la línea, y
  `Linea.porEvento` los devuelve; `Voz.porEvento(_:)` (nuevo) es lo contrario de `porInicio(_:)`. Las partituras de
  acordes, de escalas y de arpegios, y su dibujo, pasan por aquí, en lugar de cada una con su conversión.

### La tablatura, también en MusicXML

- `Partitura.musicXML()` escribe la tablatura de un pentagrama con `numeroDeCuerdas` en un pentagrama de tablatura de la misma
  parte, debajo de los demás: clave `TAB`, sus líneas, la afinación (`<staff-tuning>`), el capo y la cuerda y el
  traste de cada nota (`<technical>`). MEI, ABC, LilyPond, GUIDO y MIDI siguen sin ella.
- `Tablatura.afinacion` y `Tablatura.capo`, y `Partitura.Pentagrama.afinacion` y `capo` (nuevos): cómo suena cada
  cuerda al aire, sin el capo, y el traste del capo. `Tablatura(_:posiciones:)` los toma del mástil, y
  `Partitura.Pentagrama(clave:voces:tablatura:armadura:)` (nuevo), de la tablatura.
- Al importar MusicXML, las notas de un pentagrama de tablatura no se leen otra vez si la parte tiene otros
  pentagramas: una partitura del mástil vuelve con sus notas una vez.

### La guitarra, en clave de sol octava baja

- `Partitura.Pentagrama.claveDelInstrumento` (nuevo): la clave de sol octava baja si la cuerda más grave de la
  tablatura está entre el Si1 y el Do3, como en la guitarra; si no, `nil`. `claveEscrita` la usa si el pentagrama no
  lleva clave, en SVG y en MusicXML, así que las partituras del mástil llevan las notas como suenan y la clave las
  escribe una octava más aguda. El bajo eléctrico y el ukelele siguen con la que mejor va a sus notas.
- **Cambio incompatible:** una partitura de la guitarra (las del mástil, o con `Pentagrama(numeroDeCuerdas:afinacion:)`) se
  escribe en clave de sol octava baja en lugar de la que mejor iba a sus notas. `armonia pentagrama … --tab` deja de
  subir las notas una octava para escribirlas en clave de sol.

### Todo lo que se anota, en un solo `porEvento`

- **Cambio incompatible:** `Partitura(acordes:titulo:porEvento:tablatura:)`,
  `Escala.partitura(tocadaEn:titulo:ritmo:porEvento:tablatura:)`,
  `Escala.svgPentagrama(tocadaEn:titulo:ritmo:porEvento:tablatura:opciones:)`,
  `Acorde.partitura(arpegiadoEn:titulo:ritmo:porEvento:tablatura:)` y
  `Acorde.svgPentagrama(arpegiadoEn:ritmo:porEvento:tablatura:opciones:)` toman todo lo que se anota en cada nota en
  una `Partitura.AnotacionesPorEvento`, también el análisis y los marcadores, en lugar de los parámetros sueltos
  `cifrados:`, `grados:`, `bajoCifrado:` y `digitos:`, que ya no existen. Donde se escribía
  `Partitura(acordes: voces, cifrados: progresion, grados: grados)`, ahora
  `Partitura(acordes: voces, porEvento: .init(cifrados: .enOrden(progresion), grados: .enOrden(grados)))`; donde
  `partitura(tocadaEn: alturas, digitos: dedos)`, `partitura(tocadaEn: alturas, porEvento: .init(dedos: dedos))`.
- `Dictionary.enOrden(_:)` (nuevo, con claves `Int`): una lista, uno por nota (o columna) en orden.
- Las pulsaciones son las de la tablatura si `porEvento` no trae las suyas, y el cifrado de un arpegio va en su primera
  nota si `porEvento` no le da otro. Las partituras del mástil pasan por aquí.

### La ortografía de unas alturas, pública

- `Altura.reescritas(_:con:)` (ahora pública): las alturas escritas con unas notas cuando suenan igual, sin cambiar el
  número MIDI (el La♯3 del mástil, como Si♭3 en Do7). Es la que usan las escalas, los arpegios y las digitaciones del
  mástil, que ya no tienen la suya.

### La importación respeta las voces y los pentagramas del fichero

- `NotaDeLaPieza.pentagrama` y `NotaDeLaPieza.voz` (nuevos): el pentagrama de la parte, desde 0 (`<staff>1</staff>`
  en MusicXML es el 0), y la
  voz (`<voice>` en MusicXML, `<layer n>` en MEI), si el fichero los dice. MIDI y ABC no los dicen.
- `PiezaImportada.partitura()` hace un pentagrama por cada pentagrama de la parte (el piano vuelve en dos, cada uno
  con su clave) y, si todas las notas de un pentagrama dicen su voz, una voz de la partitura por cada voz del fichero.
  Sin ellas, como antes: lo que se solapa va en otra voz.
- **Cambio incompatible:** las notas leídas de MusicXML y de MEI son distintas (`==`) de las mismas hechas a mano sin
  `voz` ni `pentagrama`.

### Nombres más claros en la partitura

- **Cambio incompatible:** algunos nombres de la partitura dicen mejor lo que son. Donde se escribía lo de la
  izquierda, ahora lo de la derecha:
  - `Partitura.Pentagrama.cuerdas` y `Pentagrama(clave:voces:cuerdas:)`: `numeroDeCuerdas` y
    `Pentagrama(clave:voces:numeroDeCuerdas:)`; `Partitura(_:clave:cuerdas:encabezado:)`:
    `Partitura(_:clave:numeroDeCuerdas:encabezado:)`.
  - `Tablatura(cuerdas:notas:afinacion:capo:)`, `Tablatura.cuerdas` y `Tablatura.notas`:
    `Tablatura(numeroDeCuerdas:pulsaciones:afinacion:capo:)`, `numeroDeCuerdas` y `pulsaciones`.
  - `Partitura.Linea.digitos` (y la etiqueta `digitos:` de sus inicializadores): `dedos`.
  - `Encabezado.parte` y `Partitura.parte`: `nombreDeLaParte`.
- **Cambio incompatible:** `Partitura.lineas` cuenta los pentagramas desde 0 (el de arriba), como
  `Partitura.pentagramas` y `NotaDeLaPieza.pentagrama`; antes, desde 1. `partitura.pentagramas[linea.pentagrama]` es
  el suyo.

### Cada nombre, una sola cosa

- **Cambio incompatible:** `trastes` ya no nombra tres cosas distintas. `Mastil.trastes` (cuántos tiene) es
  `Mastil.numeroDeTrastes`, y `Mastil(_:trastes:)`, `Mastil(_:numeroDeTrastes:)`, como `numeroDeCuerdas`. Los trastes
  que abarca la mano en `EscalaEnElMastil` y `ArpegioEnElMastil` son `rangoDeTrastes`, también en sus
  inicializadores. `Digitacion.trastes` (uno por cuerda) sigue igual. `Mastil.posiciones(de:trastes:)`, de una
  escala o de un acorde, es `posiciones(de:en:)`: `mastil.posiciones(de: escala, en: 0...12)`.
- **Cambio incompatible:** `Encordado.cuerdas` es `Encordado.afinacion`, y `Encordado(nombre:cuerdas:)`,
  `Encordado(nombre:afinacion:)`: las alturas al aire, como `Tablatura.afinacion` y `Partitura.Pentagrama.afinacion`.
- **Cambio incompatible:** `sumar()` de unas duraciones es la propiedad `total`:
  `[Duracion.negra, .corchea, .corchea].total == .blanca`.
- **Cambio incompatible:** `Coral.partitura(…)`, `AnalisisArmonico.partitura(…)` y `RitmoArmonico.partitura(en:…)`
  piden los cifrados y el análisis con `conCifrados:` y `conAnalisis:`, en lugar de `cifrados:` y `analisis:`, que
  en `Partitura.Linea` son lo que se escribe.

### La línea de comandos: la ayuda de cada orden, la versión, las erratas, la entrada estándar y más JSON

- **`armonia ayuda <orden>`** y **`armonia <orden> --help`** (o `-h`) dan solo la ayuda de esa orden, en el idioma de
  los textos, y los errores de uso de una orden remiten a ella: «Prueba «armonia ayuda digitaciones».».
- **`armonia --version`** (o `version`) dice la versión: `armonia 0.3.4`.
- **Lo que se quiso escribir:** ante una orden o una opción desconocida, la que más se le parece, en los quince
  idiomas: `armonia acordee Do` responde «¿Querías decir «acorde»?», y `armonia digitaciones Sol7 --limte 3`,
  «--limite» (entre las opciones de esa orden).
- **La entrada estándar:** `-` toma sus palabras (`armonia analizar - --en Do mayor < progresion.txt`), y una orden
  sin argumentos las lee si la entrada no es la terminal (`echo "Do Mi Sol" | armonia identificar`).
- **`--json`** también en `arpegio` (con las notas en MIDI y las escalas del acorde), `intervalo`, `tonalidad` (con
  la armadura en números) y `digitaciones` (con el traste de cada cuerda).
- Los errores de lectura empiezan por «armonia:», como los de uso; el aviso de la salida binaria en la terminal sale
  en el idioma de los textos, y una opción de un guion (`-o`) es una opción desconocida en lugar de una nota que no se
  lee. `-m3` y `-P5` siguen siendo intervalos descendentes.
- `tonalidad`, `intervalo`, `conjunto` y `serie` dicen «opción desconocida» ante una opción que no tienen.

### La línea de comandos: escalas que no se encuentran, `grabar midi`, `--archivo -` y más propuestas

- **`armonia escalas`** sin ninguna escala que dar termina con código 1 y lo dice en la salida de errores, en lugar de
  en la salida con código 0. Si lo buscado son notas (`armonia escalas Do Mi Sol La`), recuerda que `escalas` busca
  por el nombre y que por las notas se busca con `armonia identificar --escalas Do Mi Sol La`.
- **`armonia grabar midi …`** (o `musicxml`, `mei`, `lilypond`, `guido`, `abc`) explica que esa orden ya escribe la
  partitura y cómo se graba en PDF, SVG o PNG, en lugar de «se exporta una melodia…».
- **`--archivo -`** lee el fichero de la entrada estándar en `analizar`, `identificar` y las partituras:
  `armonia analizar --archivo - < coral.mid`.
- Los valores de `--idioma`, `--textos` y `--escritura` mal escritos también proponen el más parecido: `--idioma eus`,
  «¿Querías decir «eu»?».

### Las tradiciones, con su nombre y en la línea de comandos

- **`Tradicion.nombre(en:)`**: el nombre de cada tradición en los quince idiomas («Japón», «Japan», «Japonia»,
  «Япония»), y `Tradicion` es `Nombrable` (`Tradicion.mundoArabe.nombre` es «Mundo árabe»).
- **`armonia tradiciones`** (en inglés, `traditions`): cada tradición con cómo se escribe en `--tradicion` y cuántas
  escalas tiene de cada categoría («Japón (japon): escala 13»), también con `--json`. `armonia tradiciones japon`
  es `armonia escalas --tradicion japon`, con `--categoria`.
- `armonia escalas` titula cada grupo con el nombre de la tradición en el idioma de los textos («Mundo árabe ·
  maqam»), en lugar de con lo que se escribe en `--tradicion` («mundo-arabe · maqam»), y una tradición o una categoría
  mal escritas proponen la más parecida.

## 0.3.4 (2026-11-04)

### Valores escritos a mano, sin opcionales

- **Cambio incompatible:** `Polirritmia(_:contra:)`, `Swing(unidad:largo:corto:)`,
  `RejillaDeControlador(columnas:filas:)` y `BaseDeHewlett(base:)` ya no devuelven un opcional: como `Duracion(_:_:)`
  o `Compas(_:_:)`, detienen el programa con un valor imposible (un error de quien llama), y `Polirritmia(3,
  contra: 2)` ya no necesita `!`. Para valores que vienen de fuera, `Polirritmia(comprobando:contra:)`,
  `Swing(comprobando:largo:corto:)`, `RejillaDeControlador(comprobando:filas:)` y `BaseDeHewlett(comprobando:)`
  devuelven `nil`.

### Más lectores que dicen por qué fallan

- **Cambio incompatible:** `Arpegio.grados(leyendo:)`, `Arpegio.tensiones(leyendo:)` y
  `TransformacionNeorriemanniana.secuencia(leyendo:)` lanzan en lugar de devolver `nil`: `ErrorDeLectura`
  (`.textoVacio`) si no hay nada que leer, y `ErrorDeLecturaDeTeoria` en el carácter de lo que no se entiende
  (`.numeroFueraDeRango` para un grado que no va de 1 a 22, y `.nombreNoReconocido` para una tensión o una
  transformación). `Acorde.transformar(leyendo:)` lanza el mismo error, y sigue dando `nil` si el acorde no es una
  tríada mayor o menor.
- **Cambio incompatible:** `NombreDeGrado(_:)`, `PapelEnAcorde(_:)` y `ModoGregoriano(nombre:)` son ahora
  `init(leyendo:)` y lanzan `.nombreNoReconocido` con los nombres que sí se leen.
- **Cambio incompatible:** `Contrapunto(cantusFirmus:contrapunto:especie:)` con alturas y eventos y
  `ContrapuntoAVariasVoces(cantusFirmus:voces:)` con eventos lanzan en lugar de devolver `nil`, como sus versiones
  que leen texto: `.textoVacio` sin cantus (o sin voces) y `.contrapuntoDeOtraDuracion` si una voz no dura una
  redonda por nota del cantus.

### Los lectores que fallan dicen por qué

- **Cambio incompatible:** `Arpegio.Patron(leyendo:)`, `Arpegio.Aproximacion(leyendo:)`,
  `CicloNeorriemanniano(leyendo:)` y `Digitacion(leyendo:en:)` lanzan `ErrorDeLecturaDeTeoria` en lugar de devolver
  `nil`, con el motivo en los quince idiomas: un nombre que no es ninguno de los que se leen da
  `.nombreNoReconocido`, con los que sí; una tablatura con un traste que no se entiende o no está en el mástil,
  `.trasteNoValido`, en su carácter, y una sin un traste por cuerda, `.cuerdasDistintas`. Donde se escribía
  `if let p = Arpegio.Patron(leyendo: texto)`, ahora `if let p = try? Arpegio.Patron(leyendo: texto)`.
- **Cambio incompatible:** `Coral(_:)` y `Coral(voces:)` también lanzan: `.vocesDistintas` si no hay al menos dos
  voces o los acordes no tienen todos las mismas, y `.vocesDeDistintaLongitud` si las voces, dadas voz por voz, no
  tienen todas las mismas notas.

### Tipos con nombre en lugar de tuplas

- **Cambio incompatible:** lo que antes era una tupla es ahora un tipo con nombre, `Hashable` y `Sendable`, con los
  mismos campos, así que `x.campo` sigue igual y solo cambia lo que desestructura (`let (a, b) = …`) o compara:
  - `Tonalidad.armonizarACuatroVoces(_:)` da un `CoralArmonizado` (`armonizacion`, `coral`).
  - `[NotaDeLaMelodia].notasExtranas` da `[NotaExtranaEnLaMelodia]` (`indice`, `nota`).
  - `Partitura.lineas` da `[Partitura.LineaEnPentagrama]` (`linea`, `pentagrama`).
  - `Duracion.figuraYPuntillos` da un `FiguraConPuntillos` (`figura`, `puntillos`).
  - `Polirritmia.ataques(ciclo:)` da `Polirritmia.Ataques` (`primera`, `segunda`).
  - `SerieDodecafonica.formas` da `[SerieDodecafonica.FormaConSerie]` (`forma`, `serie`), y
    `SerieDodecafonica.hexacordos`, `SerieDodecafonica.Hexacordos` (`primero`, `segundo`).
  - `EjeDeInversion.extremos` da los dos puntos en un `[Double]`: `[0.5, 6.5]` para T1I.
  - En `ArmoniaPresentacion`, `PresentacionDeContrapunto.ejemplo(_:)` da un `PresentacionDeContrapunto.Ejemplo`
    (`cantus`, `contrapunto`).
- **Cambio incompatible:** `Polirritmia.voces(compas:compases:alturas:)` es ahora
  `voces(compas:compases:arriba:abajo:)`, con una altura para cada pulsación.

### El ritmo armónico, cada acorde con lo que dura

- **`RitmoArmonico`**: una progresión con lo que dura cada acorde (`AcordeConDuracion`), su compás y su tempo.
  `RitmoArmonico.partitura(en:encabezado:cifrados:analisis:notacion:)` la escribe analizada (en la tonalidad que se
  pida o en la que mejor la explica), y `Voz(arpegiando:patron:…)` la arpegia. `con(duracion:)` da todos los
  acordes con la misma duración, y `transponer(_:)`, el mismo ritmo en otra tonalidad.
- **Cambio incompatible:** `PiezaImportada.acordesConDuracion(ventana:)` es ahora `ritmoArmonico(ventana:)`, que da
  además el compás y el tempo de la pieza, y `acordesConInicio(ventana:)` da `[AcordeConInicio]`.
- **Cambio incompatible:** `AnalisisArmonico.partitura(duraciones:…)` y `Voz(arpegiando:duraciones:…)`
  desaparecen: con los acordes y sus duraciones en dos listas, tenían que comprobar que casaban. Con un
  `RitmoArmonico` no hace falta, y `analisis.partitura(duraciones: d)` es `ritmo.partitura(en: analisis.tonalidad)`.
- En `ArmoniaPresentacion`, `RitmoArmonico` es el de la biblioteca: `ProgresionImportada` lleva solo el ritmo y el
  título, y el análisis y los arpegios siguen el ritmo de la pieza abierta solo si sus acordes son los mismos.

### Cada nota con su desvío

- **`Evento.Nota`**: una nota que suena, con su `altura` y su `desvio` en cents (redondeado a la centésima), que se
  escribe como en un evento: `Mi♭4(50¢)`. `Evento.notas` las da en orden, y `Evento(notas:duracion:…)` hace un evento
  con ellas.
- **Cambio incompatible:** `Evento.desvios`, `Evento.desvio(_:)` y el parámetro `desvios:` de
  `Evento(alturas:duracion:…)` desaparecen: cada desvío va con su nota, y no en una lista aparte que tenía que
  casar con `alturas`. `evento.desvio(1)` es ahora `evento.notas[1].desvio`, y
  `Evento(alturas: ["Do4", "Mi♭4"], duracion: .negra, desvios: [0, 50])`,
  `Evento(notas: [Evento.Nota("Do4"), Evento.Nota("Mi♭4", desvio: 50)], duracion: .negra)`.
  `Evento(alturas:duracion:…)` sigue para las alturas temperadas, y `Evento.alturas`, igual.

### Negras por defecto, y el instrumento MIDI sin paradas

- **Cambio incompatible:** `AnalisisArmonico.partitura(duracion:…)` pone los acordes en negras si no se pide otra
  figura (antes, blancas), como el coral; `armonia musicxml acordes` también.
- En MIDI, un instrumento fuera de los de General MIDI (0…127) se lleva al más cercano en vez de detener el
  programa.

### El pentagrama con ritmo, solo desde la partitura

- **Cambio incompatible:** `Voz.svgPentagrama(titulo:acordes:grados:bajoCifrado:digitos:tablatura:opciones:)`,
  `Voz.svgPentagrama(junto:titulo:acordes:opciones:)`, `Voz.svgSistema(_:titulo:claves:llave:opciones:)` y
  `Coral.svgPentagrama(titulo:figura:compas:opciones:)` dejan de ser públicas: una voz, dos en un pentagrama, un
  sistema y un coral se dibujan con `Partitura.svg(opciones:)`. Los dibujos de escalas, acordes, arpegios y
  disposiciones (`Escala.svgPentagrama`, `Acorde.svgPentagrama`…) siguen como estaban.
- `Partitura.Linea` lleva también `grados`, `bajoCifrado`, `digitos` y `pulsaciones`, y `Partitura.Pentagrama`,
  `cuerdas` (la tablatura de debajo). Por ahora solo cuentan en SVG.
- `Partitura(_:clave:cuerdas:encabezado:)` pone una voz sola en un pentagrama, sin estimar la tonalidad, y
  `Voz.inicios` y `Voz.porInicio(_:)` pasan lo que se tenía por evento a los puntos en que empieza cada uno.
- El coral en SVG sale de `coral.partitura(…)`: con negras si no se pide otra figura (antes, blancas) y con el último
  acorde alargado hasta la barra.

### Una sola partitura para todos los formatos

- **`Partitura`**: los pentagramas, de arriba abajo, con su clave y sus voces (`Partitura.Linea`: la voz, su nombre,
  sus plicas, los cifrados, el análisis y los marcadores de MIDI), el compás, la tonalidad del análisis y si los une
  una llave. Se escribe con `musicXML()`, `mei()`, `lilyPond()`, `guido()`, `abc()`, `midi(afinacion:)`,
  `exportar(como:afinacion:)` y se dibuja con `svg(opciones:)`.
- **`Encabezado`** reúne lo que vale para toda la partitura: título, tonalidad, tempo, parte e instrumento.
- `Voz.partitura(clave:encabezado:)`, `Coral.partitura(duracion:compas:encabezado:cifrados:analisis:notacion:)`,
  `AnalisisArmonico.partitura(duraciones:compas:encabezado:cifrados:analisis:notacion:)` y
  `Contrapunto.partitura(encabezado:)` hacen la de cada uno. Los escritores de los seis formatos leen solo la
  partitura.
- **Cambio incompatible:** las funciones de cada formato en `Voz`, `Coral`, `AnalisisArmonico` y `Contrapunto`
  (`musicXML(…)`, `mei(…)`, `lilyPond(…)`, `guido(…)`, `abc(…)`, `midi(…)` y `exportar(como:…)`) desaparecen: se
  pasa por la partitura. `voz.musicXML(titulo: "Escala", tempo: Tempo(90))` es ahora
  `voz.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90))).musicXML()`, y
  `coral.midi(duracion: .blanca)`, `coral.partitura(duracion: .blanca).midi()`. La línea de comandos, las apps,
  `ArmoniaPresentacion` y `ArmoniaUI` ya la usan.
- La parte y el instrumento del `Encabezado` son opcionales: si no se dan, cada partitura pone los suyos («Voz» y el
  piano; «Coro» y el coro; «Piano»).
- En MIDI, el último acorde de un coral o de una progresión se alarga también hasta la barra, como en los demás
  formatos.

### Microtonos y afinaciones en MIDI

- **Un canal por inflexión**: las notas que suenan a la vez y se apartan distinto de la temperada van cada una a su
  canal MIDI, con el instrumento de su voz, en vez de compartir la inflexión de tono (*pitch bend*) de la primera. Se
  usan los canales que no son de ninguna voz (nunca el 10) y se reutilizan los que ya tienen la inflexión que hace
  falta.
- **`midi(…, afinacion:)`** en `Voz`, `Coral`, `AnalisisArmonico` y `Contrapunto`: el fichero suena en la afinación
  que se pida (`TemperamentoRegular.mesotonicoCuartoDeComa`, `AfinacionHistorica.werckmeisterIII.afinacion()`…),
  cada nota en la tecla temperada más cercana con la inflexión de lo que falte.
- El protocolo **`Afinacion`** pasa de `ArmoniaRepresentaciones` a `ArmoniaNucleo`, para que lo usen los formatos; los
  temperamentos siguen donde estaban. Quien importe solo `ArmoniaRepresentaciones` y nombre `Afinacion` necesita
  también `import ArmoniaNucleo`.
- Al **importar MIDI**, los canales de una misma pista con el mismo programa son una sola parte (en los formatos 1 y
  2); en el formato 0 cada canal sigue siendo una parte.

### Ornamentos, grupos irregulares y sistemas de pentagramas

- **Ornamentos** en `Articulacion`: `trino`, `mordenteSuperior`, `mordenteInferior`, `grupeto` y
  `grupetoInvertido` (`esOrnamento`). Se leen en el texto de un evento («Sol4:2{trino}», también «trill», «prall»,
  «mordent», «turn»), se escriben en MusicXML (`<ornaments>`), MEI (`@ornam`), ABC, LilyPond y GUIDO, y se leen al
  importar MusicXML, MEI y ABC.
- El pentagrama SVG dibuja por fin las **articulaciones** (staccato, staccatissimo, tenuto, acento, marcato) del lado
  de la cabeza, y los ornamentos y el calderón encima, con los glifos de Bravura; con dos voces, los de la de abajo
  van debajo.
- Los **grupos irregulares** llevan su cifra en el dibujo: cinquillos, seisillos, septillos, grupos de nueve, once o
  trece, con la figura que les toca; antes solo el tresillo.
- **`Voz.svgSistema(_:titulo:claves:llave:opciones:)`**: varios pentagramas, uno debajo de otro, alineados y unidos
  por las barras de compás y una llave o un corchete, con una o dos voces en cada uno y en líneas si se pide.
  **`Coral.svgPentagrama(titulo:figura:compas:opciones:)`** pone un coral a cuatro voces en dos pentagramas.

### Opciones del pentagrama agrupadas

- `OpcionesDePentagrama` reúne sus opciones en tres grupos: **`maquetacion`** (clave, pentagramas, cambios de clave,
  marca de octava, disposición del acorde, compases por línea, tamaño y ancho de los caracteres), **`marcas`**
  (nombres, intervalos, semitonos, tónica, notas ajenas y la nota resaltada) y **`colores`**. Las propiedades sueltas
  de antes siguen funcionando y cambian las de su grupo.
- Con dos voces en un pentagrama (`Voz.svgPentagrama(junto:…)`), la cabeza de la de abajo se aparta a la derecha
  cuando suena a una segunda o al unísono de la de arriba, en vez de pisarla.

### Líneas y dos voces en el pentagrama

- **`OpcionesDePentagrama.compasesPorLinea`**: `Voz.svgPentagrama(titulo:…)` parte una voz larga en líneas del mismo
  ancho, una debajo de otra, cada una con su clave y su armadura, la cifra del compás en la primera y la barra final
  en la última. Las notas que pasan de una línea a otra se ligan, y los acordes, grados, dedos, tablatura, microtonos
  y la nota resaltada van en la línea de su evento.
- **`Voz.svgPentagrama(junto:titulo:acordes:opciones:)`**: dos voces en el mismo pentagrama, la primera con las
  plicas hacia arriba y la otra hacia abajo, alineadas por lo que suena a la vez, con los silencios de cada una por
  encima o por debajo. También en líneas.

### Microtonos en el pentagrama con ritmo

- `Voz.svgPentagrama(titulo:…)` dibuja los microtonos de los eventos (`Evento.desvios`) con los glifos de Bravura,
  como ya hacía el pentagrama de una escala, y pone sus cents en el nombre de cada nota: «Mi♭₄ (+50¢)».
- Las secuencias de estudio de una escala microtonal (`Escala.svgPentagrama(secuencia:)`) y la escala tocada en
  unas alturas cualesquiera (`svgPentagrama(tocadaEn:)`) llevan también el signo de cada nota de su sistema: el
  medio bemol de un maqam, el koron de un dastgāh, las comas de un makam…

### Repeticiones, saltos y notas de adorno al importar

- `PiezaImportada` despliega las repeticiones de MusicXML, MEI y ABC, con sus casillas de primera y segunda vez y
  las que se tocan más de dos veces, y los saltos: da capo, dal segno, fine y coda. `notas` las da en el orden en que
  se tocan; antes se leía cada compás una vez.
- **`PiezaImportada.notasDeAdorno`**: las notas de adorno de MusicXML (`<grace>`), MEI (`grace`) y ABC (`{…}`), que
  antes se descartaban. Empiezan donde empieza la nota a la que adornan y no duran.

### Swing y polirritmias

- **`Voz.conSwing(_:)`** y **`Swing`**: cada par de corcheas (o de la figura que se elija) se toca desigual, en la
  proporción que se pida: 2:1 (`ternario`), 3:1 (`conPuntillo`) u otra. Las duraciones salen exactas, con figuras de
  tresillo en 2:1.
- **`Polirritmia`**: dos pulsaciones contra el mismo tramo (3 contra 2, 4 contra 3…), con los ataques de cada una
  (`ataques(ciclo:)`), el ritmo que resulta de oírlas juntas (`resultante(ciclo:)`) y las dos voces que la tocan
  (`voces(compas:compases:alturas:)`).

### Frases, forma y motivos

- **`Voz.frases(minimo:)`**: las frases de una melodía (`Frase`), que acaban antes de un silencio o en una nota más
  larga que sus vecinas y duran al menos un compás.
- **`Voz.forma(minimo:)`**: una letra por frase, la misma para las que se repiten aunque estén transportadas y con
  prima para las variantes: `["A", "A", "B", "A′"]`.
- **`Voz.motivos(minimo:)`**: los motivos que vuelven (`MotivoMelodico`), con dónde aparece cada uno, cuánto está
  transportado y si forma una progresión.

### Contrapunto a tres y cuatro voces

- **`ContrapuntoAVariasVoces`**: un cantus firmus con varias voces, cada una de su especie. Aplica las reglas de dos
  voces de cada una con el cantus, mide el principio y el final desde el bajo, admite la cuarta entre voces altas y
  busca paralelas, unísonos, disonancias y cruces entre todas las voces. Cada falta (`FaltaEntreVoces`) dice qué
  voces la cometen.

### Dinámica y articulaciones

- **`Dinamica`** (de *ppp* a *fff*, *sfz* y *fp*, con su `velocidadMIDI`) y **`Articulacion`** (staccato,
  staccatissimo, tenuto, acento, marcato y calderón). `Evento` las lleva en `dinamica` y `articulaciones`, y se
  escriben al final de su texto entre llaves: `"Do4:4{f,staccato}"`, `"Re4:2~{acento}"`. Las transformaciones de una
  voz las conservan, y una nota partida en varias ligadas las lleva solo en la primera.
- MusicXML, MEI, LilyPond, ABC y GUIDO las escriben. MusicXML, MEI y ABC las leen al importar, en
  `NotaDeLaPieza.dinamica` y `NotaDeLaPieza.articulaciones`.
- En MIDI, cada nota suena con la velocidad de su dinámica (80, *mf*, si no hay ninguna, como antes), el acento y el
  marcato la refuerzan y el staccato y el staccatissimo la acortan.

### Los nombres de las doce clases y las cifras de una serie

- `ConjuntoDeClases.nombresDeLasClases(en:)`: el nombre de cada clase de 0 a 11, escritas todas a la vez para que no
  se repita ninguna letra, como en la matriz de una serie.
- `SerieDodecafonica.cifra(_:)`: una clase como se escribe en una serie, con t y e para 10 y 11.

### Los formatos de partitura como un solo tipo

- **`FormatoDePartitura`** (MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI), con su `extensionDeFichero`, su `nombre` y si
  es texto (`esTexto`). `exportar(como:…)` en `Voz`, `Coral`, `AnalisisArmonico` y `Contrapunto` escribe en el formato
  pedido, con las mismas opciones que la función de cada uno (`musicXML(…)`, `guido(…)`…), y da `Data`: los formatos
  de texto, en UTF-8. Las funciones de cada formato no cambian.
- **`Contrapunto.guido(tonalidad:tempo:titulo:)`**: el contrapunto de especies también en GUIDO, como en los demás
  formatos.

### Más escalas antiguas: harmoniai de Arístides, cromáticas y enarmónicas, géneros y hexacordos

- **Harmoniai de Arístides Quintiliano** (`TipoDeEscala.harmoniaiDeAristides`): la lidia, la doria, la frigia, la
  iastia, la mixolidia y la sintonolidia que da como las de Platón, de cinco a ocho notas, en cuartos de tono.
- **Harmoniai cromáticas y enarmónicas** (`harmoniaiCromaticas`, `harmoniaiEnarmonicas`): las otras seis especies de
  octava de Cleónides en el género cromático (Mi Fa Sol♭ La Si Do Re♭) y las siete en el enarmónico, estas con su
  versión en cuartos de tono. La frigia y la hipofrigia enarmónicas tienen la tónica un cuarto de tono bajo la nota
  escrita, como Sīkāh.
- **Más géneros griegos** (`generosDeDidimoYEratostenes`): el enarmónico de Arquitas (28/27 · 36/35 · 5/4), los
  tres de Dídimo y el cromático y el enarmónico de Eratóstenes, en la categoría `.tetracordo`, con sus razones en
  cents.
- **Hexacordos de Guido de Arezzo** (`TipoDeEscala.hexacordos`, categoría nueva `.hexacordo`, clase `.fragmento`):
  el natural, el duro y el blando, en la tradición `.gregoriano`.
- Todos con sus nombres en los catorce idiomas.

### Afinaciones equidistantes, gamelan en cents y modos gregorianos en el catálogo

- **Gamelan**: el pélog sigue el modelo de nueve partes iguales de la octava y el sléndro el de cinco, y cada escala
  y cada pathet tiene su versión microtonal en cents. Sus notas en doce cambian al semitono más cercano de ese
  modelo desde su tónica: el sléndro y sus tres pathet son ahora Do Re Fa Sol Si♭ (antes Do Re Fa Sol La, Do Re Mi
  Sol La o Do Mi♭ Fa Sol Si♭), pélog nem es Sol La♭ Do Re Mi♭, barang La Si♭ Re Mi Sol♯, y tembung y sunaren tienen
  los intervalos de selisir.
- **África** (`Tradicion.africa`, `TipoDeEscala.africanas`): las afinaciones del amadinda de Buganda (cinco partes
  iguales) y del timbila chopi (siete), en la categoría `.afinacion`, con su versión en cents.
- **Sudeste asiático** (`Tradicion.sudesteAsiatico`, `TipoDeEscala.sudesteAsiaticas`): el piphat tailandés y el
  pinpeat camboyano, en siete partes iguales.
- **Modos gregorianos en el catálogo** (`Tradicion.gregoriano`, categoría `.modoGregoriano`,
  `TipoDeEscala.modosGregorianos`): los ocho, con sus nombres latinos (protus authenticus…) y de alias los
  españoles, «modo gregoriano N» y los griegos de los plagales (hipodórico…). `ModoGregoriano.tipoDeEscala` lleva
  de uno a otro.
- `armonia escalas --tradicion` acepta africa, sudeste-asiatico y gregoriano.

### Ajnas, çeşni y escalas que faltaban

- **Ajnas árabes** (`TipoDeEscala.ajnas`, categoría `.jins`): los nueve fragmentos de los que se hacen los maqamat,
  jins Rāst, Bayātī, Ṣabā, Sīkāh, Ḥijāz, Kurd, Nahāwand, ʿAjam y Nikrīz, con su versión en cuartos de tono los
  que la tienen.
- **Çeşni turcos** (`TipoDeEscala.cesniler`, categoría `.cesni`): los dörtlü y beşli de Çârgâh, Bûselik, Kürdî, Rast,
  Uşşak y Hicaz, en comas los tres últimos. Los dos son de la clase `.fragmento`.
- **Makamlar** Kürdîlihicazkâr, Muhayyer, Ferahfezâ e Isfahan, en comas.
- **Rāgas indostánicos** Bhīmpalāsī, Bihāg, Darbārī Kānaḍa (en su forma recta) y Pūriyā Dhanāśrī.
- Los nombres de las dos categorías en todos los idiomas, y los de las escalas nuevas en ruso y en griego.

### Clases de escala y un catálogo con prioridad

- **`ClaseDeEscala`**: las categorías de otras tradiciones se agrupan en cuatro clases, `.modo` (rāgas, maqamat,
  dromoi…), `.escalaMadre` (mēḷa, thāṭ, grāma, laras), `.fragmento` (tetracordos y géneros griegos) y `.afinacion`
  (las babilónicas). `CategoriaTradicional.clase`, `TipoDeEscala.clase` y `TipoDeEscala.tradicionales(clase:)`.
- **`TipoDeEscala.catalogo`**: todas las escalas en el orden en que tienen prioridad, las occidentales (`todos`) y
  después las de otras tradiciones (`tradicionales`). La búsqueda por nombre, `propio` y `equivalentes` salen de él, en
  lugar de juntar las dos listas cada uno por su cuenta; no cambia ningún resultado.

### Un fichero y una ficha por tradición

- `Escalas/Tradiciones/` tiene un fichero por tradición (`TipoDeEscala+MundoArabe.swift`, `+Turquia`, `+Grecia`,
  `+GreciaAntigua`…) en lugar de `TipoDeEscala+Tradiciones.swift`, que se queda con la lista `tradicionales`.
- Cada uno acaba con la ficha de su tradición (`FichaDeTradicion`, interna): la categoría de cada lista, las versiones
  microtonales de sus escalas (antes, todas en `Microtonos.swift`) y, en la India, el mēḷa de cada janya (antes, una
  tabla por nombre en texto). `categoria`, `tradicion`, `padre`, `microtonal` y `TipoDeEscalaMicrotonal.catalogo`
  salen de las fichas, y una tradición sin ficha no compila. No cambia ninguna API pública; el catálogo microtonal
  cambia de orden (va por tradiciones).

### Ficheros de idioma más cortos

- Los ficheros de `Escalas/Nombres/` ya no listan las escalas de otras tradiciones que no se traducen
  (`.tradicional(.kafi)` sin nombre ni alias): sin fila, una escala ya conservaba su nombre original. Son 2243 filas
  menos en los catorce idiomas y los nombres no cambian. `comprobar_catalogo.py` avisa si vuelve una de esas filas.

### Afinaciones babilónicas

- **Tradición `.mesopotamia`, categoría `.afinacion`** (`TipoDeEscala.mesopotamicas`): las siete afinaciones de
  la lira y el arpa de los textos cuneiformes, išartu, kitmu, embūbu, pītu, nīd qabli, nīš tuḫri (antes nīš
  gabarî) y qablītu, en el orden de UET VII 74. Siguen la reconstrucción de Kilmer con escalas descendentes
  (išartu es la mayor, nīd qabli el frigio); se encuentran también sin diacríticos y con la mimación (išartum).
  Sus nombres y el de la categoría, en los quince idiomas, y `armonia escalas --tradicion mesopotamia`.

### Grāma y mūrchanā, y géneros griegos

- **Los 2 grāma y las 14 mūrchanā del Nāṭyaśāstra** (`TipoDeEscala.gramas`, `.murchanas`; categorías `.grama` y
  `.murchana`): el ṣaḍja-grāma y el madhyama-grāma, y las siete escalas de cada uno, con su versión microtonal en los
  22 śruti (o en cents, las que tienen el Pa de 40/27).
- **Los géneros de Arquitas y de Ptolomeo** (`TipoDeEscala.generosDeArquitasYPtolomeo`): nueve tetracordos en razones
  justas, del cromático de Arquitas al diatónico igual de Ptolomeo, con un sistema microtonal nuevo,
  `SistemaMicrotonal.razones`, en cents (Fa(−37¢)).
- Los nombres y las categorías nuevas, en los quince idiomas.

### La línea de comandos en JSON

- **`--json`**: `armonia acorde`, `identificar`, `escala`, `analizar`, `conjunto` y `serie` dan sus datos en JSON,
  para leerlos desde un script (`armonia acorde Sol7/Si --json | jq '.[0].notas'`). Las claves son siempre las mismas,
  en español y sin tildes; los nombres van en la notación elegida, y al lado, las clases de altura. Los errores siguen
  en texto, en la salida de errores. Con otra orden, `--json` es un error de uso.

### Un README más corto

- El README de la raíz cuenta qué es Tesela y cómo usarlo; lo de cada carpeta, las pruebas, el rendimiento, el
  fuzzing y el CI pasa a `DESARROLLO.md`. Hay también un resumen en inglés, `README.en.md`.

### Más motores para grabar, y cuáles están instalados

- **`armonia grabar --motor musescore|verovio|guido`**: además de LilyPond, MuseScore (a partir del MusicXML de
  `armonia musicxml`), Verovio (del MEI de `armonia mei`) y Guido Engine (del `.gmn` de `armonia guido`, con
  `guido2svg`). Verovio y Guido dan SVG; en PDF o PNG, su SVG pasa después por rsvg-convert. MuseScore se busca
  también como `musescore`, `mscore4portable`… y en la carpeta de la app en macOS; en un Linux sin pantalla se le
  pide que dibuje sin ella (`QT_QPA_PLATFORM=offscreen`).
- **`armonia motores`** (en inglés, `engines`): cada motor, con la ruta de su programa y su versión, o la variable
  (`ARMONIA_MSCORE`, `ARMONIA_VEROVIO`, `ARMONIA_GUIDO2SVG`…) que da su ruta si no se encuentra.
- **`armonia guido`**: la melodía, el coral, los acordes, los arpegios o la escala en GUIDO (`.gmn`), con las mismas
  opciones que `armonia lilypond`.
- **Documentación de `armonia grabar`** en el README, con la tabla de motores, y un job de CI que instala LilyPond
  y rsvg-convert en Linux y graba partituras y dibujos de verdad en PDF, SVG y PNG.

## 0.3.2 (2026-11-03)

### Grabar partituras y dibujos desde la línea de comandos

- **`armonia grabar`** (en inglés, `engrave`): la partitura en PDF, SVG o PNG con LilyPond (`armonia grabar coral
  Do3 Mi4 Sol4 Do5 > coral.pdf`), con las mismas opciones que `armonia lilypond`, o un dibujo de Tesela en PDF o PNG
  con rsvg-convert (`armonia grabar pentagrama escala Re dórico --formato png > dorico.png`). `--motor
  lilypond|propio` elige quién graba y `--formato pdf|svg|png`, el fichero. Los programas se buscan en el `PATH`, o
  en `ARMONIA_LILYPOND` y `ARMONIA_RSVG_CONVERT`.

### Bajo cifrado, cambios de clave y notas ajenas al acorde en el pentagrama

- **`Tonalidad.cifrasDeBajo(de:)`**: las cifras del bajo continuo de un acorde («6», «6 4», «6 5», «4 3», «4 2»),
  con las alteraciones que la armadura no da; `bajoCifrado` las escribe debajo de las disposiciones y las voces.
- **`OpcionesDePentagrama.cambiosDeClave`**: en un solo pentagrama, la clave pasa de fa a sol (y vuelve) según el
  registro, con la clave nueva más pequeña delante de la nota.
- **`marcarNotasAjenas`**: las notas que no son del acorde que suena, en color (`colorDeLasNotasDePaso` las de la
  tonalidad, `colorDeLasCromaticas` las demás).
- **En la línea de comandos**, `armonia pentagrama` con `--bajo-cifrado`, `--octava`, `--clave`, `--doble`,
  `--cambiar-clave` y `--ajenas`, y `armonia pentagrama melodia <notas> --sobre <acordes>` (en inglés,
  `--figured-bass`, `--octave`, `--clef`, `--grand-staff`, `--clef-changes`, `--non-chord` y `staff melody … --over`).

### Exportar a GUIDO

- **`Voz.guido`, `Coral.guido` y `AnalisisArmonico.guido`**: la partitura en GUIDO Music Notation (`.gmn`), la
  entrada de Guido Engine, con lo mismo que LilyPond y ABC: grafía, barras, anacrusa, ligaduras, grupos irregulares
  (`\tuplet`), tempo, cifrados encima (`\harmony`) y análisis debajo (`\text`). Los cuartos de tono se escriben con
  la nota temperada.

### Grados, dedos, secuencias y tablatura en el pentagrama

- **Grados en números romanos** debajo de cada acorde: `grados` en `DisposicionDeAcorde.svgPentagrama(…)` y
  `Voz.svgPentagrama(…)`.
- **Dedos encima de las notas**: `Escala.svgPentagrama(digitacion:)` (los de `digitacionDePiano(_:)`) y `digitos` en
  las voces y las disposiciones.
- **Secuencias con ritmo**: `Escala.svgPentagrama(secuencia:)`, por terceras en corcheas, en grupos de tres en
  tresillos y de cuatro en semicorcheas.
- **Tablatura debajo del pentagrama** (`Tablatura`), alineada nota a nota, y `Escala.svgPentagrama(tocadaEn:)` y
  `Acorde.svgPentagrama(arpegiadoEn:)` para las alturas de una posición del mástil, escritas con las notas de la
  escala o del acorde.
- **En la línea de comandos**, `armonia pentagrama` con `--romanos`, `--mano`, `--dedos`, `--secuencia` y `--tab`
  (con `--instrumento` y `--caged`); en inglés, `--roman`, `--hand`, `--fingers`, `--sequence` y `--instrument`.

### Cifrados, intervalos, semitonos y tónica en el pentagrama

- **Cifrado sobre cada acorde**: `DisposicionDeAcorde.svgPentagrama(_:titulo:cifrados:)`,
  `Voz.svgPentagrama(titulo:acordes:)` (encima de la primera nota de cada arpegio) y
  `Arpegio.svgPentagrama(cifrado:)`.
- **`OpcionesDePentagrama.intervalosDeLasNotas`**: el intervalo de cada nota debajo, desde la tónica de la escala o
  la fundamental del acorde que suena (9, 11 y 13 si tiene séptima).
- **`marcarSemitonos`** (un arco entre las notas a un semitono) y **`marcarTonica`** (la tónica en
  `colorDeLaTonica`).
- **Escalas de varias octavas**: `Escala.svgPentagrama(octavas:)`, `Escala.voz(octavas:)` y
  `alturasMicrotonales(octava:octavas:sentido:)`.
- **En la línea de comandos**, `armonia pentagrama escala|acorde|arpegio|acordes …` (en inglés, `staff
  scale|chord|arpeggio|chords`) con `--octavas`, `--bajando`, `--patron`, `--figura`, `--tresillos`, `--nombres`,
  `--intervalos`, `--semitonos`, `--tonica` y `--en <tonalidad>`.

### Ritmo y armadura en el pentagrama

- **`Voz.svgPentagrama(titulo:opciones:)`**: una voz en el pentagrama en SVG con su ritmo: cabezas negras, blancas
  y redondas, plicas, corchetes, barras de unión por pulso, puntillos, silencios, ligaduras, tresillos (con el 3 y,
  si no van unidos, su corchete), la cifra del compás y las barras de compás, que anulan las alteraciones. Con eso se
  dibuja un arpegio en corcheas, semicorcheas o tresillos, o una progresión arpegiada. `resaltada` cuenta las notas
  que se oyen, como los pasos de lo que suena.
- **`OpcionesDePentagrama.Armadura.tonalidad(_:)`**: la armadura de una tonalidad en cualquier dibujo (acordes,
  arpegios, disposiciones, escalas y voces); las notas solo llevan delante lo que la armadura no da.
- Glifos nuevos de Bravura en `GlifosSMuFL` (cabeza negra, corchetes, silencios, puntillo, cifras del compás y del
  tresillo).

### Acordes en las doce tonalidades y arpegios en el mástil

- **En la línea de comandos**, `armonia escala --doce --acordes` (con `--triadas`, sin séptima) da los acordes de
  cada grado en las doce tonalidades, y `armonia posiciones --arpegio <cifrado>` (con `--caged`, `--barrido` e
  `--ida-y-vuelta`) el arpegio en cada posición del mástil, en tablatura y con los dedos (en inglés, `--chords`,
  `--triads`, `--arpeggio`, `--sweep` y `--up-and-down`).

### Escalas propias

- **Escalas propias**: `Escala.propia(_:)` (por sus notas) y `Escala.propia(desde:pasos:)` (por sus pasos en
  semitonos); `Escala(leyendo:)` lee también «Do Re Mi♭ Fa♯ Sol La Si» y «Do 2-1-3-1-2-2-1». Si no están en el
  catálogo, `TipoDeEscala.propio(_:)` las nombra por su número de Forte y sus pasos. `Escala.pasosEnSemitonos` y
  `numeroDeForte`.
- **Escalas vecinas**: `Escala.vecinas(tipos:)` (`EscalaVecina`), las que salen moviendo una nota un semitono.
- **`Escala.enLasDoceTonalidades`**, de quinta en quinta, cada una con la escritura más sencilla.
- **`RelojDeClases`**: un conjunto de clases en un reloj de doce horas (SVG), cromático o de quintas.
- **Afinaciones abiertas**: `Encordado.guitarraEnReAbierto`, `guitarraEnSolAbierto` y `guitarraDADGAD`.
- **En la línea de comandos**, `armonia escala --vecinas` y `--doce`, `armonia posiciones --instrumento <nombre>` y
  `--capo <traste>`, y la orden nueva `armonia reloj <escala> [--quintas]` (en inglés, `--neighbors`, `--all-keys`,
  `--instrument`, `clock` y `--fifths`).

### Más escalas

- **Buscar escalas** en una pieza: `PiezaImportada.clasesDeAltura(umbral:)` (las notas que suenan, por lo que duran)
  y `PiezaImportada.escalas(umbral:tipos:)`, de más a menos probable, con la tonalidad estimada como desempate.
- **Escalas simétricas**: `Escala.intervaloDeSimetria`, `transposicionesDistintas`, `tonicasEquivalentes` y
  `ciclosSimetricos` (`CicloSimetrico`: Do7 Mi♭7 Fa♯7 La7 en la disminuida semitono-tono).
- **Líneas de notas guía**: `Acorde.lineaDeNotasGuia(_:desde:octava:)` (`InicioDeNotasGuia`), una nota por acorde,
  la más cercana a la anterior.
- **En el mástil**: `EscalaEnElMastil.recorrido`, `secuencia(_:sentido:)` (la secuencia sin salir de la posición) y
  `notasComunes(con:)`; `Mastil.formasPentatonicas(de:)`, las cinco formas desde la tónica.
- **`TecladoDePiano`**: un teclado en SVG con las teclas marcadas (los dedos o los nombres) y la tónica resaltada.
- **En la línea de comandos**, `armonia identificar --escalas` y `--archivo <fichero>`, `armonia escala --simetria`,
  `armonia analizar --notas-guia`, `armonia posiciones --secuencia <tipo>` (con `--bajando`) y `--formas`, y la orden
  nueva `armonia teclado <escala> [--mano derecha] [--octavas 2]` (en inglés, `--scales`, `--file`, `--symmetry`,
  `--guide-tones`, `--sequence`, `--descending`, `--shapes`, `keyboard` y `--hand`).

### Teclados de cuadrícula

- **Más teclados de cuadrícula**: `TecladoCuadrado.tercerasMenores`, `tritonos`, `octavas` y `secuencial`;
  `conEjes(_:)` lee unos ejes escritos «H,V», `conOrigen(_:)` cambia la nota de la casilla de origen y `enTono(_:)`
  deja solo las notas de una escala, como el modo In Key del Push (`grados`, `esCromatico`). `svg` dibuja el contorno de
  las notas marcadas y la primera con borde naranja (`primeras:`, `contorno:`). **`RejillaDeControlador`**: las
  casillas de un Launchpad o un Push (8 × 8), un LinnStrument (16 × 8 y 25 × 8) o la ventana de 12 × 7.
- **En la línea de comandos**, `armonia cuadricula` (`grid`) dibuja un teclado de cuadrícula con `--ejes H,V`,
  `--rejilla 8x8`, `--origen <altura>`, `--giro 0-3`, `--espejo` y `--en-tono` (en inglés, `--axes`, `--grid`,
  `--origin`, `--rotate`, `--mirror` y `--in-key`).
- **`TecladoCuadrado`** y **`CasillaCuadrada`**: teclados isomórficos de botones cuadrados, definidos por sus ejes H
  (los semitonos de un paso a la derecha) y V (los de un paso hacia arriba). Trae `cuartas` (LinnStrument, Launchpad,
  Push), `tercerasMayores`, `quintas`, `wickiHaydenCuadrado`, `tonosEnteros` y `tonnetzDeEuler`, con `girado()`,
  `reflejado`, `esCompleto`, `casillas(de:en:)` y su dibujo en SVG. Los nombres, en los quince idiomas.

### Estudiar escalas

- **`Escala.secuencia(_:octava:octavas:sentido:)`** con **`SecuenciaDeEscala`**: la escala por terceras, por cuartas,
  en grupos de tres o de cuatro, en tríadas o en cuatriadas, subiendo o bajando (la menor melódica baja natural).
- **`Escala.modosParalelos`** (los siete modos de la mayor sobre la misma tónica, del lidio al locrio),
  **`modosRelativos`** y **`brillo`** (cuántas notas sube o baja cada modo respecto al mayor).
- **`Escala.comparar(con:)`** da una **`ComparacionDeEscalas`**: notas comunes, las que solo están en una, los grados
  que cambian (`CambioDeGrado`) y la distancia en el círculo de quintas. `Escala.cambios(desde:)` sirve
  para seguir una progresión.
- **`Acorde.escalasBebop`** (`EscalaBebop`, con su nota de paso y el recorrido bajando con las notas del acorde en
  los tiempos fuertes) y **`Acorde.pentatonicas`** (`PentatonicaSobreElAcorde`: las mayores y menores sin notas a
  evitar, con las tensiones que suman). `TipoDeEscala.bebop` y `modosPorBrillo`.
- **`Escala.digitacionDePiano(_:octava:octavas:)`** (`DigitacionDePiano`, `Mano`): los dedos de cada mano, sin
  pulgar en las teclas negras.
- **En la línea de comandos**, `armonia escala` acepta `--secuencia <tipo>`, `--bajando`, `--octavas`, `--piano`,
  `--modos` y `--comparar <escala>` (en inglés, `--sequence`, `--descending`, `--octaves`, `--modes` y `--compare`);
  `armonia acorde`, `--bebop` y `--pentatonicas`; y `armonia analizar --escalas` añade las notas que cambian de una
  escala a la siguiente y las notas guía.

### Más acordes

- **`DisposicionDeAcorde.sinFundamentalA`, `sinFundamentalB` y `dosManos`**: las disposiciones sin fundamental de
  piano (la A, de la tercera a la novena; la B, de la séptima a la quinta, con la 13 en lugar de la 5 en los acordes
  de dominante) y a dos manos (fundamental y séptima en la izquierda; tercera, quinta y novena en la derecha).
- **`Mastil.gruposDeCuerdas(para:)` y `disposiciones(de:_:cuerdas:abertura:)`**: cada disposición tocada en un grupo
  de cuerdas (el drop 2 en las cuerdas 4-3-2-1, el drop 3 saltando la que sigue al bajo), con
  `Digitacion.dedosSugeridos`.
- **`Acorde.otrosNombres`** (Do6 = Lam7/Do; Si°7 = Re°7 = Fa°7 = La♭°7) y **`sinFundamental`** (Sol7(♭9) sin el Sol
  es Si°7).
- **`Acorde.tonalidades`**: las tonalidades mayores y menores en que el acorde es diatónico, con su grado y su
  función.
- **`Acorde.comparar(con:disposicion:)`** da una **`ComparacionDeAcordes`**: las notas comunes y la conducción de
  las voces de menor movimiento.
- **`Acorde.sustituciones(en:)`**: las rearmonizaciones del acorde suelto y, si es de dominante, su ii relativo y el
  disminuido sobre su tercera (`Rearmonizacion.Recurso.iiRelativo` y `.disminuido`, en los quince idiomas), con
  `esDeDominante` y `tonalidadPropia`.
- **En la línea de comandos**, `armonia acorde` acepta `--disposiciones`, `--nombres`, `--tonalidades`,
  `--sustituciones` (con `--en <tonalidad>`) y `--comparar <acorde>` (en inglés, `--voicings`, `--names`, `--keys`,
  `--substitutions`, `--in` y `--compare`).

### Más arpegios

- **`Arpegio(_:grados:octavas:aproximacion:)`**: un recorrido propio por grados sobre la fundamental («1 5 3 8» es
  Do–Sol–Mi–Do en Do; 9, 11 y 13 son tensiones). `Arpegio.grados(leyendo:)` lo lee de un texto.
- **`Arpegio(…inicio:)`** empieza por otra nota del acorde (Mi–Sol–Do–Mi en Do); `Arpegio.indice(de:en:)` e
  `indice(delGrado:en:)` la buscan por su nombre o por su grado.
- **`Arpegio(…tensiones:)`** suma la 9, la 11 y la 13 por encima del acorde, de su escala (`nota(delGrado:)`: en Do7,
  la del lidio dominante); `Arpegio.tensiones(leyendo:)` las lee.
- **`Arpegio.Aproximacion`**: notas cromáticas que llevan a cada nota del arpegio, desde abajo, desde arriba o en
  encierro (Fa–Re♯–Mi), con nombre en los quince idiomas y `Aproximacion(leyendo:)`.
- **`Voz(arpegiando:…tensiones:aproximacion:enlazados:)`**: con `enlazados`, cada arpegio de la progresión empieza
  por la nota de su acorde más cercana a la última del anterior (en Do–Fa, el Fa empieza por Do).
- **En el mástil**: `Mastil.arpegiosCAGED(de:ancho:)` (las cinco formas, con `ArpegioEnElMastil.forma`),
  `arpegiosDeUnaNotaPorCuerda(de:alcance:)` (para barrido) y `ArpegioEnElMastil.dedos`, el dedo sugerido para cada
  nota.
- **En la línea de comandos**, `armonia arpegio` acepta `--octavas`, `--sin-octava`, `--desde Mi` (o `--desde 3`),
  `--tensiones 9,13`, `--grados 1-5-3-8` y `--aproximacion abajo|arriba|encierro` (en inglés, `--octaves`,
  `--no-octave`, `--from`, `--tensions`, `--degrees` y `--approach`), y `musicxml arpegios` acepta `--enlazar`
  (`--connect`). La ayuda nombra todos los patrones, también «quebrado» y «baja y sube», y el autocompletado los
  propone.

### Teoría postonal en la línea de comandos

- **`armonia conjunto`** (`set`): un conjunto escrito como lo lee `ConjuntoDeClases(leyendo:)` («0 4 7», «047»,
  «Do Mi Sol», «4-Z15»), con sus notas, su forma normal y su forma prima, su número de Forte, el vector interválico,
  el vector de índice y los ejes de simetría.
- **`armonia serie`** (`row`): una serie dodecafónica con sus notas, sus intervalos, sus hexacordos, sus formas
  combinatorias, cuántas formas distintas tiene y la matriz, con P y R a los lados e I y RI arriba y abajo.
- **`--clases`** de `tonnetz` y `tabla` lee igual que `armonia conjunto`: «047», «01t», «Do Mi Sol» o «3-11». Como
  en las cifras seguidas cada cifra es una clase, «--clases 13» es {1, 3} y ya no un error.

### Series dodecafónicas

- **`SerieDodecafonica`**: las doce clases de altura en su orden. Sus 48 formas (`FormaDeSerie`: P, I, R y RI, con
  el índice de la clase con que empieza la P o la I, como en Straus) con `forma(_:)`, `original(_:)`,
  `inversion(_:)`, `retrogrado(_:)` y `retrogradoDeLaInversion(_:)`; `identificar(_:)` dice qué formas son otra
  serie y `numeroDeFormasDistintas`, si es simétrica. La `matriz` de 12 × 12, los `intervalos` y
  `esDeTodosLosIntervalos`, los `hexacordos` y la combinatoriedad hexacordal (`formasCombinatorias`,
  `tiposDeCombinatoriedad`, `esTotalmenteCombinatoria`). Se lee como un conjunto (`init(leyendo:)`) y se guarda en
  JSON como la lista de sus clases.

### Simetrías y notas comunes de un conjunto

- **`ConjuntoDeClases.vectorDeIndice`** (las notas comunes de cada TnI) y **`vectorDeTransposicion`** (las de cada
  Tn), con `notasComunes(transponiendo:)` y `notasComunes(invirtiendo:)`.
- **`ejesDeSimetria`**: el `EjeDeInversion` de cada TnI que deja el conjunto igual, con los puntos por donde pasa
  («5–11», «0½–6½») y las clases que deja fijas; y `transposicionesQueLoDejanIgual`.

### Ortografía de un conjunto

- **`ConjuntoDeClases.notas(con:)`** escribe cada clase con la nota más sencilla, buscando el tramo más corto de la
  línea de quintas: {1, 5, 8} es Re♭–Fa–La♭, y con Do♯ fijo, Do♯–Mi♯–Sol♯. Lo que cabe en una escala diatónica
  sale sin repetir letra.

### Conjuntos escritos a mano

- **`ConjuntoDeClases(leyendo:)`** lee «[0, 4, 7]», «{0 4 7}», «047», «01t» (con `t` y `e` para el 10 y el 11),
  «Do Mi Sol» o «C E G», y el número de Forte («3-11», «4-Z15»), que da la forma prima. `ErrorDeLectura` tiene
  cuatro motivos nuevos, en los quince idiomas: `claseDeAlturaNoValida`, `numeroDeForteDesconocido`,
  `faltaElCierre` y `serieNoDodecafonica(faltan:repetidas:)`.

### Planificar modulaciones

- **`Tonalidad.modulaciones(hasta:)`** escribe progresiones que modulan a otra tonalidad (`PlanDeModulacion`): por
  acorde común (Do → Sol por Lam, vi = ii), por séptima disminuida enarmónica (Do → La♭: Do♯°7, vii°7/ii, escrito
  Sol°7, vii°7 en La♭) o directa (ii–V7–I de la nueva). Cada plan lleva su progresión completa y su acorde pivote
  leído en las dos tonalidades.

### Cifrado romano

- **`Tonalidad.acorde(romano:)`** y **`Tonalidad.acordes(romanos:)`** leen cifrados romanos, el camino inverso
  de `analizar(_:)`: inversiones («ii65», «V43»), grados alterados y prestados («♭VI», «♭VII»), dominantes y
  sensibles secundarias («V7/V», «vii°7/ii», también encadenadas: «V/V/V»), sustituto tritonal («subV7/ii»),
  napolitana («N6», «♭II6») y sextas aumentadas («It+6», «Fr+6», «Ger+6»).

### Armonía negativa, disposición por cuartas y armonía modal

- **Armonía negativa**: `Tonalidad.negativa(_:)` refleja una nota sobre el eje entre la tónica y la dominante (Mi ↔
  Mi♭, Si ↔ La♭ en Do), y `Tonalidad.negativo(_:)` y `negativos(_:)` hacen lo mismo con un acorde y con una
  progresión (Do → Dom, Fa → Solm, Sol7 → Reø7).
- **`DisposicionDeAcorde.cuartal`**: cuatro notas por cuartas de la escala del acorde, con sus notas guía y sin notas
  a evitar (Rem7 → Re Sol Do Fa, Sol7 → Fa Si Mi La).
- **Armonía modal**: `Escala.modoDeLaMayor`, `Escala.notaCaracteristica` (la 6.ª mayor del dórico, la 4.ª aumentada
  del lidio…), `Escala.acordesCaracteristicos` (las tríadas que la llevan) y `Escala.cadenciaModal` (IV–i en
  dórico, ♭II–i en frigio, ♭VII–I en mixolidio…).

### Esquemas armónicos: jazz y secuencias

- **`EsquemaArmonico.buscar(en:)`** reconoce en una progresión, en cualquier tonalidad, el ii–V–I (y el ii–V sin
  resolver), el turnaround, el backdoor y el blues de 12 compases, y las secuencias y esquemas del barroco y el
  galante: quintas descendentes, romanesca, canon de Pachelbel, monte, fonte y ponte. Cada uno dice dónde está y a
  qué tónica va, y `EsquemaArmonico.Tipo.acordes(en:)` lo escribe en una tonalidad. Nombres en los quince idiomas.
- **`Rearmonizacion.Recurso.iiV`** (preparar un acorde con su ii–V: Rem → Mim7 La7 Rem) y
  **`Rearmonizacion.Recurso.backdoor`** (el V7 de una tonalidad mayor por iv7–♭VII7).

### Análisis armónico ampliado

- **Sustituto tritonal** (`AcordeAnalizado.Categoria.sustitutoTritonal(de:)`): una séptima de dominante medio tono
  por encima de su destino, cuando resuelve en él, se cifra «subV7» (o «subV7/ii»), con función de dominante y la
  escala lidia dominante. La♭7–Sol sigue siendo la sexta aumentada alemana.
- **I64 cadencial** (`AcordeAnalizado.Categoria.cuartaYSextaCadencial`): la tónica en segunda inversión que va a la
  dominante sobre el mismo bajo sigue cifrándose «I64», pero tiene función de dominante.
- **Semicadencia frigia** (`Cadencia.esFrigia`, del iv6 al V) y **plagal menor** (`Cadencia.esPlagalMenor`, del iv
  prestado al I mayor). `Cadencia.nombre(en:)` y `description` las nombran así en los quince idiomas.

### Bajo cifrado

- **`Tonalidad.acorde(sobre:cifras:)`** lee las cifras del bajo continuo sobre una nota del bajo, contando los
  intervalos en la armadura (abreviaturas «6», «64», «7», «65», «43», «42», «4», «9»; alteraciones delante o detrás
  de una cifra, o solas para la tercera).
- **`Tonalidad.acordes(bajoCifrado:)`** lee una línea («La Fa:6 Mi:# La») y
  **`Coral.realizar(bajoCifrado:en:soprano:)`** la realiza a cuatro voces.

### Notas extrañas a la armonía

- **`NotaDeLaMelodia.analizar(_:sobre:partesFuertes:)`** mira cada nota de una melodía con el acorde que suena con
  ella y, si no es del acorde, dice qué nota extraña es (`NotaExtrana`) por cómo se llega a ella y cómo se sale: de
  paso, bordadura, apoyatura, retardo, anticipación, escapada, pedal o libre. Los retardos llevan sus cifras sobre
  el bajo (`cifrasDelRetardo`: «4-3», «7-6», «9-8») y, si se dan las partes fuertes, cada nota dice si está
  acentuada. Los nombres, en los quince idiomas («nota de paso», «passing tone», «Durchgangston»).

### Escalas compatibles y acordes de una escala

- **`Acorde.escalasCompatibles(entre:)`** busca por defecto entre las escalas de jazz (`TipoDeEscala.deJazz`: los
  modos de la mayor, de la menor melódica y de la menor armónica, las disminuidas, la de tonos enteros, las bebop,
  las pentatónicas y la de blues), no en todo el catálogo, y las ordena de las que tienen menos notas a evitar a
  las que más, no por su número de notas: Do7(♯11) da primero Do lidio dominante.
- **`Escala.acordesQueCaben(grado:)`** y `Escala.acordesQueCaben`: los acordes de `TipoDeAcorde.paraEscalas` que
  caben sobre cada grado (sus, sextas, 6/9, add9, dominantes alteradas…), no solo los de terceras.
- **`Escala.estructurasSuperiores(sobre:)`**: las tríadas de la escala con tensiones y sin notas a evitar que se
  tocan sobre un acorde (Re sobre Do7M en lidio).
- `armonia escala --acordes` escribe los acordes que caben en cada grado, y `armonia analizar --escalas`, las
  estructuras superiores de cada acorde.

### Escalas sobre un acorde

- **`Escala.notas(sobre:)`**: cada nota de una escala sobre un acorde, con su papel (`PapelEnLaEscala`: nota del
  acorde, tensión disponible o nota a evitar) y su grado como en los cifrados de jazz (`NotaSobreElAcorde.cifra`:
  «9», «♯11», «♭13»). `Escala.tensiones(sobre:)` y `Escala.notasAEvitar(sobre:)` dan solo unas u otras, y
  `Escala.contiene(acorde:)`, si la escala tiene todas las notas de un acorde.
- **La escala de cada acorde en su tonalidad**: `Tonalidad.escalaDelAcorde(_:)` y `AnalisisArmonico.escalas` la eligen
  por lo que hace el acorde en el análisis (diatónico, dominante o sensible secundaria, napolitana, sexta
  aumentada, préstamo o cromático): Re dórico para Rem7 en Do, La frigio dominante para V7/ii, Si♭ lidio dominante
  para ♭VII7. Si no cabe, la de `TipoDeEscala.paraAcordes` que saca menos notas de la tonalidad.
- **`Escala.escalaMadre`**: de qué escala es modo cada una (`ModoDeEscala`), entre la mayor, la menor melódica, la
  menor armónica y la mayor armónica (`TipoDeEscala.familiasDeModos`): Do alterada, modo 7 de Re♭ menor melódica.
  Se nombra en los quince idiomas («modo 2 de Do mayor», «mode 2 of C major»).
- **`armonia analizar --escalas`** escribe debajo de cada acorde su escala, sus tensiones y sus notas a evitar, y
  `armonia escala` dice de qué escala es modo.

### Disposiciones de piano y jazz

- **`DisposicionDeAcorde`**: cerrada, drop 2, drop 3, drop 2 y 4, la shell (fundamental, tercera y séptima) y las
  notas guía. `Acorde.disposiciones(_:en:)` da todas las de un acorde en un ámbito, y
  `DisposicionDeAcorde.conducir(_:en:)`, una por acorde de una progresión con el menor movimiento de las voces.
  `Acorde.notasParaDisponer` elige las cuatro notas de un acorde extenso (tercera, séptima y tensiones) y
  `Acorde.notasGuia`, la tercera y la séptima. `DisposicionDeAcorde.svgPentagrama(_:titulo:opciones:)` las dibuja,
  una por columna.

### Contrapunto

- **El contrapunto se exporta.** `Contrapunto` escribe sus dos voces en MusicXML, MEI, LilyPond y ABC
  (`musicXML(tonalidad:tempo:titulo:)`, `mei`, `lilyPond`, `abc`), cada una en su pentagrama con la clave que le
  va mejor, y en MIDI (`midi(tonalidad:tempo:titulo:instrumento:)`), con una pista por voz. `vozDelCantus` da el
  cantus firmus como `Voz`, en redondas.

### ArmoniaFormatos

- Los formatos de fichero salen de `ArmoniaPartitura` a un módulo propio, **`ArmoniaFormatos`** (con su producto):
  la exportación a MusicXML, MEI, LilyPond, ABC y MIDI, la importación (`PiezaImportada`, `ErrorDeImportacion`) y
  el lector de XML. `ArmoniaPartitura` se queda con el modelo, el pentagrama en SVG y el contrapunto. Con
  `import Armonia` no cambia nada; quien importe solo `ArmoniaPartitura` y use los formatos tiene que añadir
  `import ArmoniaFormatos` (y el producto `ArmoniaFormatos` en su `Package.swift`).

### Errores por capa

Cambia la API pública de los errores: quien haga `catch let error as ErrorDeLectura` o un `switch` sobre su
`motivo` tiene que adaptarse.

- **`ErrorDeArmonia`**, el protocolo común de los errores del motor, con `descripcion(en:)`, `description` y
  `errorDescription`. Lo cumplen los tres errores de lectura, `ErrorDeImportacion` y `ErrorDeUIL`, así que para
  mostrar cualquiera basta `catch let error as any ErrorDeArmonia`.
- **Un error de lectura por capa.** `ErrorDeLectura` (Núcleo) se queda con las notas, las alturas, los intervalos y
  lo general (`textoVacio`, `caracteresSobrantes`). Los motivos de los cifrados, las escalas, las tonalidades y los
  corales pasan a `ErrorDeLecturaDeTeoria.Motivo`, con `CalidadesIncompatibles` y `RechazoDeAcorde`; los de las
  duraciones, los compases y el contrapunto, a `ErrorDeLecturaDePartitura.Motivo`. Los tres cumplen `ErrorAlLeer`
  (texto, posición, motivo, `explicacion(en:)` y `situado(en:posicion:)`), y sus motivos, `MotivoDeLectura`.
  `Acorde(leyendo:)` lanza `ErrorDeLectura` si falla la fundamental y `ErrorDeLecturaDeTeoria` si falla el
  cifrado; `Voz(leyendo:)`, `ErrorDeLectura` si falla una nota y `ErrorDeLecturaDePartitura` si falla una
  duración.
- Los textos de esos motivos pasan de `TextosDeNucleo` a `TextosDeTeoria` y `TextosDePartitura`: el Núcleo ya no
  sabe nada de acordes, escalas ni partituras.
- `ErrorDeUIL` se lee en los quince idiomas (`descripcion(en:)`); antes solo tenía su `description` en español.
- La CLI y `Notacion.mensaje(de:)` de las apps tratan todos los errores con un solo `catch`, y muestran los de UIL
  en el idioma elegido.

### Eliminado

- Los dos nombres que la 0.3.1 dejó marcados como obsoletos, y con ellos `ArmoniaNucleo/Obsoletos.swift`:
  `Tipografia.compacta` (ahora `.conDobles`) y `Alteracion.simboloCompacto` (ahora `simboloConDobles`).
- `armonia`: las quince constantes públicas con la ayuda de cada idioma en `LineaDeComandos` (`ayuda`, `help`,
  `ajuda`, `axuda`, `laguntza`, `ajudaEmPortugues`, `aide`, `aiuto`, `hilfe`, `ajudaEnOccitan`, `spravka`, `sugo`,
  `voitheia`, `aduya` y `ayudaEnAsturianu`). La de cualquier idioma es `LineaDeComandos.ayuda(en:)`:
  `ayuda(en: .delIdioma(.catalan))` es la de `armonia ayuda --idioma ca`.

## 0.3.1 (2026-11-02)

- **Veintiocho escalas tradicionales más** (el catálogo microtonal pasa de 68 a 74):
  - Grecia antigua: las harmoniai que faltaban (mixolidia, hipolidia, hipofrigia e hipodoria), que con la doria,
    la frigia y la lidia son las siete especies de octava (`TipoDeEscala.harmoniai`), y el tetracordo
    enarmónico, Mi Fa♭ Fa La en doce notas y Mi Fa𝄳 Fa La en cuartos de tono. `Intervalo.segundaDisminuida`,
    para escribirlo.
  - Makamlar: Mâhur, Acemaşiran, Sultânîyegâh, Şedaraban, Hümâyun, Uzzâl y Zirgüleli Hicaz, los cinco últimos
    con su versión en comas de Arel-Ezgi-Uzdilek.
  - Maqamat sin cuartos de tono: Āthār Kurd, maqām Nikrīz, Lāmī y Ṣabā Zamzam.
  - Indonesia: los pathet de Java (pélog lima, nem y barang; sléndro nem, sanga y manyura) y los modos tembung
    y sunaren de Bali, en la categoría nueva `CategoriaTradicional.pathet` (`TipoDeEscala.pathets`).
  - Rāgas que suben y bajan en línea recta: los janya Mohanakalyāṇi, Sāveri y Nāṭa (con su mēḷa padre) y el
    indostánico Lalit.
- La escala de sexta disminuida de Barry Harris se encuentra por su nombre: «sexta disminuida» es el bebop
  mayor y «sexta menor disminuida», el bebop menor melódica (en inglés, «major/minor sixth diminished»).
- **`PiezaImportada` lee MEI y ABC**, además de MIDI y MusicXML: `init(mei:)`, `init(abc:)`, y `init(leyendo:)`
  los reconoce solos. De MEI: partes y capas, armadura, compás, tempo, tresillos, ligaduras, notas de adorno
  (que no cuentan), `accid.ges` y los microtonos (cuartos de tono, koron y sori, comas turcas). De ABC, como lo
  escriben los cancioneros: cabecera (T, M, L, Q, K con sus modos, V), alteraciones que duran el compás,
  ligaduras, tresillos `(3`, ritmo con puntillo `>`/`<`, acordes `[CEG]`, campos dentro de la música `[K:D]`,
  silencios de varios compases y cuartos de tono `^/`. Lee la primera canción del fichero. Lo que exportan
  `mei()` y `abc()` vuelve igual (por ABC, las comas, temperadas).
- **Lector de XML propio** en lugar de `XMLParser`: MusicXML y MEI ya no necesitan FoundationXML (ni libxml2 en
  Linux). Admite UTF-8, UTF-16 y las codificaciones de un byte (Latin-1, windows-1252), y da la línea del error.
  `ErrorDeImportacion.xmlDanado` dice ahora «El fichero XML está dañado» y `formatoDesconocido` nombra los cuatro
  formatos.
- **Tutorial interactivo de DocC**, «De una nota a un análisis armónico», en tres partes: notas, alturas e
  intervalos; acordes y escalas, y el análisis de una progresión, de la tonalidad a las cadencias y desde un
  fichero MIDI hasta MusicXML. El código de cada paso se prueba como los ejemplos de los artículos.
- **Fuzzing de los lectores** (`Herramientas/FuzzArmonia`): libFuzzer con AddressSanitizer sobre MIDI, MusicXML,
  MXL, MEI, ABC, UIL y los textos de cifrados, notas, escalas, corales y voces, diez minutos cada domingo en el CI.
- `PiezaImportada.acordes()` identifica una sola vez el acorde de las ventanas que suenan igual. Un fichero con
  las doce notas sostenidas durante horas tardaba más de un minuto en leer sus acordes, y ahora una fracción de
  segundo (lo encontró el fuzzing en su primer minuto).
- **Los microtonos también se leen**: `NotaDeLaPieza.desvio`, los cents que una nota importada se aparta de su
  altura. En MusicXML, un `<alter>` con decimales ya no se redondea: `-0.5` sobre E es Mi♭ y 50 cents (antes, Mi♭
  sin más). En MIDI, cada nota se lleva la inflexión de tono (pitch bend) de su canal, en el ámbito que fije el
  RPN 0. Las escalas microtonales salen y vuelven igual por los dos formatos.
- Los binarios de `armonia` para Linux se compilan sin información de depuración ni símbolos, y el workflow de la
  versión crea la etiqueta si se lanza a mano y pone las notas del CHANGELOG a una release creada sin ellas.
- **Echoi bizantinos y śruti indios**, dos sistemas microtonales nuevos (el catálogo microtonal pasa de 49 a 68):
  - `SistemaMicrotonal.moria72`, los 72 moria de la Comisión Patriarcal (1881), y nueve escalas nuevas de la
    tradición `.bizancio`, categoría `.echos` (`TipoDeEscala.echoi`): los ocho echoi y el légetos. Todos menos el
    trítos, que ya es la mayor, tienen versión microtonal (Re Mi⁻² Fa Sol La Si⁻² Do).
  - `SistemaMicrotonal.sruti`, los 22 śruti con sus razones justas (`razonesDeLosSruti`), y la versión
    microtonal de los diez thāṭ y de Yaman: el ṣaḍja-grāma de Arnold, con el re y el dha pitagóricos de Bhairav,
    Bhairavī y Toḍī (Do Re↓ Mi↓ Fa Sol La↓ Si↓ en Bilāval).
  - En el pentagrama, los moria llevan los signos de Wyschnegradsky y los śruti la flecha de Helmholtz-Ellis
    (catorce glifos más de Bravura); en MusicXML, los moria también.
- **Dieciséis escalas tradicionales más**, todas con su versión microtonal (de treinta y tres a cuarenta y nueve):
  - Makamlar: Hüzzam, Saba, Karcığar, Suzinak, Nikriz y Nev'eser, en comas de Arel-Ezgi-Uzdilek.
  - Dastgāh y āvāz persas, con el *koron*: Segāh (sobre Mi, con la tónica en un *koron*), Navā, Bayāt-e Tork,
    Afšāri, Dašti, Abu ʿAtā y Bayāt-e Esfahān.
  - Maqamat en cuartos de tono: Rāḥat al-Arwāḥ (sobre Si𝄳), Bayātī Shūrī y Jiharkāh.
- **Más escalas con microtonos**, de nueve a treinta y tres:
  - Maqamat nuevos en cuartos de tono: Ḥusaynī y Nayrūz, y Sīkāh, maqām Huzām e ʿIrāq, con la tónica en un cuarto
    de tono (se escriben sobre Mi y Si; su primer paso microtonal es −1).
  - Makamlar nuevos con su segâh (Si una koma bajo): Uşşak, Hüseynî y Segâh makamı, que empieza en la segâh.
  - Versión microtonal de Hicazkâr makamı y de los quince dromoi: Ousák y Sabáh, en cuartos de tono, con la
    segunda neutra de Bayātī y de Ṣabā; los demás, en comas de Arel-Ezgi-Uzdilek, con las notas del makam que tiene
    las suyas (Hitzáz como Hicaz, Tabahaniótikos como Suzinak, Niavént como Nev'eser, Kartzigár como Karcığar…) o,
    los que solo existen en Grecia (Pireótikos, Tsingánikos, Houzám, Sengáh), con los mismos tetracordos.
  - `TipoDeEscalaMicrotonal.pasos` cuenta desde la tónica temperada, y la tónica puede ser un microtono.
- **Notaciones con palabras**: `Notacion.espanol`, `.ingles`, `.catalan`… pasan a llamarse `.espanolPalabras`,
  `.inglesPalabras`, `.catalanPalabras`… en los quince idiomas, como `.espanolASCII` y `.espanolCompacto`; igual en
  `EscrituraDeNotas`. Los nombres de antes desaparecen sin pasar por obsoletos. Los casos de `Idioma`
  (`.espanol`, `.catalan`…) no cambian.
- `Tipografia.unicode` pasa a llamarse `.conSimples` (un signo por semitono: Fa♯, Si♭♭), junto a `.conDobles`;
  también sin obsoleto. El `rawValue` es ahora «conSimples».
- **Categorías indias en IAST**: `CategoriaTradicional.nombre` y sus traducciones de alfabeto latino escriben
  thāṭ, mēḷa y rāga (Thāṭ, Mēḷa y Rāga en alemán y húngaro), como dastgāh; igual la ayuda de
  `armonia escalas` y la documentación. Los casos (`.thaat`, `.melakarta`, `.raga`) no cambian, y
  `--categoria thaat`, `that` o `thāṭ` (y `melakarta`, `mela` o `mēḷa`) siguen encontrando la misma categoría.
- **Las compactas escriben las dobles con 𝄪 y 𝄫**: `.espanolCompacto`, `.inglesCompacto`, `.catalanCompacto`,
  `.francesCompacto`, `.griegoCompacto`, `.rusoCompacto`… usan `Tipografia.conDobles`: Fa𝄪, B𝄫, Do𝄪♯. El alemán y
  el húngaro siguen con sus sufijos (Fisis). También `Nota.nombre`, `description`, `texto` y la codificación
  (Si𝄫3); lo guardado con ♭♭ se sigue leyendo.
- **Microtonos en las partituras**: cada nota de un `Evento` puede apartarse de su nota temperada (`desvios`, en
  cents; en texto, `Mi♭4(50¢):4`), y `Escala.voz(octava:sentido:duracion:)` da una escala en negras con sus
  microtonos. Los formatos los escriben: MusicXML, con el `alter` en decimales (−0.5) y su `<accidental>`
  (`quarter-flat`, `koron` y, para las comas, `other` con el glifo SMuFL); MEI, con `accid` (`1qf`, el koron y las
  comas de Arel-Ezgi-Uzdilek, `kf`, `bs`…); LilyPond y ABC, con los cuartos de tono (`eeh`, `_/E`), y las comas como
  la nota temperada; MIDI, con una inflexión de tono (pitch bend, en el ámbito de ±2 semitonos) antes de cada nota.
  `Escala.svgPentagrama()` dibuja sus signos con catorce glifos más de Bravura: los cuartos de tono de
  Stein-Zimmermann, las ocho comas de Arel-Ezgi-Uzdilek, el koron y el sori. En la línea de comandos,
  `armonia musicxml|mei|lilypond|abc|midi escala Re bayati` exporta una escala.
- **`armonia escalas`**: el catálogo de escalas en la línea de comandos, las habituales y las de otras tradiciones
  agrupadas por tradición y categoría, con sus notas desde Do y la marca de las que tienen microtonos. Se filtra con
  `--tradicion turquia` (o `--tradition turkey`) y `--categoria maqam`, y un texto busca en los nombres. Con su ayuda
  en los quince idiomas.
- **Microtonos**: la versión microtonal de las escalas que se aproximan, `TipoDeEscala.microtonal` (un
  `TipoDeEscalaMicrotonal`: la escala temperada y la posición de cada grado en los pasos de su `SistemaMicrotonal`).
  Maqām Rāst, Bayātī, Ṣabā y Sūznāk van en cuartos de tono (`.cuartosDeTono`); Šur, Homāyun y Čahārgāh, con el
  koron (`.persa`); Rast y Hicaz makamı, en las 53 comas de Arel-Ezgi-Uzdilek (`.comas53`).
  `Escala.notasMicrotonales(sentido:)` da sus notas (`NotaMicrotonal`), con los cents desde la tónica y su nombre
  (Mi𝄳, Fa𝄲, Si⁻¹ para una koma bajo Si). En la línea de comandos, `armonia escala Re bayati` añade una línea
  con los microtonos y otra con los cents.
- **Makamlar, mugam y más maqamat y dastgāh**, en su versión temperada: dos tradiciones nuevas, `Tradicion.turquia`
  y `.azerbaiyan`, con sus categorías `CategoriaTradicional.makam` y `.mugam` (con su nombre en los quince idiomas).
  Siete makamlar turcos (`TipoDeEscala.makamlar`: Rast, Hicaz, Hicazkâr, Nihâvend, Kürdî, Bûselik y Çârgâh, con
  «makamı» detrás) y cuatro mugam de Hacıbəyov (`TipoDeEscala.mugamlar`: Rast, Şur, Segah y Çahargah, con «muğamı»
  detrás; los tres primeros, de ocho notas). Los maqamat pasan de 6 a 10, con los primeros que tienen cuartos de
  tono, aproximados: maqām Rāst, Bayātī, Ṣabā y Sūznāk. Los dastgāh, de 3 a 5, con Šur (aproximado) y Rāst-Panjgāh.
  Los nombres llevan el sufijo o el prefijo de su categoría donde «Rast» sola sería el dromos griego. Los que tienen
  la tónica en un cuarto de tono, o cuyo redondeo cambia el carácter (Sīkāh, Uşşak, Segāh…), esperan a la capa
  microtonal.
- `Tipografia.compacta` pasa a llamarse `.conDobles` (𝄪 y 𝄫 por cada pareja), y `Alteracion.simboloCompacto`,
  `simboloConDobles`, para no confundirlas con las notaciones compactas. Los nombres de antes siguen, obsoletos,
  en `Obsoletos.swift`. El `rawValue` del caso es ahora «conDobles».
- `.alemanPalabras` escribe el Si♭ como B, igual que sus cifrados (B7) y tonalidades (B-Dur), y no «H Be»; «H Be» se
  sigue leyendo. El Si𝄫 sigue siendo «H Doppel-Be».
- En la línea de comandos la octava va como la escriba la notación: en subíndice en las compactas (la de siempre,
  Fa♯₄; `--ingles` sigue con F#4) y con cifras en las demás. `--cifras` (o `--digits`) y `--subindices` la fijan.
- `EstiloDeCifrado.espanolCompacto`, como `.inglesCompacto`: es el mismo que `.predeterminado`.

## 0.3.0 (2026-11-01)

- **Sin nombres obsoletos**: desaparecen los que la 0.2.0 marcó como obsoletos al revisar la terminología (los
  ficheros `Obsoletos.swift` de cada módulo). Con su nombre nuevo: `Altura.la440` (`la4`), `frecuencia(la4:)`
  (`frecuencia(frecuenciaDelLa4:)`), `ClaseDeEscala` (`CategoriaTradicional`), `TipoDeEscala.clase` (`categoria`) y
  `tradicionales(clase:)` (`tradicionales(categoria:)`), `Temperamento` (`AfinacionHistorica`), `EntonacionJusta`
  (`AfinacionJusta`) y su `frecuenciaTonica` (`frecuenciaDeLaTonica`), las variantes con `la4:` de
  `TemperamentoRegular`, `TemperamentoCircular`, `AfinacionJusta` y `AfinacionHistorica.afinacion` (con
  `frecuenciaDelLa4:`), `TecladoIsomorfico.rotado(pasos:)` (`rotado(doceavos:)`), `Tempo.pulsacionesPorMinuto`
  (`pulsosPorMinuto`) y `Encordado.bajo` (`bajoElectrico`).
- **Compactas en todos los idiomas**: cada idioma que escribe las alteraciones con palabras tiene ahora también su
  escritura compacta, con la sílaba en mayúscula, el signo y la octava en subíndice: `.catalanCompacto`,
  `.gallegoCompacto`, `.asturianoCompacto`, `.aragonesCompacto`, `.euskeraCompacto`, `.portuguesCompacto`,
  `.francesCompacto` (Ré♭₄), `.occitanoCompacto`, `.italianoCompacto`, `.griegoCompacto` (Φα♯) y `.rusoCompacto`
  (Фа♯), en `Notacion` y en `EscrituraDeNotas`. Los textos siguen en el idioma, y se leen las dos formas («ré bémol»
  y «Ré♭»). `EscrituraDeNotas.conPalabras(_:)` y `.compacta(_:)` dan las dos de cualquier idioma. La notación de
  cada idioma (`Notacion.delIdioma(_:)`) no cambia. En la línea de comandos, `--escritura palabras|compacto` vale
  con todos los idiomas.
- El húngaro, el decimoquinto idioma: `Idioma.hungaro` («hu»). Como el alemán, tiene dos escrituras:
  `.hungaroCompacto`, la habitual, con las notas a la alemana con «isz» y «esz» (Fisz, Esz, Asz, B para Si♭, H para
  Si, Heszesz) y la octava en subíndice, y `.hungaro`, con las alteraciones en palabras (F kereszt, H bé). Las
  tonalidades se escriben C-dúr y a-moll, y se leen las mismas formas («Fisz-dúr», «esz-moll», «Fisz dór»). Todos los
  textos del motor y los nombres de las escalas están en húngaro. La escritura a la alemana toma sus sufijos de
  `ReglasDeIdioma.sufijoDeSostenido` y `sufijoDeBemol`, así que otro idioma con letras puede reutilizarla.
- Solfeo relativo (do móvil, como en el método Kodály): `SolfeoRelativo(tonalidad, menor:)` da la sílaba de cada
  nota según la tónica («do re mi fa so la ti», con «di ri fi si li» y «ra me se le te» para las alteradas, y las
  húngaras «dó ré mi fá szó lá ti» con `en: .hungaro`). En menor, la tónica es «la» (`.enLa`, Kodály) o «do»
  (`.enDo`). `Escala.solfeoRelativo(menor:en:)` da las sílabas de una escala.
- En la línea de comandos, `--idioma hu` (o `magyar`) escribe las notas, los mensajes y la ayuda en húngaro, y
  `--escritura palabras|compacto` elige entre F kereszt y Fisz.
- **Notaciones compactas**: `Notacion.espanolUnicode` e `.inglesUnicode` pasan a llamarse `.espanolCompacto` e
  `.inglesCompacto` (igual en `EscrituraDeNotas`, y `EstiloDeCifrado.inglesUnicode` pasa a `.inglesCompacto`). Los
  nombres de antes ya no existen. Las compactas escriben la octava como subíndice: La₄,
  F♯₃ (`EscrituraDeNotas.esCompacta` y `.octavas`); las demás siguen con cifras, y `conOctavas(_:)` elige otra.
  `description`, `texto` y la codificación de las alturas siguen con cifras ("Fa♯4"), para que lo guardado no
  cambie. Los SVG con nombres de nota (pentagramas y teclados) llevan ahora los subíndices.
- **Alemán con palabras y compacto**: `.aleman` escribe ahora las alteraciones con palabras (F Kreuz, H Be,
  E Doppel-Be), como `.espanol` e `.ingles`, y la escritura de siempre (Fis, Es, B, H) es `.alemanCompacto`, con la
  octava en subíndice. Los cifrados y las tonalidades de las dos van a la alemana (Fis7, Fis-Dur), las dos leen las
  dos formas, y `Notacion.delIdioma(.aleman)` es `.alemanCompacto`. `EscrituraDeNotas.allCases` tiene diecinueve
  escrituras.
- En la línea de comandos, `--escritura` acepta también `compacto` (o `compact`, además de `unicode`) y, en alemán,
  `palabras` y `compacto`. La octava sigue con cifras salvo con `--subindices`, también en las notaciones compactas.
- Exportación a LilyPond y ABC: `Voz.lilyPond(tonalidad:clave:tempo:titulo:parte:)` y `Voz.abc(…)`, y las mismas
  en `Coral` y `AnalisisArmonico`, con los cifrados encima y el análisis debajo del bajo. LilyPond escribe las
  alturas en absoluto con los nombres holandeses; ABC escribe las alteraciones que se ven, como el MEI. Las dos
  parten las duraciones que no tienen figura (o que llevan más de dos puntillos) en notas ligadas, y una ligadura
  solo se escribe si la nota siguiente es la misma. El MEI comparte con ellas los grupos irregulares
  (`Exportacion.irregulares`).
- En la línea de comandos, `armonia lilypond|abc melodia|coral|acordes|arpegios …`, con las opciones de `musicxml`.
- En la línea de comandos, `armonia completado bash|zsh|fish` (o `completion`) escribe el autocompletado de las
  órdenes, sus opciones y sus valores (`source <(armonia completado bash)`), y `armonia manual` (o `man`), la ayuda
  como página de manual en roff, en el idioma de los textos (`armonia manual --ingles > armonia.1`).
- Cada versión publica en su release la herramienta `armonia` ya compilada: Linux x86_64 y arm64, estáticos, y
  macOS universal, con el manual y el completado (`Scripts/empaquetar_cli.sh`).
- `EscrituraXML.escapar`: una sola forma de escapar `&`, `<`, `>` y `"` para el SVG, el MusicXML y el MEI, en vez
  de cuatro copias (la del Tonnetz y la tabla armónica no escapaba las comillas).
- Sin `!` en el motor: los datos fijos (intervalos, tipos de acorde, temperamentos) dicen en un mensaje cuál no es
  válido, los colores se guardan como números, y los mínimos, los máximos y las búsquedas tienen su alternativa.
  `AnalisisArmonico.analizar(leyendo:)` y `RecorridoTonal(leyendo:)` lanzan un error en vez de fallar.
- `PentagramaSVG.swift` se parte en cuatro ficheros: las opciones, las escalas, acordes y arpegios, el dibujo y la
  geometría.
- El plural de cada idioma está en sus reglas (`ReglasDeIdioma.plural`): singular con 1 en casi todos, con 0 y 1
  en francés («0 demi-ton»), una forma en euskera y tres en ruso. `Idioma.contar(n, formas…)` escribe el número con
  la forma que le toca («5 полутонов»); `Traduccion.pluralRuso` desaparece en su favor.
- `ReglasDeIdioma.abreviaturas`: el idioma de las abreviaturas de intervalo (5J o P5) es un dato más de cada fila,
  y `Notacion.idiomaDeLasAbreviaturas` lo lee de ahí en vez de un `switch`.
- `Idioma.reglas` se calcula una sola vez por idioma, en una tabla, en lugar de en cada llamada.
- `Idioma(nombre:)` no distingue tildes («aleman», «FRANCAIS», «ελληνικα»), así que `nombres` ya no repite cada
  nombre sin ellas.
- `Traducido(porIdioma:)`: los catorce valores a partir del idioma.
- Desaparece `Idioma.traducidos`: era igual que `Idioma.allCases`.
- `Traducido(cadaIdioma:)`: los catorce valores a partir de la notación habitual de cada idioma
  (`Traduccion(cadaIdioma: { acorde.nombre(en: $0) })`), para no escribir a mano los catorce argumentos.
- Los datos de cada idioma, en una fila de `ReglasDeIdioma`: además de las sílabas y la alteración, su código
  (`codigo`), cómo se llama (`nombrePropio`, nuevo, y `nombres`) y los modos de sus tonalidades (`mayor`, `menor`,
  y el «a-Moll» alemán con `separadorDelModo` y `menorEnMinuscula`). `Idioma.codigo`, `nombres` y
  `Tonalidad.Modo.nombre(en:)` los leen de ahí, sin un `switch` cada uno. `ReglasDeIdioma.init` pide los datos nuevos.
- `Idioma` tiene `rawValue`: el nombre del caso («euskera», «aleman»).
- Si un instrumento de partitura propio se llama por su nombre inglés o el español lo dice el campo
  `instrumentosPropiosEnIngles` de los textos de cada idioma, en lugar de un `switch`.
- `TextosTraducidos`: los textos de cada módulo se leen con `TextosDeX.en(notacion, \.campo)` (el texto en un
  idioma) o `TextosDeX.traduccion(\.campo)` (su `Traduccion`), en vez de `traducidos.map(…)`, que copiaba en la pila
  los catorce idiomas en cada llamada. Es el arreglo de la pila de 0.2.0, ahora en el motor y la CLI.
- Los nombres de los instrumentos de partitura pasan a `TextosDePartitura` (un fichero por idioma) y
  `comprobar_traducciones` los revisa; `InstrumentoDePartitura.traducciones` sustituye a los cuatro diccionarios.
- `Arpegio.Patron(leyendo:)`: el patrón por su nombre en el código, en inglés abreviado o en cualquiera de los
  catorce idiomas. `claveDeBusqueda` quita también circunflejos, diéresis, ã/õ y la cedilla.
- `ElMejor`, para quedarse con el candidato de menor coste en las búsquedas, sustituye a seis bucles con `!`.
- La gramática de cada idioma pasa a su fichero de textos: el orden de calidad y número en los intervalos («3ª
  mayor», «große Terz»), el unísono en masculino, los ordinales con palabras o en cifras, el tipo delante de la
  fundamental en los acordes («Dominantseptakkord auf G»), «en Do mayor» con su declinación en ruso y euskera, y los
  dos puntos del francés. Desaparecen los `switch` sobre el idioma de `Intervalo`, `Acorde`, `Tonalidad` y
  `ErrorDeLectura`. `TextosTraducidos.en(idioma:_:)` lee un texto por su idioma.

## 0.2.0 (2026-10-31)

- Revisión de la terminología de la API. Los nombres viejos siguen compilando, marcados como obsoletos (con el
  nombre nuevo en el aviso), y se quitarán en la próxima versión:
  - `Altura.la440` pasa a `Altura.la4` (es una altura, no una frecuencia), y los parámetros y propiedades `la4:` que
    son frecuencias pasan a `frecuenciaDelLa4:` (`frecuencia(frecuenciaDelLa4:)`, `afinar(frecuenciaDelLa4:)`,
    `TemperamentoRegular.igual(divisiones:frecuenciaDelLa4:)`…).
  - `Temperamento` pasa a `AfinacionHistorica`: incluye la afinación justa, que no es un temperamento.
  - `EntonacionJusta` pasa a `AfinacionJusta` («entonación justa» es un calco del inglés), y `frecuenciaTonica`, a
    `frecuenciaDeLaTonica`.
  - `Encordado.bajo` pasa a `Encordado.bajoElectrico`, como en `InstrumentoDePartitura`; `bajo` es la nota más
    grave de un acorde. «bajo eléctrico» también se lee con `Encordado(nombre:)`.
  - `ClaseDeEscala` pasa a `CategoriaTradicional`, `TipoDeEscala.clase` a `categoria` y `tradicionales(clase:)` a
    `tradicionales(categoria:)`: «clase» es la clase de altura.
  - `TecladoIsomorfico.rotado(pasos:)` pasa a `rotado(doceavos:)`: cada paso es un doceavo de vuelta (30°), y en
    Hexagonos `rotada(sextos:)` gira 60°.
  - `Tempo.pulsacionesPorMinuto` pasa a `pulsosPorMinuto`, como `pulso` y `pulsos` en el resto de la API.
- Las cuerdas: `Encordado.numeroTradicional(deCuerda:)` da el número con que se nombra una cuerda (la 1.ª es la de
  abajo, el Mi agudo de la guitarra), y la documentación de `Encordado.cuerdas` y `PosicionEnElMastil.cuerda` dice
  que el índice 0 es la de arriba. `PosicionEnElMastil.description` dice «cuerda 1 desde arriba, traste 3».
- La octava de las alturas en subíndice: `Notacion.conOctavas(.subindices)` escribe La₄, Fa♯₃ y Si♭₋₁
  (`EscrituraDeLaOctava`, con `.cifras` por defecto), y `Altura(leyendo:)` lee las dos formas, también en las
  melodías y los corales. `Altura.nombreCompacto(en:)` y `octavaEscrita(en:)` dan las etiquetas de los teclados, la
  tabla armónica y los dibujos con la octava de la notación. En la línea de comandos, `--subindices` (`--subscripts`).
- `TecladoIsomorfico.todos` (los nueve teclados con nombre) y `TecladoIsomorfico.nombre(en:)`, con los nombres en los
  catorce idiomas en `TextosDeRepresentaciones`.
- `Nombrable` da `nombre` (el nombre en español) a todo tipo que lo adopta; desaparecen las 21 copias. `Arpegio`,
  `Arpegio.Patron` y `Rearmonizacion.Recurso` pasan a ser `Nombrable`.
- `Idioma.nombres` e `Idioma(nombre:)`: el idioma por su código o por su nombre («euskara», «Deutsch»).
- Las exportaciones a MusicXML y MEI de una voz, un coral y una progresión se preparan en un solo sitio
  (`Exportacion.documento` con un `EscritorDePartitura`); las funciones públicas no cambian.
- Los nombres de los arpegios, de sus patrones y de los recursos de rearmonización pasan a `TextosDeTeoria`. Ya no
  queda ningún `Traduccion("…", …)` en línea en el código: `Scripts/comprobar_higiene.py` avisa si vuelve uno.
- La documentación de `TecladoIsomorfico.janko`, `.wickiHaydenPlano` y `.tablaArmonica` dice a qué preset de 12 notas
  del Lumatone corresponde cada uno (1, «Classic Mode», Bosanquet-Wilson; 2, «Melodic Mode», y 3, «Harmonic Mode»).
- Dos patrones de arpegio más: `Arpegio.Patron.quebrado` (por terceras quebradas: Do Sol Mi Do) y `.bajaYSube` (baja
  desde la nota de arriba y vuelve a subir), con su nombre en los catorce idiomas.
- `Rearmonizacion` y `Tonalidad.rearmonizaciones(de:)`: otras armonías para cada acorde de una progresión (sustituto
  tritonal, dominante secundaria, préstamo modal del homónimo y sustituto diatónico), con `aplicar(a:)` y
  `descripcion(en:)` («Sol7 → Re♭7 (sustituto tritonal)»).
- El capo: `Encordado.conCapo(_:)` sube las cuerdas y cuenta los trastes desde el capo (`capo`, `sinCapo`), así que
  las digitaciones, los arpegios y las escalas en el mástil salen como se tocan con él.
- `Coral` es `Transponible` y tiene `texto(en:)`; `Nota.intervaloMasCorto(hasta:)` da el intervalo para transportar
  sin alejarse (de Do a La, una tercera menor abajo).
- `OpcionesDePentagrama.resaltada` y `colorResaltado`: una columna del pentagrama de otro color, la que está sonando.
- `TecladoIsomorfico.gerhard` (`1,4,3;R60`: un semitono hacia arriba y las terceras mayor y menor en las diagonales
  de la derecha) y `TecladoIsomorfico.park` (`2,5,3;R90M`: una cuarta hacia la derecha, una tercera menor arriba a la
  derecha y un tono abajo a la derecha), los dos de la Tabla 1 de Park y Gerhard.
- Un MusicXML con un byte que no es UTF-8 válido en el nombre de un elemento o de un atributo detenía el programa en
  Linux (dentro de `XMLParser`). Ahora es `ErrorDeImportacion.xmlDanado(linea:)`, con la línea del byte. Los ficheros
  que declaran una codificación de un byte por carácter (ISO-8859-1, Windows-1252…) se siguen leyendo.
- `PiezaImportada.acordes(ventana:)` podía desbordar las fracciones (y detener el programa) con una pieza de más de
  100 000 ventanas y una división rara, como un MIDI de 32 749 pulsos por negra con una nota larguísima. Para no pasar
  de 100 000, la ventana se alarga ahora a un múltiplo entero de la de partida.
- `FormatoUIL` rechaza intervalos y números de notas por octava de más de un millón (`intervalosIncoherentes`,
  `formatoNoValido`): con valores cerca del máximo de `Int`, comprobar `G = L + D` desbordaba.
- Pruebas nuevas (`ImportacionAlAzarTests`): ficheros MIDI y MusicXML estropeados al azar, números desmesurados,
  elementos anidados sin fin, entidades que se expanden y textos UIL al azar. Todos acaban con una pieza o un error.
- `PiezaImportada.acordesConDuracion(ventana:)`: los acordes con lo que dura cada uno, hasta que empieza el siguiente
  y, el último, hasta el final de la pieza.
- `AnalisisArmonico.musicXML(duraciones:…)`, `mei(duraciones:…)` y `midi(duraciones:…)`: la progresión con una
  duración por acorde (en MusicXML y MEI, el último se alarga hasta la barra). Las de `duracion:` las usan por dentro y
  dan lo mismo que antes.
- `Voz(arpegiando:duraciones:patron:…)`: la progresión arpegiada con su ritmo armónico.
- `PiezaImportada(leyendo:)` lee también el MusicXML comprimido (.mxl): el zip se abre y se descomprime (DEFLATE) sin
  dependencias, y se lee la partitura que señala `META-INF/container.xml`. `ErrorDeImportacion.comprimido` queda para
  el .mxl dañado o que no se puede leer (cifrado, ZIP64, otro método de compresión).
- `Mastil.posicionesPorCuerda(de:notasPorCuerda:)` y `Mastil.posicionesCAGED(de:ancho:)`: una escala por posiciones,
  con tres (o dos) notas por cuerda o en las cinco formas CAGED (`FormaCAGED`), como `EscalaEnElMastil`.

## 0.1.0 (2026-10-31)

Primera versión con etiqueta del repositorio: `0.1.0`.

### Organización

- Los ficheros `X+Idiomas.swift` se funden en el fichero de su tipo (`Nota+Idiomas.swift` en `Nota.swift`, etc.),
  al final, tras `// MARK: - Idiomas`. `ErrorDeLectura+Idiomas`, `+Notas`, `+Acordes`, `+Escalas` y `+Partitura` pasan a
  `ErrorDeLectura.swift`. No cambia ninguna API.
- Escalas en menos ficheros: `Escala+Busqueda` y `+Ortografia` pasan a `Escala.swift`; `TipoDeEscala+Basicas` y
  `+Catalogo`, a `TipoDeEscala.swift`; `+ModosExoticos`, a `Occidentales/TipoDeEscala+Modos.swift`; `+Hexatonicas`, `+Jazz`
  y `+Messiaen`, a `Occidentales/TipoDeEscala+Exoticas.swift`; y las tradiciones (salvo la India, que sigue aparte),
  a `Tradiciones/TipoDeEscala+Tradiciones.swift`, cada una tras su `// MARK: - Nombre`. No cambia ninguna API.

### Swift 6

- El paquete pide Swift 6.0 o posterior (`swift-tools-version:6.0`) y compila en el modo de lenguaje 6: la
  concurrencia se comprueba al compilar, no solo en el CI. Antes pedía Swift 5.9.

### Importar MIDI y MusicXML

- `PiezaImportada(leyendo:)` lee un fichero MIDI estándar (formatos 0, 1 y 2) o una partitura MusicXML por partes sin
  comprimir, según su contenido: `PiezaImportada(midi:)` y `PiezaImportada(musicXML:)` para uno en concreto. Da las
  notas (`NotaDeLaPieza`: altura, comienzo y duración en redondas, parte) y el título, la armadura, el compás y el
  tempo del fichero. En MIDI, la ortografía sale de la armadura o, si no la hay, de `tonalidadEstimada`; en MusicXML se
  conserva, con acordes, voces (`<backup>`, `<forward>`), ligaduras e instrumentos transpositores. No cuentan la
  percusión, las notas de adorno ni las notas guía.
- `acordes(ventana:)` (y `acordesConInicio(ventana:)`) reduce las notas a los acordes que suenan, por ventanas de un
  pulso: cada clase de altura pesa lo que suena, se descartan las notas breves si sin ellas sale una lectura más
  probable y las ventanas seguidas con el mismo acorde se funden. `analisis(en:ventana:)` las analiza.
- `ErrorDeImportacion` dice por qué no se puede leer un fichero (formato desconocido, MusicXML comprimido, MIDI dañado
  o con tiempo SMPTE, XML mal formado, sin notas o sin acordes), en los catorce idiomas.
- En la línea de comandos, `armonia analizar --archivo coral.mid [--ventana 2] [--en Do mayor]` (o
  `analyze --file chorale.musicxml --window 2`) analiza los acordes de un fichero como si se hubieran escrito.
- Todavía no se leen el MusicXML comprimido (.mxl), las repeticiones ni los saltos.

### Arpegios

- `Arpegio`: un acorde recorrido nota a nota, con `Patron` (`.ascendente`, `.descendente`, `.idaYVuelta`, `.alberti`),
  `octavas` y `conOctava`. `alturas(octava:)`, `notas`, `transponer(_:)`, `nombre(en:)` en los catorce idiomas y
  `Arpegio(leyendo:)` («arpegio Dom7», «Dom7 arpeggio», «Arpège de Do»). No forma parte de `TipoDeEscala.todos`.
- `Escala.arpegio(grado:cuatriada:…)`, `Escala.arpegio(grados:…)`, `Escala.arpegios(cuatriadas:)`, `Acorde.arpegio(…)`
  y `Acorde.escalasCompatibles(entre:)` (la relación acorde-escala: Do7 → Do mixolidio…).
- `Arpegio.svgPentagrama(octava:opciones:)`: las notas en el orden del patrón, una por columna.
- En la línea de comandos, `armonia arpegio Do7 [--patron alberti]` (o `arpeggio C7 --pattern up-down`): las notas
  del arpegio desde la octava 4 y las escalas que encajan con el acorde. El patrón se escribe como en el código, con
  guiones (`ida-y-vuelta`), en inglés o con su nombre en cualquiera de los catorce idiomas. La ayuda, los errores y la
  etiqueta nueva («escalas»), en los catorce.
- `Voz(_:figura:octava:compas:)`: un arpegio con ritmo, que se dibuja, suena y se exporta como cualquier voz.
  `Voz(arpegiando:patron:octavas:conOctava:figura:porAcorde:octava:compas:)` arpegia una progresión: cada acorde con el
  mismo patrón, el patrón repetido hasta llenar `porAcorde` (la última nota se alarga si no cabe un número entero) y el
  bajo de cada acorde en la octava más cercana al del primero.
- En la línea de comandos, `armonia musicxml|mei|midi arpegios Do Lam Fa Sol7 [--patron alberti] [--figura 16]
  [--duracion 2]` (o `arpeggios … --pattern up-down`) exporta la progresión arpegiada, con la armadura de la tonalidad
  que mejor la explica (o la de `--tonalidad`). `--patron` y `--figura` solo valen para los arpegios. La ayuda y los
  errores, en los catorce idiomas.
- `Mastil.posiciones(de:trastes:)` da las posiciones de las notas de un acorde, y `Mastil.arpegios(de:ancho:)` el
  arpegio por posiciones (`ArpegioEnElMastil`): franjas de cuatro trastes que empiezan un traste por debajo de la
  fundamental en una de las dos cuerdas más graves, con las notas de grave a agudo y sin unísonos repetidos.

### Teclados isomórficos

- `TecladoIsomorfico.acordeonC` y `.acordeonB`: el acordeón cromático de botones (sistemas C y B), con hexágonos planos:
  arriba una tercera menor y, a los lados, un semitono y un tono (el B es el espejo del C).
- `TecladoIsomorfico.wickiHaydenPlano` (hexágonos planos, con la quinta en vertical) y `.wickiHaydenEspejo` (la
  quinta arriba a la izquierda y la cuarta arriba a la derecha; el tono, hacia la izquierda).
- `FormatoUIL`: el formato UIL (Unified Isomorphic Layout, Park y Gerhard 2013) para describir cualquier teclado
  hexagonal isomórfico, `L,G,D;R<grados>[M][;T<tonos>]`. `FormatoUIL(leyendo:)` (también con intervalos como `M2,P5,P4`,
  `II,V,IV` o `9:8,3:2,4:3`), `descripcion`, `esCompleto` (L y D coprimos), `caso` (cero e igualdad), `orientacion`,
  `anguloDelEjeDeAltura`, `semitonos(rumbo:)`, `rotado(grados:)`, `reflejado` y `teclado(nombre:midiDelOrigen:)`.
  `ErrorDeUIL` dice por qué no se lee. `FormatoUIL.conocidos` trae los ocho de la Tabla 1 del artículo.
- `TecladoIsomorfico.uil` (su formato, p. ej. `2,7,5;R30M`), `TecladoIsomorfico.conUIL(_:)`, `rotado(pasos:)` y
  `rotado(grados:)` (de 30° en 30°, en sentido horario), `reflejado` y `semitonos(rumbo:)`.
- Los teclados que ya había coinciden con el artículo (Wicki-Hayden `2,7,5;R30M`, tabla armónica `3,7,4;R0`,
  Jankó `1,2,1;R90`) salvo los acordeones: `.acordeonC` es `1,3,2;R0M` y `.acordeonB` `1,3,2;R0`, y el artículo da
  `R270M` y `R270` (los mismos, girados 90°).
- Corregido: `TecladoIsomorfico.midi(en:)` había perdido su cabecera y no compilaba.

### Pentagramas en SVG

- `Escala.svgPentagrama(octava:sentido:opciones:)` y `Acorde.svgPentagrama(octava:cifrado:opciones:)` dibujan escalas y
  acordes en un pentagrama, en Swift y sin dependencias: clave, armadura, redondas, alteraciones, líneas adicionales y,
  en los acordes, segundas desplazadas y cifrado encima. Los glifos son los de Bravura (SMuFL, OFL).
- La escala sube y, si baja con otras notas (la menor melódica), también baja, con los becuadros que hagan falta.
- Cada nota lleva un `<title>` con su nombre en la notación elegida; el pentagrama se ensancha si el cifrado o los
  nombres son más anchos que las notas.
- `OpcionesDePentagrama`: clave (por defecto, la de sol o la de fa con menos líneas adicionales), armadura, notación,
  nombres de las notas, tamaño y color.
- `OpcionesDePentagrama.pentagramas` (`.automatico`, `.simple`, `.doble`): en el pentagrama doble, sol y fa unidos por
  una barra, las notas se reparten por el Do central y las armaduras se escriben en los dos. Automático: solo si la
  clave no se fija, el rango pasa a los dos lados del Do central y con uno harían falta más de tres líneas adicionales.
- Marca 8va u 8vb (`marcaDeOctava`): con la clave sin fijar, si el rango es muy agudo o muy grave y no pasa por el Do
  central, se escribe una octava más cerca del pentagrama con una línea de puntos hasta la última nota.
- Las etiquetas con los nombres de las notas no se pisan (la columna se corre si hace falta) y la medida del texto se
  ajusta con `anchoDeLosCaracteres`. Un hueco entre la clave (o la armadura) y la primera nota.
- Las alteraciones se reparten en columnas según lo que sube y baja cada glifo (y cada columna mide lo que su glifo
  más ancho), así que siete alteraciones seguidas caben en tres columnas, no en siete.
- La marca 8va/8vb también funciona en el pentagrama doble, cada uno con la suya (8va arriba, 8vb abajo).
- El pentagrama doble lleva una llave de Bravura (`llave` en `GlifosSMuFL`, con `extraer_glifos_bravura.py`).
- La medida del texto sale de una tabla de anchos por carácter (sin tildes) en vez de una constante, y el texto lleva
  `textLength`. `anchoDeLosCaracteres` es ahora un multiplicador (1 por defecto, antes 0,62 por carácter).
- `OpcionesDePentagrama.disposicionDelAcorde` (`.automatica`, `.cerrada`, `.abierta`): el bajo una octava más grave y
  el resto en posición cerrada; automática en los acordes que abarcan más de una octava y media.
- Ejemplos en `NotacionYPartitura.md`, que se prueban como los demás.
- Sin ritmo, vigas ni voces: para partituras completas, MEI o MusicXML y un motor externo.

### Normalización y documentación

- `Scripts/vectores/normalizar.tsv` reúne los casos de `TipoDeEscala.normalizar`; los lee `NormalizarVectoresTests` y
  `Scripts/normalizar_escalas.py`, la copia en Python que ahora usan `comprobar_catalogo.py` y los generadores (antes
  cada uno llevaba la suya).
- DocC (`Escalas.md`) y el README describen los nombres por idioma, los alias escritos y normalizados, y la clase y la
  tradición de las escalas (con ejemplos que se prueban).

### Tradición y clase de las escalas

- `TipoDeEscala.clase` (`ClaseDeEscala`: `raga`, `melakarta`, `janya`, `thaat`, `dromos`, `maqam`, `dastgah`…) y
  `TipoDeEscala.tradicion` (`Tradicion`: `india`, `grecia`, `mundoArabe`…) dicen qué es una escala de otra tradición;
  `esRaga` es cierto para ragas, melakarta y janya, no para los thaat. Salen de las listas de cada tradición (no cambian
  `TipoDeEscala` ni su `Codable`) y valen `nil` en las occidentales y en las propias. Se buscan por el nombre, porque
  Āsāvarī es igual a la menor natural por sus intervalos. `TipoDeEscala.tradicionales(clase:)` y `(tradicion:)`
  las filtran, y `ClaseDeEscala.nombre(en:)` da el nombre de la clase en cada idioma, tomado de las filas `.clase` de
  los ficheros de `Escalas/Nombres/` (`comprobar_catalogo.py` vigila que no falte ninguna).
- `clase` y `tradicion` exigen también que los intervalos coincidan: una escala propia que se llame «Kāfī» pero suene
  distinto no es el thaat. `padre` da el melakarta del que deriva un raga janya (Mohanam → Harikāmbhojī; Revati no
  tiene uno único); siempre es uno de sus `melakartasCompatibles`.

### Alias escritos y alias normalizados

- `TipoDeEscala.alias` guarda solo las grafías correctas («dórico ♭2», «húngara»); las simplificadas («dorico b2»,
  «hungara») ya no se repiten: salen de `aliasNormalizados` y de `normalizar`, que ahora también pliega «ª» y «−».
  Se quitaron 120 alias que eran solo la forma sin diacríticos; la lectura no cambia (`Scripts/comprobar_catalogo.py`
  avisa si se vuelve a guardar uno). `normalizar` pliega también «…» como «..», con lo que «cromatica -5..6» ya no
  hace falta como alias.
- Alias que faltaban en euskera y alemán («vermindert», «symmetrisch übermäßig», «phrygisch Dur», «gutxitua»…) y
  algunos más en ruso y griego.

### Alias en ruso y griego

- `NombresDeEscalas+Ruso.swift` y `NombresDeEscalas+Griego.swift` tienen ya alias (modos en femenino, «Мессиан 3»,
  «εξατονική», nombres propios como Лист o Σκριάμπιν…), como el resto de idiomas.
- En ruso y griego, las escalas de otras tradiciones llevan su nombre transcrito (Бхайрав, Μπιλαβάλ, Хиджаз…);
  los 72 melakarta siguen en IAST. El nombre original, en latino, se sigue leyendo.
- `Scripts/comprobar_traducciones.py` funciona también sin `.git`.
- Las filas `.tradicional` de los ficheros de idioma nombran la escala por su miembro de `TipoDeEscala`
  (`.tradicional(.hitzaz, "…")`), no por una cadena: renombrar o quitar una escala da un error de compilación en
  lugar de dejar la fila huérfana. Los 72 melakarta ya no se listan (sin fila conservan su nombre en IAST).
- Los generadores de alias y de nombres tradicionales están en `Scripts/nombres_de_escalas/` (con su README).

### Un idioma por fichero

- Los nombres de los tipos de escala y sus alias pasan a `NombresDeEscalas`, con un fichero por idioma en
  `ArmoniaTeoria/Escalas/Nombres/` (catalán, gallego, euskera, aragonés, asturiano, portugués, francés,
  italiano, alemán, occitano, ruso, griego e inglés). Sustituyen a `TipoDeEscala+Idiomas.swift` y a sus cuatro
  tablas agrupadas por familias de idiomas; `TipoDeEscala.nombre(en:)` y la lectura de «Re dòric», «Fis dorisch»
  o «ре дорийский» no cambian. Un idioma nuevo es un fichero más y su fila en `NombresDeEscalas.traducidos`.
- Las escalas de otras tradiciones están también en esos ficheros (`.tradicional`), por su nombre original: sus
  nombres propios (Kafi, Hitzáz, Hirajōshi…) se escriben igual en todos los idiomas, pero ahora se pueden traducir
  uno a uno. Se traducen las que llevan un nombre descriptivo en español —las escalas andinas, los tetracordos y
  las harmoniai griegas— y el «mayor» y «menor» de las etíopes. `TipoDeEscala.nombre(en:)` los da traducidos.

- Los textos de `ArmoniaNucleo` (calidades de intervalo, consonancias, palabras de las alteraciones y
  mensajes de `ErrorDeLectura`) pasan a `TextosDeNucleo`, con un fichero por idioma en `Textos/`. Los que
  llevan valores («la 7ª no es…») son cierres: `intervaloSinPapel: { intervalo, notacion in "…" }`.
- Los textos de `ArmoniaPartitura` (figuras, claves, faltas de contrapunto, pistas MIDI) pasan a
  `TextosDePartitura`, igual.
- Los textos de `ArmoniaRepresentaciones` (temperamentos, ciclos y transformaciones neorriemannianas,
  leyendas de los dibujos) pasan a `TextosDeRepresentaciones`, igual.
- Los textos de `ArmoniaTeoria` (tipos de acorde, papeles, inversiones, grados, funciones, cadencias,
  faltas de conducción, voces) pasan a `TextosDeTeoria`, igual. La declinación vasca de «De Do mayor a Sol
  mayor» pasa del código al fichero del euskera.
- En la línea de comandos, los textos de la ayuda, los errores de uso y las etiquetas de la salida pasan a
  `TextosDeCLI`, igual. La salida no cambia.
- Los textos de `ArmoniaTrastes` (los nombres de los instrumentos) pasan de un `Traduccion` con los
  catorce idiomas juntos a un fichero por idioma: `Textos/TextosDeTrastes+Espanol.swift`,
  `…+Ingles.swift`… Cada fichero da todos los campos de `TextosDeTrastes`, sin valores por omisión, así que
  un texto nuevo sigue sin compilar hasta que está en los catorce, y un idioma nuevo es un fichero más.
  `Encordado.nombre(en:)` y `titulo(en:)` dan lo mismo que antes.
- `Scripts/comprobar_traducciones.py` lee también los ficheros por idioma.

### Las reglas de cada idioma, como datos

- `EscrituraDeNotas` deja de ser una lista de dieciocho casos y pasa a ser el idioma con su variante
  (`idioma`, `conPalabras`, `tipografia`). Las constantes (`.espanolUnicode`, `.ruso`…), `allCases`,
  `init(idioma:ascii:)` y el orden no cambian, pero ya no se puede hacer `switch` sobre ella: para eso está
  `escrituraDeLaAlteracion`. Un idioma nuevo no añade casos aquí.
- Las reglas dicen además cómo escribe cada idioma las alteraciones (`alteraciones`) y los signos de sus
  cifrados (`tipografia`), así que las tres escrituras del español y del inglés salen de ellas.

- Nuevo `ReglasDeIdioma` (`Idioma.reglas`): las siete sílabas del idioma, el separador de la alteración en
  palabras (" " en casi todos, "-" en ruso) y dónde va el multiplicador (delante, detrás en euskera, unido en
  alemán). `NotaNatural.nombre(en:)` y `Alteracion.nombre(en:)` lo consultan en vez de repartir los catorce
  idiomas por sus `switch`.
- Nuevo `EscrituraDeNotas.escrituraDeLaAlteracion`: `.palabras`, `.signos` o `.alemana`. `Nota.nombre(en:)`,
  `Nota.nombreCompacto(en:)`, `Nota(leyendo:en:)` y `Altura(leyendo:en:)` preguntan por esto y ya no listan
  las dieciocho escrituras.
- Sin cambios de comportamiento: los nombres, las lecturas y los cifrados salen igual en los catorce idiomas.
  Añadir un idioma pasa a ser una fila en las reglas y un caso en `Idioma` y `EscrituraDeNotas`.

### Español e inglés con palabras, ASCII o Unicode

- **Cambio de nombres**: `Notacion.espanol` (Fa♯) pasa a llamarse `.espanolUnicode` y `Notacion.ingles` (F#),
  `.inglesASCII`; lo mismo en `EscrituraDeNotas`. Los nombres `.espanol` e `.ingles` son ahora las notaciones
  con las alteraciones en palabras: «Fa sostenido», «Si doble bemol», «F sharp», «B double flat». Sus cifrados
  llevan ♯ y ♭ en los dos idiomas (Fa♯7, B♭7(♭9)/D). `.espanolASCII` e `.inglesUnicode` no cambian.
- Las notas, las alturas, las escalas y las tonalidades se leen también con palabras, sin indicar la notación:
  `Nota("Fa sostenido")`, `Altura("B flat 4")`, `Escala("F sharp dorian")`, `Tonalidad("Mi bemol menor")`.
  `Nota(leyendo:en:)` y `Altura(leyendo:en:)` leen las tres formas en cualquiera de las seis notaciones.
- `Notacion.delIdioma(_:)` sigue dando ♯ y ♭ en español (`.espanolUnicode`) y # y b en inglés (`.inglesASCII`).
- **Cambio de nombres** en `EstiloDeCifrado`, para que casen con `Notacion`: `.ascii` pasa a `.espanolASCII`,
  `.ingles` a `.inglesASCII` y `.palabras` (Domin7, Fadim, Solaug) a `.calidadesConPalabras`, que no tiene que
  ver con las notaciones con palabras.
- En la línea de comandos, `--escritura palabras|ascii|unicode` (o `--writing words|ascii|unicode`) elige
  entre las tres en español e inglés: `armonia acorde Sib7 --escritura palabras` da «Si bemol Re Fa La bemol».
  Se combina con `--idioma`, `--ingles` y `--textos`; sin ella, todo sigue igual.
- Los cifrados también se leen con la fundamental y el bajo en palabras: `Acorde(texto: "Fa sostenido m7")`,
  `Acorde(texto: "B flat 7(b9)")`, `Acorde(texto: "Sol7/Fa sostenido")`. La palabra va en el idioma de la nota y
  separada de ella por un espacio. Lo hace el lector común de notas, así que vale para todo lo que lo usa.

### Ficheros con el nombre de su tipo

- Sin cambios en la API: `TransformacionesNeorriemannianas.swift` y `CiclosNeorriemannianos.swift` pasan a
  `TransformacionNeorriemanniana.swift` y `CicloNeorriemanniano.swift`, `Ritmo+Idiomas.swift` a `Duracion+Idiomas.swift`,
  `TipoDeEscala+Peninsulares.swift` a `TipoDeEscala+Idiomas.swift`, `MIDI.swift` a `ArchivoMIDI.swift`, y
  `TipoDeEscala+Maqamat.swift` y `TipoDeEscala+Dastgah.swift` a `TipoDeEscala+MundoArabe.swift` y
  `TipoDeEscala+Persia.swift`, como las demás tradiciones. `Coral`, `Coral+Realizacion` y `Armonizacion` pasan
  de `Tonalidad/` a una carpeta `Coral/`, y `ModoGregoriano` a `Escalas/Occidentales/`.
- Los mensajes de `ErrorDeLectura` se reparten según lo que se leía: `ErrorDeLectura+Notas`, `+Acordes`,
  `+Escalas` y `+Partitura`, con una función por motivo; `ErrorDeLectura+Idiomas.swift` se queda con los generales
  y el `switch`. Los textos no cambian. Las pruebas de `TextoTests.swift` pasan a `ErroresDeLecturaTests`,
  `NotacionInternacionalTests`, `NotacionesPeninsularesTests`, `NotacionesEuropeasTests` y `TraducidoTests`, y los
  errores de uso de la línea de comandos, a `ErrorDeUso+Consultas`, `+Armonizacion`, `+Trastes`, `+Neorriemann`,
  `+Partituras` y `+Dibujos`, como su ayuda.

### Un solo orden para los idiomas

- Los catorce idiomas van en el mismo orden en todas partes: español, inglés, catalán, gallego, asturiano,
  aragonés, euskera, portugués, francés, occitano, italiano, alemán, griego y ruso. Cambia el orden de los casos
  de `Idioma` y `EscrituraDeNotas`, de `Notacion.allCases` y `Idioma.traducidos`, y el de los argumentos de
  `Traducido(_:_:ca:gl:ast:an:eu:pt:fr:oc:it:de:el:ru:)`, así que una `Traduccion` escrita a mano tiene que
  seguir el orden nuevo. `Traducido.todos` también va en ese orden.

### Idiomas y notación

- `Idioma.codigo` («es», «an», «ast»…) e `Idioma(codigo:)`, que acepta también etiquetas con región
  («ca-ES», «pt_BR»), y `Notacion.delIdioma(_:)`, la notación habitual de un idioma (`.ingles` con #, `.espanol`
  con ♯). La línea de comandos (`--idioma`) y las apps (`Notacion.delSistema`) los usan en lugar de su propia
  tabla de códigos.
- `EscrituraDeNotas.tipografia` es ahora la que manda, y `usaASCII` es `tipografia == .ascii`. No cambia nada
  para quien las usa.
- `Texto/Idiomas.swift` se parte en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`,
  como el resto de ficheros `X+Idiomas.swift`, y `EstiloDeCifrado` pasa a su propio fichero. Los nombres de las
  alteraciones usan `Traduccion`, y los ordinales de los intervalos, una sola función con una tabla por idioma.
- Nombres que no encajaban: en alemán, las alteraciones de cuatro signos son «Vierfachkreuz» y «Vierfach-Be»
  (antes «4 Kreuze» y «4 Be»); en ruso, la nota y la alteración se unen con un solo guion, «си-тройной бемоль»
  (antes «си-тройной-бемоль»; «си-дубль-бемоль» no cambia); en gallego, «tripla aumentada» concuerda con la
  calidad como «triplo sostido» con la alteración (antes «triple aumentada»).

### Temperamentos circulares

- `TemperamentoCircular`: octava pura y doce quintas de tamaños distintos que cierran el círculo, con
  `werckmeisterIII`, `kirnbergerIII`, `vallotti` y `young`. Da los cents de cada clase de altura (`clases`) y su
  desviación del temperamento igual (`desviaciones`), y se puede afinar con otro La4 (`afinar(la4:)`).
- `Temperamento`: el catálogo de las afinaciones que se pueden elegir (igual, pitagórica, mesotónica de ¼ de coma,
  las cuatro circulares y la justa), con `afinacion(tonica:la4:)`, `distingueEnarmonicas` y el nombre en los
  catorce idiomas.

### Tipografía de las alteraciones

- `Tipografia` reúne los estilos de escribir los signos de una alteración: `.unicode` (♯♭), `.ascii` (#b) y
  `.compacta` (𝄪𝄫, con ♮ para el natural). `Alteracion.simbolo(en:)` escribe en cualquiera de ellas;
  `simbolo`, `simboloASCII` y `simboloCompacto` siguen igual. `Notacion.tipografia` y
  `EscrituraDeNotas.tipografia` dicen la de cada notación.

### Alias en griego y en devanagari

- Los 15 dromoi se encuentran también por su nombre en griego (`Escala("Re Χιτζάζ")`, «Ουσάκ», «Ραστ»…), y las
  escalas indias (las 72 melakartas, los janya, los thaats y los ragas indostánicos) por su nombre en
  devanagari («यमन», «मायामालवगौळ», «मोहनम्»).
- Al buscar un nombre en devanagari no se quitan las marcas, que distinguen भैरव (Bhairav) de भैरवी (Bhairavī).

### Exportación a MEI

- `Voz.mei(tonalidad:clave:tempo:titulo:parte:)`, `Coral.mei(…)` y `AnalisisArmonico.mei(…)` escriben la
  partitura en MEI 5 (Music Encoding Initiative), con las mismas opciones que `musicXML`: grafía con barras,
  grupos irregulares y ligaduras, anacrusa, tempo, cifrados en `<harm>` y análisis como letra. Como MEI no
  deduce qué alteraciones se ven, se escriben como en una partitura (valen hasta la barra en su pentagrama y
  su octava, y las de la armadura no se escriben), y la que suena sin escribirse va en `accid.ges`.
- `armonia mei melodia|coral|acordes …` lo da desde la terminal, con las opciones de `armonia musicxml`.

### Las seis escalas cromáticas por ventana de quintas

- `TipoDeEscala.cromatica(desdeLaQuinta:)`: la cromática de las doce quintas seguidas que empiezan en una
  quinta de −6 a −1 desde la tónica, siempre con la escala mayor dentro. Las seis son `cromaticaConCincoBemoles`,
  `cromaticaConCuatroBemoles` (la `cromatica` de siempre, que no cambia), `cromaticaConTresBemoles`,
  `cromaticaConDosBemoles`, `cromaticaConUnBemol` y `cromaticaConCincoSostenidos`, y `cromaticasPorQuintas`
  las da en orden.
- Las cinco nuevas entran en `TipoDeEscala.todos`, detrás de la `cromatica`, con nombre en los catorce idiomas
  («cromática con dos bemoles», «chromatic with two flats», «chromatique à deux bémols»…). También se leen por la
  ventana: «Do cromática −3…8», «Do cromatica -3..8». La `cromatica` gana los alias «cromática con cuatro
  bemoles» y «cromática −5…6».

### Contrapunto de especies

- `Contrapunto`: un cantus firmus en redondas y un contrapunto de la primera a la quinta especie, encima o
  debajo, que se comprueba con las reglas del contrapunto estricto de Fux. `faltas` da cada `FaltaDeContrapunto`
  con su tipo y sus compases (ritmo de la especie, principio y final, disonancias mal tratadas, retardos mal
  resueltos, quintas y octavas paralelas y directas, unísonos, cruces, saltos y notas repetidas), e
  `informe(en:)`, el resumen en los catorce idiomas.
- `Contrapunto(cantusFirmus:contrapunto:especie:)` lee las dos voces como texto; si no duran lo mismo, el
  error es `ErrorDeLectura.Motivo.contrapuntoDeOtraDuracion(redondas:)`.
- `armonia contrapunto <cantus> / <contrapunto> [--especie 1…5]` (en inglés, `counterpoint … --species`)
  escribe el informe.

### Aragonés y asturiano

- Dos idiomas más, `Idioma.aragones` e `Idioma.asturiano`, con sus notaciones `Notacion.aragones` y
  `Notacion.asturiano`: notas en do re mi («fa sosteniu», «fa sosteníu»), alteraciones, intervalos, acordes,
  inversiones, escalas, tonalidades, cadencias, avisos del coral, instrumentos y mensajes de error. Ya son
  catorce. `Traducido` gana los campos `aragones` y `asturiano`, y su `init` los argumentos `an:` y `ast:`
  tras `el:`, así que una `Traduccion` escrita a mano necesita los dos nuevos.
- `Nota(leyendo:)`, `Altura(leyendo:)` y `Encordado(nombre:)` entienden también los nombres en aragonés y
  asturiano («sol sosteníu 4», «baxu»).
- `armonia --idioma an` y `--idioma ast` (o `aragones`, `asturianu`) dan la salida y la ayuda en esos idiomas.

### Nombres traducidos de los instrumentos y las transformaciones

- `Encordado.nombre(en:)`, `Encordado.titulo(en:)` y `TransformacionNeorriemanniana.nombre(en:)` pasan de
  ArmoniaUI a la biblioteca, así que se pueden usar sin las apps: `Encordado.mandolina.nombre(en: .portugues)` es
  «bandolim» y `TransformacionNeorriemanniana.l.nombre(en: .ingles)`, «leading-tone exchange». Los dos tipos son
  `Nombrable`.
- `Encordado(nombre:)` reconoce el nombre del instrumento en los doce idiomas: «guitare», «Gitarre», «гитара»
  o «bandolim» encuentran su encordado. Así, `armonia trastes --instrumento` acepta también esos nombres.
- `Acorde.nombreDeLaInversion(_:en:)` da el nombre de una inversión en cada idioma («primera inversión»,
  «zweite Umkehrung», «первое обращение»), el mismo que usa `Acorde.nombre(en:)`. Llega hasta la sexta inversión
  con palabras; a partir de la séptima, con el número («inversión 7», «7. Umkehrung»).
- `Traducido<Valor>`: un valor en los doce idiomas, como `Traduccion`, que pasa a ser `Traducido<String>`
  (todo lo que la usaba se escribe igual). Sirve para listas por idioma, como los nombres de las inversiones o
  de los puntillos, que antes se repartían por los `case` de un `switch`, y tiene `map(_:)`.
- Dos traducciones corregidas: en ruso, «гитара со строем drop D» (era «с строем»), y en euskera, la
  transformación L es «sentsiblearen aldaketa», con el mismo nombre de la sensible que en los grados.

### Nombres de propiedades más claros

Sin alias: los nombres anteriores dejan de existir.

- En `AcordePivote`, `antes` y `despues` pasan a ser `enLaDePartida` y `enLaDeLlegada` (el mismo acorde leído
  en cada tonalidad), y en `RecorridoTonal`, `tonalidadInicial` y `tonalidadFinal` pasan a ser
  `tonalidadDePartida` y `tonalidadDeLlegada`, como en `AcordePivote`.
- `Intervalo.direccion` pasa a ser `sentido`, como su tipo `SentidoDelIntervalo`, y así también el parámetro de
  `Intervalo(pasosDeQuinta:pasosDeOctava:sentido:)`, `Intervalo(numero:calidad:sentido:)`, `Escala.notas(sentido:)`,
  `alturas(octava:sentido:)`, `contiene(_:sentido:)` y `contieneEnarmonico(_:sentido:)`.
- `TipoDeEscala.descenso` pasa a ser `intervalosDescendentes`, también en su inicializador. Al codificar se sigue
  usando la clave `descenso`, así que lo guardado antes se lee igual.
- `Alteracion.cantidad` pasa a ser `numeroDeSignos`; `ConduccionMinima.total`, `semitonosMovidos`;
  `EstiloDeCifrado.alteracionesASCII`, `tensionesEnASCII` (solo afecta a las tensiones), y
  `Clave.alturaPrimeraLinea`, `alturaDeLaPrimeraLinea`.

### Textos en alemán, occitano, ruso y griego

- Los textos del motor (mensajes de error, intervalos, papeles, grados, claves, figuras, cadencias, faltas de
  conducción, dibujos) y los nombres de los catálogos (tipos de acorde y de escala, instrumentos) están también en
  alemán, occitano, ruso y griego, que antes salían en inglés: `Intervalo.terceraMayor.nombre(en: .aleman)` es
  «große Terz» y `Acorde("Sol7/Si").nombre(en: .ruso)`, «доминантсептаккорд от соль, первое обращение».
  `Notacion.aleman.textos` es `.aleman`, y así con las otras tres.
- `Traduccion` pide también `de:`, `oc:`, `ru:` y `el:`, y `Idioma.traducidos` tiene los doce idiomas.
  Desaparecen `Idioma.deLosTextos` y `Notacion.idiomaDeLosTextos`, que ya no hacen falta. `Traduccion.pluralRuso`
  escoge la forma del plural ruso («3 полутона», «5 полутонов»).
- Las escalas se leen también con el tipo en alemán u occitano («D dorisch», «re lidian»).
- En la línea de comandos, `--idioma de|oc|ru|el` (también `--textos`), con los mensajes y la ayuda en esos
  idiomas.

### Más nombres claros

Sin alias: los nombres anteriores dejan de existir.

- En `Notacion`, `idioma` pasa a ser `idiomaDeLasNotas` y `vocabulario`, `idiomaDeLasAbreviaturas`;
  `idiomaDeLosTextos` desaparece porque es `textos`, y `Notacion(idioma:ascii:)` también: es
  `Notacion(escritura: EscrituraDeNotas(idioma:ascii:))`.
- `Coral.problemas` pasa a ser `Coral.faltas`, como `FaltaDeConduccion`.
- `Posicion` pasa a llamarse `PosicionEnElMastil`, `Direccion` (ascendente o descendente) pasa a llamarse
  `SentidoDelIntervalo` y `PuntoDelTonnetz`, `PuntoDeLaRed`, porque también lo usa la tabla armónica.
- En la línea de comandos, `conduccion` pasa a ser `conduccion-minima` (`minimal-voice-leading`), para no
  confundirla con `conduccion-parsimoniosa`. Dejan de aceptarse los sinónimos que no estaban en la ayuda:
  `--progresion` y `--conjunto` (son `--recorrido` y `--clases`), `tabla-armonica` (es `tabla`) y `neorriemanniano`
  (es `plr`).

### Sin nombres obsoletos

- Desaparecen los nombres que estaban marcados como obsoletos: `Nomenclatura`, `ConduccionDeVoces`,
  `ProblemaDeConduccion`, `Instrumento`, `Razon`, `texto(_:)` (en `RepresentableComoTexto`, `Voz`, `Armonizacion`,
  `MovimientoDeVoz`, `PasoParsimonioso` y `ConduccionMinima`), `Notacion.combinada(notas:textos:)`,
  `EstiloDeCifrado(nomenclatura:…)` y `nomenclatura`, `Tonnetz.conOrtografia`, `Tonnetz.Arista.Intervalo` e
  `intervalo`, `TablaArmonica.Modo` y `modo`, `Tonnetz.disposicion(paso:)` y `TablaArmonica.disposicion(paso:)`, y
  `Digitacion.cifra`. Cada uno tenía ya su nombre nuevo, el que proponía Xcode.
- La línea de comandos deja de aceptar los nombres antiguos de órdenes y opciones: `voces` y `voices` (son
  `revisar` y `check`), `camino` y `path` (son `conduccion-parsimoniosa` y `smooth-path`), `--path` en `tonnetz` y
  `tabla` (es `--sequence`, o `--recorrido`) y `--instrumento` en `midi` (es `--programa`, o `--program`).

### Nombres

Los nombres antiguos estuvieron marcados como obsoletos con `renamed:` y ya se han quitado (ver arriba).

- `Nomenclatura` pasa a llamarse `Notacion`, como la llaman ya los parámetros, el entorno de las apps y
  `SelectorDeNotacion`. `EstiloDeCifrado(nomenclatura:…)` y su propiedad `nomenclatura` pasan a ser
  `EstiloDeCifrado(notacion:…)` y `notacion`. Si no se da `alteracionesASCII`, ahora sigue a la notación
  (`Notacion.usaASCII`): `EstiloDeCifrado(notacion:)`, el estilo básico de cada notación, es el mismo
  inicializador con los valores por omisión.
- `ConduccionDeVoces` pasa a llamarse `Coral` (un valor es un coral; la conducción es lo que se revisa), y
  `ProblemaDeConduccion`, `FaltaDeConduccion`, como las «faltas» de las apps.
- `Instrumento` pasa a llamarse `InstrumentoDePartitura`: es el instrumento tal como se escribe (clave y
  transposición). En las apps y en la línea de comandos, «instrumento» es un `Encordado`.
- `RepresentableComoTexto.texto(_:)` pasa a ser `texto(en:)`, como `nombre(en:)` y `cifrado(en:)`; lo mismo en
  `Armonizacion`, `Voz`, `MovimientoDeVoz`, `PasoParsimonioso` y `ConduccionMinima`. Un tipo propio que
  cumpla `RepresentableComoTexto` tiene que implementar `texto(en:)`.
- `Tonnetz.conOrtografia` pasa a llamarse `tieneOrtografia`, como los demás booleanos (`esCorrecta`…).
- **Cambio incompatible:** `Tonalidad.armonizarACuatroVoces(_:)` devuelve `(armonizacion:, coral:)` en lugar de
  `(armonizacion:, voces:)`. Una etiqueta de tupla no admite alias: `resultado.voces` pasa a ser
  `resultado.coral`.
- Las carpetas `Reticulos` y `Reticulos/Neorriemann` de `ArmoniaRepresentaciones` pasan a ser `Redes` y
  `Redes/Neorriemanniana`, y las pruebas `RejillaHexagonalTests`, `RedesSobreHexagonosTests`; las de
  `ConduccionDeVoces`, `CoralTests`. No cambia ningún módulo.

- El ejemplo vuelve a llamarse `EjemploArmonia` (`Ejemplos/EjemploArmonia`, `swift run EjemploArmonia`), como el
  nuevo `EjemploHexagonos`.

### Código

- `ErrorDeLectura` explica sus motivos con un solo `switch` que devuelve una `Traduccion`, en lugar de uno
  por idioma (de 765 a 458 líneas). Los textos no cambian, y un motivo nuevo no compila sin sus ocho idiomas.
- Los `switch` sobre `Nomenclatura` de `Nota(leyendo:en:)`, `Altura(leyendo:en:)` y `Nota.nombreCompacto(en:)`
  ya no tienen `default`: el compilador avisa al añadir una notación.
- `Nomenclatura` deja de ser un `enum` y pasa a ser un `struct` con dos partes: `escritura`
  (`EscrituraDeNotas`, cómo se escriben las notas) y `textos` (el `Idioma` de los textos). `.espanol`,
  `.ruso`… siguen existiendo como constantes, y `conTextos(en:)`, `notas`, `idioma` e `idiomaDeLosTextos` no
  cambian. Desaparece el caso `.combinada(notas:textos:)`: `Nomenclatura.combinada(notas:textos:)` estuvo
  marcada como obsoleta (ya se ha quitado), y se escribe `Nomenclatura(escritura: .ruso, textos: .espanol)`.
  `esCombinada` dice si los textos van en otro idioma. Los `switch` que antes iban sobre `Nomenclatura` van
  ahora sobre `escritura`, sin `default`. Un `switch` sobre `Nomenclatura` fuera del paquete tiene que pasar a
  `escritura`.

### Notas y textos en idiomas distintos

- `Nomenclatura.conTextos(en:)` combina los nombres de nota de una notación con los textos de otro
  idioma: `Acorde("Sol7/Si").nombre(en: Nomenclatura.ruso.conTextos(en: .espanol))` es «соль séptima de
  dominante, primera inversión». `Nomenclatura` gana el caso `.combinada(notas:textos:)` y la propiedad
  `notas`; `allCases` sigue listando solo las notaciones simples. Los textos siguen `idiomaDeLosTextos`
  en lugar de `idioma`.
- Las apps eligen por separado las notas y los textos en el selector de notación (se guarda como
  «ruso+espanol»), y la línea de comandos tiene `--textos`.

### Escalas en francés, italiano, ruso y griego

- `Escala(leyendo:)` acepta la tónica y el tipo en francés e italiano (`Escala("fa dièse lydien")`), y
  en ruso y griego con los tipos más comunes o con su nombre inglés (`Escala("ре дорийский")`,
  `Escala("до lydian dominant")`).

### Nombres de nota en occitano, ruso y griego

- `Nomenclatura` e `Idioma` tienen `.occitano`, `.ruso` y `.griego`: notas, alteraciones y tonalidades
  se escriben y se leen en esas lenguas (`Nota("Fa#").nombre(en: .ruso)` es «фа-диез»;
  `Tonalidad("Re mayor").nombre(en: .griego)`, «ρε μείζονα»; `Altura("sòl dièsi 2")`, Sol♯2). Las lecturas
  genéricas también las aceptan, sin distinguir tildes griegas ni la ё rusa. Los demás textos salen en
  inglés, como en alemán.

### Textos en portugués, francés e italiano

- Los textos del motor y los nombres de los catálogos salen también en portugués, francés e italiano con esas
  notaciones: antes salían en español (portugués) o en inglés (francés e italiano). `Traduccion` pide ahora ocho
  textos (`pt:`, `fr:`, `it:`), y `idiomaDeLosTextos` solo cambia el alemán, que sigue en inglés. El portugués es el europeo (tónica, meio-tom, traste).
  `Intervalo.terceraMayor.nombre(en: .frances)` es «tierce majeure»; `Escala(.re, .dorico).nombre(en: .italiano)`,
  «re dorico»; `Acorde("Sol7/Si").nombre(en: .portugues)`, «sol sétima de dominante, primeira inversão».
- Las escalas se leen también con su nombre en portugués: `Escala("dó maior")`.
- En la línea de comandos, `--idioma pt|fr|it` y la ayuda en esos idiomas.

### Textos en catalán, gallego y euskera

- Los textos del motor salen en catalán, gallego y euskera con esas notaciones, además de en español e inglés:
  los mensajes de `ErrorDeLectura`, los nombres de intervalos, calidades, consonancias, papeles en el acorde,
  calidades de tríada, grados, funciones tonales, claves, figuras y duraciones, cadencias, faltas de conducción,
  análisis y modulaciones, y los nombres de las pistas MIDI. `Intervalo.terceraMayor.nombre(en: .catalan)` es
  «3a major»; en euskera, «3. handia».
- `Traduccion`: un texto en los cinco idiomas, sin valores por omisión, para que el compilador señale el que falta.
  `Nomenclatura.idiomaDeLosTextos` dice en qué idioma salen: el propio en esos cinco, el inglés en alemán, francés
  e italiano, y el español en portugués.
- Cambia la salida con `.catalan`, `.gallego` y `.euskera`, que antes era en español.
- Los nombres de los catálogos también: tipos de acorde («sèptima de dominant», «dominanteko zazpigarrena»), nombres
  de acorde con su inversión, tipos de escala («dòric», «doriarra»; los nombres tradicionales, como los ragas, no
  cambian), instrumentos de la partitura, ciclos neorriemannianos y los títulos y leyendas de los dibujos SVG. Las
  escalas se leen también en esos idiomas: `Escala("re doriarra")`. `Nomenclatura.vocabulario` queda solo para las
  abreviaturas de los intervalos.
- En la línea de comandos, `--idioma ca|gl|eu|es|en` (o `--language`) escribe las notas, los nombres, las
  etiquetas, los errores y la ayuda en ese idioma. Los nombres de las órdenes y de las opciones siguen en español.

### Cadencias, modulaciones y armonización

- `AnalisisArmonico.cadencias`: las cadencias de la progresión (`Cadencia`, con su `Tipo`: auténtica, plagal, rota
  y semicadencia), dónde están y si la auténtica es perfecta (`esPerfecta`).
- `RecorridoTonal`: parte una progresión en tramos (`TramoTonal`), cada uno en su tonalidad, con sus modulaciones
  (`Modulacion`) y el acorde pivote de cada una (`AcordePivote`: «Lam = vi en Do mayor = ii en Sol mayor»). Una
  tonalidad nueva se confirma con una cadencia auténtica; si no, es una tonicalización y no se parte.
- `Tonalidad.acordes(para:)`: los acordes de la tonalidad que tienen una nota, ordenados por coste.
  `Tonalidad.armonizar(melodia:propuestas:)`: las mejores armonizaciones de una melodía (`Armonizacion`), de menor a
  mayor coste, según la armonía funcional y terminando en cadencia.
- `ConduccionDeVoces.realizar(_:soprano:en:)`: escribe unos acordes a cuatro voces sin ninguna falta de las que
  comprueba `problemas`, moviendo las voces lo menos posible, con el soprano fijado si se da.
  `Tonalidad.armonizarACuatroVoces(_:)` armoniza una melodía y la escribe como coral con la melodía en el soprano.
- En la línea de comandos, `analizar` escribe las cadencias y, sin `--en`, las modulaciones con su pivote;
  `armonizar` (`harmonize`) propone acordes para una melodía y, con octavas, escribe el coral; `realizar`
  (`realize`) escribe unos acordes a cuatro voces.

### Paquetes

- El repositorio tiene un `Package.swift` en la raíz, para usar el motor desde otro proyecto:
  `.package(url: "https://github.com/rododendro1/Tesela.git", branch: "main")`, con los productos `Armonia`
  (y uno por capa), `Hexagonos` y `ArmoniaUI`.
- `import Armonia` ya no reexporta `Hexagonos`: quien nombre sus tipos (`CoordenadaAxial`, `FormasDeMapa`,
  `DireccionHexagonal`…) escribe también `import Hexagonos`. Lo que devuelve el motor no cambia.

### La rejilla hexagonal

El motor depende ahora del paquete `Hexagonos` (rejillas hexagonales).

- `PuntoDelTonnetz.coordenada` y `PuntoDelTonnetz(_:)` pasan de un punto del Tonnetz a una `CoordenadaAxial` y
  de vuelta; `distancia(hasta:)` es la de la rejilla (el resultado no cambia).
- `Tonnetz.trazado(paso:)` y `TablaArmonica.trazado(paso:)` dicen dónde dibuja `svg()` cada nota, y
  `punto(en:paso:)`, qué nota hay bajo un punto del dibujo. Los dos dibujos colocan ya las notas con ellas (el SVG
  es el mismo, salvo algún `-0.0` que pasa a `0.0`). `TablaArmonica.coordenada(de:)` y `punto(de:)` traducen entre
  el Tonnetz y la rejilla de la tabla, que es la misma girada 120°.
- `TecladoIsomorfico`: teclados de botones hexagonales en los que cada dirección sube siempre el mismo intervalo
  (`.tablaArmonica`, `.wickiHayden`, `.janko` o cualquier otro), con la altura de cada casilla, las casillas de una
  altura y su dibujo en SVG.

### Tesela

- El ecosistema se llama Tesela: el repositorio es `rododendro1/Tesela`, el proyecto de
  Xcode, `Tesela.xcodeproj`, el paquete de la raíz, `Tesela`, y los identificadores de las apps empiezan por
  `es.solfa.tesela`. El motor no cambia.
- El paquete de la interfaz es `ArmoniaUI`.

### Nombres de tipos

Los nombres anteriores estuvieron marcados como obsoletos y ya se han quitado.

- `Tonnetz.Arista.Intervalo` pasa a `Tonnetz.Arista.Eje`, y la propiedad `intervalo` a `eje`: son los tres ejes de la
  red (quinta justa, tercera mayor y tercera menor), y el nombre tapaba a `Intervalo` dentro de `Tonnetz`.
- `TablaArmonica.Modo` pasa a `TablaArmonica.Colocacion`, y la propiedad `modo` a `colocacion`: dice cómo se colocaron
  las notas, y «modo» ya es `Tonalidad.Modo`.
- `Razon` pasa a `RazonDeFrecuencias`.

### Terminología

- `Digitacion.cifra` pasa a `tablatura` (el nombre anterior estuvo marcado como obsoleto y ya se ha quitado): «cifra» se
  confundía con el cifrado de los acordes.
- La transformación neorriemanniana P se llama «homónima» en `nombre`, no «paralela»: en español, Do mayor y Do menor
  son tonalidades homónimas, y «paralela» era un calco del inglés. El caso `.p` y la letra no cambian.
- `Tonnetz.disposicion(paso:)` y `TablaArmonica.disposicion(paso:)` pasan a `trazado(paso:)` y devuelven un
  `Trazado`, el nuevo nombre de `Disposicion` en `Hexagonos`. Los nombres anteriores estuvieron marcados como
  obsoletos y ya se han quitado.
- La documentación de `Digitacion.trastesPisados` decía que eran el más grave y el más agudo; son todos los que se
  pisan.

### Carpetas

- El objetivo de pruebas `ArmoniaPruebasExhaustivas` pasa a `ArmoniaExhaustivasTests`, como los demás
  (`swift test --filter "^ArmoniaExhaustivasTests\."`).
- El ejemplo pasa de `Apps/ArmoniaEjemplo` a `Ejemplos/ArmoniaEjemplo`: no es una app.
- Los scripts del motor (`comprobar_modulos.py`, `comprobar_catalogo.py`, `comprobar_enlaces_docc.py` y
  `generar_pruebas_de_documentacion.py`) pasan de `Packages/Armonia/Scripts/` al `Scripts/` de la raíz, junto a los
  demás, y se ejecutan desde la raíz del repositorio.

### La línea de comandos, en inglés de verdad

- Con `--ingles`, `armonia` ya no mezcla idiomas: la ayuda, los mensajes de uso («falta el cifrado…») y las
  etiquetas de la salida («pasos», el nombre del instrumento) salen en inglés. Los textos de la herramienta están en
  `Apps/ArmoniaCLI/Sources/ArmoniaCLI/Textos.swift`, cada uno en los dos idiomas, y `LineaDeComandos.ayuda(en:)`
  devuelve la ayuda en el idioma de la notación.
- `Encordado(nombre:)` acepta también «seven-string guitar», «drop D guitar» y «five-string bass».
- Nombres más claros en `armonia` (los de antes se aceptaron un tiempo y ya se han quitado):
  - `voces` pasa a `revisar` (*check*): busca faltas de conducción, y se confundía con `conduccion`.
  - `camino` pasa a `conduccion-parsimoniosa` (*smooth-path*): «camino» y *path* también nombraban la opción
    `--camino` y el alias inglés de `--recorrido` de `tonnetz` y `tabla`.
  - En `tonnetz` y `tabla`, `--recorrido` es *--sequence* en inglés (antes *--path*).
  - En `midi`, `--instrumento` pasa a `--programa` (*--program*): el instrumento es el de cuerda de `digitaciones`.
  - La inversión de un acorde se escribe con ordinal: «primera inversión» (*first inversion*), no «inversión 1».
- «opción desconocida» lleva siempre comillas: antes, según la orden, salía `--foo`, `«--foo»` o `foo`.

### Digitaciones: dedos, orden y ukelele

- **Dedos.** Nuevos `Digitacion.dedos` (los que hacen falta, como mínimo) y `Digitacion.cejilla` (el traste de la
  cejilla, si la forma la lleva): cada nota pisada pide un dedo, salvo en el traste más bajo, donde el índice pisa
  varias cuerdas a la vez si son seguidas o abarcan cuatro o más. `Mastil.digitaciones` tiene un parámetro nuevo,
  `maximoDeDedos` (4 por defecto). **Cambia el resultado por defecto**: antes se devolvían formas que no se pueden
  tocar (con un modelo de dedos, el 19 % de las de una batería de 32 acordes necesitaba más de cuatro).
- **Orden.** Ya no es «menos abertura, más cuerdas, más cerca de la cejilla», que ponía `8-10-10-0-8-0` por delante de
  `x32010`. Ahora es un coste de comodidad (un punto por traste de posición, dedo y traste de abertura; dos por cuerda
  apagada; uno si falta la quinta de un acorde de cuatro notas o más), y a igual coste, antes la de más cuerdas. En una
  batería de 32 acordes de guitarra, la forma de manual pasa de ser la primera en 16 a serlo en 21 (22 con la quinta
  opcional), y de estar entre las tres primeras en 20 a 30 (31); en una de 10 acordes de ukelele, de 4 a 9 primeras.
  Las cifras salen de una réplica en Python del algoritmo (`TrastesTests` comprueba las mismas formas en Swift).
- **Ukelele y reentrantes.** Nuevo `Encordado.esReentrante`. En esos instrumentos, un acorde en estado fundamental ya
  no exige la raíz en la nota más grave (la cuerda de Do suena más grave que la de Sol): antes no aparecían ni el Sol
  `0232`, ni el Fa `2010`, ni el La menor `2000`. Un acorde con bajo propio (`Do/Mi`) sigue exigiéndolo.
- La quinta sigue siendo obligatoria por defecto (`exigirQuinta: true`); la línea de comandos y la aplicación la piden
  opcional, como se toca (el Do7 de manual, `x32310`, no la tiene).
- Corregido un `guard let` que redeclaraba una variable del mismo ámbito en `digitaciones` (no compilaba).

### Plataformas y entradas inválidas

- `Armonia` declara `platforms: [.macOS(.v13), .iOS(.v16)]`, como las apps y `ArmoniaUI`. `ArmoniaCLI` y `ArmoniaEjemplo`
  declaran macOS 13: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de uno con un mínimo más alto.
- Nuevos inicializadores que devuelven `nil` en vez de detener el programa: `Duracion(comprobando:_:)` y
  `Duracion(comprobando:puntillos:)` (denominador 0; puntillos fuera de 0…30), `Compas(comprobando:_:agrupacion:)` y
  `Tempo(comprobando:unidad:)`. Los inicializadores de siempre siguen deteniendo el programa ante un error de
  quien llama, y ahora lo dicen en su documentación. `BaseDeHewlett(alteracionMaxima:)` toma un número negativo como 0.
- MusicXML y MIDI solo se exportan (no se leen), y los analizadores de texto validan: hoy ningún dato de entrada puede
  llegar a esas precondiciones.

### Renombrado

- El paquete `ArmoniaMusical` pasa a llamarse `Armonia` (carpeta `Packages/Armonia`), como su producto principal y su
  módulo paraguas. `import Armonia` no cambia; en un `Package.swift` ahora es
  `.package(path: "…/Packages/Armonia")` y `.product(name: "Armonia", package: "Armonia")`. En Xcode, el esquema de todo
  el paquete pasa de `ArmoniaMusical-Package` a `Armonia-Package`.
- `Apps/LineaDeComandos` pasa a `Apps/ArmoniaCLI`: el paquete, su biblioteca (antes `ArmoniaLineaDeComandos`, ahora
  `ArmoniaCLI`) y sus pruebas (`ArmoniaCLITests`). El ejecutable sigue siendo `armonia`, y el tipo `LineaDeComandos`
  conserva su nombre.
- `Apps/EjemploArmonia` pasa a `Apps/ArmoniaEjemplo` (`swift run ArmoniaEjemplo`).
- Las entradas anteriores de este registro conservan los nombres de su época.

### Eliminado

- Los nombres anteriores de la API, que llevaban una versión marcados como obsoletos (`Armonia/Obsoletos.swift`):
  `quintas`, `octavas`, `quintasConSigno`, `octavasConSigno` y `NotaNatural.quintasBase`, los inicializadores
  `(quintas:octavas:)` y `TipoDeAcorde(quintas:)`/`(comprobandoQuintas:)`, `simpleAscendente(quintas:)`,
  `EstructuraDeAcorde.quintas`, `Altura.octavaCientifica`, `TipoDeAcorde.quinta`, `CalidadDeTriada.quinta`,
  `Intervalo.quinta`, `NombreDeGrado.submediante`, `Intervalo.oncena`/`oncenaAumentada`/`trecenaMenor`/`trecenaMayor`
  y `TipoDeAcorde.dominanteOncena`/`menorSeptimaOncena`/`dominanteTrecena`. Cada uno tiene su equivalente nuevo en la
  tabla de «Nombres nuevos», más abajo. Al leer texto se siguen aceptando «oncena», «trecena» y «submediante».
  `PuntoDelTonnetz.quintas` no cambia: es otra cosa.
- Los dos tests que solo comprobaban que esos alias seguían funcionando, y `Obsoletos.swift` como fichero permitido en
  el módulo paraguas (`Scripts/comprobar_modulos.py`).

### Mástil y digitaciones

- `Mastil(_:trastes:)` toma un número negativo de trastes como 0 en vez de detener el programa.
- Nuevos `Mastil.midiSiExiste(en:)` y `alturaSiExiste(en:preferirBemoles:)`, que devuelven `nil` para una posición
  que no está en el mástil. `midi(en:)` y `altura(en:)` siguen deteniendo el programa en ese caso (error de quien
  llama); ahora lo dicen en su documentación y remiten a las nuevas.
- Nuevos `Digitacion.init?(comprobando:en:)` e `init?(leyendo:en:)` (lee la cifra de `cifra`: «x32010»,
  «x-10-12-12-11-10»), que devuelven `nil` si los trastes no encajan en el mástil. `Digitacion(mastil:trastes:)`
  sigue deteniendo el programa si no hay un traste por cuerda.
- Nuevo `Digitacion.notas(para:)`: las notas que suenan, escritas como las escribe el acorde (Si♭, no La♯).
- Nuevo `Encordado(nombre:)`: busca un instrumento por su nombre, sin tildes ni mayúsculas («ukulele», «drop D»,
  «bajo de 5 cuerdas», «bass»…).
- Nuevo artículo de DocC, `Trastes`, con sus ejemplos entre las pruebas de documentación.
- Corregido un cierre de `Digitacion.digitaciones` que no compilaba (`$0` dentro de un cierre con parámetros
  explícitos).

### Herramientas

- Nuevo `Scripts/comprobar_enlaces_docc.py` (lo ejecuta el CI): los enlaces ``Tipo`` y `<doc:Articulo>` del
  catálogo apuntan a algo que existe. Y, en la raíz, `Scripts/comprobar_higiene.py`: sin caracteres invisibles,
  tabuladores ni espacios al final, scripts ejecutables que compilan.
- Nuevo `Scripts/compilar_todo.sh` (en la raíz del repositorio): compila y prueba por capas, módulo a módulo
  en el orden de sus dependencias, con un log por paso.
- La herramienta de línea de comandos tiene una orden nueva, `armonia digitaciones`
  (`--instrumento`, `--limite`, `--traste`, `--dedos`, `--completo`, `--tab`), que indica los dedos y la cejilla de
  cada forma.
- `Scripts/comprobar_higiene.py` detecta además un `guard let x` que redeclara un `let x` del mismo ámbito.

### Organización interna (la API pública no cambia)

- La carpeta del ejecutable pasa de `Sources/armonia` a `Sources/ArmoniaEjecutable`: en sistemas de
  ficheros que no distinguen mayúsculas (macOS, Windows) chocaba con `Sources/Armonia`. El producto
  sigue llamándose `armonia` (`swift run armonia`). El CI comprueba que ninguna ruta del
  repositorio se repita al ignorar mayúsculas.
- Los catálogos de escalas se reparten en un fichero por tradición (`Escalas/Tradiciones/`) y por
  tema (`Escalas/Occidentales/`). Los tipos y sus nombres son los mismos y `todos` conserva el orden
  (del que depende qué escala gana al identificar).
- Nuevo `Scripts/comprobar_catalogo.py`, que el CI ejecuta: falla si una escala declarada no está en
  `todos` ni en una lista de tradición, si una lista repite una escala, o si una escala de `todos` no
  tiene nombre inglés en `internacionales`.
- La herramienta de línea de comandos se reparte en una extensión por grupo de órdenes
  (`LineaDeComandos+Consultas`, `+Partituras`, `+Dibujos`, `+Neorriemann`).
- `ConduccionDeVoces` pasa de `Partitura/` a `Tonalidad/`, y `Neorriemann/` (transformaciones, ciclos
  y conducción parsimoniosa) de `Acordes/` a `Representaciones/`, junto al Tonnetz del que depende.
  Las extensiones de `Candidato` para `Acorde` y `Tonalidad` pasan a las carpetas de esos tipos.
- `Texto/Idiomas.swift` conserva los nombres de los tipos del núcleo; los de `Tonalidad`, `PapelEnAcorde`,
  `CalidadDeTriada`, `NombreDeGrado`, `Clave`, `Figura`, `Duracion` y `CorrespondenciaDeColores` pasan a
  un fichero `X+Idiomas.swift` junto a cada tipo, de modo que el núcleo ya no depende de las capas
  superiores. Para añadir un idioma, el compilador señala los `switch` sobre `idioma` que falten.
- La biblioteca se reparte en módulos por capas, y `Armonia` los reexporta: `ArmoniaNucleo`
  (Fundamentos, Texto, Postonal), `ArmoniaTeoria` (Acordes, Escalas, Tonalidad), `ArmoniaRepresentaciones`
  `ArmoniaPartitura` y `ArmoniaTrastes`. `import Armonia` da la misma API pública que antes, y cada capa es también un producto
  (`import ArmoniaTeoria`). Lo que era interno y se usa entre capas pasa a `package`: no se añade a la API pública.
  El paquete se llama ahora `ArmoniaMusical`; el producto y el módulo `Armonia` no cambian.
- La herramienta de línea de comandos (`armonia`, con sus pruebas) y `EjemploArmonia` salen del paquete a
  `Apps/LineaDeComandos` y `Apps/EjemploArmonia`, cada uno con su `Package.swift`. El paquete queda solo con la
  biblioteca; `swift run armonia` y `swift run EjemploArmonia` se ejecutan ahora desde esas carpetas.
- Nuevo módulo `ArmoniaTrastes` (y producto del mismo nombre), reexportado por `Armonia`: `Encordado` (guitarra, bajo,
  ukelele, mandolina…), `Mastil` con `Posicion` (dónde suena una nota o una escala) y `Digitacion` (formas de tocar un
  acorde, con `Mastil.digitaciones(de:)`). Depende de `ArmoniaNucleo` y `ArmoniaTeoria`, como Representaciones y Partitura.
- `Scripts/comprobar_capas.py` se sustituye por `Scripts/comprobar_modulos.py`, que el CI ejecuta: comprueba las
  dependencias declaradas en `Package.swift`, las importaciones y los tipos que cada módulo usa de los demás.
- Nuevo `Scripts/comprobar_catalogo.py`, que el CI ejecuta: falla si una escala declarada no está en
  `todos` ni en una lista de tradición, si una lista repite una escala, o si una escala de `todos` no
  tiene nombre inglés en `internacionales`.
- `Partitura/` se divide en `Modelo/` y `Formatos/`, y `Representaciones/` en `Afinacion/`, `Color/`, `Reticulos/` y
  `Dibujo/`. `Escalas/TipoDeEscala.swift` se reparte en cuatro ficheros. Solo se mueve texto: ningún tipo ni nombre cambia.

## Versión 5

Probada en Linux con Swift 5.9, 5.10, 6.0 y 6.1 (y concurrencia estricta en Swift 6).

### Para actualizar desde la versión 4

Casi todo lo que cambia de nombre sigue compilando: los nombres antiguos están en
`Sources/Armonia/Obsoletos.swift`, marcados como obsoletos, y el compilador avisa y propone el
nombre nuevo (Xcode lo cambia con un clic). Desaparecerán en la próxima versión.

Hay dos cambios que **no avisan** y conviene revisar a mano:

1. **`print` de una `Duracion` da su nombre.** `"\(Duracion(.negra, puntillos: 1))"` era `"4."`
   y ahora es `"negra con puntillo"` (la duración nula es `"cero"`). Si usabas la descripción para
   escribir ritmos que luego se leen, usa `duracion.texto`, que sigue dando `"4."` y `"5/8"`.
2. **El inicializador opcional desde texto se llama `init?(texto:)`.** En la versión 4 era
   `init?(_:)`, pero por SE-0213 `Acorde("Sol7")` con un literal nunca lo usaba (crea el valor
   directamente, sin opcional), y con una variable no compilaba. Ahora:
   - con un literal: `Acorde("Sol7")` o `let a: Acorde = "Sol7"`, sin cambios;
   - con texto del usuario: `Acorde(texto: entrada)` devuelve `nil` si no se puede leer;
   - para saber por qué no se puede leer: `try Acorde(leyendo: entrada)`.

### Nombres nuevos

| Antes | Ahora |
|---|---|
| `Nota.quintas`, `Altura.quintas`, `Intervalo.quintas`, `Alteracion.quintas` | `pasosDeQuinta` |
| `Altura.octavas`, `Intervalo.octavas` | `pasosDeOctava` |
| `Nota(quintas:)`, `Altura(quintas:octavas:)`, `Intervalo(quintas:octavas:direccion:)` | `(pasosDeQuinta:pasosDeOctava:…)` |
| `quintasConSigno`, `octavasConSigno` | `pasosDeQuintaConSigno`, `pasosDeOctavaConSigno` |
| `NotaNatural.quintasBase` | `pasosDeQuintaBase` |
| `Intervalo.simpleAscendente(quintas:)` | `simpleAscendente(pasosDeQuinta:)` |
| `TipoDeAcorde.quintas`, `TipoDeAcorde(quintas:)`, `TipoDeAcorde(comprobandoQuintas:)` | `pasosDeQuinta`, `(pasosDeQuinta:)`, `(comprobandoPasosDeQuinta:)` |
| `EstructuraDeAcorde.quintas` | `quintasDelAcorde` |
| `Altura.octavaCientifica` | `octava` (como en `Altura(.do, octava: 4)`) |
| `TipoDeAcorde.quinta`, `CalidadDeTriada.quinta` (acorde de potencia) | `potencia` |
| `Intervalo.oncena`, `oncenaAumentada`, `trecenaMenor`, `trecenaMayor` | `undecima`, `undecimaAumentada`, `decimoterceraMenor`, `decimoterceraMayor` |
| `TipoDeAcorde.dominanteOncena`, `menorSeptimaOncena`, `dominanteTrecena` | `dominanteUndecima`, `menorSeptimaUndecima`, `dominanteDecimotercera` |
| `Intervalo.quinta` | `quintaJusta` |
| `NombreDeGrado.submediante` | `superdominante` |

Al leer texto se siguen aceptando «oncena», «trecena» y «submediante».

Los nombres que escribe la biblioteca también cambian: el papel en el acorde es «undécima» y
«decimotercera» (antes «oncena» y «trecena»), y los tipos de acorde, «undécima», «menor
undécima», «decimotercera» y «menor decimotercera».

### Correcciones

- El paquete no compilaba: los inicializadores opcionales desde texto chocaban con los literales
  (SE-0213), había dos `switch` sobre opcionales en `EstructuraDeAcorde` que el compilador rechazaba y una
  expresión en `Escala.alturas` que el compilador no podía resolver.
- `TipoDeEscala.melakartasCompatibles` comparaba semitonos y aceptaba escalas con otra ortografía;
  ahora compara las notas.
- La identificación de acordes ya no propone lecturas sin tercera, sin suspensión y sin quinta.
- Los cifrados con paréntesis anidados, sin cerrar o cerrados de más (`Do7((b9))`, `Do7(b9`,
  `Do7)`) se rechazan con un error en lugar de leerse a medias.
- No se mezclan idiomas: la tónica en español va con el tipo en español («Re dórico», «D dorian»,
  pero no «Re dorian»), y el bajo de un acorde se escribe como su fundamental («Sol7/Si», «G7/B»,
  pero no «Sol7/B»).

### Novedades

- **Análisis de progresiones**: `AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")` da
  «I–vi–V7/V–V7–I en Do mayor», con la función de cada acorde (tónica, subdominante, dominante)
  y su categoría: diatónico, dominante o sensible secundaria, napolitana, préstamo del modo
  homónimo o cromático. Cifra las inversiones (I6, V65) y, si no se le da, elige la tonalidad.
  La sexta añadida se cifra «iii(add6)», para no confundirla con la primera inversión, y los
  acordes invertidos que no son tríadas ni séptimas llevan los intervalos sobre el bajo
  («IV(add6)643»). Reconoce las sextas aumentadas italiana, francesa y alemana («It+6», «Fr+6»,
  «Ger+6»), escritas desde el ♭6̂ (`La♭(♯6)`), desde otra nota (`Re7(♭5)/La♭`) o, la alemana,
  como séptima de dominante que va a la dominante (`La♭7`), y la napolitana invertida («♭II6»,
  «♭II64»). Al leer la progresión, las comas de dentro de un paréntesis son del cifrado.
  También `tonalidad.analizar(acordes)` para una tonalidad conocida.
- **Conducción de voces**: `ConduccionDeVoces(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5").problemas`
  señala quintas y octavas paralelas y directas, cruces, superposiciones, separación excesiva,
  saltos no melódicos y notas fuera de tesitura, con las voces y los acordes donde ocurren.
- **Exportación a MusicXML**: `voz.musicXML(tonalidad:clave:tempo:titulo:)` escribe una melodía
  (con ligaduras, barras, puntillos, tresillos y demás grupos irregulares, anacrusa, armadura,
  clave y tempo) y `conduccion.musicXML(duracion:compas:)`, un coral a cuatro voces en dos
  pentagramas, y `analisis.musicXML()`, una progresión con los cifrados americanos encima (como
  símbolos de acorde que el editor reconoce) y el cifrado romano y la función debajo; el coral
  también puede llevarlos (`cifrados: true, analisis: true`). Los documentos se validan con el esquema oficial de MusicXML 4.0 y se abren en
  MuseScore, Finale, Sibelius o Dorico. Desde la terminal, `armonia musicxml melodia …` y
  `armonia musicxml coral …` y `armonia musicxml acordes Do Lam Re7 Sol7 Do`.
- **Exportación a MIDI**: `voz.midi(tempo:titulo:instrumento:)`, `coral.midi(duracion:)` y
  `analisis.midi()` escriben ficheros MIDI estándar (formato 1) para oír melodías, corales y
  progresiones: tempo, compás, armadura, una pista por voz con su nombre e instrumento General
  MIDI, ligaduras como una sola nota, grupos irregulares exactos y un marcador por acorde con su
  cifrado. Desde la terminal, `armonia midi melodia|coral|acordes … > fichero.mid`.
- **Grafía de las figuras con puntillo**: `voz.grafia` (y con ella el MusicXML) escribe entera la
  figura con puntillo que empieza en un pulso de un compás simple, sin ocultar la mitad del 4/4:
  la negra con puntillo del 1.er o del 3.er tiempo ya no sale como negra ligada a corchea. En 6/8
  no se cruza el grupo de tres corcheas. En los compases de amalgama (5/8, 7/8, 3+2+2/8) no se
  oculta el paso entre grupos de distinto tamaño (el 7/8 entero es blanca ligada a negra con
  puntillo), y el silencio de todo un compás queda entero.
- **Herramienta de línea de comandos `armonia`**: `armonia acorde Sol7/Si`, `armonia identificar
  Do Mi Sol Sib`, `armonia intervalo Do4 Mi5`, `armonia escala Re dórico`, `armonia tonalidad
  La menor`, `armonia analizar Do Lam Re7 Sol7 Do` y `armonia voces …`; con `--ingles`, en
  notación inglesa.
- **Más escalas occidentales** en `TipoDeEscala.todos`: los seis modos de la mayor armónica
  (dórico ♭5, frigio ♭4, lidio ♭3, mixolidio ♭2, lidio aumentado ♯2, locrio ♭♭7), doble
  armónica, menor y mayor húngaras, napolitanas menor y mayor, enigmática, persa, mayor locria,
  lidio menor, Prometeo, disminuida semitono-tono, aumentada, blues mayor, egipcia, cromática,
  flamenca, Petrushka, bebop menor melódica y menor armónica, los modos 3 a 7 de Messiaen, los
  modos de la doble armónica y de las napolitanas, cuatro pentatónicas del jazz (dominante,
  menor 6, mayor ♭6 y menor ♭5), la blues de nueve notas, la blues menor con 2ª y el hexacordo,
  la argelina, con sus nombres en inglés. `Escala.identificar` y `rotacion` las tienen en cuenta: el modo 2
  de la pentatónica mayor es ahora la egipcia. Más nombres para las que ya estaban: acústica o
  de Bartók, menor rumana, dominante ♭9 ♭13, mayor melódica, gitana española, Tcherepnin (modo 3 de
  Messiaen) y las auxiliares de la cromática lidia de Russell.
- **Escalas chinas y japonesas**: los cinco modos pentatónicos chinos (Gōng, Shāng, Jué, Zhǐ,
  Yǔ) y las escalas Qīngyuè, Yǎyuè y Yànyuè; las japonesas Ritsu, Ryo, Yō, Min'yō, Miyakobushi,
  In, Insen, Iwato, Hirajōshi, Kumoijōshi y Ryūkyū. Los nombres llevan sus diacríticos (tonos
  del pinyin, macrones del Hepburn) y se leen también sin ellos y en chino o japonés:
  `Escala("Do hirajoshi")`, `Escala("Do 平調子")`. También Akebono y Kokin-jōshi.
- **Escalas etíopes, maqamat, de Indonesia y klezmer** (en `TipoDeEscala.tradicionales`): los
  qenet Təzəta, Bati, Ambassäl y Ančihoye; los maqamat temperados Ḥijāz, Nahāwand, Kurd, ʿAjam,
  Ḥijāzkār y Nawā Athar; Pélog selisir y Sléndro, aproximadas; y los modos klezmer Freygish,
  Misheberakh, Adonai Malakh y Magen Avot. Con su transliteración y diacríticos, y sin ellos
  como alias. Al buscar por nombre, un nombre gana a un alias: «Hijaz» es ahora el maqam Ḥijāz
  (el dromos sigue siendo Hitzáz o Hicaz; las notas son las mismas).
- **Más escalas de otras tradiciones** (en `TipoDeEscala.tradicionales`): ragas indostánicos
  (Bhūpālī, Mālkauns, Durgā, Śivarañjanī, Kalāvatī, Candrakauns, Megh, Yaman, Bāgeśrī y Deś), los
  janya Revati y Amṛtavarṣiṇī, los dastgāh Māhur, Homāyun y Čahārgāh (estos dos, aproximados),
  las coreanas P'yŏngjo y Kyemyŏnjo, la pentatónica y la tritónica andinas, y los tetracordos y
  harmoniai de la Grecia antigua (diatónicos y cromáticos).
- **Más escalas occidentales** en `TipoDeEscala.todos`: los modos de la mayor húngara
  (ultralocrio ♭♭6, menor armónica ♭5, superlocrio ♮6, menor melódica ♯5, dórico ♭2 ♯4, lidio
  aumentado ♯3), las hexatónicas gaélicas (jónico sin 4ª, mixolidio sin 3ª, dórico sin 6ª, eólico
  sin 2ª), las hexatónicas mayor y menor de dos tríadas, las pentatónicas mixolidia, lidia y
  escocesa, y la mayor rumana. Al identificar Do Mi Sol Si Fa♯, la primera es ahora Do
  pentatónica lidia, que tiene exactamente esas notas, y la segunda, Sol mayor. Más nombres:
  nordestina (lidio dominante) y los de compositor (de Liszt, de Rimski-Kórsakov, de Debussy, de
  Weitzmann).
- **`ModoGregoriano`**: los ocho modos del canto gregoriano con su final, su tenor y su ámbito:
  `ModoGregoriano(2)` es el protus plagal o hipodórico (final Re, tenor Fa, ámbito La3–La4), y
  también se busca por nombre: `ModoGregoriano(nombre: "hipofrigio")`.
- **Tonnetz**: `Tonnetz(acorde)`, `Tonnetz(escala)`, `Tonnetz(notas)` o `Tonnetz(conjunto)`
  colocan las notas en la red de quintas y terceras, en la disposición más compacta (se prueban
  todas), conservando la
  ortografía (Fa♯ y Sol♭ caen en puntos distintos); `triadas` da los triángulos mayores y menores
  completos y `svg()` dibuja la red. Desde la terminal, `armonia tonnetz --acorde Domaj7`.
- **Transformaciones neorriemannianas**: `Acorde("Do").transformar(.r)` da Lam, y
  `transformar(leyendo: "PLR")` aplica una secuencia (también N, S y H), conservando la
  ortografía. `Tonnetz.camino(desde: "Do", hasta: "Mibm")` da el camino más corto ([P, R, P]) y
  `Tonnetz(recorrido: ["Do", "Lam", "Fa"])` dibuja una progresión con flechas de triángulo a
  triángulo (curvas y separadas cuando el recorrido va y vuelve). Los ciclos hexatónico,
  octatónico y LR (`Acorde("Do").ciclo(.hexatonico)`, `Tonnetz(ciclo:desde:)`) se escriben con la
  ortografía más sencilla y se dibujan como una banda de triángulos. Desde la terminal, `armonia plr Do PLR`, `armonia plr Do Mibm`,
  `armonia plr Do hexatonico` y `armonia tonnetz --recorrido Do Lam Rem Sol Do`.
- **Conducción parsimoniosa**: `Acorde("Sol7").vecinosParsimoniosos()` da los acordes a un
  semitono (Sol♯°7, Solm7, Mim7) entre séptimas de dominante, menores, semidisminuidas y
  disminuidas (las «Power Towers» de Douthett y Steinbach) o entre tríadas mayores, menores y
  aumentadas (el «Cube Dance»); con `voces: 2`, moviendo dos voces (Sol7 → Re♭7). Los maj7
  tienen su propia familia, `familiaDeSeptimasAmpliada` (las «Power Towers» con maj7): Domaj7
  pasa a Do7 y a Do♯ø7.
  `Tonnetz.caminoParsimonioso(desde:hasta:)` da el camino más corto y
  `conduccionMinima(hasta:)`, la conducción con menos semitonos entre acordes cualesquiera
  (Sol7 → Do: 4). Desde la terminal, `armonia vecinos`, `armonia camino` y `armonia conduccion`.
- **Título y leyenda en los dibujos**: los SVG del Tonnetz y de la tabla armónica llevan
  encima el acorde, la escala o la progresión, y debajo una leyenda con lo que aparece (notas,
  tríadas mayores y menores, intervalos, contorno, tónica o fundamental, pasos del recorrido), en
  español o en inglés. `svg(titulo:leyenda:)` los cambia o los quita.
- **Tabla armónica**: `TablaArmonica` coloca notas, acordes, escalas, conjuntos de clases de altura
  o alturas en la disposición en hexágonos de los teclados isomórficos (quinta hacia arriba,
  terceras en diagonal) y `svg()` la dibuja con el contorno de la forma y un punto en cada tríada.
  Con alturas, cada hexágono es una altura concreta, como en el instrumento. También dibuja
  recorridos de tríadas con flechas (`TablaArmonica(recorrido:)`, `TablaArmonica(caminoDesde:hasta:)`)
  y ciclos neorriemannianos (`TablaArmonica(ciclo:desde:)`).
  Desde la terminal, `armonia tabla --acorde Domaj7`, `armonia tabla Do3 Sol3 Mi4`,
  `armonia tabla --recorrido Do Lam Fa Rem` o `armonia tabla --ciclo octatonico Do`.
- **Portugués**: nombres de notas (dó, ré, mi, fá…), alteraciones («sustenido», «bemol», «duplo
  sustenido»…) y modos («maior», «menor»).
- **Errores en inglés**: `ErrorDeLectura` explica el error en inglés cuando se lee con una
  notación inglesa (`descripcion(en:)`), y sus motivos son tipos concretos
  (`ErrorDeLectura.RechazoDeAcorde`, `CalidadesIncompatibles`) en lugar de texto.
- **Pruebas de la documentación**: `Scripts/generar_pruebas_de_documentacion.py` convierte los
  ejemplos del README y del catálogo DocC en pruebas que comprueban el resultado escrito en cada
  comentario. El CI comprueba que estén al día (`--comprobar`).
- **Pruebas nuevas**: ida y vuelta al azar en todas las notaciones (con semilla fija), casos que
  se deben rechazar y nombres obsoletos.
