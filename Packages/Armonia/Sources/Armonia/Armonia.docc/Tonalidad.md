# Tonalidad

Tonalidades, ortografía de alturas MIDI, detección de la tonalidad, análisis de progresiones (con cadencias y
modulaciones), conducción de voces y armonización a cuatro voces.

## Tonalidad

Una `Escala` es un conjunto ordenado de notas (Re dórico, Do blues, Sol alterada); una
`Tonalidad` es el marco tonal: tónica y modo, mayor o menor. En menor, la armadura sale de la
menor natural, pero se escribe y se armoniza con la sensible (V mayor, vii°).

```swift
let laMenor: Tonalidad = "La menor"
laMenor.armadura                      // 0
laMenor.relativa, laMenor.homonima    // Do mayor, La mayor
laMenor.vecinas                       // [Do mayor, Sol mayor, Mi menor, Fa mayor, Re menor]
laMenor.armonizar(cuatriadas: true)   // Lam7 Sim7(♭5) Domaj7 Rem7 Mi7 Famaj7 Sol♯°7
laMenor.cifradosRomanos()             // i ii° III iv V VI vii°
laMenor.nombreDeGrado(de: .sol)             // .subtonica  (y Sol♯ es la sensible)
Tonalidad.circuloDeQuintas(.menor)    // La♭ menor … La♯ menor
Tonalidad(Escala(.re, .dorico))       // nil: un modo no es una tonalidad
```

## Ortografía y detección de tonalidad

```swift
Escala(.do).ortografiar(midi: [60, 61, 62])        // Do4 Do♯4 Re4   (sube con sostenido)
Escala(.do).ortografiar(midi: [62, 61, 60])        // Re4 Re♭4 Do4   (baja con bemol)
Altura(midi: 70, escala: Escala(.fa))           // Si♭4
Altura(midi: 68, tonalidad: "La menor")              // Sol♯4
Escala("Fa# mayor").ortografiar(midi: [65, 60])   // Mi♯4 Si♯3
Tonalidad.candidatos(midi: melodia).first?.valor   // La menor  (la de mayor correlación)
```

Las notas de la escala usan su nombre; las cromáticas se eligen entre las dos escrituras
más cercanas a la escala en la línea de quintas, según la dirección de la melodía. La
detección usa el algoritmo de Krumhansl-Schmuckler (con duraciones opcionales) y escribe
la tónica con la armadura más sencilla, o con la ortografía de las notas si se dan nombres.

## Análisis de progresiones

`AnalisisArmonico` lee una sucesión de acordes en una tonalidad: el grado de cada uno en
cifrado romano (con la inversión en cifra de bajo continuo), su función y por qué está ahí.
Si no se da la tonalidad, elige entre las más probables por sus notas la que explica más
acordes y empieza o termina en su tónica.

```swift
let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
analisis.tonalidad                    // Do mayor
analisis.cifrados                     // ["I", "vi", "V7/V", "V7", "I"]
analisis.funciones.map { $0?.abreviatura ?? "–" }   // ["T", "T", "D", "D", "T"]
analisis.acordes[2].categoria         // .dominanteSecundaria(de: 5)
analisis.nombre(en: .ascii(.ingles))          // "I–vi–V7/V–V7–I in C major"

try AnalisisArmonico.analizar(leyendo: "Do Fa/La Sol7/Si Do")      // I–IV6–V65–I en Do mayor
try AnalisisArmonico.analizar(leyendo: "Sim7(b5) Mi7 Lam")         // «iiø7–V7–i en La menor»
try AnalisisArmonico.analizar(leyendo: "Do Lab Sib Do")            // I–♭VI–♭VII–I en Do mayor
try AnalisisArmonico.analizar(leyendo: "Do Reb/Fa Sol7 Do")        // I–♭II6–V7–I en Do mayor
try AnalisisArmonico.analizar(leyendo: "Do Fa#°7 Sol Do")          // I–vii°7/V–V–I en Do mayor
Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi7", "La"]).cifrados   // ["i", "iv6", "V7", "I"]
Tonalidad(.do).analizar(["Mim6", "Mim/Sol"]).cifrados   // ["iii(add6)", "iii6"]
```

La sexta añadida se cifra «(add6)», porque un 6 solo es la primera inversión. Los acordes
invertidos que no son tríadas ni cuatríadas de séptima llevan todos los intervalos sobre el bajo,
de mayor a menor:

