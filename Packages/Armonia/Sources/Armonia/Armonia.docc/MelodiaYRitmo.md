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

## Exportar a MusicXML

`musicXML(tonalidad:clave:tempo:titulo:parte:)` escribe una voz como partitura MusicXML 4.0,
que se abre en MuseScore, Finale, Sibelius o Dorico. Se escribe la grafía: las notas ya
divididas y ligadas según el compás, con barras, tresillos (y demás grupos irregulares),
anacrusa y doble barra final.

```swift
let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
let xml = escala.musicXML(tonalidad: Tonalidad(.do), tempo: Tempo(90), titulo: "Escala")
xml.contains("<fifths>0</fifths>")             // true
xml.contains("<actual-notes>3</actual-notes>") // true
```

- La ortografía se conserva: un Sol♯ se escribe como sol con sostenido, nunca como la bemol.
- La armadura es la de la tonalidad (`Tonalidad.armadura`); si no se da, se estima a partir de
  las notas. La clave, si no se da, es la de sol o la de fa según el registro.
- MusicXML solo admite las octavas de 0 a 9.
- Un coral a cuatro voces se exporta en dos pentagramas con `Coral.musicXML`, y
  una progresión con sus cifrados y su análisis con `AnalisisArmonico.musicXML` (ver
  <doc:Tonalidad>).
- Desde la terminal: `armonia musicxml melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > escala.musicxml`.

## Exportar a MEI

`mei(tonalidad:clave:tempo:titulo:parte:)` escribe la misma partitura en MEI 5 (Music Encoding
Initiative), el formato de las ediciones críticas y de la musicología, que abren Verovio,
mei-friend o MuseScore 4. Lleva lo mismo que la de MusicXML: grafía, barras, grupos
irregulares, ligaduras, anacrusa, tempo y doble barra final.

```swift
let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
let mei = escala.mei(tonalidad: Tonalidad(.do), tempo: Tempo(90), titulo: "Escala")
mei.contains("keysig=\"0\"")                       // true
mei.contains("<tuplet num=\"3\" numbase=\"2\">") // true
```

- MEI no deduce qué alteraciones se ven, así que se escriben como en una partitura: una
  alteración vale hasta la barra en su pentagrama y en su octava, la de la armadura no se
  escribe y el becuadro sí. La que suena sin escribirse va en `accid.ges`.
- `Coral.mei` y `AnalisisArmonico.mei` escriben el coral y la progresión en dos pentagramas,
  con los cifrados en `<harm>` y el análisis como letra debajo del bajo.
- Desde la terminal: `armonia mei melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > escala.mei`.

## Exportar a LilyPond y ABC

`lilyPond(tonalidad:clave:tempo:titulo:parte:)` escribe la voz como fuente de LilyPond 2.24,
para grabarla en PDF con calidad de imprenta (`lilypond escala.ly`), y
`abc(tonalidad:clave:tempo:titulo:parte:)`, en notación ABC, el texto de las colecciones de
música tradicional que leen abcm2ps, abcjs o EasyABC. Llevan lo mismo que el MusicXML: grafía,
barras, grupos irregulares, ligaduras, anacrusa, tempo y doble barra final.

```swift
let tema = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
let ly = tema.lilyPond(tonalidad: Tonalidad(.sol), titulo: "Tema")
ly.contains("\\key g \\major \\time 3/4 \\partial 4")   // true
ly.contains("fis''4 g''2")                            // true
let abc = tema.abc(tonalidad: Tonalidad(.sol), titulo: "Tema")
abc.contains("K:G")                                   // true
abc.contains("c2 d/2e/2 | f g2 |]")                   // true
```

- LilyPond escribe las alturas en absoluto (`c'` es Do4) y con los nombres holandeses
  (`fis`, `bes`); una nota que no cabe en el compás se parte con `~`.
- ABC, como MEI, escribe las alteraciones que se ven: la de la armadura no, y el becuadro
  sí, hasta la barra. Las corcheas de un mismo pulso van juntas, con su viga.
- `Coral` y `AnalisisArmonico` tienen las dos también: el coral en dos pentagramas, con los
  cifrados encima y el análisis debajo del bajo.
- Desde la terminal: `armonia lilypond melodia Do4:4 Re4:8 Mi4:8 Fa4:2 > escala.ly` y
  `armonia abc melodia Do4:4 Re4:8 Mi4:8 Fa4:2 > escala.abc`.

## Exportar a MIDI

