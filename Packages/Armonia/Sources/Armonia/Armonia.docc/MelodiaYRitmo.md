# Melodía y ritmo

Melodías, duraciones exactas, compases, tempo y voces.

## Melodías

```swift
let tema: Melodia = ["Do4", "Mi4", "Sol4"]
tema.transponer(.segundaMayor)              // Re4 Fa♯4 La4      (real)
tema.transponer(grados: 1, en: Escala(.do)) // Re4 Fa4 La4       (tonal)
tema.invertir()                             // Do4 La♭3 Fa3
tema.retrogradar()                          // Sol4 Mi4 Do4
tema.intervalos, tema.contorno, tema.ambito
Melodia(midi: [69, 71, 72, 74, 76, 77, 80, 81])   // La4 … Sol♯5 La5 (tonalidad estimada)
```

## Ritmo

Las duraciones son fracciones exactas de redonda, así que sumarlas y repartirlas en compases
no acumula errores. Se escriben al estilo de LilyPond (`4` negra, `8.` corchea con puntillo)
o como fracción (`1/12`, una corchea de tresillo).

```swift
Duracion(.negra, puntillos: 1)                 // «negra con puntillo» (3/8 de redonda)
Duracion(.negra, puntillos: 1).texto           // "4."
Duracion.corchea.grupoIrregular(3, en: 2)      // 1/12 de redonda (corchea de tresillo)
Duracion("8.")                                 // «corchea con puntillo»
(Duracion.blanca + .corchea).descomposicion    // [blanca, corchea]: dos figuras ligadas
Duracion.corchea.ticks(porNegra: 480)          // 240

let c: Compas = "6/8"
c.tipo, c.pulsos, c.pulso                      // compuesto, 2, negra con puntillo
Tempo(100).indicacion                          // "Andante"
Tempo(120).segundos(de: .blanca)               // 1
```

Un `Evento` es una nota, un acorde o un silencio con su duración (`"Do4:4."`,
`"Do4+Mi4+Sol4:2"`, `"-:8"`, `"Re4:2~"` si va ligada). Una `Voz` es una sucesión de eventos
en un compás, con anacrusa opcional:

```swift
let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4", compas: "3/4")
voz.duracion                 // «redonda con puntillo» (3/2 de redonda: dos compases)
voz.compases                 // [[Do4:4, Re4:8, Mi4:8, Fa4:4~], [Fa4:2, Sol4:4]]
voz.segundos(tempo: Tempo(90))   // 4
voz.melodia, voz.ritmo       // las alturas y las duraciones por separado
voz.aumentar(2), voz.disminuir(2), voz.retrogradar(), voz + .quintaJusta
Voz(melodia: ["Do4", "Mi4", "Sol4"], ritmo: [.negra, .negra, .blanca], compas: "3/4")
```

Al repartir en compases, una nota que cruza la barra se divide en dos ligadas y un silencio,
en dos silencios. Las indicaciones de tempo son aproximadas: sus márgenes varían según la época.

### Dinámica y articulaciones

Cada evento puede llevar una dinámica (`Dinamica`: de *ppp* a *fff*, *sfz* y *fp*) y sus
articulaciones (`Articulacion`: staccato, staccatissimo, tenuto, acento, marcato y calderón) y
ornamentos (trino, mordente superior e inferior, grupeto y grupeto invertido).
En el texto van al final, entre llaves y separadas por comas, sin espacios; los nombres son los
mismos en todos los idiomas:

```swift
let frase = try Voz(leyendo: "Do4:4{p} Re4:4{staccato} Mi4:2{f,acento}")
frase.eventos[0].dinamica                         // .p
frase.eventos[2].articulaciones == [.acento]      // true
frase.eventos[2].description                      // "Mi4:2{f,acento}"
Dinamica.f.velocidadMIDI                          // 96
try Evento(leyendo: "Sol4:2{trino}").articulaciones == [.trino]   // true
```

MusicXML, MEI, LilyPond, ABC y GUIDO las escriben, y MusicXML, MEI y ABC las leen al importar
(`NotaDeLaPieza.dinamica` y `articulaciones`). En MIDI, la dinámica es la velocidad de cada nota
(*mf* si no se marca ninguna), el acento y el marcato la refuerzan y el staccato acorta la nota.
Una nota partida en varias ligadas las lleva solo en la primera. Los ornamentos no cambian lo que
suena en MIDI. El pentagrama SVG dibuja las articulaciones del lado de la cabeza (en los espacios,
contrarias a la plica) y los ornamentos y el calderón encima, con los glifos de Bravura.

