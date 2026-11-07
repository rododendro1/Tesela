# Desarrollo de Tesela

Cómo está organizado el repositorio y cómo se compila, se prueba y se mide. Lo que es Tesela y cómo usarlo está en
el [README](README.md); cómo contribuir, en [CONTRIBUTING.md](CONTRIBUTING.md).

## Qué hay en cada carpeta

```
Apps/
├── ArsHarmonicaApp/  Acordes (con su arpegio, también en el mástil, sus disposiciones de piano y jazz, las
│                     escalas que encajan, con sus tensiones y notas a evitar, y las digitaciones),
│                     escalas (con el mástil y sus posiciones, CAGED o de tres notas por cuerda, y de qué escala
│                     son modo), análisis armónico (con modulaciones y cadencias, la escala de cada acorde en su
│                     tonalidad, también de un fichero MIDI, MusicXML, .mxl
│                     incluido, MEI o ABC, con su ritmo armónico, y la progresión arpegiada o dispuesta en drop 2,
│                     shell… con el menor movimiento de las voces),
│                     corales (armonizar, realizar a cuatro voces y revisar), contrapunto de especies (de la
│                     primera a la quinta, con las faltas compás a compás) e identificar un acorde tocándolo en
│                     el mástil o en un teclado MIDI (con su forma prima, su número de Forte y su vector
│                     interválico), y series dodecafónicas (la matriz, las 48 formas y su combinatoriedad);
│                     exporta MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI
├── TonnetzApp/       Un acorde, una escala, un recorrido con P, L y R, los acordes de un fichero MIDI, MusicXML,
│                     MEI o ABC mientras suenan (con las transformaciones entre ellos), o las notas que se toquen (y
│                     qué acorde forman), en el Tonnetz, la tabla armónica o un
│                     teclado isomórfico (Wicki-Hayden, Jankó, acordeón cromático, Gerhard, Park, o uno en formato UIL con giros de 30°); exporta el dibujo en SVG
├── ConsolaArmonia/   La herramienta `armonia`, con sus pruebas (SwiftPM)
└── PruebasDeInterfaz/  Las pruebas de interfaz de las dos apps (XCUITest), con los ejemplos de cada vista
Ejemplos/
├── EjemploArmonia/     Un recorrido por la API del motor, ejecutable (SwiftPM)
├── EjemploCatalogoDeEscalas/  El catálogo de escalas en un fichero TSV, una fila por escala (SwiftPM)
└── EjemploHexagonos/   Un recorrido por las rejillas hexagonales, con mapas dibujados en el terminal (SwiftPM)
Herramientas/
├── FuzzArmonia/         Los lectores de ficheros y textos con datos al azar (libFuzzer; el CI lo pasa cada semana)
└── RendimientoArmonia/  Cuánto tarda el motor en lo que hacen las apps (SwiftPM; el CI lo mide en cada cambio)
Packages/
├── Armonia/        El motor de armonía, en siete módulos (Elementos, Teoría, Diagramas, Partituras, Polifonía, Formatos, Trastes)
│                   y el paraguas `Armonia`: notas, acordes, escalas, tonalidad, Tonnetz, MusicXML, MEI, LilyPond, ABC, MIDI, pentagramas en SVG,
│                   y los mástiles, afinaciones, digitaciones de acordes y escalas por posiciones (guitarra, bajo, ukelele…)
├── Interfaz/       Componentes SwiftUI (DiagramaDeMastil, DiagramaDePentagrama, DiagramaDeTonnetz, DiagramaDeRejilla, VistaSVG, tema) y lo que comparten las apps:
│                   el selector de notación y su ajuste (en el entorno), los textos de la interfaz en doce
│                   lo que enseña cada vista, el cálculo en segundo plano y el menú para exportar
├── Exposicion/     Lo que enseñan las apps y la línea de comandos, sin SwiftUI: el análisis, el coral, la
│                   transposición, la tablatura, la escucha, los ficheros para exportar y los textos de la
│                   interfaz en trece idiomas
└── Hexagonos/      Rejillas hexagonales: coordenadas axiales, cúbicas, desplazadas y dobladas, vecinos, distancias,
                    líneas, regiones, rotaciones y el paso a píxeles; el motor la usa para el Tonnetz,
                    la tabla armónica y los teclados isomórficos
Scripts/
├── comprobaciones/   Las del repositorio y del motor, que pasa el CI (comprobar_*.py, notas_de_version.py)
├── generadores/      El proyecto de Xcode, el Package.swift de la raíz, las pruebas de la documentación, los glifos de Bravura y los nombres de escalas
├── datos/            Los casos que comparten las comprobaciones en Python y las pruebas en Swift (normalizar.tsv)
└── compilar_todo.sh  Todo, por capas, como el CI
Config/             Ajustes de compilación de las apps (Local.xcconfig, el de tu equipo, no se guarda en git), su
                    manifiesto de privacidad (PrivacyInfo.xcprivacy) y sus trece idiomas (Idiomas.plist; cada
                    app tiene además sus carpetas Idiomas/<idioma>.lproj)
project.yml         Definición del proyecto de Xcode (XcodeGen)
Package.swift       Los paquetes juntos, para usarlos desde otro proyecto por URL (generado)
```

