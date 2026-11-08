# Notación y partitura

Notación española e inglesa, alteraciones, intervalos, pentagrama, instrumentos y errores de lectura.

## Notación internacional

| | Español | Internacional |
|---|---|---|
| Altura | `Altura("Fa#3").nombreCompleto` → Fa♯3 | `.nombre(en: .inglesASCII)` → F#3 |
| Intervalo | `.abreviatura` → 4A · `.nombre` → 4ª aumentada | `.abreviatura(en: .inglesASCII)` → A4 · `.nombre(en: .inglesASCII)` → augmented fourth |
| Escala | `.nombre` → Re dórico | `.nombre(en: .inglesASCII)` → D dorian |
| Acorde | `.cifrado` → Si♭7(♭9)/Re | `.cifrado(en: .inglesASCII)` → Bb7(b9)/D |
| Nombre de acorde | Sol séptima de dominante, primera inversión | G dominant seventh, first inversion |

`Notacion` reúne el idioma y cómo se escriben las alteraciones. En español y en inglés hay tres
modalidades: con palabras, `.espanolPalabras` (Fa sostenido) e `.inglesPalabras` (F sharp); en ASCII, `.espanolASCII` (Fa#)
e `.inglesASCII` (F#), y compactas, con los símbolos Unicode y la octava en subíndice, `.espanolCompacto`
(Fa♯, La₄) e `.inglesCompacto` (F♯, A₄). Con palabras, los cifrados llevan los símbolos Unicode: Fa♯7, F♯7. Se usa en `nombre(en:)`, `texto(en:)`,
`abreviatura(en:)`, `cifrado(en:)` y `EstiloDeCifrado(notacion:)`.

Todo se lee en ambas notaciones (`Intervalo("P5")`, `Escala("Bb harmonic minor")`,
`Acorde("B♭7(♭9)/D")`), y las notas, las alturas, las escalas y las tonalidades también con palabras
(`Nota("Fa sostenido")`, `Altura("B flat 4")`, `Escala("F sharp dorian")`); la `Notacion` solo elige
cómo se escribe.

## Otras lenguas

Además del español y el inglés, `Notacion` tiene `.conPalabras(.aleman)` y `.compacta(.aleman)`, `.conPalabras(.frances)`, `.conPalabras(.italiano)`,
`.conPalabras(.catalan)`, `.conPalabras(.gallego)`, `.conPalabras(.euskera)`, `.conPalabras(.portugues)`, `.conPalabras(.ruso)` y `.conPalabras(.griego)`. El alemán, como el español
y el inglés, escribe las alteraciones con palabras (`.conPalabras(.aleman)`: C Kreuz, E Be, con B para el Si♭) o de forma compacta
(`.compacta(.aleman)`: Cis, Es, con la octava en subíndice); en los cifrados y las tonalidades, las dos escriben
a la alemana (Cis7, Fis-Dur), y se leen las dos formas:

| | Do♯ | Mi♭ | Si♭ | Si | Fa♯ mayor | La menor |
|---|---|---|---|---|---|---|
| `.conPalabras(.aleman)` | C Kreuz | E Be | B | H | Fis-Dur | a-Moll |
| `.compacta(.aleman)` | Cis | Es | B | H | Fis-Dur | a-Moll |
| `.conPalabras(.frances)` | do dièse | mi bémol | si bémol | si | fa dièse majeur | la mineur |
| `.conPalabras(.italiano)` | do diesis | mi bemolle | si bemolle | si | fa diesis maggiore | la minore |
| `.conPalabras(.catalan)` | do sostingut | mi bemoll | si bemoll | si | fa sostingut major | la menor |
| `.conPalabras(.gallego)` | do sostido | mi bemol | si bemol | si | fa sostido maior | la menor |
| `.conPalabras(.euskera)` | do diesa | mi bemol | si bemol | si | fa diesa maiorra | la minorra |
| `.conPalabras(.portugues)` | dó sustenido | mi bemol | si bemol | si | fá sustenido maior | lá menor |
| `.conPalabras(.ruso)` | до-диез | ми-бемоль | си-бемоль | си | фа-диез мажор | ля минор |
| `.conPalabras(.griego)` | ντο δίεση | μι ύφεση | σι ύφεση | σι | φα δίεση μείζονα | λα ελάσσονα |

```swift
Nota("Sib").nombre(en: .compacta(.aleman))    // "B"
Nota("Mibb").nombre(en: .compacta(.aleman))   // "Eses"
Nota("Fa#").nombre(en: .conPalabras(.aleman))            // "F Kreuz"
Altura("Fa#3").nombre(en: .compacta(.aleman))           // "Fis₃"
Altura("Fa#3").nombre(en: .conPalabras(.frances))                  // "fa dièse 3"
Acorde("Sim7").cifrado(en: .conPalabras(.aleman))                // "Hm7"
Acorde("Rebmaj7").cifrado(en: .conPalabras(.frances))            // "Ré♭maj7"
try Nota(leyendo: "B", en: .compacta(.aleman)) // Si♭
try Nota(leyendo: "F Kreuz", en: .compacta(.aleman))   // Fa♯
try Altura(leyendo: "re diesis 5", en: .conPalabras(.italiano))     // Re♯5
Tonalidad("Fis-Dur"), Tonalidad("ré bémol majeur"), Tonalidad("la minore")
Alteracion(-2).nombre(en: .conPalabras(.frances))                 // "double bémol"
Nota("Fa#").nombre(en: .conPalabras(.portugues))                  // "fá sustenido"
Alteracion(2).nombre(en: .conPalabras(.portugues))                // "duplo sustenido"
Acorde("Rebmaj7").cifrado(en: .conPalabras(.portugues))           // "Ré♭maj7"
Altura("fá sustenido 3")                            // Fa♯3
Tonalidad("si bemol maior")                         // Si♭ mayor
Escala("ré dórico")                                 // Re dórico
Nota("Fa#").nombre(en: .conPalabras(.ruso))                       // "фа-диез"
Tonalidad("Re mayor").nombre(en: .conPalabras(.griego))           // "ρε μείζονα"
Acorde("Sibm7").cifrado(en: .conPalabras(.griego))                // "Σι♭m7"
Tonalidad("ля минор")                               // La menor
```

- En catalán, gallego, euskera, portugués, francés, italiano, griego y ruso
  los nombres van
  en minúscula y con las alteraciones en palabras (en euskera, con el adjetivo detrás: diesa
  bikoitza; en ruso, unidas con guion: фа-диез); en los cifrados se usa la forma compacta
  (`nombreCompacto(en:)`: Fa♯, Ré♭, Фа♯, Σι♭).
  Cada uno tiene también su escritura compacta (`.compacta(.catalan)`, `.compacta(.frances)`, `.compacta(.ruso)`…),
  que escribe así todas las notas, con la octava en subíndice: `Altura("Reb4").nombre(en: .compacta(.frances))`
  es «Ré♭₄». La notación de cada idioma (`Notacion.delIdioma(_:)`) sigue siendo la de palabras.
- Las octavas son siempre las científicas (Do4 = do central), también en francés, donde a menudo
  se numera de otra forma.
- Las lecturas genéricas (`init(leyendo:)`) aceptan español, inglés, catalán, gallego,
  euskera, portugués, griego y ruso, que no se confunden entre sí: `Altura("fa sostido 3")`,
  `Escala("re bemoll dòric")`, `Altura("fá sustenido 3")`, `Nota("си-бемоль")`, `Nota("σι ύφεση")`. El
  alemán, el francés y el italiano se leen con `leyendo:en:`, porque «B» no significa lo mismo en inglés que
  en alemán: `Nota(leyendo:en:)`, `Altura(leyendo:en:)`, `Acorde(leyendo:en:)`, `Escala(leyendo:en:)` y
  `Tonalidad(leyendo:en:)`. Con la notación, lo que escriben `cifrado(en:)` y `nombre(en:)` se lee de vuelta en
  todos los idiomas: `Acorde(leyendo: "B7/D", en: .compacta(.aleman))` es Si♭7/Re, y `Acorde("B7/D")`, Si7.
- Un mismo texto no mezcla idiomas: con la tónica en español, el tipo de escala o de tonalidad
  va en español (`Escala("Re dórico")`, `Escala("D dorian")`, pero no «Re dorian»), y el bajo de
  un acorde se escribe como su fundamental (`Acorde("Sol7/Si")`, `Acorde("G7/B")`, pero no
  «Sol7/B», que da el error `.idiomasMezclados`).
- Los textos del motor (mensajes de error, intervalos, calidades, papeles en el acorde, grados,
  claves, figuras, cadencias y faltas de conducción) están en español, inglés, catalán, gallego,
  euskera, portugués, francés, italiano, alemán, griego, ruso, húngaro y sueco. Es lo que indica
  `notacion.textos`, y cada texto es una `Traduccion` con los trece idiomas.
- Los nombres de los catálogos (tipos de acorde y de escala, instrumentos) siguen el mismo
  `textos`. Los nombres tradicionales de escala (rāga, maqam, pentatónicas japonesas…)
  se escriben igual en todos los idiomas, y una escala se lee también con su nombre en catalán,
  gallego, euskera, portugués o alemán (`Escala("re doriarra")`, `Escala("dó maior")`).
- El ruso y el griego se escriben también en el alfabeto latino: `conAlfabeto(.latino)` translitera las notas y
  los textos, el cirílico con ISO 9 (solʹ, bolʹšaâ terciâ) y el griego con ELOT 743 (fa díesi, megáli tríti). En
  ese alfabeto también se leen: `Escala(leyendo: "fa-diez dorijskij", en: notacion)`. Para los textos que se
  componen fuera del motor, `notacion.enSuAlfabeto(_:)` y `Transliteracion.latina(_:)`.

```swift
Intervalo.terceraMayor.nombre(en: .conPalabras(.catalan))        // "3a major"
Intervalo.terceraMayor.nombre(en: .conPalabras(.gallego))        // "3ª maior"
Intervalo.sextaMenor.nombre(en: .conPalabras(.euskera))          // "6. txikia"
Cadencia.Tipo.rota.nombre(en: .conPalabras(.catalan))            // "cadència trencada"
Escala(.re, .dorico).nombre(en: .conPalabras(.euskera))          // "re doriarra"
Acorde("Sol7/Si").nombre(en: .conPalabras(.catalan))           // "sol sèptima de dominant, primera inversió"
Intervalo.terceraMayor.nombre(en: .conPalabras(.frances))        // "tierce majeure"
Cadencia.Tipo.rota.nombre(en: .conPalabras(.italiano))           // "cadenza d'inganno"
Escala(.re, .dorico).nombre(en: .conPalabras(.frances))          // "ré dorien"
Acorde("Sol7/Si").nombre(en: .conPalabras(.portugues))         // "sol sétima de dominante, primeira inversão"
Intervalo.terceraMayor.nombre(en: .conPalabras(.aleman))         // "große Terz"
Cadencia.Tipo.rota.nombre(en: .conPalabras(.aleman))             // "Trugschluss"
Acorde("Sol7/Si").nombre(en: .conPalabras(.aleman))            // "Dominantseptakkord auf G, erste Umkehrung"
Intervalo.terceraMayor.nombre(en: .conPalabras(.ruso))           // "большая терция"
Escala(.re, .dorico).nombre(en: .conPalabras(.ruso))             // "ре дорийский"
Intervalo.terceraMayor.nombre(en: .conPalabras(.griego))         // "μεγάλη τρίτη"
```

### Notas y textos en idiomas distintos

Una `Notacion` son dos elecciones: `escritura` (``EscrituraDeNotas``, cómo se escriben las notas)
y `textos` (el ``Idioma`` de los intervalos, acordes y mensajes). Las notaciones con nombre (`.conPalabras(.ruso)`…)
llevan los textos en el idioma de sus notas, y `conTextos(en:)` los cambia; también se puede crear
directamente con `Notacion(escritura:textos:)`. Las apps lo ofrecen en el selector de notación, y la
línea de comandos con `--textos` (y la escritura con `--escritura palabras` o `compacto`, y en español e
inglés también `ascii` o `unicode`).

```swift
let notacion = Notacion.conPalabras(.ruso).conTextos(en: .espanol)
Acorde("Sol7/Si").nombre(en: notacion)              // "соль séptima de dominante, primera inversión"
Escala(.re, .dorico).nombre(en: Notacion.inglesASCII.conTextos(en: .euskera))   // "D doriarra"
Notacion(escritura: .conPalabras(.ruso), textos: .espanol) == notacion   // true
```

### La octava en subíndice

La octava de una ``Altura`` se escribe como subíndice (La₄) en las notaciones compactas (`.espanolCompacto`,
`.inglesCompacto`, `.compacta(.aleman)`, `.compacta(.frances)`…) y con cifras (La4) en las demás; `conOctavas(_:)` elige otra. Al leer se
aceptan siempre las dos formas, también en las melodías y los corales. `description` y la codificación las
escriben siempre con cifras ("Fa♯3"). La línea de comandos escribe cifras salvo con `--subindices`.

```swift
Altura(Nota.fa.sostenido, octava: 3).nombre(en: .espanolCompacto)   // "Fa♯₃"
Altura(Nota.fa.sostenido, octava: 3).nombre(en: .espanolASCII)      // "Fa#3"
let conCifras = Notacion.espanolCompacto.conOctavas(.cifras)
Altura(Nota.fa.sostenido, octava: 3).nombre(en: conCifras)          // "Fa♯3"
try Altura(leyendo: "Si♭₋₁") == Altura(Nota.si.bemol, octava: -1) // true
```

### Escalas en otras lenguas

Una escala se lee también con la tónica y el tipo en francés o italiano, y en ruso o griego con los
tipos más comunes (o con el nombre inglés del tipo):

```swift
Escala("fa dièse lydien")                           // Fa♯ lidio
Escala("si bemolle minore melodica")                // Si♭ menor melódica
Escala("ре дорийский")                              // Re dórico
Escala("λα αρμονική ελάσσονα")                      // La menor armónica
```

### Nombres de otras tradiciones

Los nombres de nota del bizantino (Ni Pa Vou Ga Di Ke Zo), del sargam indio (Sā Re Ga ma Pa Dha Ni), del japonés
(ハニホヘトイロ), del coreano (다라마바사가나), de Guido (Ut Re Mi) y los doce lü de China, Japón y Corea no son un
idioma: son un ``SistemaDeNombres``, y los textos siguen en el idioma que se elija. El sargam es móvil, y su Sā es la
tónica que se dé; los demás son fijos (en el bizantino, Ni es siempre Do, como en los echoi). En el sargam, el komal va
en minúscula (re, ga, dha, ni) y el Ma tivra en mayúscula; en japonés y en coreano la alteración va delante (嬰ヘ,
올림바). Los lü nombran la clase de altura, sin alteraciones: 大吕 es Do♯ y Re♭. Cada sistema se escribe en su
escritura, transliterado (con IAST en el sargam y pinyin en los lü chinos) o en ASCII (``Grafia``), y se lee en las
tres.

Son también móviles el jianpu chino (1 2 3 4 5 6 7, con la alteración delante: ♭7), el gongche (上 尺 工 凡 六 五 乙),
los cinco tonos 宫 商 角 徵 羽 con sus añadidos (清角, 变徵, 闰, 变宫), el carnático con sus svarasthanas (Ri₁ Ri₂ Ri₃,
Ga₁ Ga₂ Ga₃…, que se leen también abreviadas: R1, G3), el tonic sol-fa (d r m f s l t) y las notas de forma del Sacred
Harp (fa sol la fa sol la mi).

```swift
SistemaDeNombres.bizantino.nombre(de: Nota("Fa#"))                     // "Ga♯"
SistemaDeNombres.bizantino.nombre(de: Nota("Re"), grafia: .original)   // "Πα"
SistemaDeNombres.sargam.nombre(de: Nota("Fa"), tonica: Nota("Re"))     // "ga"
SistemaDeNombres.sargam.nombre(de: Nota("Fa#"), grafia: .original)     // "म॑"
try SistemaDeNombres.sargam.leer("Ma")                                 // Fa♯
Escala(.re, .dorico).nombres(en: .sargam).joined(separator: " ")       // "Sā Re ga ma Pa Dha ni"
SistemaDeNombres.japones.nombre(de: Nota("Fa#"), grafia: .original)    // "嬰ヘ"
SistemaDeNombres.coreano.nombre(de: Nota("Sib"), grafia: .original)    // "내림나"
SistemaDeNombres.luChinos.nombre(de: Nota("Reb"))                      // "dàlǚ"
SistemaDeNombres.luJaponeses.nombre(de: Nota("Re"), grafia: .original) // "壱越"
try SistemaDeNombres.luCoreanos.leer("黃")                             // Mi♭
SistemaDeNombres.jianpu.nombre(de: Nota("Fa#"))                        // "♯4"
SistemaDeNombres.gongche.nombre(de: Nota("Re"))                        // "chě"
try SistemaDeNombres.wusheng.leer("變徵")                               // Fa♯
try SistemaDeNombres.carnatico.leer("G2")                              // Mi♭
SistemaDeNombres.tonicSolFa.nombre(de: Nota("Sib"), tonica: Nota("Fa")) // "f"
```

Los fijos son también una escritura de las notas: con `Notacion.sistema(_:grafia:textos:)`, todo lo que el motor
nombra sale en ese sistema, y se lee en él. Los móviles no, porque nombran grados (`nil`).

```swift
let bizantina = Notacion.sistema(.bizantino)!
Acorde("Sol7/Si").cifrado(en: bizantina)                                // "Di7/Zo"
try Nota(leyendo: "Γα♯", en: bizantina)                                 // Fa♯
Notacion.sistema(.sargam)                                               // nil
```

Las notas árabes, las perde turcas y las cuerdas de la Grecia antigua cambian de nombre en cada octava, y las dos
primeras nombran también microtonos: son un ``NombresPorOctava``, que nombra una ``Altura`` con su ajuste en cuartos de
tono o en comas. Rāst es Do4 y Yakāh, Sol3; Sīkāh, Mi𝄳4. En el turco, Rast es Sol4, como se escribe, y Segâh es Si4 una
koma bajo. Con una escala que tiene versión microtonal, salen los nombres de sus grados. Los 22 śruti y las notas del
gamelan javanés tienen también sus nombres.

```swift
NombresPorOctava.arabe.nombre(de: Altura(.mi, octava: 4), ajuste: -1)   // "Sīkāh"
NombresPorOctava.turco.nombre(de: Altura(.si, octava: 4), ajuste: -1)   // "Segâh"
NombresPorOctava.griegoAntiguo.nombre(de: Altura(.la, octava: 3))       // "mésē"
Escala(.do, .maqamRast).nombres(en: .arabe, octava: 4).compactMap { $0 }.joined(separator: " ")
// "Rāst Dūkāh Sīkāh Jahārkāh Nawā Ḥusaynī Awj"
SistemaMicrotonal.nombresDeLosSruti().first                             // "tīvrā"
Escala(.sol, .pelogNem).nombresDelGamelan()?.joined(separator: " ")     // "lima nem bem gulu dhadha"
SistemaDeNombres.solfeoHebreo.nombre(de: Nota("Fa"), grafia: .original) // "פה"
```

## Alteraciones

`Alteracion` es el número de semitonos que sube o baja una nota respecto a la natural. Se
puede escribir con un entero (`Nota(.fa, 1)`) o con su nombre (`Nota(.fa, .sostenido)`).

```swift
Nota("Sibb").alteracion          // doble bemol
Alteracion(3).nombre                      // "triple sostenido"
Alteracion(-1).nombre(en: .inglesASCII)        // "flat"
Alteracion(2).simbolo                     // "♯♯"
Alteracion(3).simboloConDobles            // "𝄪♯"
Alteracion(-2).simboloASCII               // "bb"
Alteracion(-2).simbolo(en: .conDobles)    // "𝄫"
Alteracion("x"), Alteracion("doble bemol"), Alteracion("♮")
Alteracion.sostenido + .sostenido         // doble sostenido
Alteracion.sostenido.pasosDeQuinta        // 7: un sostenido son siete quintas
```

Los signos se escriben en una de las tres `Tipografia`: `.conSimples` (♯ y ♭, uno por semitono), `.ascii`
(# y b) y `.conDobles` (𝄪 y 𝄫 por cada pareja, y ♮ para el natural). `Notacion.tipografia` dice cuál usa
cada notación: las compactas (`.espanolCompacto`, `.inglesCompacto`, `.compacta(.frances)`…) usan `.conDobles`
(Fa𝄪, B𝄫).

También la usan `PosicionEnElPentagrama.alteracion` y `Clave.altura(lugar:alteracion:)`.

## Intervalos, pentagrama e instrumentos

```swift
Intervalo.sextaMenor.claseIntervalica          // 4
Intervalo.segundaAumentada.consonancia()       // .disonancia (aunque suene como una 3ª menor)
Intervalo(numero: 1, calidad: .disminuida(1))  // nil: no existe el unísono disminuido

Clave.sol.posicion(de: "Do4").descripcion      // "1.ª línea adicional inferior"
Clave.doEnTercera.posicion(de: "Do4").lugar   // 4 (3.ª línea)
Clave.fa.altura(lugar: 8)                   // La3
Clave.masAdecuada(para: ["Do2", "Mi2"])        // .fa

InstrumentoDePartitura.clarineteEnSib.sonido(de: Altura("Do5"))     // Si♭4
InstrumentoDePartitura.saxofonAlto.escritura(de: Escala("Si mayor"))   // La♭ mayor (simplificada)
InstrumentoDePartitura.saxofonAlto.escritura(de: Acorde("Do7"))   // La7
```

Hay 30 instrumentos predefinidos con su transposición y su clave habitual, y nueve claves
(sol, sol octava baja y alta, fa en 4.ª y 3.ª, do en 1.ª a 4.ª).

## Pentagramas en SVG

Una escala o un acorde se dibuja en un pentagrama, como texto SVG, sin ninguna dependencia: clave,
armadura, redondas, alteraciones, líneas adicionales y, en los acordes, las segundas desplazadas y el cifrado
encima. Los glifos son los de Bravura (SMuFL, licencia OFL). Cada nota lleva un `<title>` con su nombre en la
notación elegida, para los lectores de pantalla.

```swift
Escala("Re mayor").svgPentagrama().hasPrefix("<svg")              // true
Escala("Re mayor").svgPentagrama().contains("<title>Re₄</title>")  // true
Escala("La menor melódica").svgPentagrama().contains("<title>Sol₅</title>")   // true
Acorde("Sol7").svgPentagrama().contains(">Sol7</text>")            // true
Acorde("Sol7").svgPentagrama(cifrado: false).contains("<text")     // false
Escala("Do mayor").svgPentagrama(opciones: OpcionesDePentagrama(notacion: .inglesASCII)).contains("<title>C4</title>")   // true
```

Cada uno de estos dibujos sale de su ``Partitura``, la misma que se exporta: `Escala.partitura(octava:octavas:sentido:digitacion:)`,
`Escala.partitura(secuencia:…)`, `Acorde.partitura(octava:posicion:)` y `Arpegio.partitura(octava:)`, y
`svgPentagrama(…)` es `partitura(…).svg(opciones:)`. Su título es lo que se toca (``Encabezado/Tema``), en la notación
con que se dibuja o se exporta. Como en los diagramas, las opciones pueden cambiar el título (`titulo: ""` lo quita)
y el tamaño (`escala: 2`, el doble de grande), y `marcas.cifrados` quita los cifrados de encima.

```swift
Escala("Re mayor").svgPentagrama() == Escala("Re mayor").partitura().svg()   // true
Acorde("Sol7").partitura().pentagramas[0].voces[0].cifrados == [.cero: Acorde("Sol7")]   // true
Escala("Re mayor").svgPentagrama(opciones: OpcionesDePentagrama(titulo: "")).contains("id=\"titulo\"")   // false
Escala("Re mayor").svgPentagrama(opciones: OpcionesDePentagrama(titulo: "Escala")).contains("<title id=\"titulo\">Escala</title>")   // true
```

- La escala sube y, si baja con otras notas (la menor melódica, muchos rāgas), también baja, con los becuadros que
  hagan falta. Con `sentido:` se dibuja solo la subida o la bajada.
- Con la clave sin fijar, se elige la de sol o la de fa. Si el rango pasa a los dos lados del Do central y haría
  falta más de tres líneas adicionales, se usan los dos pentagramas (`OpcionesDePentagrama.maquetacion.pentagramas`:
  `.automatico`, `.simple` o `.doble`); si todo es agudo o grave, se escribe una octava más cerca con la marca 8va u 8vb
  (`maquetacion.marcaDeOctava`), y en el pentagrama doble cada uno la lleva por su cuenta (8va el de arriba, 8vb el de abajo).
- Las alteraciones de un acorde se reparten en columnas escalonadas, según lo que sube y baja cada glifo: un bemol
  baja menos que un sostenido y caben más juntos.
- El pentagrama doble lleva una llave (la de Bravura) a la izquierda.
- Los acordes se apilan en posición cerrada; los muy extensos (novenas, oncenas y trecenas) y
  `maquetacion.posicionDelAcorde = .abierta` ponen el bajo una octava más grave y el resto encima, como la mano
  izquierda y la derecha del piano, y con eso suelen pasar al pentagrama doble.
- `marcas.nombresDeLasNotas` escribe el nombre de cada nota debajo; las etiquetas no se pisan. La medida del texto sale de
  una tabla de anchos de Helvetica y Arial (`anchoDeLosCaracteres` la multiplica si la tipografía es más ancha), y el
  texto lleva `textLength`, así que no se sale de su sitio con ninguna tipografía.
- Una voz o varias voces en un pentagrama, saltos de línea y letra quedan fuera: para partituras completas, MusicXML o
  MEI y un motor como Verovio.

```swift
Acorde("Do13").svgPentagrama().contains("<title>Do₃</title>")      // true
Escala("Do mayor").svgPentagrama(octava: 6).contains("8va")        // true
Escala("Do mayor").svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(maquetacion: .init(pentagramas: .doble))).contains("<title>Do₃</title>")   // true
```

### Armadura de una tonalidad

Las escalas diatónicas llevan su armadura; los acordes, los arpegios y las disposiciones, ninguna. Con
`OpcionesDePentagrama(armadura: .tonalidad(…))` cualquier dibujo lleva la de una tonalidad, y sus notas solo
llevan delante las alteraciones que la armadura no da (o el becuadro que la anula): el arpegio de Mi7 en La menor
lleva el sostenido del Sol, el acorde de Re7 en Sol mayor no lleva ninguno.

```swift
let enLaMenor = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.la, .menor)))
Arpegio(Acorde("Mi7")).svgPentagrama(opciones: enLaMenor).contains("<title>Sol♯₄</title>")   // true
```

### Ritmo

Una ``Voz`` se dibuja con su ritmo en su ``Partitura`` (`Partitura.svg(opciones:)`): cabezas negras, blancas y redondas, plicas, corchetes, barras de unión
(las de cada pulso, como en `barrasDeAgrupacion`), puntillos, silencios, ligaduras, tresillos, la cifra del compás y
las barras de compás. Las notas que cruzan un pulso o una barra se dividen y se ligan como en `grafia`. Con eso se
dibuja un arpegio en corcheas, en semicorcheas o en tresillos, o una progresión arpegiada.

```swift
let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
Partitura(.init(voz), encabezado: Encabezado(titulo: "Do7")).svg().contains("<title>Si♭₄</title>")   // true
```

- La plica sube si la nota más alejada de la 3.ª línea está debajo, y baja si no; las notas unidas por una barra
  van todas hacia el mismo lado, con la barra un poco inclinada.
- Un tresillo lleva el 3 del lado de las plicas, con corchete si sus notas no van unidas por una barra.
- `OpcionesDePentagrama.marcas.resaltada` cuenta las notas que se oyen (sin silencios ni notas ligadas a la anterior), como
  los pasos de lo que suena.

### Líneas y dos voces

Una voz larga se parte en líneas con `OpcionesDePentagrama.maquetacion.compasesPorLinea`: cada línea lleva los compases que le
tocan (la primera, también la anacrusa), su clave y su armadura; la cifra del compás va solo en la primera y la barra
final, en la última. Todas miden lo que la más ancha (la última no, si es mucho más corta), y una nota que pasa de una
línea a otra se divide y se liga. Los acordes, los grados, los dedos y la tablatura van con su nota.

Un pentagrama de la partitura con dos voces las pone juntas: la primera con las plicas
hacia arriba y la otra hacia abajo, lo que suena a la vez en la misma vertical y los silencios de cada una encima o
debajo. Las dos se parten igual en líneas.

```swift
var porLineas = OpcionesDePentagrama()
porLineas.maquetacion.compasesPorLinea = 4
let larga = try Voz(leyendo: Array(repeating: "Do4:4 Mi4:4 Sol4:2", count: 8).joined(separator: " "))
let ocho = Partitura(.init(larga), encabezado: Encabezado(titulo: "Ocho compases"))
ocho.svg(opciones: porLineas) != ocho.svg()   // true
let soprano = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
let contralto = try Voz(leyendo: "Do5:4 Si4:4 Sol4:2")
let juntas = Partitura(pentagramas: [.init(voces: [.init(soprano), .init(contralto)])], encabezado: Encabezado(titulo: "Dos voces"))
juntas.svg().contains("<title>Sol₄</title>")   // true
```

Una partitura con varios pentagramas se dibuja como un sistema, uno debajo de otro, alineados por lo
que suena a la vez y con las barras de compás atravesándolos: el piano con sus dos manos (con `llave`) o un coro
(con corchete), con una o dos voces en cada pentagrama. La de un coral (`Coral.partitura(…)`) lo pone en dos
pentagramas, la soprano y la contralto en el de sol y el tenor y el bajo en el de fa.

```swift
let derecha = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
let izquierda = try Voz(leyendo: "Do3:2 Sol2:2")
let manos: [Partitura.Pentagrama] = [.init(clave: .sol, voces: [.init(derecha)]), .init(clave: .fa, voces: [.init(izquierda)])]
Partitura(pentagramas: manos, encabezado: Encabezado(titulo: "Piano"), llave: true).svg().contains("<title>Sol₂</title>")   // true
let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4 | Do3 Sol3 Mi4 Do5")
coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia")).svg().contains("<title>Si₄</title>")   // true
```

Los grupos irregulares llevan su cifra: el tresillo, el cinquillo, el seisillo, el septillo y los demás (5 en 4,
7 en 4 u 8, 9 en 8, 11 y 13 en 8…), con corchete si sus notas no van unidas por una barra.

Para partituras con más pentagramas o una maquetación completa, el MEI o el MusicXML (``FormatoDePartitura``) y un
motor como Verovio.

### Cifrados, intervalos, semitonos y tónica

Alrededor de las notas se puede escribir lo que ayuda a estudiarlas:

- **Cifrado de cada acorde.** Los `cifrados` de `Partitura(acordes:titulo:porEvento:)` (uno por columna:
  `.init(cifrados: .enOrden(progresion))`) van encima de la columna de cada acorde (y, sin `titulo`, la partitura se titula con ellos, «Rem7 – Sol7 – Do7M», en la notación con que se
  dibuja o se exporta); los `cifrados` de una ``Partitura/Linea``, encima de la nota en que empieza cada acorde;
  `Arpegio.svgPentagrama(cifrado: true)`, encima de la primera nota.
- **Intervalos** (`marcas.intervalosDeLasNotas`). Debajo de cada nota, su intervalo desde la tónica de la escala o desde la
  fundamental del acorde que suena (con 9, 11 y 13 si el acorde tiene séptima).
- **Semitonos** (`marcas.semitonos`). Un arco une dos notas seguidas a un semitono.
- **Tónica** (`marcas.tonica`). La tónica va en color (`colores.tonica`) en cada octava.
- **Varias octavas.** `Escala.svgPentagrama(octavas:)` sube (y baja) dos, tres o cuatro octavas.

```swift
let opciones = OpcionesDePentagrama(marcas: .init(intervalosDeLasNotas: true, semitonos: true, tonica: true))
Acorde("Sol9").svgPentagrama(opciones: opciones).contains(">1 3 5 ♭7 9</text>")   // true
Escala("Re dórico").svgPentagrama(octavas: 2, opciones: opciones).contains("<title>Re₆</title>")   // true
```

### Para estudiar: grados, dedos, secuencias y tablatura

- **Grados en números romanos.** Los `grados` del `porEvento` de `Partitura(acordes:titulo:porEvento:)` y los de una
  ``Partitura/Linea`` (o su `analisis`) escriben debajo de cada acorde su grado (los de
  `AnalisisArmonico.cifrados`), y su `bajoCifrado`, las cifras del bajo continuo.
- **Dedos.** `Escala.svgPentagrama(digitacion:)` pone encima los dedos del piano de `digitacionDePiano(_:)`, y el
  `dedos` del `porEvento` de los demás dibujos (y los de una ``Partitura/Linea``), los que se le den (los de la
  guitarra, por ejemplo).
- **Secuencias con ritmo.** `Escala.svgPentagrama(secuencia:)` toca la escala por terceras o en grupos, cada grupo en
  un pulso: corcheas, tresillos o semicorcheas.
- **Tablatura.** Una ``Tablatura`` (la cuerda y el traste de cada nota) va debajo del pentagrama, alineada nota a
  nota. `Escala.partitura(tocadaEn:)` y `Acorde.partitura(arpegiadoEn:)` hacen la partitura de las alturas de una
  posición del mástil, escritas con las notas de la escala o del acorde (Si♭, no La♯, en Do7), con la armadura de la
  escala (``Partitura/Pentagrama/armadura``) y los intervalos contados desde su tónica (``Partitura/Linea/tonica``);
  `svgPentagrama(tocadaEn:)` y `svgPentagrama(arpegiadoEn:)` la dibujan. Su título es el nombre de la escala o el
  cifrado del acorde (``Encabezado/tema``), escrito en la notación con que se dibuja o se exporta. La tablatura
  cuenta las cuerdas como el mástil, desde la más grave (la 0), y al dibujarla pone la más aguda arriba:
  `Tablatura(_:posiciones:)` toma las posiciones del mástil tal cual, con la afinación y el capo. Con la afinación de
  la guitarra, el pentagrama va en clave de sol octava baja (``Partitura/Pentagrama/claveDelInstrumento``). En
  MusicXML, la tablatura va en un pentagrama de tablatura debajo, con la cuerda y el traste de cada nota.
- **Ritmo.** Las escalas, los arpegios y las posiciones del mástil van en redondas y sin ritmo; con
  `ritmo: .uniforme(.corchea)` (``Partitura/Ritmo``), en corcheas, con la última nota en negra.
- **Nota a nota.** Lo que dan las escalas, los arpegios y el mástil va por el índice de cada nota; una
  ``Partitura/Linea`` lo guarda por el punto en que empieza cada evento. ``Partitura/AnotacionesPorEvento``, con
  `Partitura.Linea(_:porEvento:)` y `linea.porEvento`, pasa de una forma a la otra. `Partitura(acordes:porEvento:)`,
  `partitura(tocadaEn:porEvento:)` y `partitura(arpegiadoEn:porEvento:)` la toman entera: los cifrados, el análisis, los
  marcadores, los grados, el bajo cifrado, los dedos y las pulsaciones. `.enOrden(_:)` da una lista, uno por nota.
- **Notación.** La de la partitura (``Partitura/notacion``) vale al exportarla y al dibujarla: `svg()` escribe en ella
  los cifrados, los nombres de las notas y el título, salvo que `OpcionesDePentagrama(notacion:)` fije otra.

```swift
let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
let voces = DisposicionDeAcorde.drop2.conducir(progresion) ?? []
let grados = Tonalidad(.do).analizar(progresion).cifrados
Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(grados: .enOrden(grados))).svg().contains(">V7</text>")   // true
Escala("Re mayor").svgPentagrama(digitacion: .derecha).contains(">5</text>")   // true
Escala("Do mayor").svgPentagrama(secuencia: .terceras).contains("por terceras")   // true
```

### Bajo cifrado, claves y notas ajenas al acorde

- **Bajo cifrado.** `Tonalidad.cifrasDeBajo(de:)` da las cifras del bajo continuo de un acorde (lo contrario de
  `acorde(sobre:cifras:)`): «6», «6 4», «6 5», «4 3», «4 2», con la alteración de las notas que la armadura no da.
  El parámetro `bajoCifrado` de las disposiciones y las voces las escribe debajo, una encima de otra.
- **Cambios de clave.** Con `OpcionesDePentagrama.maquetacion.cambiosDeClave`, un solo pentagrama pasa de la clave de fa a la de
  sol (y vuelve) cuando las notas se van a tres líneas adicionales, con la clave nueva más pequeña delante.
- **Notas ajenas al acorde.** Con `marcas.notasAjenas`, las notas que no son del acorde que suena van en color: las de
  la tonalidad (notas de paso, bordaduras…) en `colores.notasDePaso`, las cromáticas en `colores.cromaticas`.

```swift
Tonalidad(.do).cifrasDeBajo(de: Acorde("Sol7/Si"))          // ["6", "5"]
Tonalidad(.la, .menor).cifrasDeBajo(de: Acorde("Mi"))       // ["♯"]
```

En la línea de comandos, `armonia pentagrama escala|acorde|arpegio|acordes …` dibuja lo mismo (con `--octavas`,
`--figura`, `--tresillos`, `--nombres`, `--intervalos`, `--semitonos`, `--tonica` y `--en <tonalidad>`), y con
`--romanos`, `--dedos`, `--secuencia` y `--tab` (`--instrumento`), los grados, los dedos, las secuencias
y la tablatura; con `--bajo-cifrado`, `--registro`, `--clave`, `--doble` y `--cambiar-clave`, el
bajo cifrado y el registro, y `armonia pentagrama melodia … --sobre <acordes>` colorea las notas ajenas.

## Errores

Cada tipo tiene un inicializador `init(leyendo:)` que lanza un error con el texto, el carácter
donde se detuvo y el motivo. Cada capa tiene el suyo: `ErrorDeLectura` para las notas, las alturas y
los intervalos, `ErrorDeLecturaDeTeoria` para los cifrados, las escalas, las tonalidades y los corales,
y `ErrorDeLecturaDePartitura` para las duraciones, los compases y el contrapunto. Leer un acorde puede
lanzar los dos primeros (si falla la fundamental o si falla el cifrado); los tres cumplen
`ErrorAlLeer`. Para tener `nil` en lugar del error basta `try?` (`try? Acorde(leyendo: …)`).

Todos los errores del motor, también `ErrorDeLecturaDeFichero` y `ErrorDeLecturaDeUIL`, cumplen `ErrorDeArmonia`:
para mostrar cualquiera basta `catch let error as any ErrorDeArmonia` y `error.descripcion(en:)`.

El mensaje está en español (`description`, `explicacion`) y también en inglés, catalán, gallego,
euskera, portugués, francés, italiano, alemán, griego, ruso, húngaro y sueco: `descripcion(en:)` y
`explicacion(en:)` usan el idioma de los textos de la notación (`notacion.textos`), como los
nombres de intervalos.

```swift
do {
    let acorde = try Acorde(leyendo: "Do7(b3)")
    print(acorde)                     // no se llega aquí: la línea anterior lanza el error
} catch let error as ErrorDeLecturaDeTeoria {
    print(error)
    // No se puede leer «Do7(b3)» (carácter 5): «b3» no es una tensión válida
    // (se admiten ♭/♯ con 5, 9, 11 y 13, y add con 2, 4, 6, 9, 11 y 13)
    error.motivo     // .tensionNoValida("b3")
    error.posicion   // 4
    print(error.descripcion(en: .inglesASCII))
    // Cannot read "Do7(b3)" (character 5): "b3" is not a valid tension (♭/♯ go with 5, 9, 11 and 13, …
}
do { _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, -3, 4]) } catch { print(error) }
// … tiene tercera mayor y menor a la vez (la ♯9 se escribe como 9ª aumentada, no como 3ª menor)
```