```swift
Tonalidad(.do).analizar(["Fa6/La", "Fa6/Do", "Do(add9)/Mi"]).cifrados   // ["IV(add6)643", "IV(add6)642", "I(add9)763"]
```

Cada acorde cae en una de estas categorías (`AcordeAnalizado.Categoria`):

- **Diatónico**: con las notas de la tonalidad; en menor cuentan también el 6.º y el 7.º
  elevados, así que V y vii° son diatónicos.
- **Dominante o sensible secundaria** (V7/V, vii°7/V): dominante o acorde de sensible de un
  grado que no es la tónica. Si resuelve en ese grado es la lectura preferida; si no, solo se
  elige cuando el acorde no es prestado.
- **Napolitana** (♭II): el acorde mayor sobre el 2.º grado rebajado, con función de subdominante.
  Invertida se cifra como cualquier tríada: ♭II6 (la sexta napolitana) o ♭II64.
- **Sexta aumentada** (It+6, Fr+6, Ger+6): ♭6̂ y ♯4̂, a distancia de sexta aumentada, con la
  tónica y nada más (italiana), con 2̂ (francesa) o con ♭3̂ (alemana), sea cual sea el bajo. Tiene
  función de subdominante y va a la dominante o al I64 cadencial. La alemana escrita como
  séptima de dominante (La♭7 en Do, con Sol♭ en vez de Fa♯) cuenta como tal si va a la dominante.
- **Sustituto tritonal** (subV7, subV7/ii): una séptima de dominante medio tono por encima de
  su destino, cuando resuelve en él (Re♭7–Do en Do). Tiene función de dominante. La♭7–Sol sigue
  leyéndose como sexta aumentada alemana.
- **I64 cadencial**: la tónica en segunda inversión que va a la dominante sobre el mismo bajo.
  Se cifra I64, pero tiene función de dominante (`cuartaYSextaCadencial`).
- **Préstamo** del modo homónimo: iv, ♭VI o ♭VII en mayor, o el I mayor (tercera de picardía)
  en menor.
- **Cromático**: ninguno de los anteriores; se cifra con la alteración del grado y sin función.

```swift
Tonalidad(.do).analizar(["Do", "Lab(#6,omit5)", "Sol", "Do"]).cifrados          // ["I", "It+6", "V", "I"]
Tonalidad(.do).analizar(["Fa", "Re7(b5)/Lab", "Sol"]).cifrados                  // ["IV", "Fr+6", "V"]
Tonalidad(.do).analizar(["Lab(#6)", "Do/Sol", "Sol7", "Do"]).cifrados           // ["Ger+6", "I64", "V7", "I"]
Tonalidad(.do).analizar(["Lab7", "Sol"]).cifrados                               // ["Ger+6", "V"]
Tonalidad(.do).analizar(["Reb/Lab", "Sol7", "Do"]).cifrados                     // ["♭II64", "V7", "I"]
Tonalidad(.do).analizar(["Mib7", "Rem7", "Reb7", "Do"]).cifrados                // ["subV7/ii", "ii7", "subV7", "I"]
Tonalidad(.do).analizar(["Do/Sol", "Sol7", "Do"]).funciones.map { $0!.abreviatura }   // ["D", "D", "T"]
```

Las funciones siguen los grados: I, iii y vi son de tónica; ii y IV, de subdominante; V y
vii°, de dominante. La alteración delante del numeral (♭VI) se mide respecto a la escala de
la armadura, y en menor no se escribe para el 6.º y el 7.º elevados (vii°, no ♯vii°).

`partitura(duracion:compas:encabezado:conCifrados:conAnalisis:notacion:)` pone el análisis en una
partitura de dos pentagramas, que `musicXML()` escribe: los acordes en posición cerrada en clave de sol,
con su cifrado americano encima (como símbolo de acorde, que el editor reconoce y puede
transportar), y el bajo en clave de fa, con el cifrado romano y la función debajo:

```swift
let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
let partituraAnalizada = analisis.partitura(encabezado: Encabezado(titulo: "Progresión")).musicXML()
partituraAnalizada.contains("<kind text=\"7\">dominant</kind>")   // true
partituraAnalizada.contains("<text>V7/V</text>")               // true
analisis.partitura(notacion: .ascii(.ingles)).musicXML().contains("C major:")      // true
```

`mei()` escribe lo mismo en MEI,
con el cifrado como texto en `<harm>` (en la notación que se pida) y el análisis como letra:

