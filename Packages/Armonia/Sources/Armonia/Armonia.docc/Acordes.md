# Acordes

Cifrado americano generativo, identificación tolerante, estilos y estructura de los acordes.

## Acordes: cifrado generativo

Un `TipoDeAcorde` es el conjunto de desplazamientos en quintas de sus notas respecto a la
fundamental. Como la ortografía fija el papel de cada nota (la ♯9 es +9 quintas y la 3ª
menor −3, aunque suenen igual), el cifrado se **genera** a partir del conjunto y se **lee**
con la misma gramática, sin una lista cerrada de tipos:

```swift
Acorde("G7(b9,#11)").cifrado        // "Sol7(♭9,♯11)"
TipoDeAcorde("m11").cifrado           // "m11"
TipoDeAcorde("13sus4").intervalos     // [1ª justa, 4ª justa, 5ª justa, 7ª menor, 9ª mayor, 13ª mayor]
TipoDeAcorde("7alt").cifrado          // "7(♭9,♯9,♯11,♭13)"
Acorde("Do6/9/Mi")                  // la barra del bajo es la última seguida de una nota
Acorde("Do/Re").tieneBajoAjeno      // true
```

Se aceptan, entre otros: `m min -`, `° dim o`, `ø`, `+ aug`, `maj M Δ 7M`, `5 6 7 9 11 13`,
`6/9`, `sus sus2 sus4`, `add9 add♭13`, alteraciones `b9 #11 -5 +9` con o sin paréntesis,
`alt`, `omit3 no5`. Cualquier cifrado generado se vuelve a leer igual (comprobado sobre
miles de combinaciones).

La fundamental y el bajo también se pueden escribir con la alteración en palabras, separada de la nota
por un espacio: `Acorde(leyendo: "Fa sostenido m7")`, `Acorde(leyendo: "B flat 7(b9)")` o
`Acorde(leyendo: "Sol7/Fa sostenido")`. La palabra va en el idioma de la nota («Fa sharp» no se lee) y tiene
que terminar ahí («Fa sostenidom7» tampoco). Como las melodías, las voces y la línea de comandos separan
las notas por espacios, allí se escriben con signos.

**Igualdad por contenido.** Dos `TipoDeAcorde` son iguales si tienen las mismas notas
(`"add2" == "add9"`, `"Δ" == "maj7"`), y dos `TipoDeEscala` si tienen los mismos intervalos,
sea cual sea su nombre.

**Identificación tolerante.** `Acorde.candidatos(notas:)` devuelve todas las lecturas razonables
ordenadas por coste (menor = más probable), como `Candidato<Acorde>`. Admite notas duplicadas, quinta omitida,
tensiones alteradas y bajo ajeno:

```swift
let c = Acorde.candidatos(notas: [.do, .mi, "Sib"]).first!
c.valor.cifrado    // "Do7"
c.omitidas         // [Sol]
Acorde.identificar(notas: [.do, .mi, "Sib", "Reb"]).first   // Do7(♭9)
```

## Sextas aumentadas

Los acordes de sexta aumentada se escriben desde el bajo natural, ♭6̂, con la sexta aumentada
(`♯6`) dentro de la octava, como una sexta añadida: la italiana es `La♭(♯6,omit5)`, la francesa
`La♭(♯6,♯11,omit5)`, la alemana `La♭(♯6)` y la suiza, la alemana con la cuarta doble aumentada en lugar
de la quinta (La♭ Do Re♯ Fa♯), `La♭(♯6,𝄪11,omit5)`, que también se lee `Lab(#6,##11,omit5)`. Sin quinta, la italiana y la francesa no se dan por
incompletas al identificarlas:

```swift
Acorde("Lab(#6,omit5)").tipo.nombre                         // "sexta aumentada italiana"
Acorde.identificar(notas: ["La♭", "Do", "Fa♯"] as [Nota]).first?.cifrado             // "La♭(♯6,omit5)"
Acorde.identificar(notas: ["La♭", "Do", "Mi♭", "Fa♯"] as [Nota]).first?.cifrado      // "La♭(♯6)"
```

La francesa también es `Re7(♭5)/La♭`, que sale antes al identificarla; el análisis en una
tonalidad las reconoce escritas de cualquier forma (véase «Tonalidad»).

## Acordes con nombre