## Dependencias

```
ArsHarmonicaApp ──┬──► Interfaz ───┬──► Exposicion ──► Armonia ──► Hexagonos
TonnetzApp ───────┘               ├──► Armonia
                                  └──► Hexagonos
ArsHarmonicaApp, TonnetzApp, ConsolaArmonia, EjemploArmonia, EjemploCatalogoDeEscalas, RendimientoArmonia, FuzzArmonia ──► Armonia
ConsolaArmonia ──► Exposicion (sin SwiftUI) ──► Armonia
EjemploHexagonos ──► Hexagonos
```

Un paquete solo depende de los que tiene debajo, y nunca de una app. La línea de comandos (`ConsolaArmonia`),
los ejemplos (`EjemploArmonia`, `EjemploCatalogoDeEscalas` y `EjemploHexagonos`) y la medida del rendimiento (`RendimientoArmonia`) se construyen con SwiftPM; las apps de SwiftUI, con Xcode (`project.yml`).
`Scripts/comprobaciones/comprobar_dependencias.py` lo comprueba (también en el CI).

El paquete, su producto principal y su módulo paraguas se llaman `Armonia`: en el código es
`import Armonia`, y en un `Package.swift` es `.product(name: "Armonia", package: "Armonia")`.
Cada módulo del motor es también un producto (`Elementos`, `Teoria`, `Trastes`…), por si un paquete necesita solo uno.

## Empezar

```sh
# Los paquetes, desde su carpeta
cd Packages/Armonia && swift test
cd Packages/Hexagonos && swift test      # las rejillas hexagonales
swift run --package-path Apps/ConsolaArmonia armonia acorde Sol7/Si  # la herramienta de línea de comandos
swift run --package-path Apps/ConsolaArmonia armonia digitaciones Sol7/Si --instrumento ukelele --diagrama
swift run --package-path Apps/ConsolaArmonia armonia lilypond coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.ly
swift run --package-path Apps/ConsolaArmonia armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf   # con LilyPond instalado
swift run --package-path Apps/ConsolaArmonia armonia motores   # LilyPond, MuseScore, Verovio, Guido: cuáles están instalados
swift run --package-path Apps/ConsolaArmonia armonia manual > armonia.1   # y `completado bash|zsh|fish`, el autocompletado
swift run --package-path Ejemplos/EjemploArmonia EjemploArmonia       # el ejemplo del motor
swift run --package-path Ejemplos/EjemploHexagonos EjemploHexagonos   # el de las rejillas hexagonales
swift run --package-path Ejemplos/EjemploCatalogoDeEscalas EjemploCatalogoDeEscalas escalas.tsv   # el catálogo en TSV
swift run -c release --package-path Herramientas/RendimientoArmonia RendimientoArmonia   # los tiempos del motor

# Las apps (macOS, con XcodeGen)
brew install xcodegen
cp Config/Local.xcconfig.ejemplo Config/Local.xcconfig   # tu equipo de firma y el prefijo de identificadores
./Scripts/generadores/generar_proyecto.sh        # crea Tesela.xcodeproj
open Tesela.xcodeproj     # elige el esquema ArsHarmonicaApp o TonnetzApp
```

Cada release trae también `armonia` ya compilada para Linux (x86_64 y arm64, sin dependencias) y macOS, con su
página de manual y el completado para bash, zsh y fish.

`Interfaz` usa SwiftUI para dibujar, pero su lógica (notación, qué trastes y qué notas enseña el mástil,
qué muestran el análisis, el coral y las redes, y los ficheros que se exportan) no: esa parte
compila y se prueba también en Linux, y la de interfaz queda tras `#if canImport(SwiftUI)`. El dibujo y las apps se
construyen en macOS.

## Rendimiento

`Herramientas/RendimientoArmonia` mide, compilado con optimización, lo que hacen las apps y la línea de comandos:
leer y escribir cifrados, identificar acordes y escalas, analizar, armonizar y realizar a cuatro voces (con
sucesiones de varias longitudes, para ver cómo crece el tiempo), digitaciones, dibujos y partituras. Escribe una
tabla en Markdown con la primera vez (que paga lo que el motor prepara una sola vez), la mediana y el mínimo.

```sh
cd Herramientas/RendimientoArmonia
swift run -c release RendimientoArmonia --json antes.json        # guarda los tiempos
# … un cambio en el motor …
swift run -c release RendimientoArmonia --comparar antes.json    # y los compara
swift run -c release RendimientoArmonia --comparar antes.json --avisar 25   # y avisa de lo que va un 25 % más lento
swift run -c release RendimientoArmonia --filtro armonizar       # solo unos casos
```

El CI la ejecuta en cada cambio y deja la tabla en el resumen de la ejecución y los tiempos en el artefacto
`rendimiento`. En un pull request mide antes la rama de destino en la misma máquina y la compara: avisa de los
casos que van más de un 25 % más lentos que en main, en la mediana y en el mínimo (`--avisar 25`). No falla por
lentitud, porque sus máquinas varían demasiado para fijar límites absolutos.

