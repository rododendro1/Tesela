# Teoría postonal

Conjuntos de clases de altura, formas primas y números de Forte.

## Conjuntos de clases de altura

```swift
let c: ConjuntoDeClases = [0, 4, 7]
c.formaPrima            // [0, 3, 7]
c.numeroDeForte         // "3-11"
c.vectorIntervalico     // [0, 0, 1, 1, 1, 0]
c.nombreComun           // "tríada mayor o menor"
ConjuntoDeClases([0, 1, 4, 6]).estaEnRelacionZ(con: [0, 1, 3, 7])   // true (4-Z15 y 4-Z29)
Escala(.re).conjuntoDeClases.numeroDeForte                          // "7-35"
```

Incluye forma normal, forma prima de Forte y de Rahn (difieren en seis clases), complemento,
Tn/TnI, simetrías y la tabla completa de Forte (223 clases, 46 en relación Z), generada a
partir de las tablas de music21 y comprobada sobre los 4096 subconjuntos posibles.

## Conjuntos escritos a mano

``ConjuntoDeClases/init(leyendo:)`` lee las formas habituales de los manuales: la lista con corchetes, llaves,
paréntesis o sin nada; una cifra por clase con `t` y `e` para el 10 y el 11; nombres de nota; o el número de Forte,
que da la forma prima.

```swift
let triada = try ConjuntoDeClases(leyendo: "{0 4 7}")
triada.numeroDeForte                                   // "3-11"
try ConjuntoDeClases(leyendo: "01t").clases            // [0, 1, 10]
try ConjuntoDeClases(leyendo: "Re Fa La").clases       // [2, 5, 9]
try ConjuntoDeClases(leyendo: "4-Z15").clases          // [0, 1, 4, 6]
```

Un texto se lee entero como clases o entero como notas: «C E G» es Do, Mi y Sol, y «0 4 E», 0, 4 y 11.

## Series dodecafónicas

``SerieDodecafonica`` guarda las doce clases en su orden. Sus 48 formas se nombran como en Straus, por la clase con
que empieza la original o la inversión: P₅ empieza en 5, I₅ también, R₅ es P₅ al revés y RI₅, I₅ al revés.

```swift
let berg = try SerieDodecafonica(leyendo: "Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si")
berg.description                                       // "5 4 0 9 7 2 8 1 3 6 t e"
berg.inversion(5).description                          // "5 6 t 1 3 8 2 9 7 4 0 e"
berg.matriz[1]                                         // [6, 5, 1, 10, 8, 3, 9, 2, 4, 7, 11, 0]
berg.esDeTodosLosIntervalos                            // true
berg.identificar(berg.retrogrado(5))                   // [P11, R5]
berg.hexacordos.primero.numeroDeForte                  // "6-32"
berg.formasCombinatorias                               // [P11, I10, R5, RI4]
berg.esTotalmenteCombinatoria                          // true
```

La ``SerieDodecafonica/matriz`` tiene la serie en la primera fila y su inversión en la primera columna: cada fila es
una P (al revés, su R) y cada columna una I (de abajo arriba, su RI). ``SerieDodecafonica/formasCombinatorias`` son
las formas cuyo primer hexacordo completa el total cromático con el primero de la serie.