## Frases, forma y motivos

`Voz.frases(minimo:)` parte una melodía en frases con reglas sencillas de agrupamiento: una frase
acaba antes de un silencio o en una nota más larga que la anterior y la siguiente, y dura al
menos un compás (o lo que se pida). `forma(minimo:)` da una letra a cada frase: la misma a las
que se repiten, aunque estén transportadas, y una prima a las variantes, que coinciden en la
mitad o más de sus intervalos y su ritmo. `motivos(minimo:)` busca los trozos que vuelven, iguales
o transportados, y dice si forman una progresión (`esSecuencia`):

```swift
let tema = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Do4:4 Re4:4 Mi4:2 Sol4:4 Fa4:4 Mi4:2 Do4:4 Re4:4 Do4:2")
tema.frases().count                         // 4
tema.frases()[2].eventos == 6..<9           // true
tema.forma() == ["A", "A", "B", "A′"]       // true

let progresion = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4 Re4:8 Mi4:8 Fa#4:4 Mi4:8 Fa#4:8 Sol#4:2")
let motivo = progresion.motivos(minimo: 3)[0]
motivo.intervalos == [2, 2]                 // true
motivo.apariciones == [0, 3, 6]             // true
motivo.transposiciones == [0, 2, 4]         // true
motivo.esSecuencia                          // true
```

En un acorde cuenta la nota más aguda, y una nota ligada cuenta una vez. Es una estimación: no
reconoce períodos ni secciones a gran escala.

### Swing y polirritmias

`conSwing(_:)` toca una voz con swing: cada par de corcheas (o de la figura que se elija) dura lo
mismo, pero la primera se alarga y la segunda se acorta, en la proporción de ``Swing``: 2:1
(`ternario`, el del jazz, con figuras de tresillo), 3:1 (`conPuntillo`) o la que se pida. Las
duraciones son fracciones exactas, así que la voz se escribe y se exporta como cualquier otra.
``Polirritmia`` reparte el mismo tramo en dos pulsaciones (3 contra 2, 4 contra 3…): da los
ataques de cada una, el ritmo que resulta de oírlas juntas y las dos voces que la tocan:

```swift
let corcheas = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:2")
corcheas.conSwing().ritmo == [Duracion(1, 6), Duracion(1, 12), Duracion(1, 6), Duracion(1, 12), .blanca]   // true

let tresContraDos = Polirritmia(3, contra: 2)
tresContraDos.resultante() == [Duracion(1, 3), Duracion(1, 6), Duracion(1, 6), Duracion(1, 3)]   // true
tresContraDos.voces(compases: 2)[0].eventos.count                                                  // 6
```

## Métrica

Cada compás agrupa sus unidades en pulsos: `[1, 1, 1, 1]` en 4/4, `[3, 3]` en 6/8, `[2, 2, 3]`
en 7/8 (o la agrupación que se indique: `Compas("3+2+2/8")`). Con eso sabe dónde empieza cada
pulso y qué acento tiene:

```swift
Compas("7/8").agrupacion                  // [2, 2, 3]
Compas("7/8").pulsos                      // 3
Compas("6/8").iniciosDePulso              // [cero, negra con puntillo]: al principio y tras 3/8
Compas.compasillo.acento(pulso: 2)       // .semifuerte
Compas.compasillo.acento(en: .corchea)     // nil (a contratiempo)
```

`Voz.grafia` reparte los eventos como se escriben en una partitura:

- una nota que cruza el comienzo de un pulso se divide en él y se liga, salvo que empiece en un
  pulso, acabe en otro y quepa en una figura (una blanca en el 1.er tiempo de 4/4, una negra con
  puntillo en 6/8); al dividir, se busca que la primera parte sea lo más larga posible
  (blanca ligada a corchea mejor que negra–negra–corchea);
- en los compases simples, una figura con puntillo que empieza en un pulso se escribe entera
  aunque acabe entre dos (la negra con puntillo del 1.er tiempo, seguida de corchea); en los
  compuestos, la nota no cruza el grupo de tres corcheas;
