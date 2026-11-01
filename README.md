# Tesela

Ecosistema de apps y paquetes de música en Swift. El motor de armonía (`Armonia`) es la base;
encima hay paquetes para el mástil de los instrumentos de cuerda y para la interfaz, y dos apps de
SwiftUI para iOS y macOS.

```
Apps/
├── ArmoniaApp/       Acordes (con su arpegio, también en el mástil, las escalas que encajan y las digitaciones),
│                     escalas (con el mástil y sus posiciones, CAGED o de tres notas por cuerda), análisis
│                     armónico (con modulaciones y cadencias, también de un fichero MIDI o MusicXML, .mxl
│                     incluido, con su ritmo armónico, y la progresión arpegiada),
│                     corales (armonizar, realizar a cuatro voces y revisar) e identificar un acorde tocándolo en
│                     el mástil o en un teclado MIDI (con su forma prima, su número de Forte y su vector
│                     interválico); exporta MusicXML, MEI, LilyPond, ABC y MIDI
├── TonnetzApp/       Un acorde, una escala, un recorrido con P, L y R, o las notas que se toquen (y qué acorde
│                     forman), en el Tonnetz, la tabla armónica o un
│                     teclado isomórfico (Wicki-Hayden, Jankó, acordeón cromático, Gerhard, Park, o uno en formato UIL con giros de 30°); exporta el dibujo en SVG
├── ArmoniaCLI/       La herramienta `armonia`, con sus pruebas (SwiftPM)
└── PruebasDeInterfaz/  Las pruebas de interfaz de las dos apps (XCUITest), con los ejemplos de cada vista
Ejemplos/
├── EjemploArmonia/     Un recorrido por la API del motor, ejecutable (SwiftPM)
└── EjemploHexagonos/   Un recorrido por las rejillas hexagonales, con mapas dibujados en el terminal (SwiftPM)
Herramientas/
└── RendimientoArmonia/  Cuánto tarda el motor en lo que hacen las apps (SwiftPM; el CI lo mide en cada cambio)
Packages/
├── Armonia/        El motor de armonía, en cinco módulos (Núcleo, Teoría, Representaciones, Partitura, Trastes)
│                   y el paraguas `Armonia`: notas, acordes, escalas, tonalidad, Tonnetz, MusicXML, MEI, LilyPond, ABC, MIDI, pentagramas en SVG,
│                   y los mástiles, afinaciones, digitaciones de acordes y escalas por posiciones (guitarra, bajo, ukelele…)
├── ArmoniaUI/      Componentes SwiftUI (DiagramaDeMastil, DiagramaDePentagrama, DiagramaDeTonnetz, DiagramaDeRejilla, VistaSVG, tema) y lo que comparten las apps:
│                   el selector de notación y su ajuste (en el entorno), los textos de la interfaz en catorce
│                   idiomas, lo que enseña cada vista, el cálculo en segundo plano y el menú para exportar.
│                   El análisis y el coral están en el módulo `ArmoniaPresentacion`, sin SwiftUI, que
│                   también usa la línea de comandos
└── Hexagonos/      Rejillas hexagonales: coordenadas axiales, cúbicas, desplazadas y dobladas, vecinos, distancias,
                    líneas, regiones, rotaciones y el paso a píxeles; el motor la usa para el Tonnetz,
                    la tabla armónica y los teclados isomórficos
Scripts/
├── comprobaciones/   Las del repositorio y del motor, que pasa el CI (comprobar_*.py, notas_de_version.py)
├── generadores/      El proyecto de Xcode, las pruebas de la documentación, los glifos de Bravura y los nombres de escalas
├── datos/            Los casos que comparten las comprobaciones en Python y las pruebas en Swift (normalizar.tsv)
└── compilar_todo.sh  Todo, por capas, como el CI
Config/             Ajustes de compilación de las apps (Local.xcconfig, el de tu equipo, no se guarda en git), su
                    manifiesto de privacidad (PrivacyInfo.xcprivacy) y sus catorce idiomas (Idiomas.plist; cada
                    app tiene además sus carpetas Idiomas/<idioma>.lproj)
project.yml         Definición del proyecto de Xcode (XcodeGen)
Package.swift       Los tres paquetes juntos, para usarlos desde otro proyecto por URL
```

## Dependencias

```
ArmoniaApp ──┬──► ArmoniaUI ──┬──► Armonia ──► Hexagonos
TonnetzApp ──┘               └──► Hexagonos
ArmoniaApp, TonnetzApp, ArmoniaCLI, EjemploArmonia, RendimientoArmonia ──► Armonia
ArmoniaCLI ──► ArmoniaPresentacion (en el paquete ArmoniaUI, sin SwiftUI) ──► Armonia
EjemploHexagonos ──► Hexagonos
```

Un paquete solo depende de los que tiene debajo, y nunca de una app. La línea de comandos (`ArmoniaCLI`),
los ejemplos (`EjemploArmonia` y `EjemploHexagonos`) y la medida del rendimiento (`RendimientoArmonia`) se construyen con SwiftPM; las apps de SwiftUI, con Xcode (`project.yml`).
`Scripts/comprobaciones/comprobar_dependencias.py` lo comprueba (también en el CI).

El paquete, su producto principal y su módulo paraguas se llaman `Armonia`: en el código es
`import Armonia`, y en un `Package.swift` es `.product(name: "Armonia", package: "Armonia")`.
Cada módulo del motor es también un producto (`ArmoniaNucleo`, `ArmoniaTeoria`, `ArmoniaTrastes`…), por si un paquete necesita solo uno.

