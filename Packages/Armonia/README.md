# Armonia

Motor de armonía tonal en Swift, con la API en español. Todo se apoya en un mismo sistema de
coordenadas —la **línea de quintas** y el **plano quintas × octavas**—, que conserva la
ortografía de las notas (Fa♯ ≠ Sol♭, 4ª aumentada ≠ 5ª disminuida) y reduce casi todas las
operaciones a sumas de enteros.

## Uso

```swift
import Armonia

let i = Altura("Re5") - Altura("Do4")       // 9ª mayor, (2, 0)
Nota.si.intervalo(hasta: .fa)        // 5ª disminuida
Intervalo.terceraMayor.inversion           // 6ª menor
Altura("La4").frecuencia()                  // 440.0
Altura(midi: 63, ventana: .bemoles)      // Mi♭4

Acorde("Sol7/Si").posicionCerrada(octava: 3)   // [Si3, Re4, Fa4, Sol4]
Acorde.identificar([.mi, .sol, .do]).first         // Do/Mi

let menor = Escala("La menor armónica")
menor.cifradosRomanos(cuatriadas: true)
// ["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]
Escala("Mib mayor").armadura              // -3
Escala(.do).rotacion(2)                    // Re dórico
```

## Línea de comandos

`armonia` usa el motor sin escribir código. Vive en `Apps/ArmoniaCLI` del repositorio
(`cd Apps/ArmoniaCLI` y `swift run armonia …`). Acepta nombres en español o en inglés y, con
`--ingles`, responde en notación inglesa (`armonia ayuda` lista todas las órdenes):

```sh
$ swift run armonia acorde Sol7/Si
Sol7/Si: séptima de dominante
  notas: Sol Si Re Fa  (bajo Si, inversión 1)
  Sol fundamental · Si tercera · Re quinta · Fa séptima

$ swift run armonia analizar Do Lam Re7 Sol7 Do
I–vi–V7/V–V7–I en Do mayor
  Do        I         tónica
  Lam       vi        tónica
  Re7       V7/V      dominante
  Sol7      V7        dominante
  Do        I         tónica
Cadencia auténtica V7–I (acordes 4 → 5)

$ swift run armonia analizar Do Fa Sol7 Do Lam Re7 Sol
I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor
  …
De Do mayor a Sol mayor en el acorde 5 (pivote: Lam = vi en Do mayor = ii en Sol mayor)
  …

$ swift run armonia armonizar Mi4 Fa4 Re4 Do4
Do mayor
  1. Do Fa Sol Do (I–IV–V–I)
  2. Do Fa Sol7 Do (I–IV–V7–I)
  3. Do Rem Sol Do (I–ii–V–I)
A cuatro voces (bajo, tenor, contralto, soprano):
  Do        I         Do3 Sol3 Do4 Mi4
  Fa        IV        Fa2 La3 Do4 Fa4
  Sol       V         Sol2 Sol3 Si3 Re4
  Do        I         Do3 Mi3 Do4 Do4

$ swift run armonia revisar Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5
Quintas paralelas entre bajo y tenor (acordes 1 → 2)
Octavas paralelas entre bajo y soprano (acordes 1 → 2)

$ swift run armonia contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2
Especie 2, con el contrapunto encima del cantus firmus
Sin faltas.

$ swift run armonia musicxml melodia Re4:8 Sol4:4 La4:8 Si4:4. --compas 6/8 --anacrusa 8 > tema.musicxml
$ swift run armonia musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4, Do3 Mi4 Sol4 Do5 --duracion 2 > coral.musicxml
$ swift run armonia musicxml acordes Do Lam Re7 Sol7 Do > progresion.musicxml
$ swift run armonia midi acordes Do Lam Re7 Sol7 Do --tempo 80 > progresion.mid
$ swift run armonia midi arpegios Do Lam Fa Sol7 --patron alberti --duracion 2 > alberti.mid

$ swift run armonia tonnetz --escala "Re dórico" > dorico.svg
$ swift run armonia tonnetz --recorrido Do Lam Fa Rem > recorrido.svg
$ swift run armonia tabla Do3 Sol3 Mi4 Si4 > tabla.svg
$ swift run armonia cuadricula --rejilla 8x8 --en-tono --escala "Re dórico" > pads.svg
$ swift run armonia conduccion-minima Sol7 Do
Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos

$ swift run armonia plr Do PLR
Do –P→ Dom –L→ La♭ –R→ Fam
PLR, 3 pasos
```