- en 4/4 una nota que no empieza al principio del compás no oculta la mitad;
- en los compases de amalgama una figura puede abarcar grupos iguales (la blanca de los dos
  primeros de 7/8 = 2+2+3), pero no el paso a un grupo de otro tamaño: el compás entero de 7/8
  es blanca ligada a negra con puntillo, y no blanca con dos puntillos;
- lo que no cabe en una figura se descompone en figuras ligadas;
- el silencio de todo un compás no se divide (en MusicXML y en MEI es un silencio de compás).

```swift
try Voz(leyendo: "Do4:4 Re4:2 Mi4:4").grafia          // [[Do4:4, Re4:4~, Re4:4, Mi4:4]]
try Voz(leyendo: "Do4:8 Re4:4 Mi4:8 Fa4:2").grafia    // [[Do4:8, Re4:8~, Re4:8, Mi4:8, Fa4:2]]
try Voz(leyendo: "Do4:4. Re4:8 Mi4:2").grafia         // [[Do4:4., Re4:8, Mi4:2]]
try Voz(leyendo: "Do4:4 Re4:4. Mi4:8 Fa4:4").grafia   // [[Do4:4, Re4:4~, Re4:8, Mi4:8, Fa4:4]]
try Voz(leyendo: "Do4:4 Re4:4 Mi4:4", compas: "6/8").grafia   // [[Do4:4, Re4:8~, Re4:8, Mi4:4]]
try Voz(leyendo: "Do4:2..", compas: "7/8").grafia             // [[Do4:2~, Do4:4.]]
try Voz(leyendo: "Do4:2..", compas: "3+2+2/8").grafia         // [[Do4:4.~, Do4:2]]
```

`barrasDeAgrupacion` dice qué notas van unidas por barras (las más breves que una negra dentro de
un mismo pulso: las tres corcheas de cada pulso en 6/8) y `acentos`, el acento métrico de cada
evento de la grafía.

## La partitura

Todos los formatos y el dibujo salen de un mismo valor, ``Partitura``: los pentagramas de arriba abajo, cada uno con
su clave y sus voces (una ``Partitura/Linea`` con su nombre, la dirección de sus plicas, los cifrados de encima, el
análisis de debajo y los marcadores de MIDI), y un ``Encabezado`` con lo que vale para toda ella: el título, la
armadura, el tempo, el nombre de la parte y el instrumento de MIDI. Una ``Voz``, un ``Coral``, un
``AnalisisArmonico`` y un ``Contrapunto`` hacen la suya con `partitura(…)`, y de ella salen `musicXML()`, `mei()`,
`lilyPond()`, `guido()`, `abc()`, `midi(afinacion:)`, `exportar(como:)` y `svg(opciones:)`. Con la partitura se
puede, además, cambiar algo antes de escribirla o montar una a mano.

```swift
let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
let partitura = escala.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90)))
partitura.musicXML().contains("<work-title>Escala</work-title>")             // true
partitura.pentagramas.count                                                  // 1
let bajo = try Voz(leyendo: "Do3:2. Fa2:4", compas: "3/4")
let manos: [Partitura.Pentagrama] = [.init(clave: .sol, voces: [.init(escala)]), .init(clave: .fa, voces: [.init(bajo)])]
let dos = Partitura(pentagramas: manos, encabezado: Encabezado(titulo: "Dos manos"), llave: true)
dos.lilyPond().contains("PianoStaff")                                        // true
dos.svg().contains("<svg")                                                   // true
```

## Exportar a MusicXML

`musicXML()` escribe la partitura de una voz (`partitura(clave:encabezado:)`) en MusicXML 4.0,
que se abre en MuseScore, Finale, Sibelius o Dorico. Se escribe la grafía: las notas ya
divididas y ligadas según el compás, con barras, tresillos (y demás grupos irregulares),
anacrusa y doble barra final.

```swift
let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
let xml = escala.partitura(encabezado: Encabezado(titulo: "Escala", tonalidad: Tonalidad(.do), tempo: Tempo(90))).musicXML()
xml.contains("<fifths>0</fifths>")             // true
xml.contains("<actual-notes>3</actual-notes>") // true
```

