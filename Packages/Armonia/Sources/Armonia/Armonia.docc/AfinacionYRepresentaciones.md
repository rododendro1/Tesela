# Afinación y otras representaciones

Temperamentos, afinación justa, numeraciones de Hewlett, colores de las notas, el Tonnetz y la tabla armónica.

## Afinaciones

```swift
TemperamentoRegular.igual                    // quinta de 700 cents
TemperamentoRegular.pitagorico               // quintas puras
TemperamentoRegular.mesotonicoCuartoDeComa   // terceras mayores puras
TemperamentoRegular.igual(divisiones: 31)    // la octava dividida en 31 partes iguales
AfinacionJusta(tonica: .do)                  // razones 1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8
Altura("Sol#4").frecuencia(en: TemperamentoRegular.mesotonicoCuartoDeComa)   // más grave que La♭4
Intervalo.terceraMayor.razonJusta            // 5/4
TemperamentoRegular.igual.cents(de: .terceraMayor)       // 400
AfinacionJusta(tonica: .do).desviacion(de: "Mi4")        // −13,69 cents
```

En un temperamento regular cada nota se afina con su coordenada de quintas:
`cents = quintas · quinta + octavas · 1200`. Por eso Sol♯ y La♭, distintos en el motor,
también suenan distintos en el mesotónico.

### Temperamentos circulares

Los «buenos temperamentos» del Barroco reparten la coma pitagórica entre unas pocas quintas y
dejan puras las demás. Todas las tonalidades se pueden tocar, pero cada una suena con su color.
`TemperamentoCircular` guarda las doce quintas, desde Do–Sol, y afina cada nota por su número
MIDI, así que las enarmónicas suenan igual:

```swift
let werckmeister = TemperamentoCircular.werckmeisterIII     // Do–Sol, Sol–Re, Re–La y Si–Fa♯, ¼ de coma más estrechas
werckmeister.desviaciones[4]                                  // −9,78: Mi, respecto al temperamento igual
werckmeister.frecuencia(de: "Sol#4") == werckmeister.frecuencia(de: "Lab4")   // true
TemperamentoCircular.kirnbergerIII.cents(desde: "Do4", hasta: "Mi4")      // 386,31: la tercera pura
TemperamentoCircular.vallotti.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4")       // 415
TemperamentoCircular(nombre: "mío", quintas: Array(repeating: 701, count: 12))   // nil: no cierra el círculo
```

`TemperamentoConNombre.paraEscuchar` reúne las afinaciones más conocidas del catálogo (igual, pitagórico, mesotónico
de ¼ de coma, Werckmeister III, Kirnberger III, Vallotti, Young y la afinación justa), con su nombre en cada idioma,
para elegir una; es lo que usa el botón «Escuchar» de las apps:

```swift
TemperamentoConNombre.paraEscuchar.count                                        // 8
TemperamentoConNombre.afinacionJusta.afinacion(tonica: .re)?.desviacion(de: "Fa#4")   // −13,69
TemperamentoConNombre.mesotonicoCuartoDeComa.distingueEnarmonicas               // true
TemperamentoConNombre.vallotti.nombre(en: .conPalabras(.ruso))                  // "Валлотти"
```

### El catálogo de temperamentos

``TemperamentoConNombre`` reúne en un catálogo los temperamentos y los sistemas de afinación: los regulares (el
igual, el pitagórico y cinco mesotónicos), los circulares del Barroco, la afinación justa, las octavas en 19, 22, 31 y
41 partes iguales y los sistemas de otras tradiciones (los cuartos de tono, el koron y el sori, las 53 comas turcas,
los 72 moria y los 22 śruti). Cada uno tiene su familia (``FamiliaDeTemperamento``), su autor, su año, sus
referencias y su nombre en los trece idiomas, y da los cents de cada paso de su octava.
``EstadisticasDeTemperamento`` mide sus pasos, lo que se apartan de las razones justas (``AproximacionJusta``) y, en
los de doce notas, la quinta del lobo y las terceras mayores:

```swift
TemperamentoConNombre.catalogo.count                                     // 22
TemperamentoConNombre.buscar(nombre: "meantone") == .mesotonicoCuartoDeComa   // true
TemperamentoConNombre.comas53.pasosPorOctava                             // 53
TemperamentoConNombre.divisiones31.autor                                 // "Christiaan Huygens"
TemperamentoConNombre.paraEscuchar.contains(.vallotti)                   // true
TemperamentoConNombre.temperamentoIgual.estadisticas.uniforme             // true
```

### El catálogo de notas