Un ``AcordeConNombre`` es una entrada del catálogo de acordes: un nombre, otros nombres y las notas desde la más
grave, con su ortografía. A diferencia de `TipoDeAcorde`, que es solo contenido, varios acordes con nombre pueden
tener el mismo tipo, y uno puede no tener ninguno, si sus notas no se leen por terceras. El catálogo
(``AcordeConNombre/catalogo``), con sus nombres en los trece idiomas, tiene dos partes. Los genéricos
(``AcordeConNombre/genericos``) son los tipos que tienen nombre, y de ellos sale el nombre de un tipo:

```swift
AcordeConNombre.dominanteSeptima.nombre                        // "séptima de dominante"
AcordeConNombre.dominanteSeptima.tipo?.cifrado                 // "7"
AcordeConNombre.dominanteSeptima.notas(sobre: .sol)            // [Sol, Si, Re, Fa]
TipoDeAcorde.dominanteSeptima.acordeConNombre == .dominanteSeptima   // true
AcordeConNombre.sextaAumentadaAlemana.estilos                  // [clasica]
```

Los genéricos citan dónde se leen: Aldwell, Schachter y Cadwallader los de la armonía tonal (las tríadas, las séptimas,
las sextas aumentadas), Levine los del jazz y Walser el de potencia. Los de nombre propio
(``AcordeConNombre/conNombrePropio``) son acordes de una obra o de un estilo, con la obra donde se leen: el de
Tristán, el místico de Skriabin, el de Petrushka, el de «Farben», el So What, el de Hendrix, el mu, el acorde por
cuartas, el de «Elektra», el de los augures, el de la «Sinfonía de los salmos» y el alfa de Lendvai. Los de Hendrix y
mu, los cuatro últimos y la novena añadida menor, m(add9), no citan todavía ninguna obra. No dan nombre a su tipo,
pero ``TipoDeAcorde/acordesConNombre`` los encuentra:

```swift
AcordeConNombre.tristan.notas(sobre: .fa)                      // [Fa, Si, Re♯, Sol♯]
AcordeConNombre.tristan.referencias.map(\.cita)              // ["Wagner 1859", "Rothgeb 1995"]
AcordeConNombre.dominanteSeptima.referencias.map(\.cita)     // ["Aldwell et al. 2011", "Levine 1995"]
AcordeConNombre.petrushka.tipo                                 // nil
TipoDeAcorde.mayorNovenaAnadida.acordesConNombre               // [novena añadida, acorde mu]
```

`nombre(en:)` lo nombra en los trece idiomas. ``AcordeConNombre/buscar(nombre:)`` lo encuentra por su nombre, un
alias o una variante en cualquier idioma, sin mirar mayúsculas, tildes, espacios ni guiones, y
``AcordeConNombre/buscar(conteniendo:)`` da los que tienen un texto en el nombre. En la línea de comandos,
`armonia acordes tristan --sobre Fa` los busca y escribe sus notas.

```swift
AcordeConNombre.dominanteSeptima.nombre(en: .conPalabras(.ingles))   // «dominant seventh»
AcordeConNombre.buscar(nombre: "Tristan chord") == .tristan          // true
AcordeConNombre.buscar(conteniendo: "sexta aumentada").count         // 4
```

## Cardinal y estadísticas

``CardinalDeAcorde`` nombra un acorde por sus notas distintas, como ``CardinalDeEscala`` a las escalas: díada,
tríada, tétrada, péntada, héxada, héptada y óctada, que es la de la séptima alterada y el acorde alfa. Lo dan
`TipoDeAcorde`, `AcordeConNombre` (también los que no se leen por terceras) y `Acorde`, con el bajo si es ajeno.

```swift
TipoDeAcorde.dominanteSeptima.cardinal?.nombre                 // "tétrada"
TipoDeAcorde.potencia.cardinal?.nombre(en: .conPalabras(.ingles))   // "dyad"
AcordeConNombre.petrushka.numeroDeNotas                        // 6
TipoDeAcorde.todos(numeroDeNotas: 3).count                     // 6
```

``EstadisticasDeAcorde`` es lo que se mide de él, como ``EstadisticasDeEscala``: el número de notas, si se lee por
terceras y cuántas tensiones lleva, el brillo por quintas (la media de las quintas de la fundamental a cada nota), la
amplitud en quintas, el vector interválico, la forma prima y el número de Forte, las transposiciones distintas, si es
simétrico por inversión, si es anhemitónico, si tiene un tritono y, en los acordes con nombre, el ámbito de su
disposición en semitonos.