```swift
let progresion = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
progresion.partitura(notacion: .ascii(.ingles)).mei().contains(">D7</harm>")        // true
progresion.partitura().mei().contains("<syl>V7/V</syl>")                   // true
```

### Tensión, movimiento y cromatismo

``EstadisticasDeProgresion`` mide una progresión en una tonalidad: la tensión de Lerdahl de cada acorde
(``TensionDeLerdahl``: desde el anterior y desde la tónica, con ``Tonalidad/distanciaDeLerdahl(de:a:)``), los
semitonos que se mueven las voces de un acorde al siguiente con la conducción mínima, la función probable de cada
acorde, las notas nuevas y las que no son de la tonalidad.

```swift
Tonalidad(.do).distanciaDeLerdahl(de: Acorde("Do"), a: Acorde("Sol"))                     // 5
Tonalidad(.do).distanciaDeLerdahl(de: Acorde("Do"), a: Acorde("Rem"))                     // 8
Tonalidad(.do).estadisticas(de: [Acorde("Do"), Acorde("Fa"), Acorde("Sol7"), Acorde("Do")]).movimientos   // [3, 5, 4]
Tonalidad(.do).estadisticas(de: [Acorde("Do"), Acorde("Lab"), Acorde("Reb7"), Acorde("Do")]).cromatismo  // 0.308
```

`armonia analizar Do Fa Sol7 Do --estadisticas` las escribe debajo del análisis, también en `--json`.

## Cadencias

`cadencias` busca en un análisis las parejas de acordes con forma de cadencia (`Cadencia.Tipo`):

- **Auténtica**: de la dominante (V, V7 o un acorde de sensible) a la tónica. Es **perfecta**
  (`esPerfecta`) con V y I en estado fundamental.
- **Plagal**: de IV (o iv) a la tónica.
- **Rota**: de V a vi (VI en menor, o el ♭VI prestado en mayor).
- **Semicadencia**: termina en V en estado fundamental. Es **frigia** (`esFrigia`) si llega
  desde el iv6, con el bajo bajando medio tono (Rem/Fa–Mi en La menor).

Una plagal desde el iv prestado al I mayor es una **plagal menor** (`esPlagalMenor`), y las dos
se nombran así en `description` y en `nombre(en:)`.

```swift
let cadencia = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do").cadencias[0]
cadencia.tipo                         // .autentica
cadencia.esPerfecta                   // true
cadencia.description                  // "Cadencia auténtica V7–I (acordes 3 → 4)"
cadencia.descripcion(en: .ascii(.ingles))     // "Authentic cadence V7–I (chords 3 → 4)"

Tonalidad(.do).analizar(["Do", "Fa", "Do"]).cadencias.first?.tipo          // .plagal
Tonalidad(.do).analizar(["Do", "Sol7", "Lam"]).cadencias.first?.tipo       // .rota
Tonalidad(.do).analizar(["Do", "Lam", "Fa", "Sol"]).cadencias.first?.tipo  // .semicadencia
Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi"]).cadencias[0].description   // "Semicadencia frigia iv6–V (acordes 2 → 3)"
Tonalidad(.do).analizar(["Do", "Fam", "Do"]).cadencias[0].description       // "Cadencia plagal menor iv–I (acordes 2 → 3)"
```

Sin la partitura no se sabe dónde acaban las frases, así que cada V–I cuenta como cadencia
auténtica, también en mitad de la progresión; la semicadencia solo se reconoce al final. El I64
cadencial no cierra: la cadencia es la del V que lo sigue.

## Modulaciones

`RecorridoTonal` parte una progresión en tramos (`TramoTonal`), cada uno en su tonalidad, y
señala cada modulación (`Modulacion`) con su acorde pivote (`AcordePivote`): el último acorde
que pertenece a las dos tonalidades antes del primero que solo es de la nueva.

```swift
let recorrido = try RecorridoTonal(leyendo: "Do Fa Sol7 Do Lam Re7 Sol")
recorrido.tramos.map(\.tonalidad)    // [Do mayor, Sol mayor]
recorrido.cifrados                   // ["I", "IV", "V7", "I", "ii", "V7", "I"]
recorrido.description                // "I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor"
recorrido.modulaciones[0].acorde     // 4
recorrido.modulaciones[0].pivote?.description   // "Lam = vi en Do mayor = ii en Sol mayor"
recorrido.cadencias.map(\.tonalidad)  // [Do mayor, Sol mayor]

try RecorridoTonal(leyendo: "Do Sol Do Fa Rem Mi7 Lam").modulaciones[0].description
// "De Do mayor a La menor en el acorde 5 (pivote: Rem = ii en Do mayor = iv en La menor)"
```