``NotaConNombre`` reúne las notas con nombre propio: los diapasones (el La 440, el La 415 barroco, el La 435 del
diapasón normal francés, el Do 256 científico…), las notas de referencia (el Do central, las notas extremas del piano
y del MIDI), las veinte posiciones de la mano guidoniana y las alturas con nombre de otras tradiciones, que salen de
``NombresPorOctava``: las notas árabes, las perde turcas y las cuerdas del sistema perfecto griego. Cada una tiene su
familia (``FamiliaDeNota``), su altura, lo que se aparta en cents de la temperada, su frecuencia, sus referencias y su
nombre en los trece idiomas. Si dos nombres se leen igual (Rāst y la perde Rast; E la mi, la grave y la aguda), la
segunda lleva su altura: «Rast (Sol4)».

```swift
NotaConNombre.la415.frecuencia                          // 415
NotaConNombre.buscar(nombre: "middle C") == .doCentral   // true
NotaConNombre.buscar(nombre: "Sikah")?.desvio            // -50
NotaConNombre.buscar(nombre: "Segâh")?.desvio            // -13,21: una koma bajo Si, en comas de 1200/53 cents
NotaConNombre.do256.frecuenciaDelLa4                     // 430,54
NombresPorOctava.griegoAntiguo.alturas[7].notaConNombre  // mésē
```

``FuncionDeNota`` es el catálogo del papel que hace una nota: los grados de la escala (los de ``NombreDeGrado``), la
finalis, el tenor y la confinalis del modo gregoriano, el sa, el pa, el vādī, el saṃvādī y el nyāsa del rāga, el
qarār, el ghammāz y el yeden del maqam y el makam, las tres blue notes, cuatro adornos y las notas extrañas al acorde
(las de `NotaExtrana`, en Polifonia, que tiene su `funcion`). Cada una tiene su familia
(``FamiliaDeFuncionDeNota``), sus referencias, su nombre en los trece idiomas y, si es siempre el mismo, su intervalo
desde la tónica, con lo que se aparta del temperado:

```swift
FuncionDeNota.dominante.nota(sobre: .re)                 // La
FuncionDeNota.terceraBlue.cents                          // 350: la tercera neutra
FuncionDeNota.septimaBlue.desvio                         // -31,17: la séptima armónica, 7/4
FuncionDeNota.buscar(nombre: "leading tone") == .sensible   // true
NombreDeGrado.subdominante.funcion == .subdominante      // true
FuncionDeNota.tenor.intervalo                            // nil: cambia de un modo a otro
```

### Escalas y afinaciones

Una escala con microtonos (``TipoDeEscalaMicrotonal``, en <doc:EscalasDelMundo>) se puede oír como es:
`Escala.afinacion(la4:microtonal:sentido:)` da una ``AfinacionDeEscala``, que afina cada nota de la escala con lo
que se aparta de su nota temperada y deja las demás en temperamento igual. La nota se busca por su nombre y, si no
está, por su altura (Re♯ suena como el Mi♭ de la escala). Una escala puede tener varias afinaciones, cada una de un
autor (`TipoDeEscala.afinaciones`, con su `fuente`, una ``FuenteTeorica``): los echoi diatónicos, en los 72 moria de la Comisión
Patriarcal (1881) y en los 68 de Chrysanthos (1832).

```swift
let bayati = Escala(.re, .bayati).afinacion()!
bayati.desviacion(de: "Mib4")                              // 50: el Mi𝄳
bayati.desviacion(de: "Mi4")                               // 0: no es de la escala
Escala(.re, .bayati).afinacion(la4: 442)?.frecuencia(de: "La4")   // 442
TipoDeEscala.echosProtos.afinaciones.count                 // 2
TipoDeEscala.echosProtos.afinaciones[1].fuente             // .chrysanthos
let chrysanthos = TipoDeEscala.echosProtos.afinaciones[1]
Escala(.re, .echosProtos).afinacion(microtonal: chrysanthos)?.desviacion(de: "Mi4")   // −29
Escala(.do, .mayor).afinacion()                            // nil: no tiene microtonos
```

Una escala de doce notas se mide en cualquier ``TemperamentoConNombre`` que afine notas con `Escala.cents(con:sentido:)`: los cents de
cada grado desde la tónica. Como en los temperamentos circulares cada tonalidad suena distinta, depende de la
tónica, y la afinación justa se construye sobre ella. Cada tradición sugiere la suya (`Tradicion.temperamentoSugerido`,
también en `TipoDeEscala`): la pitagórica en el canto gregoriano, la Grecia antigua, Mesopotamia y China, que
afinan por quintas puras, la justa en la India y la mesotónica en el Renacimiento; las demás tienen sus microtonos o no se ajustan a ninguna.
Las escalas occidentales la toman de su estilo (`Estilo.temperamentoSugerido`): Werckmeister III en la música
clásica, donde cada tonalidad tiene su color, y el temperamento igual en el jazz, el blues, el siglo XX (las escalas
simétricas lo necesitan), la música popular y las sintéticas. Los modos y el hexacordo, los de la polifonía del
Renacimiento, van en mesotónico. La escala de blues tiene además sus blue notes
(`TipoDeEscalaMicrotonal.occidentales`): la tercera neutra, de 350 cents, y la séptima armónica, de 969.