```swift
TipoDeAcorde.dominanteSeptima.estadisticas.brilloPorQuintas    // 0.75
TipoDeAcorde.dominanteSeptima.estadisticas.numeroDeForte       // "4-27"
TipoDeAcorde.disminuidoSeptima.estadisticas.transposicionesDistintas   // 3
AcordeConNombre.tristan.estadisticas.ambito                    // 15
AcordeConNombre.petrushka.estadisticas.porTerceras             // false
```

### Lo que dice la teoría

Además de contar, ``EstadisticasDeAcorde`` mide el acorde con las medidas clásicas de la teoría y la psicoacústica:

- **Consonancia diádica** (Huron, 1994): la suma del vector interválico por los pesos de consonancia de cada clase de
  intervalo; cuanto más alta, más consonante.
- **Grupo y fundamental de Hindemith** (*Unterweisung im Tonsatz*, 1937): ``GrupoDeHindemith`` clasifica el acorde
  por si tiene tritono, segundas o séptimas y si la fundamental está en el bajo (I 1 … VI); la fundamental es la nota
  grave o aguda del mejor intervalo de la serie 2 (quinta, cuarta, terceras…), y `nil` si es indeterminado.
- **Intervalos entre voces**, en semitonos, de la disposición de grave a agudo.
- **Gradus suavitatis** (Euler, 1739) de las notas afinadas en justa sobre la fundamental: 1 es el unísono.
- **Magnitudes de Fourier** |f1|…|f6| (Quinn, Amiot): cuánto se parece el conjunto a la escala cromática, la de
  tonos enteros, el acorde aumentado, el disminuido, el ciclo de quintas y el tritono.
- **Prominencias de fundamental** (Parncutt, 1988): ``ProminenciaDeFundamental`` da cada nota con su peso, y la
  primera es la fundamental más probable.
- **Distancia a la uniformidad** (Tymoczko): cuánto se aleja de repartir las notas a partes iguales en la octava.
- ``TriadasContenidas``: cuántas tríadas mayores, menores, disminuidas y aumentadas hay entre sus notas.
- **Tensión y modalidad** (Cook y Fujisawa, 2006): la tensión de las tríadas de intervalos iguales y la modalidad,
  positiva en las mayores y negativa en las menores.
- **Rugosidad** (Sethares, 1993) de la disposición con seis armónicos desde el Do central.

- **Afinación justa**: la altura de Tenney (log₂(n·d) de cada par de notas), los límites impar y primo de Partch y
  la armonicidad de Gill y Purves (el porcentaje de armónicos que comparten), con cada nota afinada en el sistema de
  cinco límites que pide su ortografía.
- **Entropía armónica** (Erlich): cuánto cuesta oír cada intervalo entre voces como una razón sencilla, en bits.
- **Fundamental virtual** (Terhardt): la nota de la que más notas del acorde son armónicos, aunque no suene.
- **Fusión tonal** (Huron, 1991): la proporción de pares de voces a unísono, octava o quinta.
- **Rugosidad de Vassilakis y disonancia de Hutchinson y Knopoff**, las otras dos medidas clásicas de aspereza.
- **Pareja Z y complemento** de Forte.
- **Disposición**: cerrada, drop 2, drop 3, drop 2 + 4 u otra abierta, y si deja los intervalos anchos abajo, como
  la serie armónica.

```swift
TipoDeAcorde.mayor.estadisticas.conjunto.consonanciaDiadica           // 2.22
TipoDeAcorde.potencia.estadisticas.afinacion.limiteImpar              // 3
TipoDeAcorde.dominanteSeptima.estadisticas.afinacion.limiteImpar      // 45
TipoDeAcorde.mayor.estadisticas.afinacion.armonicidad                 // 51.1
AcordeConNombre.hendrix.estadisticas.conjunto.parejaZ                 // "4-Z29"
TipoDeAcorde.dominanteSeptima.estadisticas.afinacion.gradoDeSuavidad  // 11
TipoDeAcorde.mayor.estadisticas.afinacion.gradoDeSuavidad             // 7
```