`analizar` señala las cadencias (auténtica, plagal, rota y semicadencia) y, sin `--en`, parte la progresión en
tramos por tonalidad, con el acorde pivote de cada modulación. Con `--archivo coral.mid` (o `.musicxml`) analiza los
acordes de un fichero MIDI o MusicXML, uno por pulso (`--ventana 2`, uno por blanca). `armonizar` propone acordes para una melodía, de
mejor a peor, y si las notas llevan octava la escribe a cuatro voces con la melodía en el soprano; `realizar`
escribe unos acordes a cuatro voces. Las dos dan corales sin faltas de conducción, que se pueden pasar a
`revisar` o a `musicxml coral`.

`midi` escribe lo mismo como fichero MIDI para oírlo (con `--programa` de General MIDI).
`musicxml` escribe una partitura que se abre en MuseScore, Finale, Sibelius o Dorico: una
melodía (con `--compas`, `--anacrusa`, `--tonalidad`, `--clave`, `--tempo` y `--titulo`) o un
coral a cuatro voces en dos pentagramas (con `--duracion` de cada acorde, y `--cifrados` y
`--analisis` para escribir los cifrados y el análisis), o unos acordes con su cifrado americano
encima y el cifrado romano y la función debajo. `tonnetz` dibuja en SVG unas notas, un acorde
(`--acorde`), una escala (`--escala`) o un conjunto de clases de altura (`--clases 0,4,7`) sobre
el Tonnetz, o un recorrido de tríadas con flechas (`--recorrido`, `--camino`, `--ciclo`), y `plr` aplica las
transformaciones neorriemannianas o busca el camino más corto entre dos tríadas. `tabla` dibuja la tabla
armónica en hexágonos, con notas, alturas (`Do3 Sol3 Mi4`), `--acorde`, `--escala`, `--clases`,
`--recorrido`, `--camino` o `--ciclo`. `vecinos`
y `camino` buscan acordes a un semitono (séptimas, maj7 y tríadas, con `--voces 2` para mover dos voces) y
`conduccion`, la conducción con menos semitonos entre dos acordes. Las demás órdenes son
`identificar` (los acordes que forman unas notas), `intervalo`, `escala` y `tonalidad`. Para instalarla: `swift build -c release` y copiar `.build/release/armonia` a
una carpeta del `PATH`.

### Grabar partituras

`grabar` (en inglés, `engrave`) pasa una partitura o un dibujo a PDF, SVG o PNG con un programa externo. Tesela
escribe lo que ya sabe exportar en una carpeta temporal, el programa lo convierte allí y la orden devuelve el
fichero:

```
$ swift run armonia grabar coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados > coral.pdf
$ swift run armonia grabar melodia Sol4:4 Do5:2 --compas 3/4 --anacrusa 4 --motor verovio --formato svg > tema.svg
$ swift run armonia grabar pentagrama escala Re dórico --formato png > dorico.png
$ swift run armonia motores
lilypond   /opt/homebrew/bin/lilypond (GNU LilyPond 2.24.4)
musescore  /Applications/MuseScore 4.app/Contents/MacOS/mscore (MuseScore4 4.5.2)
verovio    no instalado (o pon su ruta en ARMONIA_VEROVIO)
guido      no instalado (o pon su ruta en ARMONIA_GUIDO2SVG)
propio     /opt/homebrew/bin/rsvg-convert (rsvg-convert version 2.60.0)
```

| `--motor`   | Programa            | Lee                         | Da                                     |
| ----------- | ------------------- | --------------------------- | -------------------------------------- |
| `lilypond`  | `lilypond`          | el `.ly` de `lilypond`      | PDF, SVG y PNG                         |
| `musescore` | `mscore`            | el MusicXML de `musicxml`   | PDF, SVG y PNG                         |
| `verovio`   | `verovio`           | el MEI de `mei`             | SVG; PDF y PNG, con rsvg-convert       |
| `guido`     | `guido2svg`         | el `.gmn` de `guido`        | SVG; PDF y PNG, con rsvg-convert       |
| `propio`    | `rsvg-convert`      | el SVG de la orden de dibujo | PDF y PNG; el SVG, tal cual           |

