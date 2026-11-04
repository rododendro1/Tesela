# Convenciones de la API

Protocolos comunes, comodidades, convención de nombres y sinónimos.

## Protocolos comunes

Lo que comparten varios tipos se declara una sola vez, en `Protocolos.swift`:

| Protocolo | Requisito | Lo que aporta | Tipos |
|---|---|---|---|
| `RepresentableComoTexto` | `init(leyendo:)`, `texto(en:)` | `init?(texto:)`, literal de texto, `Codable`, `texto` | `Alteracion`, `Nota`, `Altura`, `Intervalo`, `TipoDeAcorde`, `Acorde`, `Escala`, `Tonalidad`, `Duracion`, `Compas`, `Evento` |
| `Nombrable` | `nombre(en:)` | el mismo nombre en cualquier `Notacion` | los anteriores salvo `Compas` y `Evento`, y casi todo lo que tiene nombre: `NotaNatural`, `CalidadDeIntervalo`, `Consonancia`, `TipoDeEscala`, `NombreDeGrado`, `Clave`, `Figura`, `InstrumentoDePartitura`, `PapelEnAcorde`, `CalidadDeTriada`, `Encordado`, `Arpegio`… |
| `Transponible` | `transponer(_:)` | operadores `+` y `−`, `transponer(_:veces:)`, `secuencia(_:veces:)` | `Nota`, `Altura`, `Acorde`, `Escala`, `Tonalidad`, `Melodia`, `Evento`, `Voz`, `Coral`, `RitmoArmonico`, `ConjuntoDeClases`, `SerieDodecafonica` |
| `ConClasesDeAltura` | `conjuntoDeClases` | `numeroDeForte`, `vectorIntervalico`, `esDeLaMismaClase(que:)` | `Acorde`, `Escala`, `Tonalidad`, `Melodia`, `ConjuntoDeClases` |

```swift
func subirQuinta<T: Transponible>(_ x: T) -> T { x + .quintaJusta }
subirQuinta(Acorde("Do7"))                  // Sol7
subirQuinta(Escala(.do))                      // Sol mayor
Nota.do.secuencia(.quintaJusta, veces: 3)          // Do, Sol, Re, La
Acorde("Do").esDeLaMismaClase(que: Acorde("Lam"))      // true (3-11)
Acorde("Sib7(b9)/Re").texto(en: .inglesASCII)             // "Bb7(b9)/D"
Escala("Re dórico").nombre(en: .inglesASCII)                 // "D dorian"
```

Todos los lectores usan un mismo `Lector` interno, que lleva la posición en el texto; por eso
todos los errores indican el carácter exacto donde se detuvo la lectura.

## Comodidades

```swift
let n: Nota = "Fa#";  let i: Intervalo = "3M";  let a: Acorde = "Sol7/Si"
let e: Escala = "Re dórico";  let t: TipoDeAcorde = "m7(b5)"
Nota.re + "3M"                                 // Fa♯
String(decoding: try JSONEncoder().encode([a]), as: UTF8.self)   // ["Sol7\/Si"]  (Codable como texto)
[Intervalo.quintaJusta, .terceraMayor].sorted()      // [3ª mayor, 5ª justa]  (Comparable)
Escala("La menor melódica").alturas(octava: 4, sentido: .descendente)   // baja con Sol♮ y Fa♮
Escala(.la, .menorArmonica).cifradosRomanos(referencia: .menorNatural)
// ["i", "ii°", "III+", "iv", "V", "VI", "♯vii°"]
```

Literales, `Codable` e `init?(texto:)` llegan a través de `RepresentableComoTexto`. Un literal no
válido detiene la ejecución con el mensaje del error de lectura (es un error de programación).
Para texto que viene del usuario, usa `init(leyendo:)`, que dice dónde y por qué falla, o
`init?(texto:)`, que devuelve `nil`.

`Acorde("Sol7")` con un literal es el propio literal, no un opcional: Swift lo trata como
`"Sol7" as Acorde` (SE-0213). Por eso la versión opcional lleva etiqueta:

```swift
let a = Acorde("Sol7")              // Acorde (literal; se detiene si no es válido)
let b = Acorde(texto: entrada)      // Acorde? (nil si no se puede leer)
let c = try Acorde(leyendo: entrada) // Acorde, o un ErrorAlLeer con posición y motivo
```

El texto se acepta en español (`Do`, `Sib`, `Fa#`, `Solx`, `Mi♭♭`) o con letras (`C#`, `Bb`).

## Convención de nombres

- **Operaciones que devuelven un valor nuevo: infinitivo.** `transponer`, `invertir`,
  `retrogradar`, `ortografiar`, `anadir`, `quitar`, `cambiarBajo`, `afinar`, `unir`, `intersecar`.