Una tonalidad nueva tiene que confirmarse con una cadencia auténtica a su tónica; si no, los
acordes ajenos son dominantes secundarias o préstamos de la tonalidad en la que se está (una
tonicalización):

```swift
try RecorridoTonal(leyendo: "Do Lam Re7 Sol7 Do").modulaciones.isEmpty   // true
```

Entre las particiones posibles se elige la de menor coste, con el mismo coste por acorde que usa
`AnalisisArmonico` para elegir la tonalidad, una rebaja por cada cadencia auténtica en la
tonalidad del tramo y un coste fijo por cada modulación. Si la progresión no modula, el único
tramo es el mismo análisis que da `AnalisisArmonico.analizar`.

### Planificar una modulación

`modulaciones(hasta:)` hace el camino contrario: escribe progresiones que van de una tonalidad
a otra (`PlanDeModulacion`). Cada una afirma la de partida con I–IV–V7–I, pasa por un puente y
confirma la de llegada con V7–I. Salen de la más suave a la más brusca: primero por un **acorde
común** (los que en la nueva son ii o IV, luego vi y iii); después por una **séptima disminuida
enarmónica**, el vii°7 de un grado de la de partida que, escrito de otra forma, es el de la nueva;
y al final la **directa**, el ii–V7–I de la nueva sin puente.

```swift
let planes = Tonalidad(.do).modulaciones(hasta: Tonalidad(.sol))
planes[0].tecnica                    // .acordeComun
planes[0].pivote?.description        // "Lam = vi en Do mayor = ii en Sol mayor"
Tonalidad(.do).modulaciones(hasta: Tonalidad(Nota.la.bemol))[0].tecnica   // .disminuidaEnarmonica
```

## Conducción de voces

`Coral` comprueba las reglas de la armonía escrita voz por voz. Cada acorde lleva
sus alturas de grave a agudo (a cuatro voces: bajo, tenor, contralto y soprano), separados
por barras o comas:

```swift
let c = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5")
c.faltas.map(\.tipo) == [.quintasParalelas, .octavasParalelas]   // true
c.faltas[0].voces                  // [0, 1]
c.faltas[0].description            // "Quintas paralelas entre bajo y tenor (acordes 1 → 2)"
c.faltas[0].descripcion(en: .ascii(.ingles))   // "Parallel fifths between bass and tenor (chords 1 → 2)"

try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5").esCorrecta   // true
try Coral(voces: [["Do3", "Sol2"], ["Mi4", "Re4"], ["Sol4", "Sol4"], ["Do5", "Si4"]]).esCorrecta       // true
```

Las faltas que encuentra (`FaltaDeConduccion.Tipo`):

- **Quintas y octavas paralelas**: dos voces a distancia de quinta justa, u octava justa o
  unísono, que se mueven a otra igual, también por movimiento contrario. Una quinta justa que
  pasa a disminuida no cuenta.
- **Quintas y octavas directas**: bajo y soprano llegan a una quinta u octava justa
  moviéndose en el mismo sentido, con salto en el soprano.
- **Cruce de voces** y **superposición** (una voz pasa más allá de la nota que la vecina
  tenía en el acorde anterior).
- **Más de una octava** entre dos voces superiores vecinas; entre bajo y tenor se permite.
- **Salto no melódico**: más de una octava, o un intervalo aumentado (salvo el semitono cromático).
- **Fuera de tesitura**, a cuatro voces: bajo Mi2–Do4, tenor Do3–Sol4, contralto Sol3–Re5 y
  soprano Do4–Sol5.

`partitura(duracion:compas:encabezado:conCifrados:conAnalisis:notacion:)` pone los acordes en una
partitura de coral: soprano y contralto en clave de sol, tenor y bajo en clave de fa, cada voz con sus
plicas. Todos los acordes duran lo mismo (negras si no se dice otra cosa) y el último se
alarga hasta la barra:

```swift
let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
let partitura = coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia")).musicXML()
partitura.contains("<staves>2</staves>")        // true
```

Con `conCifrados: true` cada acorde lleva su cifrado americano encima del soprano, y con
`conAnalisis: true`, el cifrado romano y la función debajo del bajo. Los acordes se identifican
por sus notas; los que no son de ningún tipo del catálogo (por una nota de paso, por ejemplo)
se quedan sin cifrar:

```swift
let cadencia = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
cadencia.partitura(conCifrados: true, conAnalisis: true).musicXML().contains("<text>V</text>")   // true
```

`mei()` da el mismo coral en MEI, con cada pareja de voces en dos capas del pentagrama:

```swift
let cierre = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
cierre.partitura(conCifrados: true, conAnalisis: true).mei().contains("<syl>V</syl>")           // true
```

## Realización a cuatro voces

`Coral.realizar(_:soprano:en:)` escribe unos acordes a cuatro voces sin ninguna de
las faltas anteriores, con el bajo del cifrado y moviendo las voces lo menos posible (en
semitonos, como `conduccionMinima(hasta:)`, pero con alturas). Duplica antes la fundamental que
la quinta y esta antes que la tercera, nunca la sensible ni la séptima; puede omitir la quinta
justa; hace subir la sensible a la tónica y bajar la séptima por grado conjunto. Con `soprano`,
la melodía del soprano queda fijada:

```swift
let coral = Coral.realizar(["Do", "Fa", "Sol7", "Do"])!
coral.esCorrecta                      // true
coral.voz(0).map(\.nota)              // [Do, Fa, Sol, Do]

let conSoprano = Coral.realizar(["Do", "Fa", "Sol", "Do"], soprano: ["Mi4", "Fa4", "Re4", "Do4"])!
conSoprano.voz(3)                     // [Mi4, Fa4, Re4, Do4]
Coral.realizar(["Do", "Rem"], soprano: ["Sol4", "La4"])   // nil: quintas paralelas con el bajo
```

## Armonización de melodías

`acordes(para:)` da los acordes de la tonalidad que tienen una nota, de más a menos habitual, y
`armonizar(melodia:propuestas:)`, las mejores sucesiones de acordes para una melodía, cada una
con su coste (`Candidato`). La sucesión se puntúa con la armonía funcional: tónica,
subdominante, dominante y tónica es lo natural; de la dominante a la subdominante cuesta mucho;
una dominante secundaria tiene que ir a su destino; se prefiere empezar en la tónica y terminar
con una cadencia auténtica (o con una semicadencia si la última nota no es del I).

```swift
Tonalidad(.do).acordes(para: .sol).prefix(3).map(\.valor)   // [Sol, Do, Sol7]

let propuestas = Tonalidad(.do).armonizar(melodia: ["Mi", "Fa", "Re", "Do"], propuestas: 3)
propuestas.map(\.valor.cifrados)     // [["I", "IV", "V", "I"], ["I", "IV", "V7", "I"], ["I", "ii", "V", "I"]]
propuestas[0].valor.description      // "Do Fa Sol Do (I–IV–V–I)"
Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"])[0].valor.cifrados   // ["I", "V/V", "V", "I"]
```

`armonizarACuatroVoces(_:)` elige a la vez los acordes y las disposiciones, con la melodía en el
soprano: de las armonizaciones que se pueden realizar sin faltas, la de menos coste.

```swift
let armonizada = Tonalidad(.do).armonizarACuatroVoces(["Mi4", "Fa4", "Re4", "Do4"])!
armonizada.armonizacion.cifrados      // ["I", "IV", "V", "I"]
armonizada.coral.voz(3)               // [Mi4, Fa4, Re4, Do4]
armonizada.coral.esCorrecta           // true
```

## Esquemas armónicos

`EsquemaArmonico.buscar(en:)` reconoce en una progresión las del catálogo de progresiones
(`ProgresionConNombre.catalogo`, más abajo), por el movimiento de las fundamentales y el tipo de
los acordes, en cualquier tonalidad (también las secundarias). Las del jazz y el blues y las
secuencias y esquemas del barroco y el galante tienen reglas propias, que admiten sus variantes:

- Del jazz y el blues: **ii–V–I** en mayor y en menor (y el **ii–V** que no resuelve),
  **turnaround** (I–vi–ii–V o iii–vi–ii–V), **backdoor** (iv7–♭VII7–I) y **blues de 12
  compases**, mayor o menor (un acorde por compás, con el IV en el segundo y el V en el último si
  se quiere).
- Secuencias y esquemas del barroco y el galante: **quintas descendentes** (cuatro acordes o
  más), **romanesca** (I–V–vi–iii), **canon de Pachelbel** (I–V–vi–iii–IV–I–IV–V), **monte**
  (V7/IV–IV–V7/V–V), **fonte** (V7/ii–ii–V7–I) y **ponte** (V–V7 sobre el mismo bajo, y la tónica).