En la línea de comandos, `armonia acorde Sol7 --estadisticas` las escribe; `armonia acordes` filtra el catálogo por
ellas (`--notas 4` o `--notas tétrada`, `--por-terceras`, `--sin-semitonos`, `--con-intervalo tritono`…), lo ordena
con `--orden brillo` (o `notas`, o `consonancia`), lo pone en una tabla con `--estadisticas` y cuenta cuántos hay de cada clase con `--resumen`.

### Lo que separa a dos acordes

``RelacionEntreAcordes`` mide la distancia de un acorde a otro: la conducción de voces mínima con los tres tamaños
de Tymoczko (*A Geometry of Music*, 2011: la suma de los semitonos, la euclídea y la del máximo), los pasos P, L y R
del Tonnetz entre dos tríadas, la distancia de Lerdahl en una tonalidad (*Tonal Pitch Space*, 2001) y lo que se
parecen sus contenidos (``RelacionEntreConjuntos``: Fourier, Isaacson, Morris y Forte). Con una tonalidad,
``Tonalidad/ajuste(de:)`` da cómo encaja el acorde en ella según el perfil de Krumhansl y Kessler,
``Acorde/ajustesTonales`` ordena las 24 tonalidades por ese ajuste, ``Tonalidad/funcionProbable(de:)`` dice qué
función hacen sus notas aunque no sea uno de sus grados y ``Acorde/escalasDelCatalogo`` busca en todo el catálogo las
escalas que lo contienen.

```swift
Acorde("Sol7").relacion(con: Acorde("Do")).conduccion.semitonosMovidos         // 4
Acorde("Sol7").relacion(con: Acorde("Do")).conduccion.desplazamientoEuclideo   // 2.449
Acorde("Sol7").relacion(con: Acorde("Do")).distanciaDeLerdahl                  // 5
Acorde("Do").relacion(con: Acorde("Lab")).distanciaEnElTonnetz                 // 2
Acorde("Do").relacion(con: Acorde("Lab")).conjunto.distanciaDeFourier          // 0
Acorde("Sol7").ajustesTonales.first?.tonalidad.nombre                          // "Sol mayor"
Tonalidad(.do).funcionProbable(de: Acorde("Reb7"))                             // .dominante
```

`armonia acorde Sol7 --comparar Do` añade estas distancias a la conducción, y `armonia acorde Sol7 --estadisticas`,
cómo encaja en la tonalidad (la de `--en`, o la suya).

## Identificación desde alturas (MIDI)

Un teclado o un archivo MIDI solo da alturas. `Acorde.candidatos(midi:)` y
`candidatos(clasesDeAltura:)` prueban todas las ortografías posibles de cada nota (cada
distancia en semitonos admite una o dos posiciones en la línea de quintas), puntúan cada
lectura igual que con nombres y escriben la fundamental de la forma más sencilla:

```swift
Acorde.identificar(midi: [60, 64, 68]).first          // Do+   (no La♭+/Do)
Acorde.identificar(midi: [60, 63, 66, 69]).first      // Do°7  (no Si♯°7)
Acorde.identificar(midi: [61, 65, 68]).first          // Re♭   (no Do♯)
Acorde.identificar(midi: [55, 59, 62, 65, 68]).first  // Sol7(♭9)
Acorde.identificar(midi: [66, 70, 73], tonalidad: "Solb mayor").first   // Sol♭
Acorde("Do+").ortografiar(midi: [60, 64, 68])        // [Do4, Mi4, Sol♯4]
```

Con `tonalidad:` se prefieren las notas propias de la tonalidad (en menor, también el 6.º y
el 7.º elevados); con `escala:`, las de una escala cualquiera, como un modo. Una prueba exhaustiva recorre todos los tipos
predefinidos sobre las 12 fundamentales y comprueba que el acorde correcto sale primero.

## Estilos de cifrado

Las adiciones, alteraciones y omisiones van en un único grupo entre paréntesis
(`Mim(add♭13)`, `sus4(add9)`, `7(♭9,♯11)`), y `EstiloDeCifrado` cambia la notación sin
cambiar el significado. Todos los estilos se vuelven a leer igual.