- **Valores derivados con nombre propio: sustantivo o adjetivo.** `inversion` (de un intervalo),
  `simple`, `ascendente`, `descendente`, `enarmonicaMasSimple`, `complemento`, `relativa`,
  `homonima`, `sostenido`, `bemol`.
- **Consultas con parámetro: sustantivo.** `grado(_:)`, `rotacion(_:)`, `intervalo(hasta:)`,
  `acorde(grado:)`, `nombreDeGrado(de:)`, `sonido(de:)`, `escritura(de:)`.
- **Preguntas: `es…`, `tiene…`, `esta…`.** `esConsonante`, `tieneBajoAjeno`, `estaDentroDelPentagrama`.
- **El mismo valor con algo cambiado: `con…` y `sin…`.** `con(duracion:)`, `con(dinamica:articulaciones:)`,
  `conSwing(_:)`, `conCapo(_:)`, `conTextos(en:)`, `conOctavas(_:)`, `sinFundamental`, `sinCapo`. La preposición va
  delante de lo que cambia, nunca de lo que se añade a una operación musical: es `anadir(_:)`, no `conAnadida`.
- **Movimientos de una figura en el plano: participio.** Los teclados y los mapas se giran, se reflejan y se mueven
  como dibujos, y se nombran como el resultado: `rotado(…)`, `reflejado`, `desplazado(por:)`, y `rotada(sextos:)` y
  `reflejada` en las direcciones. Siempre `rotado`, nunca `girado`, y un giro que no es posible lanza
  `ErrorDeUIL.rotacionNoValida`, en todos los teclados.
- Fuera de esos dos casos, nunca participios, gerundios ni preposiciones como nombre (`invertido`, `anadiendo`,
  `conBajo`): las operaciones musicales van en infinitivo (`invertir`, `transponer`).
- **Leer texto que viene de fuera: `init(leyendo:)`, que lanza.** El error dice el texto, el carácter y el motivo en
  los quince idiomas (`ErrorAlLeer`). Lo que se escribe a mano en el código es un literal o un inicializador que
  detiene el programa con un valor imposible, y `init?(comprobando:)` es su versión para valores de fuera, con `nil`.
- **Tipos: sustantivo con su complemento, siempre con preposición.** `TipoDeAcorde`,
  `Nota`, `CalidadDeIntervalo`, `EstiloDeCifrado`, `PapelEnAcorde`, `PosicionEnPentagrama`.
- **Búsquedas: `candidatos` e `identificar`.** `candidatos(…)` devuelve las lecturas posibles
  con su coste (`[Candidato<…>]`) e `identificar(…)`, solo los valores, de más a menos probable:
  `Acorde.candidatos(_:)`, `Tonalidad.candidatos(midi:)`, `Escala.candidatos(_:)`.
- **Nota, altura y nota natural**, como en la teoría: `Nota` no tiene octava (Do, Fa♯), `Altura`
  sí (Do4) y `NotaNatural` no lleva alteración. Las colecciones con octava se llaman `alturas`
  (`Melodia.alturas`, `Evento.alturas`, `Escala.alturas(octava:sentido:)`).
- **Lo que es mejor cuanto más pequeño se llama `coste`.** Las lecturas posibles de unos datos
  son `Candidato<Valor>` (`Candidato<Acorde>`, `Candidato<Tonalidad>`), ordenadas de menor a mayor coste.
- **Constantes de `TipoDeAcorde`: tríada + lo añadido**, de abajo arriba y con el calificativo
  detrás de lo que califica: `menorSeptima`, `mayorSeptimaMayor`, `menorSexta`, `sus4Septima`,
  `mayorNovenaAnadida`. `dominante` es la tríada mayor con séptima menor (`dominanteSeptima`,
  `dominanteNovena`); la undécima y la decimotercera incluyen la novena (`menorSeptimaUndecima`). El acorde de
  potencia («5») es `potencia`, para no confundirlo con `Acorde.quinta`, la nota que hace de quinta.

### Sinónimos

Donde España e Hispanoamérica, o la armonía moderna y la académica, usan nombres distintos,
el motor acepta los dos:

```swift
try NombreDeGrado(leyendo: "submediante")                     // .superdominante
(try NombreDeGrado(leyendo: "Tónica"), try NombreDeGrado(leyendo: "leading tone"))
try PapelEnAcorde(leyendo: "oncena") == PapelEnAcorde(leyendo: "undécima")         // true: .tension(11)
try PapelEnAcorde(leyendo: "trecena") == PapelEnAcorde(leyendo: "decimotercera")   // true: .tension(13)
PapelEnAcorde.tension(11).nombre                             // "undécima"
```

Al escribir se usan superdominante, undécima y decimotercera. Las constantes siguen el mismo
criterio (`Intervalo.undecima`, `TipoDeAcorde.dominanteDecimotercera`); las constantes `oncena` y
`trecena…` ya no existen, aunque al leer texto se siguen aceptando.