## Usar los paquetes en otro proyecto

```swift
dependencies: [
    .package(url: "https://github.com/rododendro1/Tesela.git", from: "0.2.0"),
],
targets: [
    .target(name: "MiApp", dependencies: [
        .product(name: "Armonia", package: "Tesela"),     // o ArmoniaTeoria, Hexagonos, ArmoniaUI…
    ]),
]
```

Las versiones llevan etiqueta (la primera fue `0.1.0`; la última, `0.2.0`); para seguir lo último sin esperar a una versión, usa
`branch: "main"`. Los cambios de cada paquete están en su `CHANGELOG.md`, y cada etiqueta crea su release en GitHub
con esas notas (`.github/workflows/version.yml`; los pasos para publicar una están en `CONTRIBUTING.md`). Mientras la versión sea 0.x, una versión
nueva puede quitar lo que una anterior marcó como obsoleto.

## Empezar

```sh
# Los paquetes, desde su carpeta
cd Packages/Armonia && swift test
cd Packages/Hexagonos && swift test      # las rejillas hexagonales
swift run --package-path Apps/ArmoniaCLI armonia acorde Sol7/Si  # la herramienta de línea de comandos
swift run --package-path Apps/ArmoniaCLI armonia digitaciones Sol7/Si --instrumento ukelele --diagrama
swift run --package-path Apps/ArmoniaCLI armonia lilypond coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.ly
swift run --package-path Apps/ArmoniaCLI armonia manual > armonia.1   # y `completado bash|zsh|fish`, el autocompletado
swift run --package-path Ejemplos/EjemploArmonia EjemploArmonia       # el ejemplo del motor
swift run --package-path Ejemplos/EjemploHexagonos EjemploHexagonos   # el de las rejillas hexagonales
swift run -c release --package-path Herramientas/RendimientoArmonia RendimientoArmonia   # los tiempos del motor

# Las apps (macOS, con XcodeGen)
brew install xcodegen
cp Config/Local.xcconfig.ejemplo Config/Local.xcconfig   # tu equipo de firma y el prefijo de identificadores
./Scripts/generadores/generar_proyecto.sh        # crea Tesela.xcodeproj
open Tesela.xcodeproj     # elige el esquema ArmoniaApp o TonnetzApp
```

Cada release trae también `armonia` ya compilada para Linux (x86_64 y arm64, sin dependencias) y macOS, con su
página de manual y el completado para bash, zsh y fish.

`ArmoniaUI` usa SwiftUI para dibujar, pero su lógica (notación, qué trastes y qué notas enseña el mástil,
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

## Añadir un paquete o una app

1. Crea la carpeta en `Packages/` (con el mismo nombre que el paquete) o en `Apps/`.
2. Un paquete se añade a `PERMITIDO` en `Scripts/comprobaciones/comprobar_dependencias.py`, con los paquetes de los que puede depender,
   y sus módulos y bibliotecas al `Package.swift` de la raíz (el script avisa si no coinciden).
3. Una app de SwiftUI, además, en `project.yml` (un `target` y su `scheme`, y sus pruebas de interfaz en `Apps/PruebasDeInterfaz/<App>`); un paquete, en `packages:`. Una app de
   SwiftPM solo necesita su `Package.swift`, con dependencias por ruta a `Packages/`.
4. Añade su job a `.github/workflows/ci.yml`.

## Estado

Todo está en Swift 6 (el modo de lenguaje 6, con la concurrencia comprobada al compilar) y pide Swift 6.0 o posterior.
Todo compila y pasa las pruebas en el CI: el motor en Linux (Swift 6.0 y 6.2) y en macOS, `ArmoniaUI`, `Hexagonos`, la línea de
comandos, el ejemplo, las dos apps en macOS y en el simulador de iOS (compiladas y con sus pruebas de interfaz), y la documentación de DocC, sin enlaces sin
resolver. Los jobs de macOS (paquetes y apps, pruebas de interfaz y DocC) corren a mano desde la pestaña Actions y una vez por
semana, los lunes; en cada push y en cada pull request corre Linux, y en los pull requests que cambian las apps,
`ArmoniaUI` o el proyecto de Xcode, también la compilación de las dos apps en macOS. La documentación de DocC (Armonia, Hexagonos, ArmoniaUI y ArmoniaPresentacion) se publica en
[GitHub Pages](https://rododendro1.github.io/Tesela/) con cada versión (`.github/workflows/documentacion.yml`), y también se
puede publicar a mano desde la pestaña Actions. Dependabot mantiene al día las acciones del CI (`.github/dependabot.yml`). El formato del código Swift se comprueba con swift-format (`.swift-format`; los comandos, en `CONTRIBUTING.md`). Los jobs de Linux guardan `.build` en caché y recompilan solo lo que ha cambiado desde la última ejecución en main. `./Scripts/compilar_todo.sh` hace lo mismo en una máquina con Swift, por capas y con un log por paso.

Cómo contribuir está en `CONTRIBUTING.md`, y cómo avisar de un fallo de seguridad, en `SECURITY.md`.
`.spi.yml` le dice a [Swift Package Index](https://swiftpackageindex.com) qué módulos documentar.

El código se publica con licencia MIT (`LICENSE`). Los iconos de las apps, en
`Apps/<App>/Assets.xcassets/AppIcon.appiconset`, muestran a Kokopelli: en negro sobre ámbar en Armonía y sobre un
mosaico hexagonal en Tonnetz.
El equipo de firma y el prefijo de los identificadores no se guardan en el repositorio: cada cual los pone en
su `Config/Local.xcconfig`.