| Estilo | Si♭7(♭9)/Re | Do♯m7(♭5) | Mi♭maj7 | Fa+ |
|---|---|---|---|---|
| `.predeterminado` | Si♭7(♭9)/Re | Do♯m7(♭5) | Mi♭maj7 | Fa+ |
| `.ascii(.espanol)` | Sib7(b9)/Re | Do#m7(b5) | Mibmaj7 | Fa+ |
| `.ascii(.ingles)` | Bb7(b9)/D | C#m7(b5) | Ebmaj7 | F+ |
| `.compacta(.ingles)` | B♭7(♭9)/D | C♯m7(♭5) | E♭maj7 | F+ |
| `.jazz` | Bb7(b9)/D | C#ø7 | EbΔ7 | F+ |
| `.calidadesConPalabras` | Si♭7(♭9)/Re | Do♯min7(♭5) | Mi♭maj7 | Faaug |

Cada opción (`notacion`, `tensionesEnASCII`, `menor`, `disminuido`, `aumentado`,
`septimaMayor`, `semidisminuido`) se puede combinar libremente. Si no se da `tensionesEnASCII`, las
tensiones llevan b y # cuando las notas de la notación los llevan.

## Estructura del acorde

`TipoDeAcorde.estructura` y las propiedades de `Acorde` dicen qué papel cumple cada nota:

```swift
let a: Acorde = "Sol13(b9)"
a.componentes.map { "\($0.nota) \($0.papel)" }
// ["Sol fundamental", "Si tercera", "Re quinta", "Fa séptima", "La♭ novena", "Mi decimotercera"]
a.tercera, a.quinta, a.septima          // Si, Re, Fa
a.tensiones                             // [La♭, Mi]
a.papel(de: "Lab")                      // .tension(9)
a.estructura.calidadDeTriada            // .mayor
TipoDeAcorde("7sus4").estructura.suspension   // 4ª justa
```

## Conducción parsimoniosa

Dos acordes de una familia son vecinos si se pasa de uno a otro moviendo una voz un semitono
(P₁,₀, de Douthett y Steinbach) o dos voces un semitono cada una (P₂,₀). Hay tres familias:

- `TipoDeAcorde.familiaDeSeptimas`: séptimas de dominante, menores, semidisminuidas y
  disminuidas, las «Power Towers». Cada séptima de dominante tiene tres vecinas; la menor, cuatro;
  la semidisminuida, tres, y la disminuida, ocho.
- `TipoDeAcorde.familiaDeTriadas`: tríadas mayores, menores y aumentadas, el «Cube Dance». Aquí
  P y L son movimientos de una voz; R no, porque la quinta sube un tono.
- `TipoDeAcorde.familiaDeSeptimasAmpliada`: las «Power Towers» con las séptimas mayores (maj7).
  Es la de los maj7: Domaj7 pasa a Do7 (Si→Si♭) y a Do♯ø7 (Do→Do♯). Las demás séptimas siguen
  en la primera salvo que se pida con `tipos:`; en esta, la de dominante y la semidisminuida
  tienen cuatro vecinas.

```swift
Acorde("Sol7").vecinosParsimoniosos().map(\.description) == ["Sol♯°7 (Sol→Sol♯)", "Solm7 (Si→Si♭)", "Mim7 (Fa→Mi)"]   // true
Acorde("Sol7").vecinosParsimoniosos(voces: 2).contains { $0.acorde == Acorde("Reb7") }   // true
Acorde("Sol7").caminoParsimonioso(hasta: "Rem7")?.map(\.acorde.cifrado) == ["Sol♯°7", "Sim7(♭5)", "Rem7"]   // true
Acorde("Sol7").caminoParsimonioso(hasta: "Reb7", voces: 2)?.count == 1   // true
Acorde("Domaj7").vecinosParsimoniosos().map(\.description) == ["Do♯m7(♭5) (Do→Do♯)", "Do7 (Si→Si♭)"]   // true
Acorde("Domaj7").caminoParsimonioso(hasta: "Sol7")?.count == 3   // true
```

Con dos voces, Sol7 llega a Re♭7 en un paso, que es la sustitución tritonal. Con
`tipos: [.dominanteSeptima, .semidisminuido]` salen las transformaciones de Childs. La nota
movida se escribe como semitono cromático o diatónico, y el acorde con la ortografía que necesite
menos alteraciones sin renombrar las notas que no se mueven: Re♭7 pasa a Re♭m7, no a Do♯m7.
El camino compara la meta sin ortografía, de modo que Do♯7 llega a Re♭7, y sin `tipos:` va por
la primera familia que tenga a los dos acordes (de Domaj7 a Sol7, por la ampliada).