```swift
Escala(.do, .mayor).cents(con: .afinacionJusta)?[2]             // 386,31: la tercera pura
Escala(.do, .mayor).cents(con: .werckmeisterIII)?[2]            // 390,22
Escala(Nota(.re, .bemol), .mayor).cents(con: .werckmeisterIII)?[2]   // 407,82: más abierta
TipoDeEscala.protusAuthenticus.temperamentoSugerido             // .pitagorico
Escala(.re, .protusAuthenticus).cents(con: .pitagorico)?[2]     // 294,13: la tercera menor de 32/27
Tradicion.india.temperamentoSugerido                            // .afinacionJusta
TipoDeEscala.dorico.temperamentoSugerido                        // .mesotonicoCuartoDeComa
TipoDeEscala.mayor.temperamentoSugerido                         // .werckmeisterIII
TipoDeEscala.alterada.temperamentoSugerido                      // .temperamentoIgual
Escala(.la, .blues).afinacion()?.desviacion(de: "Sol4")        // −31: la séptima armónica
```

## Base 40, base 54 y base 600

La numeración de Walter Hewlett da a cada altura un número que conserva la ortografía
(Fa♯ y Sol♭ son distintos) y hace que los intervalos sean restas. Cada letra ocupa un bloque
de valores, de la máxima alteración en bemoles a la máxima en sostenidos, y entre letras a
distancia de tono queda un hueco. Con `m` alteraciones como máximo, la base es 7·(2m + 1) + 5:
40 para dobles alteraciones, 54 para triples y 600 para 42. Do4 vale 4·base + m (162 en base
40, como en Humdrum).

```swift
Altura("Do4").numero(en: .base40)              // 162
Altura("Fa#4").numero(en: .base40)             // 180
Altura("Solb4").numero(en: .base40)            // 184
Altura(numero: 185, en: .base40)                // Sol4
Intervalo.quintaJusta.numero(en: .base40)     // 23
Intervalo(numero: 12, en: .base40)            // 3ª mayor
Intervalo(numero: 20, en: .base40)            // nil (hueco)
Nota("Si#").numero(en: .base40)      // 38
Altura(Nota(.fa, 3), octava: 4).numero(en: .base40)   // nil: solo llega a 𝄪
Altura(Nota(.fa, 3), octava: 4).numero(en: .base54)   // 245
Altura("Do4").numero(en: .base600)             // 2442
BaseDeHewlett(base: 96)                       // hasta 6 alteraciones
```

En el modelo de quintas la conversión es lineal: una quinta justa vale 8m + 7 y una octava, la base.

## Colores de las notas

`CorrespondenciaDeColores` reúne varias correspondencias históricas entre notas y colores. No
son sinestesia, que es un fenómeno de la percepción, sino sistemas propuestos para asociar sonido
y color:

| Correspondencia | Criterio | Do | Re | Mi | Sol |
|---|---|---|---|---|---|
| `.newton` (1704) | los siete colores del espectro sobre las notas naturales | rojo | naranja | amarillo | azul |
| `.castel` (1734) | doce colores por clase de altura | azul | verde | amarillo | rojo |
| `.scriabin` (1911) | *clavier à lumières* de Prometeo, por el círculo de quintas | rojo intenso | amarillo | azul cielo | naranja |
| `.circuloDeQuintas` | círculo cromático sobre el círculo de quintas (30° por quinta) | rojo | amarillo | verde | naranja |

```swift
Nota.re.color(segun: .scriabin)             // #FFFF00
CorrespondenciaDeColores.scriabin.nombreDelColor(de: .mi)         // "azul cielo (luz de luna o escarcha)"
Altura("La4").color(segun: .newton).hexadecimal      // "#4B0082" (añil)
Acorde("Do").colores(segun: .circuloDeQuintas)     // [#FF0000, #00FF00, #FF8000]
Escala(.re, .dorico).colores(segun: .castel)
ColorRGB(hexadecimal: "#FF8000"), ColorRGB(tono: 120, saturacion: 1, brillo: 1)
```

Las fuentes históricas dan nombres de colores, no valores exactos: los RGB son una
interpretación de esos nombres. En Newton las alteraciones no cambian el color; en Castel y
Scriabin las enarmónicas comparten color.

## Tonnetz

El Tonnetz de Euler y Riemann dispone las notas en una red triangular: hacia la derecha, quintas
justas; en diagonal hacia arriba, terceras mayores; en diagonal hacia abajo, terceras menores.
Cada tríada mayor es un triángulo con el vértice hacia arriba y cada menor, uno hacia abajo.