- La ortografía se conserva: un Sol♯ se escribe como sol con sostenido, nunca como la bemol.
- La armadura es la de la tonalidad del encabezado (`Tonalidad.armadura`); si no se da, se
  estima a partir de las notas. La clave, si no se da, es la de sol o la de fa según el registro.
- MusicXML solo admite las octavas de 0 a 9.
- Un coral a cuatro voces se escribe en dos pentagramas con `Coral.partitura(…)`, y
  una progresión con sus cifrados y su análisis con `AnalisisArmonico.partitura(…)` (ver
  <doc:Tonalidad>).
- Desde la terminal: `armonia musicxml melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > escala.musicxml`.

## Exportar a MEI

`mei()` escribe la misma partitura en MEI 5 (Music Encoding
Initiative), el formato de las ediciones críticas y de la musicología, que abren Verovio,
mei-friend o MuseScore 4. Lleva lo mismo que la de MusicXML: grafía, barras, grupos
irregulares, ligaduras, anacrusa, tempo y doble barra final.

```swift
let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
let mei = escala.partitura(encabezado: Encabezado(titulo: "Escala", tonalidad: Tonalidad(.do), tempo: Tempo(90))).mei()
mei.contains("keysig=\"0\"")                       // true
mei.contains("<tuplet num=\"3\" numbase=\"2\">") // true
```

- MEI no deduce qué alteraciones se ven, así que se escriben como en una partitura: una
  alteración vale hasta la barra en su pentagrama y en su octava, la de la armadura no se
  escribe y el becuadro sí. La que suena sin escribirse va en `accid.ges`.
- Las partituras de un coral y de una progresión van en dos pentagramas,
  con los cifrados en `<harm>` y el análisis como letra debajo del bajo.
- Desde la terminal: `armonia mei melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > escala.mei`.

## Exportar a LilyPond y ABC

`lilyPond()` escribe la partitura como fuente de LilyPond 2.24,
para grabarla en PDF con calidad de imprenta (`lilypond escala.ly`), y
`abc()`, en notación ABC, el texto de las colecciones de
música tradicional que leen abcm2ps, abcjs o EasyABC. Llevan lo mismo que el MusicXML: grafía,
barras, grupos irregulares, ligaduras, anacrusa, tempo y doble barra final.

```swift
let tema = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
let ly = tema.partitura(encabezado: Encabezado(titulo: "Tema", tonalidad: Tonalidad(.sol))).lilyPond()
ly.contains("\\key g \\major \\time 3/4 \\partial 4")   // true
ly.contains("fis''4 g''2")                            // true
let abc = tema.partitura(encabezado: Encabezado(titulo: "Tema", tonalidad: Tonalidad(.sol))).abc()
abc.contains("K:G")                                   // true
abc.contains("c2 d/2e/2 | f g2 |]")                   // true
```

- LilyPond escribe las alturas en absoluto (`c'` es Do4) y con los nombres holandeses
  (`fis`, `bes`); una nota que no cabe en el compás se parte con `~`.
- ABC, como MEI, escribe las alteraciones que se ven: la de la armadura no, y el becuadro
  sí, hasta la barra. Las corcheas de un mismo pulso van juntas, con su viga.
- Las de un coral y de una progresión van en dos pentagramas, con los cifrados encima y el
  análisis debajo del bajo.
- `guido()` escribe lo mismo en GUIDO Music Notation
  (`.gmn`), la entrada de Guido Engine (`guido2svg escala.gmn`): la octava 1 es la del Do central
  (`c1` es Do4), las alteraciones son `#` y `&`, y cada duración va como fracción de redonda
  (`/4`, `*3/8`).
- Desde la terminal: `armonia lilypond melodia Do4:4 Re4:8 Mi4:8 Fa4:2 > escala.ly`,
  `armonia guido melodia … > escala.gmn` y `armonia abc melodia … > escala.abc`.

## Exportar a MIDI

`midi(afinacion:)` da la partitura como fichero MIDI estándar
(formato 1), para oírla en cualquier reproductor o secuenciador. La primera pista lleva el
título, el tempo, el compás y la armadura; la segunda, las notas. Las ligadas suenan como una
sola nota y los grupos irregulares quedan exactos (480 pulsos por negra, o los que hagan falta).