Las demás de tres acordes o más se reconocen por sus grados: las fundamentales, la calidad de
cada tríada (con séptima o sin ella) y el bajo de las que van invertidas. Así se encuentran la
cadencia andaluza, la folía, el bajo de lamento, el do-re-mi, el Prinner, la chacona, el
I–V–vi–IV, los cambios de Coltrane… Las cadencias de dos acordes las reconoce `Cadencia`, que sabe en qué tonalidad se
está. Cada esquema dice cuál es (`progresion`, una `ProgresionConNombre`), dónde está (`indices`) y a
qué tónica va.

```swift
let esquemas = EsquemaArmonico.buscar(en: ["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"])
esquemas.map(\.progresion)    // [turnaround, progresión por quintas, ii–V–I]
esquemas.map(\.indices)       // [0..<4, 1..<5, 2..<5]
EsquemaArmonico.buscar(en: ["Fam7", "Sib7", "Do7M"])[0].progresion == .backdoor     // true
EsquemaArmonico.buscar(en: ["Lam", "Sol", "Fa", "Mi"])[0].progresion == .andaluza   // true
EsquemaArmonico.buscar(en: ["Lam", "Sol", "Fa", "Mi"])[0].tonica                  // La
```

`rearmonizaciones(de:)` propone también preparar un acorde con su **ii–V** (Rem → Mim7 La7 Rem)
y cambiar el V7 de una tonalidad mayor por el **backdoor** (Sol7 → Fam7 Si♭7).

## Cifrado romano

`acorde(romano:)` lee un cifrado romano en la tonalidad, escrito como lo escribe `analizar(_:)`:
el numeral en mayúsculas o minúsculas (tríada mayor o menor), la calidad detrás («°», «ø7»,
«maj7», «7»), las inversiones en cifras de bajo continuo («6», «64», «65», «43», «42»), una
alteración delante para los grados cromáticos («♭VI», «♭VII») y, tras una barra, el grado del
que es dominante, sensible o sustituto («V7/V», «vii°7/ii», «subV7/ii»). «N6» es la napolitana, y
«It+6», «Fr+6» y «Ger+6», las sextas aumentadas. `acordes(romanos:)` lee una progresión entera.
Si algo no se lee, lanzan `ErrorDeLecturaDeTeoria` en su carácter: `.cifradoRomanoNoValido`, o
`.destinoNoTonicalizable` si lo que va tras la barra no es una tríada mayor o menor («V/vii°»).

```swift
try Tonalidad(.do).acorde(romano: "ii65") == Acorde("Rem7/Fa")                       // true
try Tonalidad(.do).acorde(romano: "V7/V") == Acorde("Re7")                           // true
try Tonalidad(.la, .menor).acorde(romano: "vii°7") == Acorde("Sol#°7")               // true
try Tonalidad(.do).acordes(romanos: "I ♭VI ♭VII I") == ["Do", "Lab", "Sib", "Do"]    // true
```

## El catálogo de progresiones

`ProgresionConNombre.catalogo` reúne 52 progresiones con nombre, cada una con sus grados en
cifrado romano, su modo, sus estilos y, si la hay, la obra donde se lee:

- Las cadencias (perfecta, plagal, rota, semicadencia, frigia, napolitana, con sexta aumentada,
  evitada y la tercera de picardía) y la progresión por quintas.
- Los esquemas del galante (romanesca, canon de Pachelbel, monte, fonte, ponte, do-re-mi,
  Prinner, Fenaroli, quiescenza, Meyer, sol-fa-mi e indugio), la folía, el bajo de lamento,
  diatónico y cromático, y los bajos de danza del Renacimiento y el barroco (passamezzo antico y
  moderno, ruggiero, bergamasca, chacona y pasacalle).
- Las del jazz y el blues: ii–V–I mayor y menor, ii–V, ii–subV–I, turnaround, el de Tadd
  Dameron, backdoor, blues de 12 compases, menor y el Bird blues, rhythm changes, cambios de
  Coltrane y la progresión de Autumn Leaves.
- Las del pop y el rock: I–V–vi–IV, progresión de los 50, ♭VI–♭VII–I, cadencia andaluza,
  I–♭VII–IV, i–♭VII–♭VI–♭VII, I–IV–V–IV e I–III–IV–iv.