Un punto `(a, b)` son `a` quintas y `b` terceras mayores desde Do. Como el motor distingue Sol♯ de
La♭, la red no se cierra: Mi es `(0, 1)` como tercera de Do y `(4, 0)` como cuarta quinta, y un
acorde de Fa♯ no comparte puntos con uno de Sol♭. Con clases de altura, en cambio, la red es un
toro de doce puntos y cada clase se repite.

```swift
PuntoDeLaRed(quintas: 0, terceras: 1).nota            // Mi
PuntoDeLaRed(quintas: 1, terceras: -1).nota           // Mi♭
PuntoDeLaRed(quintas: 4, terceras: -1).claseDeAltura  // 0
"\(Tonnetz(Acorde("Do")))"                               // "Do (0, 0) · Mi (0, 1) · Sol (1, 0)"
Tonnetz(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")]   // true
Tonnetz(Escala(.do)).esConexo                            // true
Tonnetz(Escala(.do, .tonosEnteros)).esConexo             // false
"\(Tonnetz(ConjuntoDeClasesDeAltura([0, 4, 7])))"                // "0 (0, 0) · 4 (0, 1) · 7 (1, 0)"
```

Las notas se colocan en la disposición más compacta: la que deja menos grupos sueltos y, entre
ellas, la de menor suma de distancias entre cada par de notas. Se prueban todas las disposiciones
(con ramificación y poda, en milésimas de segundo incluso para la escala cromática): de las 52
escalas de `TipoDeEscala.occidentales` en Do, 21 quedan más juntas que colocando las notas una a una. `triadas` da los
triángulos completos y `aristas`, los lados entre notas del conjunto.

`svg(opciones:margen:leyenda:)` dibuja la red alrededor del conjunto: los triángulos mayores en
naranja, los menores en azul, los lados entre notas del conjunto en trazo grueso y las notas en
círculos oscuros. Con clases de altura se marcan todas las repeticiones de cada clase en la ventana.
Encima va un título (el acorde, la escala, las notas, el conjunto o, en un recorrido, la progresión
con sus pasos) y debajo, una leyenda con solo lo que aparece en el dibujo; en notación inglesa, la
leyenda está en inglés. `svg(opciones: .init(titulo: "Tónica"))` cambia el título (`""` lo quita),
`.init(escala: 2)` lo dibuja el doble de grande y `svg(leyenda: false)` quita la leyenda. Lo mismo vale para la tabla
armónica. Las ``OpcionesDeDiagrama`` (la notación, si se prefieren bemoles, el título y la escala) son las mismas en
todos los dibujos que no son un pentagrama: el Tonnetz, la tabla armónica, los teclados isomórficos y cuadrados, el
teclado de piano y el reloj de clases. Las notas marcadas de los teclados son unas ``MarcasDeDiagrama``: `[60, 64, 67]`
las marca y `[60: "1", 64: "3"]` las marca con un rótulo, que se escribe en lugar del nombre de la nota. El teclado
de piano y el reloj también nombran en la notación las notas sin rótulo; con `nombresDeLasNotas: false`, el piano las
marca sin texto y el reloj escribe el número de cada clase (0 es Do). Marcadas con sus alturas
(`MarcasDeDiagrama(Escala("Fa mayor").alturas(octava: 4))`), o un reloj hecho con notas
(`RelojDeClasesDeAltura(notas:tonica:orden:)`), las notas se nombran como se escriben: Si♭, y no La♯, en Fa mayor.

```swift
let dibujo = Tonnetz(Escala(.re, .dorico)).svg()          // con el título «Re dórico» y su leyenda
let sinLeyenda = Tonnetz(Acorde("Do")).svg(opciones: .init(titulo: "Tónica"), leyenda: false)
let ingles = Tonnetz(Acorde("Fa#m7")).svg(opciones: .init(notacion: .ascii(.ingles)), margen: 2)
let toro = Tonnetz(ConjuntoDeClasesDeAltura([0, 4, 7, 11])).svg(margen: 3)
RelojDeClasesDeAltura(clases: [0, 4, 7]).svg(opciones: .init(notacion: .ascii(.ingles))).contains(">G</text>")   // true
TecladoDePiano(desde: 60, hasta: 72).svg(marcadas: [61], opciones: .init(ventana: .bemoles)).contains(">Re♭</text>")   // true
TecladoDePiano(desde: 60, hasta: 72).svg(marcadas: MarcasDeDiagrama(Escala("Fa mayor").alturas(octava: 4))).contains(">Si♭</text>")   // true
RelojDeClasesDeAltura(notas: Escala("Fa mayor").notas).svg().contains(">Si♭</text>")   // true
```

### Transformaciones neorriemannianas

P, L y R cambian una tríada mayor o menor por otra con la que comparte dos notas; en el Tonnetz,
el triángulo gira sobre uno de sus lados:

| | Lado | Do mayor → | La menor → |
|---|---|---|---|
| **P** (homónima) | la quinta | Do menor | La mayor |
| **L** (cambio de sensible) | la tercera menor | Mi menor | Fa mayor |
| **R** (relativa) | la tercera mayor | La menor | Do mayor |

Las tres son involuciones: aplicadas dos veces, devuelven la tríada. Las secuencias se aplican de
izquierda a derecha, y N (RLP), S (LPR) y H (LPL) son las compuestas habituales. La ortografía se
conserva: H de Do es Sol♯ menor, no La♭ menor.

```swift
Acorde("Do").transformar(.r) == Acorde("Lam")                     // true
Acorde("Mib").transformar(.r) == Acorde("Dom")                    // true
try Acorde("Do").transformar(leyendo: "PLR") == Acorde("Fam")     // true
Acorde("Do").transformar(TransformacionNeorriemanniana.s) == Acorde("Do#m")   // true
Acorde("Sol7").transformar(.p) == nil                             // true
TransformacionNeorriemanniana.entre("Do", "Mim") == .l            // true
Acorde("Do").caminoNeorriemanniano(hasta: "Mibm") == [.p, .r, .p]        // true
Acorde("Do").caminoNeorriemanniano(hasta: "Sol#", enarmonico: true) == [.p, .l]   // true
```

`Acorde.caminoNeorriemanniano(hasta:)` da la secuencia más corta de P, L y R entre dos tríadas. Para las séptimas, y
para caminos que pasan por tríadas aumentadas, está la conducción parsimoniosa (véase Acordes). Con
ortografía, Sol♯ y La♭ son destinos distintos; con `enarmonico: true` basta con que suenen igual.

`Tonnetz(recorrido:)` coloca una progresión de tríadas, cada una en el triángulo más cercano a la
anterior, y `Tonnetz(caminoDesde:hasta:)`, el camino más corto. Al dibujarlos, unas flechas rojas
unen los triángulos y debajo se escribe la progresión con sus pasos: «Do –R→ Lam –L→ Fa». Si el
recorrido va y vuelve entre los mismos triángulos, las flechas se curvan hacia lados distintos para
no montarse, y la red se dibuja algo más grande (`paso` 88 en vez de 64). La
progresión Do–Lam–Rem–Sol–Do no vuelve a su punto de partida, sino a otro Do una coma sintónica
más alto: es la «bomba de comas» de la entonación justa.

```swift
let recorrido = Tonnetz(recorrido: ["Do", "Lam", "Fa", "Rem"])
recorrido?.recorrido.count == 4                                   // true
let bomba = Tonnetz(recorrido: ["Do", "Lam", "Rem", "Sol", "Do"])!
bomba.recorrido.first == bomba.recorrido.last                     // false
let dibujo = Tonnetz(caminoDesde: "Do", hasta: "Fa#")?.svg()
```

### Ciclos

Alternando dos transformaciones se vuelve a la tríada de partida (`CicloNeorriemanniano`):

- **hexatónico** (P, L): seis tríadas, con las notas de una escala hexatónica;
- **octatónico** (P, R): ocho, con las de una octatónica;
- **LR** (L, R): las veinticuatro tríadas mayores y menores, avanzando por quintas.

Con ortografía, un ciclo no se cierra: seis pasos del hexatónico llevan de Do a Re𝄫. Por eso
`Acorde.ciclo(_:)` escribe cada tríada con su enarmónica cuando esta evita dobles alteraciones o
lleva al menos dos alteraciones menos (Mi y no Fa♭; Fa♯m y no Sol♭m, que tiene Si𝄫; pero La♭m
sigue siendo La♭m), y termina en la tríada de partida.

```swift
Acorde("Do").ciclo(.hexatonico)?.map(\.cifrado) == ["Do", "Dom", "La♭", "La♭m", "Mi", "Mim", "Do"]   // true
Acorde("Do").ciclo(.octatonico)?.map(\.cifrado) == ["Do", "Dom", "Mi♭", "Mi♭m", "Sol♭", "Fa♯m", "La", "Lam", "Do"]   // true
Acorde("Do").ciclo(.lr)?.count == 25   // true
Tonnetz(ciclo: .hexatonico, desde: "Do")?.recorrido.count == 7   // true
```

`Tonnetz(ciclo:desde:)` lo dibuja como una banda recta de triángulos, de la tríada de partida a la
misma tríada más abajo. Cada punto lleva el nombre que tiene en la primera tríada del ciclo que lo
toca; por eso, donde cambia la ortografía, el triángulo de Mi muestra La♭ y Do♭, que son las notas
que comparte con La♭m. `TablaArmonica(ciclo:desde:)` lo dibuja igual en la tabla armónica, con
los mismos nombres.

Desde la línea de comandos, `armonia tonnetz` escribe el SVG y `armonia plr`, las transformaciones:

```
armonia tonnetz Do Mi Sol Si > domaj7.svg
armonia tonnetz acorde Fa#m7 --margen 2 > fasm7.svg
armonia tonnetz escala "Re dórico" > dorico.svg
armonia tonnetz clases 0,4,7,11 > clases.svg
armonia tonnetz recorrido Do Lam Rem Sol Do > bomba-de-comas.svg
armonia tonnetz camino Do Mibm > camino.svg
armonia tonnetz ciclo hexatonico Do > hexatonico.svg
armonia tabla ciclo octatonico Do > octatonico.svg
armonia plr Do PLR              # Do –P→ Dom –L→ La♭ –R→ Fam
armonia plr camino Do Mibm      # Do –P→ Dom –R→ Mi♭ –P→ Mi♭m
armonia plr ciclo hexatonico Do # Do –P→ Dom –L→ La♭ –P→ La♭m –L→ Mi –P→ Mim –L→ Do
armonia tonnetz ciclo octatonico Do > octatonico.svg
```

## Tabla armónica

La tabla armónica (*Harmonic Table*) es la disposición en hexágonos de teclados isomórficos como el
C-Thru AXiS: hacia arriba, una quinta justa; en diagonal hacia arriba a la derecha, una tercera
mayor; en diagonal hacia arriba a la izquierda, una tercera menor. Es el dual del Tonnetz, con la
misma red y cada nota en un hexágono, así que `TablaArmonica` usa sus coordenadas y su colocación.
Una tríada son tres hexágonos que se tocan en un vértice, y la forma de un acorde o una escala es
la misma en todas las tonalidades.

Con notas, acordes y escalas se conserva la ortografía, como en el Tonnetz; un conjunto de clases
de altura se repite como un toro. Con alturas, cada hexágono suena a una altura concreta, como en
el instrumento: el hexágono `(a, b)` está 7a + 4b semitonos por encima de Do4, de modo que
Do4–Mi4–Sol4 es una tríada y Do3–Mi4–Sol4 no.

```swift
TablaArmonica.midi(de: PuntoDeLaRed(quintas: 1, terceras: 0)) == 67    // true
TablaArmonica(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")]   // true
TablaArmonica([Altura("Do4"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 1   // true
TablaArmonica([Altura("Do3"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 0   // true
"\(TablaArmonica([Altura("Do4"), Altura("Sol4")]))"   // "Do4 (0, 0) · Sol4 (1, 0)"
let dibujo = TablaArmonica(Escala(.re, .dorico)).svg()
```

`svg(opciones:margen:leyenda:)` rellena los hexágonos de las notas, bordea en naranja la primera (la
tónica de la escala o la fundamental del acorde), traza el contorno de la forma y pone un punto
en el vértice común de cada tríada: naranja si es mayor, azul si es menor. Con clases de altura o
alturas se marcan todos los hexágonos que suenan igual.

```
armonia tabla acorde Domaj7 > domaj7.svg
armonia tabla escala "Re dórico" > dorico.svg
armonia tabla Do3 Sol3 Mi4 Si4 > abierto.svg      # con octava: alturas
armonia tabla clases 0,4,7 > clases.svg
armonia tabla recorrido Do Lam Fa Rem > recorrido.svg
armonia tabla camino Do Mibm > camino.svg
```

Los recorridos también se dibujan en la tabla: `TablaArmonica(recorrido:)` y
`TablaArmonica(caminoDesde:hasta:)` colocan las tríadas como en el Tonnetz y unen con flechas los
vértices donde se tocan los tres hexágonos de cada una. Como la tabla es el dual del Tonnetz, un
paso de P, L o R es aquí una flecha entre dos vértices vecinos del mismo lado.

```swift
TablaArmonica(recorrido: ["Do", "Lam", "Fa"])?.recorrido.count == 3   // true
TablaArmonica(caminoDesde: "Do", hasta: "Sol7") == nil               // true
```

## La rejilla hexagonal y los teclados isomórficos

El Tonnetz y la tabla armónica son la misma rejilla hexagonal, la del paquete `Hexagonos`, que se
importa aparte (`import Hexagonos`) para nombrar sus tipos. Un punto del Tonnetz es la casilla `(q, r)` = (quintas, terceras): los
seis pasos del Tonnetz son las seis direcciones de la rejilla, y la distancia es la suya. En la
tabla armónica, la misma rejilla está girada 120° y dibujada con hexágonos planos.

`Tonnetz.trazado(paso:)` y `TablaArmonica.trazado(paso:)` dicen dónde cae cada nota en sus
dibujos, y `punto(en:paso:)` hace el camino de vuelta: de un punto del SVG (donde se ha tocado) a la
nota.