Sin `--motor`, una partitura (`melodia`, `coral`, `acordes`, `arpegios`, `escala`) se graba con LilyPond y una orden
de dibujo (`pentagrama`, `tonnetz`, `tabla`…) con el motor propio; sin `--formato`, sale en PDF. Cada programa se
busca en el `PATH`, en las carpetas de Homebrew y en la de la app de MuseScore en macOS, o en la variable que dice
`motores` (`ARMONIA_LILYPOND`, `ARMONIA_MSCORE`, `ARMONIA_VEROVIO`, `ARMONIA_GUIDO2SVG`, `ARMONIA_RSVG_CONVERT`).
Los programas se llaman sin shell, con un tiempo límite de dos minutos, y no forman parte de Tesela: se instalan
aparte (`brew install lilypond librsvg`, `apt install lilypond librsvg2-bin`…) y cada uno tiene su licencia.

## Documentación

La documentación está en el catálogo DocC `Sources/Armonia/Armonia.docc`, que Xcode muestra
con *Product › Build Documentation*. Para empezar, el tutorial interactivo [De una nota a un análisis
armónico](https://rododendro1.github.io/Tesela/armonia/tutorials/armonia) lleva paso a paso de nombrar una nota a
analizar una progresión leída de un fichero MIDI ([sus tres partes](Sources/Armonia/Armonia.docc/Tutoriales), con
el código de cada paso probado). Los artículos también se pueden leer directamente:

- [El modelo](Sources/Armonia/Armonia.docc/ElModelo.md): las coordenadas de quintas y octavas en que se apoya todo el motor.
- [Acordes](Sources/Armonia/Armonia.docc/Acordes.md): cifrado americano generativo, identificación tolerante, estilos, estructura y conducción parsimoniosa de los acordes.
- [Escalas](Sources/Armonia/Armonia.docc/Escalas.md): tipos de escala, modos, escalas que suben y bajan distinto, y escalas de la India, Grecia, China y Japón.
- [Tonalidad](Sources/Armonia/Armonia.docc/Tonalidad.md): tonalidades, ortografía de alturas MIDI, detección de la tonalidad, análisis de progresiones y conducción de voces.
- [Notación y partitura](Sources/Armonia/Armonia.docc/NotacionYPartitura.md): notación española e inglesa, alteraciones, intervalos, pentagrama, instrumentos y errores de lectura.
- [Melodía y ritmo](Sources/Armonia/Armonia.docc/MelodiaYRitmo.md): melodías, duraciones exactas, compases, tempo y voces.
- [Afinación y otras representaciones](Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md): temperamentos regulares y circulares (Werckmeister, Kirnberger, Vallotti, Young), afinación justa, numeraciones de Hewlett, colores de las notas, el Tonnetz y la tabla armónica.
- [Teoría postonal](Sources/Armonia/Armonia.docc/Postonal.md): conjuntos de clases de altura, formas primas y números de Forte.
- [Convenciones de la API](Sources/Armonia/Armonia.docc/Convenciones.md): protocolos comunes, comodidades, convención de nombres y sinónimos.

## Compilar y probar

```
swift build
swift test                                    # todas las pruebas
swift test --filter "^Armonia(Nucleo|Teoria|Representaciones|Partitura|Formatos|Trastes)?Tests\."   # solo las rápidas (segundos)
swift test --filter "^ArmoniaTeoriaTests\."    # las de un módulo
swift test --filter "^ArmoniaExhaustivasTests\."  # solo las exhaustivas
swift test --filter "^ArmoniaDocumentacionTests\."  # los ejemplos del README y de DocC
python3 ../../Scripts/generadores/generar_pruebas_de_documentacion.py # regenera esas pruebas tras cambiar un ejemplo
```

La herramienta `armonia` y el ejemplo (`swift run EjemploArmonia`) son paquetes aparte, en
`Apps/ArmoniaCLI` y `Ejemplos/EjemploArmonia`, y se construyen y prueban desde allí.

Requiere Swift 6.0 o posterior (y compila en el modo de lenguaje 6) (macOS 13 / iOS 16 en las plataformas de Apple); sin dependencias (solo Foundation
para `pow`).

Los cambios de cada versión, con la guía para actualizar, están en [CHANGELOG.md](CHANGELOG.md).

### Organización de los ficheros

La biblioteca son seis módulos por capas, y `Armonia` los reexporta: `import Armonia` da toda la API, e
`import ArmoniaTeoria` (con `ArmoniaNucleo`, de que depende) solo los acordes, las escalas y las tonalidades.
Lo interno que se usa entre capas es `package`, no público. Un módulo solo usa los de su izquierda, y
`Scripts/comprobaciones/comprobar_modulos.py`, en la raíz del repositorio, lo vigila:

    ArmoniaNucleo ◄── ArmoniaTeoria ◄──┬── ArmoniaRepresentaciones
                                       └── ArmoniaPartitura ◄──┬── ArmoniaFormatos
                                                               └── ArmoniaTrastes

Un fichero por concepto: el tipo principal junto con sus tipos auxiliares y sus extensiones
(`Intervalo.swift` contiene también `SentidoDelIntervalo`, `CalidadDeIntervalo` y `Consonancia`). Solo se separa en
`Tipo+Tema.swift` lo que es largo y tiene entidad propia, como la identificación de acordes o la
ortografía de las escalas. La conformidad a cada protocolo va en el fichero del tipo.

```
Sources/
├── ArmoniaNucleo/
│   ├── Fundamentos/       Nota (con NotaNatural y Alteracion), Altura, Intervalo (con SentidoDelIntervalo,
│   │                      CalidadDeIntervalo, Consonancia), Candidato, Protocolos, Aritmetica, y los
│   │                      nombres de notas e intervalos en cada idioma (al final de Nota e Intervalo)
│   ├── Notacion/          Notacion (con EscrituraDeNotas e Idioma), ReglasDeIdioma, EstiloDeCifrado, Traduccion
│   ├── Lectura/           Lector, ErrorDeArmonia (con ErrorAlLeer y MotivoDeLectura), ErrorDeLectura
│   ├── Textos/            TextosDeNucleo y un fichero por idioma
│   └── Postonal/          ConjuntoDeClasesDeAltura, TablaForte
├── ArmoniaTeoria/
│   ├── Lectura/           ErrorDeLecturaDeTeoria (cifrados, escalas, tonalidades y corales)
│   ├── Acordes/           TipoDeAcorde, Acorde, Acorde+Identificacion, EstructuraDeAcorde (con
│   │                      PapelEnAcorde, TipoDeAcorde.Componente, CalidadDeTriada), ClasificacionDeAcorde
│   ├── Escalas/           TipoDeEscala (el tipo, las escalas básicas, el catálogo con la búsqueda por nombre y
│   │   │                  `nombre(en:)`), Escala (con NombreDeGrado, la búsqueda por notas y la ortografía)
│   │   ├── Nombres/       NombresDeEscalas y un fichero por idioma (`NombresDeEscalas+Catalan.swift`…): el nombre de cada
│   │   │                  tipo, sus alias, las escalas de otras tradiciones y el nombre de cada clase
│   │   ├── Occidentales/  TipoDeEscala+Modos (con los modos exóticos), +Exoticas (con hexatónicas, jazz y
│   │   │                  Messiaen), ModoGregoriano
│   │   └── Tradiciones/   Un fichero por tradición (TipoDeEscala+India, +MundoArabe, +Turquia, +GreciaAntigua…), cada
│   │                      uno con sus escalas (cada una con su categoría, sus microtonos y, los janya, su mēḷa)
│   │                      y sus listas; +Tradiciones (`listasTradicionales`, cada lista con su tradición, y
│   │                      `tradicionales`), CategoriaTradicional (con `Tradicion`) y Microtonos (SistemaMicrotonal,
│   │                      TipoDeEscalaMicrotonal)
│   ├── Tonalidad/         Tonalidad, Tonalidad+Deteccion, Cadencia, RecorridoTonal, AnalisisArmonico (con
│   │                      FuncionTonal y AcordeAnalizado)
│   ├── Coral/             Coral (quintas y octavas paralelas, cruces…), Coral+Realizacion, Armonizacion
│   └── Afinacion/         SistemaDeAfinacion (frecuencias: temperamentos regulares y circulares, justa), AfinacionHistorica
│                          (el catálogo), AfinacionDeEscala (una escala con sus microtonos), BaseDeHewlett (números)
├── ArmoniaRepresentaciones/
│   ├── Color/         CorrespondenciaDeColores (colores)
│   ├── Redes/         Tonnetz (la red de quintas y terceras, en SVG),
│   │   │              TablaArmonica (hexágonos de teclado isomórfico, en SVG), FormatoUIL
│   │   └── Neorriemanniana/   TransformacionNeorriemanniana (P, L, R y caminos), CicloNeorriemanniano
│   │                  (hexatónico, octatónico, LR), ConduccionParsimoniosa (vecinos a un semitono,
│   │                  conducción mínima): todo lo que se apoya en el Tonnetz
│   └── Dibujo/        DibujoSVG (título, leyenda y colores comunes de los dibujos)
├── ArmoniaPartitura/
│   ├── Modelo/        Duracion (con Figura y Tempo), Compas, Evento, Melodia (con Voz), ErrorDeLecturaDePartitura,
│   │                  Pentagrama (Clave, PosicionEnElPentagrama, InstrumentoDePartitura), SignoMicrotonal
│   ├── Dibujo/        PentagramaSVG (con sus opciones y los glifos SMuFL)
│   └── Contrapunto/   Contrapunto (contrapunto de especies a dos voces, con sus faltas)
├── ArmoniaFormatos/   MusicXML, MEI, LilyPond, GUIDO y ABC (exportación de voces, corales y progresiones),
│                      ArchivoMIDI (ficheros MIDI estándar), la importación de MusicXML, MXL, MEI, ABC y MIDI
│                      (Importacion, con ErrorDeLecturaDeFichero) y el lector de XML propio (LectorXML)
├── ArmoniaTrastes/    Encordado (afinaciones del instrumento), Mastil (con PosicionEnElMastil: dónde suena cada nota),
│                      Digitacion (formas de tocar un acorde en el mástil)
└── Armonia/           el módulo paraguas, sin código propio: Exportaciones (reexporta los seis)
    │                  y la documentación
    └── Armonia.docc/  portada y un artículo por tema
```

Los nombres que dependen del idioma están en el fichero de cada tipo, al final, tras `// MARK: - Idiomas`
(`grep -rl 'MARK: - Idiomas' Sources` los lista): en el núcleo, `Nota.swift` (letras, alteraciones
y nombres de nota en las quince lenguas de las notaciones), `Intervalo.swift` (calidades de
intervalo, intervalos y consonancias) y `ErrorDeLectura.swift` (los mensajes de error generales y los de las
notas); en las demás capas, los errores de lectura de cada una (`ErrorDeLecturaDeTeoria.swift`,
`ErrorDeLecturaDePartitura.swift`), los modos y las tonalidades, los papeles en el acorde, las calidades de tríada, los grados, las claves,
las figuras, las duraciones y los colores. Los textos usan `Traduccion`, que pide los quince idiomas:
español, inglés, catalán, gallego, asturiano, aragonés, euskera, portugués, francés, occitano, italiano, alemán,
griego y ruso. Los nombres que son datos de un catálogo (tipos de acorde y de escala, instrumentos)
siguen junto a su catálogo, en los quince idiomas (los de las escalas en los que no son español ni inglés,
un fichero por idioma en `ArmoniaTeoria/Escalas/Nombres/`, `NombresDeEscalas+Catalan.swift`…, con los alias y las variantes con que también se leen;
`Scripts/comprobaciones/comprobar_catalogo.py` vigila que no falte ninguno, y `Scripts/generadores/nombres_de_escalas/` tiene las herramientas con que se sembraron).

Para añadir un idioma: un caso en `Idioma`, su fila en `ReglasDeIdioma` (código, nombre, sílabas, alteraciones y
modos) y en `Scripts/comprobaciones/idiomas.py`, un caso en `EscrituraDeNotas` (con su constante en `Notacion`), un campo en
`Traducido`, un fichero en cada `Textos/`, y corregir lo que el compilador señale: ningún `switch` sobre el
idioma o la escritura tiene `default`, y cada `Traduccion` sin el idioma nuevo deja de compilar.

Las pruebas rápidas están en un objetivo por módulo (`Tests/ArmoniaNucleoTests/`, `Tests/ArmoniaTeoriaTests/`,
`Tests/ArmoniaRepresentacionesTests/`, `Tests/ArmoniaPartituraTests/`, `Tests/ArmoniaFormatosTests/`,
`Tests/ArmoniaTrastesTests/`), que depende
solo de ese módulo y de los que puede usar: una prueba de Teoría que necesitara Partitura no compila. Lo que cruza
capas (leer acordes en cada notación, literales, Codable, convenciones de nombres, entradas inválidas, robustez, los
textos con valores y los dibujos de referencia) está en `Tests/ArmoniaTests/`, y lo que comparten varias (el
generador al azar con semilla y el lector de XML) en `Tests/ApoyoDePruebas/`. Las exhaustivas
están en un objetivo aparte, `Tests/ArmoniaExhaustivasTests/ExhaustivasTests.swift`. Las de la
línea de comandos están con ella, en `Apps/ArmoniaCLI/Tests/`.

### Capas

La biblioteca se reparte en seis módulos que siguen unas capas: **ArmoniaNucleo** (Fundamentos,
Texto, Postonal), **ArmoniaTeoria** (Acordes, Escalas, Tonalidad, que se necesitan entre sí, y la afinación) y
dos ramas que usan las anteriores y no se usan entre sí: **ArmoniaRepresentaciones** (color, dibujo y redes, con
la teoría neorriemanniana) y **ArmoniaPartitura** (el modelo, el pentagrama en SVG y el contrapunto). Sobre Partitura van **ArmoniaFormatos** (exportar e importar MusicXML, MXL, MEI, ABC, MIDI y LilyPond)
y **ArmoniaTrastes** (instrumentos de cuerda con trastes, que escriben lo que se toca en una partitura con su
tablatura), que tampoco se usan entre sí. `Armonia` los reexporta
todos; `Hexagonos`, que usan las Representaciones, se importa aparte. `python3
Scripts/comprobaciones/comprobar_modulos.py`, que ejecuta el CI, comprueba que las dependencias declaradas y los
`import` respetan esas capas.

### Integración continua

`.github/workflows/ci.yml` comprueba las rutas y las capas, compila, prueba y ejecuta el ejemplo en Linux (Swift 6.0, la
mínima, y 6.2) y en macOS en cada push o pull request. Con Swift 6.2 también compila la
biblioteca con los avisos tratados como errores. Primero ejecuta las
pruebas rápidas y después las exhaustivas, así un fallo corriente se ve antes. El job «Grabado con LilyPond y rsvg-convert» instala
los dos programas y graba partituras y dibujos de verdad con `armonia grabar`, y deja los ficheros como artefacto.

### Pruebas exhaustivas

El objetivo `ArmoniaExhaustivasTests` reúne las pruebas que recorren espacios completos:
`ConjuntoDeClasesDeAlturaExhaustivoTests` (los 4.096 subconjuntos de las doce clases y sus 223
nombres de Forte), `IdentificacionPorAlturaExhaustivaTests` (cada tipo predefinido sobre las
12 fundamentales, identificado desde MIDI) e `IdaYVueltaTests`, que recorre espacios completos en lugar de ejemplos sueltos: los 2¹⁵
subconjuntos de notas de acorde (9.344 interpretables) en siete estilos de cifrado, cada acorde predefinido con varias
fundamentales y todas sus inversiones, y miles de nombres de nota, notas e intervalos.
En todos los casos, lo que el motor escribe debe volver a leerse igual.