`acordes(sobre:)` la escribe con una
tónica, en su modo, y `nombre(en:)` la nombra en los trece idiomas. `buscar(nombre:)` la
encuentra por su nombre, un alias o una variante en cualquier idioma, sin mirar mayúsculas,
tildes ni guiones, y `buscar(conteniendo:)` da las que tienen un texto en el nombre. Una
progresión propia se crea con `ProgresionConNombre(nombre:leyendo:modo:…)`, que lanza un error si
su cifrado no se lee. En la línea de comandos, `armonia progresiones andaluza --en La` las busca y
las escribe.

```swift
ProgresionConNombre.monte.acordes(sobre: .do) == ["Do7", "Fa", "Re7", "Sol"]           // true
ProgresionConNombre.andaluza.acordes(sobre: .la) == ["Lam", "Sol", "Fa", "Mi"]         // true
ProgresionConNombre.andaluza.nombre(en: .conPalabras(.ingles)) == "Andalusian cadence"   // true
ProgresionConNombre.buscar(nombre: "ii-V-I") == .iiVI                                    // true
ProgresionConNombre.buscar(conteniendo: "blues").count                                  // 3
```

## Bajo cifrado

`acorde(sobre:cifras:)` lee las cifras del bajo continuo sobre una nota del bajo, contando los
intervalos en la armadura de la tonalidad (en menor, la natural: la sensible se escribe con su
alteración). Completa las abreviaturas (nada o «5» es la tríada, «6» y «64» sus inversiones,
«7», «65», «43» y «42» la séptima y las suyas), y una alteración sola altera la tercera.
`acordes(bajoCifrado:)` lee una línea entera, con cada nota del bajo y sus cifras tras dos
puntos, y `Coral.realizar(bajoCifrado:en:soprano:)` la realiza a cuatro voces. Unas cifras que no
se leen lanzan `.cifrasNoValidas`, y unas que no forman acorde, `.cifrasSinAcorde`.

```swift
try Tonalidad(.do).acorde(sobre: .si, cifras: "65")                    // Sol7/Si
try Tonalidad(.la, .menor).acorde(sobre: .mi, cifras: "#")             // Mi
try Tonalidad(.la, .menor).acordes(bajoCifrado: "La Fa:6 Mi:# La")     // [Lam, Rem/Fa, Mi, Lam]
let realizado = try Coral.realizar(bajoCifrado: "Do Fa Sol:7 Do", en: Tonalidad(.do))!
realizado.esCorrecta                  // true
```

## Armonía negativa

`negativa(_:)` refleja una nota sobre el eje que queda entre la tónica y la dominante (entre Mi♭ y
Mi en Do): Do ↔ Sol, Mi ↔ Mi♭, Si ↔ La♭, Re ↔ Fa. El eje es el mismo en mayor y en menor.
`negativo(_:)` refleja todas las notas de un acorde y lo lee en estado fundamental si puede: el
acorde mayor se vuelve menor, y la dominante, subdominante menor (Sol7 → Reø7). `negativos(_:)`
hace lo mismo con una progresión.

```swift
Tonalidad(.do).negativa(.mi) == Nota(.mi, .bemol)                  // true
Tonalidad(.do).negativo(Acorde("Do")) == Acorde("Dom")             // true
Tonalidad(.do).negativo(Acorde("Fa")) == Acorde("Solm")            // true
```

## Notas extrañas a la armonía

`NotaDeLaMelodia.analizar(_:sobre:partesFuertes:)` mira cada nota de una melodía con el acorde
que suena con ella (uno por nota; si un acorde dura varias, se repite) y, si no es del acorde,
dice qué nota extraña es (`NotaExtrana`) por cómo se llega a ella y cómo se sale: de paso
(grado conjunto en el mismo sentido), bordadura (grado conjunto de ida y vuelta), apoyatura
(salto y grado conjunto), escapada (grado conjunto y salto), anticipación (la nota del acorde
siguiente antes de tiempo), retardo (la nota del acorde anterior que se mantiene y resuelve
por grado conjunto, con sus cifras sobre el bajo), pedal (la que se repite mientras cambian los
acordes) o libre (ninguna de las anteriores).

```swift
let melodia: [Altura] = ["Mi5", "Re5", "Do5", "Do5", "Si4", "Do5"]
let notas = NotaDeLaMelodia.analizar(melodia, sobre: ["Do", "Do", "Fa", "Sol", "Sol", "Do"])!
notas[1].description           // "Re5 (nota de paso)"
notas[3].description           // "Do5 (retardo 4-3)"
notas.notasExtranas.map(\.indice)   // [1, 3]
NotaExtrana.apoyatura.nombre(en: .ascii(.ingles))   // "appoggiatura"
```