`midi(tonalidad:tempo:titulo:parte:instrumento:)` da la voz como fichero MIDI estándar
(formato 1), para oírla en cualquier reproductor o secuenciador. La primera pista lleva el
título, el tempo, el compás y la armadura; la segunda, las notas. Las ligadas suenan como una
sola nota y los grupos irregulares quedan exactos (480 pulsos por negra, o los que hagan falta).

```swift
let melodia = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
let datos = melodia.midi(tempo: Tempo(90), titulo: "Escala", instrumento: 40)   // violín
datos.prefix(4) == Data("MThd".utf8)   // true
```

- Para guardarlo: `try datos.write(to: URL(fileURLWithPath: "escala.mid"))`.
- `instrumento` es el programa General MIDI (0 = piano de cola, 40 = violín, 52 = coro…).
- `Coral.midi` escribe una pista por voz (soprano, contralto, tenor y bajo), con el
  coro como instrumento; `AnalisisArmonico.midi`, los acordes en posición cerrada y el bajo, con
  un marcador por acorde («Re7 · V7/V») que los secuenciadores muestran al sonar.
- Las alturas fuera del rango MIDI (0…127) se omiten. Los textos van en Latin-1, con las
  alteraciones en ASCII («Mib · bVI»), porque es lo que leen casi todos los programas.
- Desde la terminal: `armonia midi melodia …`, `armonia midi coral …` y
  `armonia midi acordes Do Lam Re7 Sol7 Do > progresion.mid`, con las mismas opciones que
  `musicxml` salvo `--clave` y los cifrados, y con `--instrumento 0…127`.

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
let datos = alberti.midi(titulo: "Bajo de Alberti")
```

- Desde la terminal: `armonia musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2`, y lo mismo
  con `mei` y `midi`. `--figura 16` cambia lo que dura cada nota (corchea si no).

## Importar MIDI y MusicXML

`PiezaImportada(leyendo:)` lee un fichero MIDI estándar o una partitura MusicXML, sin comprimir o
comprimida (.mxl) (lo distingue por el contenido, no por la extensión) y da sus notas, cada una con su altura, su
comienzo y su duración en redondas, junto con el título, la armadura, el compás y el tempo del
fichero. `acordes(ventana:)` reduce las notas a los acordes que suenan y `analisis(en:ventana:)`
los analiza.

```swift
let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
let pieza = try PiezaImportada(leyendo: coral.midi(duracion: .blanca, tonalidad: Tonalidad(.do)))
pieza.tonalidad                  // Do mayor
pieza.notas.count                // 12
pieza.acordes().map(\.cifrado)   // ["Do", "Sol", "Do"]
pieza.analisis()?.cifrados       // ["I", "V", "I"]
pieza.acordesConDuracion().map(\.duracion) == [.blanca, .blanca, .blanca]   // true
```

- MIDI solo da números de nota: la ortografía sale de la armadura del fichero o, si no la
  tiene, de la tonalidad que mejor explica las notas. MusicXML conserva la suya.
- La reducción corta la pieza en ventanas de un pulso del compás. En cada una, cada nota pesa
  lo que suena dentro; si quitando una o dos de las que menos pesan sale una lectura mucho más
  probable, se quitan (son de paso, bordaduras, apoyaturas). Las ventanas seguidas con el mismo
  acorde se funden. Con `ventana:` se elige otro tamaño: una blanca para un ritmo armónico lento.
- De MusicXML se leen acordes, voces (`<backup>`, `<forward>`), ligaduras e instrumentos
  transpositores (se lee lo que suena). No cuentan las notas de adorno, las notas guía ni la
  percusión, y tampoco el canal 10 de MIDI.
- `acordesConDuracion(ventana:)` da además lo que dura cada acorde, el ritmo armónico de la pieza:
  hasta que empieza el siguiente y, el último, hasta el final. Las exportaciones de una progresión
  analizada lo aceptan con `duraciones:` (`musicXML(duraciones:)`, `mei(duraciones:)` y
  `midi(duraciones:)`), y `Voz(arpegiando:duraciones:)` la arpegia con ese ritmo.
- Todavía no se leen las repeticiones ni los saltos. Del .mxl se lee la partitura que señala
  `META-INF/container.xml`. Los errores son `ErrorDeImportacion`, con su explicación en los quince
  idiomas.
- Desde la terminal: `armonia analizar --archivo coral.mid` (o `.musicxml`, o `.mxl`), y
  `armonia musicxml acordes --archivo coral.mid` para la progresión con su ritmo armónico (también
  `arpegios`, `mei` y `midi`).