## Fuzzing

`Herramientas/FuzzArmonia` prueba con [libFuzzer](https://llvm.org/docs/LibFuzzer.html) todo lo que el motor lee
de fuera: ficheros MIDI, MusicXML, MXL, MEI y ABC (con lo que se saca después de ellos: acordes, tonalidad y análisis),
teclados en UIL y los textos que se escriben en las apps y en `armonia` (cifrados, notas, escalas, corales,
voces…). Compilado con AddressSanitizer, un fallo es cualquier caso que detenga el programa, se cuelgue más de
10 segundos o pierda memoria. Solo en Linux, que es donde Swift trae libFuzzer:

```sh
cd Herramientas/FuzzArmonia
swift build -c release --product FuzzArmonia --scratch-path .build/fuzz -Xswiftc -sanitize=fuzzer,address -Xswiftc -DFUZZING
swift run FuzzArmonia --semillas semillas         # los casos de partida, de lo que escribe la propia biblioteca
LSAN_OPTIONS=suppressions=fugas-ajenas.supp .build/fuzz/release/FuzzArmonia corpus semillas -max_total_time=600
swift run FuzzArmonia crash-…                     # repite un fallo, sin libFuzzer
```

El CI (`.github/workflows/fuzzing.yml`) lo pasa diez minutos cada domingo, guarda los casos que llegan a código
nuevo para la semana siguiente y, si encuentra un fallo, deja el caso en el artefacto `fallos`. Un fallo así se
arregla con su prueba en `ImportacionAlAzarTests`, con el caso dentro.

## Añadir un paquete o una app

1. Crea la carpeta en `Packages/` (con el mismo nombre que el paquete) o en `Apps/`.
2. Un paquete se añade a `PERMITIDO` en `Scripts/comprobaciones/comprobar_dependencias.py`, con los paquetes de los que puede depender,
   y se regenera el `Package.swift` de la raíz con `python3 Scripts/generadores/generar_paquete_raiz.py`, que reúne
   los módulos y las bibliotecas de todos (el CI comprueba que está al día).
3. Una app de SwiftUI, además, en `project.yml` (un `target` y su `scheme`, y sus pruebas de interfaz en `Apps/PruebasDeInterfaz/<App>`); un paquete, en `packages:`. Una app de
   SwiftPM solo necesita su `Package.swift`, con dependencias por ruta a `Packages/`.
4. Añade su job a `.github/workflows/ci.yml`.

## Estado

Todo está en Swift 6 (el modo de lenguaje 6, con la concurrencia comprobada al compilar) y pide Swift 6.0 o posterior.
Todo compila y pasa las pruebas en el CI: el motor en Linux (Swift 6.0 y 6.2) y en macOS, `Exposicion`, `Interfaz`, `Hexagonos`, la línea de
comandos, el ejemplo, las dos apps en macOS y en el simulador de iOS (compiladas y con sus pruebas de interfaz), y la documentación de DocC, sin enlaces sin
resolver. Los jobs de macOS (paquetes y apps, pruebas de interfaz y DocC) corren a mano desde la pestaña Actions y una vez por
semana, los lunes; en cada push y en cada pull request corre Linux, y en los pull requests que cambian las apps,
`Exposicion`, `Interfaz` o el proyecto de Xcode, también las pruebas de interfaz de las dos apps, en macOS y en el simulador de iOS (que antes las compilan). Si una máquina de macOS se pierde a mitad de un job, `.github/workflows/reintentar.yml` repite una vez los jobs que fallaron. La documentación de DocC (Armonia, Hexagonos, Interfaz y Exposicion) se publica en
[GitHub Pages](https://rododendro1.github.io/Tesela/) con cada versión (`.github/workflows/documentacion.yml`), y también se
puede publicar a mano desde la pestaña Actions. Dependabot mantiene al día las acciones del CI (`.github/dependabot.yml`). El formato del código Swift se comprueba con swift-format (`.swift-format`; los comandos, en `CONTRIBUTING.md`). Los jobs de Linux guardan `.build` en caché y recompilan solo lo que ha cambiado desde la última ejecución en main. `./Scripts/compilar_todo.sh` hace lo mismo en una máquina con Swift, por capas y con un log por paso.

Cómo contribuir está en `CONTRIBUTING.md`, y cómo avisar de un fallo de seguridad, en `SECURITY.md`.
`.spi.yml` le dice a [Swift Package Index](https://swiftpackageindex.com) qué módulos documentar.

El código se publica con licencia MIT (`LICENSE`). Los iconos de las apps, en
`Apps/<App>/Assets.xcassets/AppIcon.appiconset`, muestran a Kokopelli: en negro sobre ámbar en Ars Harmonica y sobre un
mosaico hexagonal en Tonnetz.
El equipo de firma y el prefijo de los identificadores no se guardan en el repositorio: cada cual los pone en
su `Config/Local.xcconfig`.