```swift
import Hexagonos

let mi = PuntoDeLaRed(quintas: 0, terceras: 1)
mi.coordenada == CoordenadaAxial(q: 0, r: 1)                           // true
PuntoDeLaRed(CoordenadaAxial(q: 1, r: 0)).nota == .sol               // true
Tonnetz.punto(en: Punto(x: 60, y: 3), paso: 64) == PuntoDeLaRed(quintas: 1, terceras: 0)   // true
TablaArmonica.coordenada(de: mi) == CoordenadaAxial(q: 1, r: -1)        // true
```

``TecladoIsomorfico`` generaliza la tabla armónica: cada paso por la rejilla sube siempre los mismos
semitonos, así que un acorde tiene la misma forma en todas las tonalidades. Trae la tabla armónica,
Wicki-Hayden (también en espejo y con hexágonos planos), Jankó, el acordeón cromático de botones (sistemas C y B),
Gerhard y Park, y admite cualquier otro con los semitonos de cada eje. Los tres vecinos de un hexágono suben, según el
teclado: 7, 4 y 3 (tabla armónica), 2, 5 y 7 (Wicki-Hayden), 3, 2 y 1 (acordeón cromático), 2, 1 y 1 (Jankó), 4, 3 y 1
(Gerhard, con la escala cromática en cada columna) o 5, 3 y 2 (Park, con la cuarta en horizontal). Bosanquet-Wilson,
en 12 notas, es el mismo teclado que Jankó: el tono en horizontal y los dos semitonos, que aquí valen lo mismo, en las
diagonales. Los tres presets de 12 notas del Lumatone son de aquí: el 1 («Classic Mode», Bosanquet-Wilson) es
``TecladoIsomorfico/janko``, el 2 («Melodic Mode») es ``TecladoIsomorfico/wickiHaydenPlano`` y el 3 («Harmonic Mode»)
es ``TecladoIsomorfico/tablaArmonica``. Cambia la forma del instrumento, con las teclas inclinadas y varios manuales
repetidos por canales MIDI, pero no los intervalos.

```swift
import Hexagonos

let teclado = TecladoIsomorfico.wickiHayden
teclado.midi(en: CoordenadaAxial(q: 1, r: -1)) == 67                       // true
teclado.semitonos(hacia: DireccionHexagonal(.noreste, .puntiaguda)!) == 7   // true
TecladoIsomorfico.tablaArmonica.semitonos(hacia: .sMasRMenos) == 7         // true
TecladoIsomorfico.acordeonC.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 3     // true
TecladoIsomorfico.acordeonB.semitonos(hacia: DireccionHexagonal(.noreste, .plana)!) == 2   // true
TecladoIsomorfico.wickiHaydenPlano.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 7   // true
TecladoIsomorfico.gerhard.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 1   // true
TecladoIsomorfico.park.semitonos(hacia: DireccionHexagonal(.este, .puntiaguda)!) == 5   // true
let mapa = FormasDeMapa.rectangulo(columnas: 12, filas: 4, .filasImpares)
let dibujo = TecladoIsomorfico.janko.svg(mapa, marcadas: [60, 64, 67])
```

### El formato UIL

``FormatoUIL`` lee y escribe cualquier teclado hexagonal isomórfico en el formato UIL (Unified Isomorphic Layout) de
Park y Gerhard (SMC 2013), que parte de la notación LGD de Brian Hayden: `L,G,D;R<grados>[M]`. `L`, `G` y `D` son el menor,
el mayor y la diferencia de los tres intervalos de un hexágono (`G = L + D`; Wicki-Hayden es `2,7,5`); `R` es el giro
en sentido horario de la disposición base (con `G` hacia el norte, `D` al noreste y `L` al noroeste) y `M` indica que
`L` y `D` están intercambiados, como en un espejo, antes de girar. Las rotaciones van de 30° en 30°: con 60° los
intervalos pasan a la dirección siguiente, y con 30° además los hexágonos pasan de planos a puntiagudos.

```swift
let formato = try FormatoUIL(leyendo: "2,7,5;R30M")
formato.esCompleto == true                                                // true
formato.orientacion == .puntiaguda                                        // true
try formato.teclado().semitonos(hacia: .qMasSMenos) == 2                  // true
try FormatoUIL(leyendo: "M2,P5,P4;R30M").descripcion == "2,7,5;R30M"      // true
try TecladoIsomorfico.conUIL("3,7,4;R0").semitonos(hacia: .sMasRMenos) == 7   // true
TecladoIsomorfico.wickiHayden.uil?.descripcion == "2,7,5;R30M"            // true
try TecladoIsomorfico.wickiHayden.rotado(grados: -30).uil?.descripcion == "2,7,5;R0M"   // true
TecladoIsomorfico.wickiHayden.reflejado.uil?.descripcion == "2,7,5;R330"  // true
FormatoUIL.conocidos.count == 8                                           // true
```