```swift
let melodia = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
let datos = melodia.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90), instrumento: 40)).midi()   // violín
datos.prefix(4) == Data("MThd".utf8)   // true
```

- Para guardarlo: `try datos.write(to: URL(fileURLWithPath: "escala.mid"))`.
- El `instrumento` del encabezado es el programa General MIDI (0 = piano de cola, 40 = violín, 52 = coro…).
- La de un coral lleva una pista por voz (soprano, contralto, tenor y bajo), con el
  coro como instrumento; la de una progresión, los acordes en posición cerrada y el bajo, con
  un marcador por acorde («Re7 · V7/V») que los secuenciadores muestran al sonar.
- Las alturas fuera del rango MIDI (0…127) se omiten. Los textos van en Latin-1, con las
  alteraciones en ASCII («Mib · bVI»), porque es lo que leen casi todos los programas.
- Desde la terminal: `armonia midi melodia …`, `armonia midi coral …` y
  `armonia midi acordes Do Lam Re7 Sol7 Do > progresion.mid`, con las mismas opciones que
  `musicxml` salvo `--clave` y los cifrados, y con `--instrumento 0…127`.

### Microtonos y afinaciones en MIDI

Los microtonos de una voz (los desvíos de cada nota, como en `Mi♭4(50¢):4`) suenan en MIDI con inflexiones de tono
(*pitch bend*). Con `afinacion`, además, todas las notas suenan en la que se pida: un temperamento regular, uno
circular o la afinación justa (``AfinacionHistorica``). La inflexión mueve todo un canal, así que las notas que suenan
a la vez y se apartan distinto (la tercera pura de un acorde, por ejemplo) van cada una a un canal, con el mismo
instrumento: los que no son de ninguna voz, sin el 10, el de percusión. Al importar el fichero, los canales de una
pista con el mismo instrumento vuelven a ser una sola parte.

```swift
let acorde = try Voz(leyendo: "Do4+Mi4+Sol4:1")
let datos = acorde.partitura().midi(afinacion: TemperamentoRegular.mesotonicoCuartoDeComa)
let pieza = try PiezaImportada(midi: datos)
pieza.notas.map(\.parte) == [0, 0, 0]                                     // true
abs(400 + pieza.notas[1].desvio - pieza.notas[0].desvio - 386.31) < 0.05   // true: la tercera, pura
```

## Todos los formatos a la vez

``FormatoDePartitura`` reúne los seis formatos (MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI), y
`exportar(como:afinacion:)` escribe una ``Partitura`` en el que se pida. Los formatos de texto salen en
UTF-8, así que todos dan `Data`, listos para guardar con `extensionDeFichero`.

```swift
let tema = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
FormatoDePartitura.allCases.map(\.extensionDeFichero) == ["musicxml", "mei", "ly", "gmn", "abc", "mid"]   // true
let delTema = tema.partitura(encabezado: Encabezado(titulo: "Tema"))
delTema.exportar(como: .lilyPond) == Data(delTema.lilyPond().utf8)   // true
delTema.exportar(como: .midi) == delTema.midi()                       // true
```

- La clave no cuenta en MIDI, ni el instrumento en los demás; el MIDI de un coral o de una
  progresión no lleva cifrados ni análisis.
- Las apps ofrecen así todos los formatos en el menú de exportar, y `armonia grabar` elige con él la
  partitura que lee cada motor.

## Arpegios con ritmo

Un ``Arpegio`` da las notas de un acorde en un orden; `Voz(_:figura:octava:compas:)` les pone ritmo, y
`Voz(arpegiando:patron:octavas:conOctava:figura:porAcorde:octava:compas:)` arpegia una progresión entera,
un acorde detrás de otro con el mismo patrón. Con `porAcorde`, cada acorde dura eso: el patrón se repite (o
se corta) hasta llenarlo, y si no cabe un número entero de notas, la última se alarga. El bajo de cada acorde
va a la octava que lo deja más cerca del primero, para que la mano no salte. Como son una ``Voz``, se dibujan,
suenan y se exportan a MusicXML, MEI y MIDI como cualquier melodía.