## Contrapunto de especies

`Contrapunto` comprueba un ejercicio de contrapunto a dos voces como los del *Gradus ad
Parnassum* de Fux: un cantus firmus en redondas y, encima o debajo, un contrapunto de una de las
cinco especies (nota contra nota, dos blancas, cuatro negras, síncopas y florido). El cantus se
escribe como alturas y el contrapunto como los eventos de una voz; una nota sin duración lleva la
figura de la especie:

```swift
let cantus = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"
let fux = try Contrapunto(cantusFirmus: cantus, contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)
fux.esCorrecto            // true
fux.contrapuntoArriba     // true
fux.informe.hasPrefix("Especie 1, con el contrapunto encima del cantus firmus\n")   // true
fux.informe.hasSuffix("Sin faltas.")              // true

let quintas = try Contrapunto(cantusFirmus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera)
quintas.faltas.contains(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1))   // true
FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1).description              // "Quintas paralelas (compases 1 → 2)"

// Segunda especie, empezando con silencio de blanca; cuarta, con la cadencia 7–6 ligada.
try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1", especie: .segunda).esCorrecto   // true
try Contrapunto(cantusFirmus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1", especie: .cuarta).esCorrecto                // true
```

Las dos voces se exportan como las de un coral, cada una en su pentagrama y con su clave, con
``Contrapunto/partitura(encabezado:)`` y cualquiera de los formatos de la ``Partitura``. Sin tonalidad no llevan armadura, como los ejemplos
modales de Fux, y las voces se llaman en latín: *Cantus firmus* y *Contrapunctus*.

Las faltas que encuentra (`FaltaDeContrapunto.Tipo`), con los compases contados desde 0 (en la
descripción, desde 1):

- **Ritmo de la especie**: un compás con otras figuras (tres notas en la segunda especie, por
  ejemplo), o un silencio que no es el del principio.
- **Principio y final**: se empieza en unísono, quinta u octava (debajo del cantus, solo unísono u
  octava), se acaba en unísono u octava y a la última nota se llega por grado conjunto.
- **Disonancias**: en parte fuerte solo valen los retardos de la cuarta especie, preparados en
  consonancia y resueltos bajando por grado; en parte débil, las notas de paso y, desde la
  tercera especie, las bordaduras. A dos voces, la cuarta justa es disonancia.
- **Quintas y octavas paralelas y directas**, el **unísono** en medio del ejercicio y el **cruce**
  con el cantus.
- **Saltos**: no se admiten los aumentados y disminuidos, las séptimas, la sexta mayor, la sexta
  menor descendente ni los de más de una octava; tras un salto de más de una cuarta, la voz
  vuelve en sentido contrario. Desde la segunda especie, tampoco se repite una nota sin ligarla.

`informe(en:)` lo resume todo en el idioma que se pida, como la orden `armonia contrapunto`.

### A tres y cuatro voces

`ContrapuntoAVariasVoces` comprueba un cantus firmus con dos o tres voces más, cada una de su
especie, como en el libro II de Fux. Cada voz cumple con el cantus las reglas de dos voces, con
lo que cambia al haber más: el principio y el final se miden desde el bajo (consonancia perfecta
o tercera), una cuarta entre dos voces que no son el bajo es consonante, las directas solo
cuentan entre las voces extremas y el bajo puede llegar al final saltando. Entre cada par de
voces, también entre las que se añaden, se buscan paralelas, unísonos, disonancias y cruces.
Cada falta (``FaltaEntreVoces``) dice qué voces la cometen: 0 es el cantus.

```swift
let tres = try ContrapuntoAVariasVoces(cantusFirmus: "Re4 Fa4 Mi4 Re4", voces: [("La4 La4 Do#5 Re5", .primera), ("Re3 Re3 La2 Re3", .primera)])
tres.esCorrecto            // true

let paralelas = try ContrapuntoAVariasVoces(cantusFirmus: "Re4 Fa4 Mi4 Re4", voces: [("La4 La4 Sol4 La4", .primera), ("Re3 Re3 Do3 Re3", .primera)])
paralelas.faltas.contains(FaltaEntreVoces(falta: FaltaDeContrapunto(tipo: .quintasParalelas, compases: 1...2), voces: [1, 2]))   // true
```