`TecladoIsomorfico.rotado(grados:)` y `.reflejado` hacen sobre el teclado lo que `R` y `M` sobre el texto: Wicki-Hayden girado
−30° es el plano, y su espejo es el que sube la quinta a la izquierda. `FormatoUIL.conocidos` reúne los de la Tabla 1 del
artículo: Wicki-Hayden, tabla armónica, Gerhard, Park, Jankó, sistema C, sistema B y bayan. Un formato es *completo*
si aparecen las doce notas, lo que ocurre si y solo si `L` y `D` son coprimos; `2,6,4` es degenerado (solo suenan seis).
Se pueden describir otras afinaciones (`1,4,3;R30M;T7`), pero no dibujarlas: `TecladoIsomorfico` cuenta semitonos.
No se leen todavía la cizalla (`S`) ni las razones o centésimas como intervalos fuera de 12 notas.

Los acordeones del artículo (`1,3,2;R270M` y `R270`) son los de ``TecladoIsomorfico/acordeonC`` y ``TecladoIsomorfico/acordeonB``
girados 90°: los mismos intervalos con otra colocación. La app Tonnetz los trae con las colocaciones de arriba; el
artículo es la referencia de la colocación del bayan y de los sistemas C y B.

## Teclados de cuadrícula

``TecladoCuadrado`` es el teclado isomórfico de botones cuadrados en filas y columnas, como los de los controladores de
pads (LinnStrument, Launchpad, Push). Se define por sus dos ejes: H, los semitonos que sube un paso hacia la derecha, y
V, los que sube un paso hacia arriba; las diagonales suben H + V y V − H. Trae seis: en cuartas (H 1, V 5, la
disposición por defecto del LinnStrument y la «4ths» del Launchpad y del Push), en terceras mayores (1, 4), en quintas
(1, 7, como las cuerdas del violín), Wicki-Hayden en cuadrícula (2, 5, con la quinta en la diagonal), de tonos enteros
(2, 1, como Jankó) y el Tonnetz de Euler (7, 4: quintas en horizontal y terceras mayores en vertical). Una casilla es
una ``CasillaCuadrada``, con su columna y su fila; `rotado()` le da un cuarto de vuelta y `reflejado`, la vuelve del
revés, como en un espejo.

```swift
let cuartas = TecladoCuadrado.cuartas
cuartas.midi(en: CasillaCuadrada(columna: 2, fila: 1)) == 67              // true
cuartas.semitonosEnDiagonal == 6                                          // true
TecladoCuadrado.wickiHaydenCuadrado.semitonosEnDiagonal == 7              // true
cuartas.rotado().semitonosEnH == 5                                        // true
cuartas.reflejado.semitonosEnH == -1                                      // true
TecladoCuadrado(nombre: "Tonos", semitonosEnH: 2, semitonosEnV: 4).esCompleto == false   // true
let ventana = CasillaCuadrada.rectangulo(columnas: 0...11, filas: 0...3)
let dibujo = cuartas.svg(ventana, marcadas: [60, 64, 67])
```

Trae también las demás filas del LinnStrument, en terceras menores (1, 3), en tritonos (1, 6) y en octavas (1, 12), y
la secuencial del Push (1, 8). Cualquier otro se escribe con sus ejes, `TecladoCuadrado.conEjes("2,7")`, y
`conOrigen(_:)` cambia la nota de la casilla `(0, 0)`. ``RejillaDeControlador`` da las casillas de un controlador real:
8 × 8 (Launchpad, Push), 16 × 8 y 25 × 8 (LinnStrument), con la `(0, 0)` en la esquina de abajo a la izquierda y el Do2
en ella, o la ventana de 12 × 7 alrededor del Do4.

`enTono(_:)` lo convierte en un teclado en tono, como el modo In Key del Push: solo suenan las notas de una escala, H y
V cuentan grados (los que caben en sus semitonos: en cuartas, tres grados por fila en una escala de siete notas) y la
casilla de origen es la tónica. `svg(_:marcadas:primeras:contorno:margen:opciones:)` dibuja además el contorno de las notas marcadas y
la primera (la tónica o la fundamental) con el borde naranja de la tabla armónica.

```swift
let enTono = TecladoCuadrado.cuartas.enTono(Escala(.re, .dorico))
enTono.semitonosEnV == 3                                                  // true
enTono.midi(en: .origen) == 62                                            // true
TecladoCuadrado.conEjes("2,7")?.semitonosEnV == 7                         // true
TecladoCuadrado.secuencial.conOrigen(36).midi(en: CasillaCuadrada(columna: 0, fila: 1)) == 44   // true
RejillaDeControlador.launchpad.casillas.count == 64                       // true
let pads = enTono.conOrigen(36).svg(RejillaDeControlador.launchpad.casillas, marcadas: [62], primeras: [62], contorno: true)
```