```swift
let arpegio = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
arpegio.eventos.count   // 9
let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Sol7")]
let alberti = Voz(arpegiando: acordes, patron: .alberti, porAcorde: .blanca)
alberti.eventos.count   // 16
alberti.eventos.prefix(4).flatMap(\.alturas).map(\.midi) == [48, 55, 52, 55]   // true
let datos = alberti.partitura(encabezado: Encabezado(titulo: "Bajo de Alberti")).midi()
```

- Desde la terminal: `armonia musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2`, y lo mismo
  con `mei` y `midi`. `--figura 16` cambia lo que dura cada nota (corchea si no).

## Importar MIDI, MusicXML, MEI y ABC

`PiezaImportada(leyendo:)` lee un fichero MIDI estándar o una partitura MusicXML (sin comprimir o
comprimida, .mxl), MEI o ABC (lo distingue por el contenido, no por la extensión) y da sus notas,
cada una con su altura, su comienzo y su duración en redondas, junto con el título, la armadura,
el compás y el tempo del fichero. `acordes(ventana:)` reduce las notas a los acordes que suenan y `analisis(en:ventana:)`
los analiza.

```swift
let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
let pieza = try PiezaImportada(leyendo: coral.partitura(duracion: .blanca, encabezado: Encabezado(tonalidad: Tonalidad(.do))).midi())
pieza.tonalidad                  // Do mayor
pieza.notas.count                // 12
pieza.acordes().map(\.cifrado)   // ["Do", "Sol", "Do"]
pieza.analisis()?.cifrados       // ["I", "V", "I"]
pieza.ritmoArmonico().duraciones == [.blanca, .blanca, .redonda]  // true
```

- MIDI solo da números de nota: la ortografía sale de la armadura del fichero o, si no la
  tiene, de la tonalidad que mejor explica las notas. MusicXML, MEI y ABC conservan la suya.
- La reducción corta la pieza en ventanas de un pulso del compás. En cada una, cada nota pesa
  lo que suena dentro; si quitando una o dos de las que menos pesan sale una lectura mucho más
  probable, se quitan (son de paso, bordaduras, apoyaturas). Las ventanas seguidas con el mismo
  acorde se funden. Con `ventana:` se elige otro tamaño: una blanca para un ritmo armónico lento.
- De MusicXML se leen acordes, voces (`<backup>`, `<forward>`), ligaduras e instrumentos
  transpositores (se lee lo que suena). No cuentan las notas guía ni la percusión, y tampoco el
  canal 10 de MIDI. Las notas de adorno de MusicXML, MEI y ABC van aparte, en `notasDeAdorno`:
  empiezan donde empieza la nota a la que adornan y no duran.
- `ritmoArmonico(ventana:)` da además lo que dura cada acorde, el ritmo armónico de la pieza: un
  ``RitmoArmonico`` con cada acorde y su duración (hasta que empieza el siguiente y, el último, hasta el
  final), en el compás y al tempo del fichero. `RitmoArmonico.partitura(en:encabezado:cifrados:analisis:notacion:)`
  lo escribe analizado, y `Voz(arpegiando:patron:octavas:conOctava:figura:octava:tensiones:aproximacion:enlazados:)`
  lo arpegia. `acordesConInicio(ventana:)` da en cambio dónde empieza cada acorde.
- Las repeticiones de MusicXML, MEI y ABC (con sus casillas de primera y segunda vez) y los saltos
  (da capo, dal segno, fine, coda) se despliegan: `notas` las da en el orden en que se tocan. Tras
  un da capo o un dal segno no se repite nada y se toman las últimas casillas. Del .mxl se lee la partitura que señala
  `META-INF/container.xml`. Los errores son `ErrorDeImportacion`, con su explicación en los quince
  idiomas.
- Desde la terminal: `armonia analizar --archivo coral.mid` (o `.musicxml`, `.mxl`, `.mei`, `.abc`), y
  `armonia musicxml acordes --archivo coral.mid` para la progresión con su ritmo armónico (también
  `arpegios`, `mei` y `midi`).

```swift
let repetida = try PiezaImportada(abc: "X:1\nM:4/4\nL:1/4\nK:C\n|: {B}c4 |1 d4 :|2 e4 |]\n")
repetida.notas.map(\.inicio) == [.cero, Duracion(1), Duracion(2), Duracion(3)]   // true
repetida.notas[3].altura                                                          // Mi5
repetida.notasDeAdorno.count                                                      // 2
```