Entre acordes cualesquiera, incluso de distinto tamaño, `conduccionMinima(hasta:)` da la
conducción con menos semitonos en total, duplicando las notas que haga falta:

```swift
"\(Acorde("Sol7").conduccionMinima(hasta: "Do"))"   // "Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos"
Acorde("Rem7").conduccionMinima(hasta: "Sol7").semitonosMovidos == 3   // true
Acorde("Do").conduccionMinima(hasta: "Lam").semitonosMovidos == 2      // true
```

Desde la línea de comandos:

```
armonia vecinos Sol7              # Sol♯°7 (Sol→Sol♯), Solm7 (Si→Si♭), Mim7 (Fa→Mi)
armonia vecinos Sol7 --voces 2
armonia vecinos Domaj7            # Do♯m7(♭5) (Do→Do♯), Do7 (Si→Si♭)
armonia vecinos Sol7 --ampliada   # también Solmaj7 (Fa→Fa♯)
armonia camino-parsimonioso Sol7 Rem7   # Sol7 –Sol→Sol♯→ Sol♯°7 –Sol♯→La→ Sim7(♭5) –Si→Do→ Rem7
armonia conduccion-minima Sol7 Do           # Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos
```

## Disposiciones de piano y jazz

``DisposicionDeAcorde`` reparte las notas de un acorde entre las voces como en el piano o en el jazz: cerrada,
drop 2, drop 3, drop 2 y 4 (la segunda, la tercera, o la segunda y la cuarta voz desde arriba, una octava más
grave), la shell (el bajo con la tercera y la séptima) y las notas guía (la tercera y la séptima solas). Un acorde de
más de cuatro notas se queda con la tercera, la séptima y las tensiones (``Acorde/notasParaDisponer``), y una
tríada dobla una nota. ``Acorde/disposiciones(_:en:)`` da todas las de un acorde dentro de un ámbito, y
``DisposicionDeAcorde/conducir(_:en:)``, una para cada acorde de una progresión con la menor suma de movimientos de
las voces: en un ii–V–I en drop 2, la séptima de cada acorde baja por grado a la tercera del siguiente.

La disposición **cuartal** apila cuatro notas por cuartas (justas, o alguna aumentada), como en el jazz modal: las
toma de la escala de siete notas del acorde con menos notas a evitar, y se queda con las pilas que llevan las notas
guía y ninguna nota a evitar.

```swift
Acorde("Sol7").disposiciones(.cuartal).isEmpty   // false
DisposicionDeAcorde.cuartal.voces                // 4
```

Las disposiciones **sin fundamental** (``DisposicionDeAcorde/sinFundamentalA`` y
``DisposicionDeAcorde/sinFundamentalB``) son las de Bill Evans para la mano izquierda del piano: tercera, quinta,
séptima y novena, o séptima, novena, tercera y quinta, con la 13.ª en lugar de la quinta en los acordes de
dominante. ``DisposicionDeAcorde/dosManos`` pone la fundamental y la séptima en la izquierda y la tercera, la quinta
(o la 13.ª) y la novena en la derecha. En la guitarra, ``Mastil/gruposDeCuerdas(para:)`` y
``Mastil/disposiciones(de:_:cuerdas:abertura:)`` las tocan con una voz por cuerda, y
``Digitacion/dedosSugeridos`` dice qué dedo pisa cada una.

## Un acorde entre los demás

``Acorde/otrosNombres`` da otros cifrados de las mismas notas sobre el mismo bajo (Do6 es también Lam7/Do; un
disminuido con séptima se llama igual desde cualquiera de sus notas), y ``Acorde/sinFundamental``, el acorde que
queda sin la fundamental (Sol7(♭9) sin Sol es Si°7). ``Acorde/tonalidades`` dice en qué tonalidades mayores y
menores es diatónico, con su cifrado romano y su función. ``Acorde/relacion(con:en:)`` da las notas comunes con
otro acorde (``RelacionEntreAcordes/comunes``) y ``RelacionEntreAcordes/voces(en:)``, cómo va cada voz de uno a otro
en una disposición, y ``Acorde/sustituciones(en:)``, por qué acordes se puede cambiar suelto: las rearmonizaciones de su tonalidad y, en
una dominante, su ii relativo y el disminuido sobre su tercera.
