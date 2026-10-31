# Trastes

Instrumentos de cuerda con trastes: dónde suena cada nota en el mástil y cómo se toca un acorde.

## Overview

``Encordado`` es la afinación de un instrumento (guitarra, bajo, ukelele, mandolina y algunas
variantes), ``Mastil`` es ese encordado con un número de trastes, ``PosicionEnElMastil`` es un lugar del
mástil (una cuerda y un traste, con el 0 como cuerda al aire) y ``Digitacion`` es una forma de tocar
un acorde: un traste, o ninguno, por cada cuerda.

```swift
import Armonia

let mastil = Mastil(.guitarra)                           // veinticuatro trastes
let ukelele = Encordado(nombre: "ukulele")               // también «bajo de 5 cuerdas», «drop D»…

let acorde = Acorde("Sol7/Si")
let formas = mastil.digitaciones(de: acorde, limite: 3)  // las más cómodas primero
let primera = formas.first
let tablatura = primera?.tablatura                       // como «x20001»: de la cuerda grave a la aguda
let notas = primera?.notas(para: acorde)                 // escritas como el acorde: Si♭, no La♯
let dedos = primera?.dedos                               // cuántos dedos hacen falta, como mínimo
let cejilla = primera?.cejilla                           // el traste de la cejilla, si la lleva

let pentatonica = mastil.posiciones(de: Escala(.la, .pentatonicaMenor), trastes: 0...12)
```

Las digitaciones cumplen unas reglas de comodidad: una abertura de la mano de cuatro trastes como
máximo, las cuerdas que suenan seguidas (las apagadas, solo en los extremos), la nota más grave que
suena es el bajo del acorde y suenan todas sus notas (la quinta de un acorde de más de tres notas
puede omitirse si se pide: el Do7 de manual, `x32310`, no tiene el Sol).

Hacen falta cuatro dedos como máximo. ``Digitacion/dedos`` cuenta los mínimos: cada nota pisada pide un
dedo, salvo en el traste más bajo, donde el índice puede pisar varias cuerdas a la vez (si son seguidas, o
con una cejilla de cuatro cuerdas o más; ``Digitacion/cejilla``). Una cuerda al aire entre dos de ellas lo
impide. Sin este límite, uno de cada cinco resultados de un acorde corriente eran formas imposibles.

En un instrumento reentrante (``Encordado/esReentrante``), como el ukelele, cuya cuerda más grave no es la
primera, un acorde en estado fundamental no exige la raíz en la nota más grave: el `2000` es un La menor aunque
el Do suene más grave. Un acorde con bajo propio (`Do/Mi`) sí lo exige.

El orden es el de un coste de comodidad: un punto por traste de posición, por dedo y por traste de
abertura, dos por cada cuerda apagada y uno si falta la quinta. Por eso `x32010` es la primera forma de
Do.

## Arpegios en el mástil

`Mastil/posiciones(de:trastes:)` da todas las posiciones de las notas de un acorde, y
`Mastil/arpegios(de:ancho:)` el arpegio por posiciones: franjas de cuatro trastes (las que abarca la mano
sin moverse) que empiezan un traste por debajo de la fundamental en una de las dos cuerdas más graves. Cada
``ArpegioEnElMastil`` trae sus notas de la más grave a la más aguda, el orden en que se tocan al subir, con
los unísonos una sola vez; solo salen las franjas en las que están todas las notas del acorde.

```swift
let mastil = Mastil(.guitarra, trastes: 12)
let posiciones = mastil.arpegios(de: Acorde("Lam"))
posiciones.count   // 3
posiciones[0].trastes == 0...3                                      // true
posiciones[0].alturas.map(\.midi) == [40, 45, 48, 52, 57, 60, 64]   // true
let todas = mastil.posiciones(de: Acorde("Lam"), trastes: 0...5)
```

## Escalas por posiciones

`Mastil/posicionesPorCuerda(de:notasPorCuerda:)` da una escala por posiciones con el mismo número de notas
en cada cuerda: tres en las de seis o más notas, dos en las pentatónicas. Hay una posición por grado,
empezando por cada nota de la escala en la cuerda más grave. `Mastil/posicionesCAGED(de:ancho:)` da las
cinco formas del sistema CAGED, franjas de cinco trastes alrededor de la tónica tal como cae en los acordes
abiertos de Do, La, Sol, Mi y Re (``FormaCAGED``). Cada ``EscalaEnElMastil`` trae sus trastes, sus notas
cuerda a cuerda y, en CAGED, su forma. Las dos van de la posición más baja a la más alta y dan solo las que
caben en el mástil.

```swift
let mastil = Mastil(.guitarra, trastes: 15)
let porCuerda = mastil.posicionesPorCuerda(de: Escala(.sol, .mayor))
porCuerda.count                     // 7
porCuerda[0].trastes == 0...5       // true
porCuerda[0].posiciones.count       // 18
let caged = mastil.posicionesCAGED(de: Escala(.do, .mayor))
caged.map(\.forma) == [.c, .a, .g, .e, .d]                          // true
caged.map(\.trastes) == [0...4, 2...6, 5...9, 7...11, 9...13]       // true
```

Las de tres notas por cuerda necesitan cuerdas que vayan de grave a aguda (en un ukelele con el Sol agudo no
salen), y CAGED, la guitarra afinada como siempre. Desde la terminal: `armonia posiciones Sol mayor`, o con
`--caged`.

## Datos que vienen de fuera

Un traste o una posición que escribe una persona puede no existir. Los inicializadores y los
métodos que se detienen ante un error del programador (como salirse de un array) tienen un
equivalente que devuelve `nil`.

```swift
import Armonia

let mastil = Mastil(.guitarra)
let leida = Digitacion(leyendo: "x32010", en: mastil)            // nil si no se entiende o no cabe
let comprobada = Digitacion(comprobando: [nil, 3, 2, 0, 1, 0], en: mastil)
let sonido = mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 9, traste: 0))   // nil: no hay décima cuerda
```

## Topics

### Instrumentos y mástil

- ``Encordado``
- ``Mastil``
- ``PosicionEnElMastil``

### Acordes en el mástil

- ``Digitacion``
- ``ArpegioEnElMastil``

### Escalas en el mástil

- ``EscalaEnElMastil``
- ``FormaCAGED``
