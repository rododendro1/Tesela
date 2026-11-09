# Tesela

Teoría musical en Swift: un motor de armonía, dos apps para iOS y macOS y una herramienta de línea de comandos,
`armonia`. Todo habla trece idiomas, del español y el euskera al griego, el húngaro y el sueco, y el ruso
y el griego también se escriben en alfabeto latino.

[English](README.en.md) · [Documentación](https://rododendro1.github.io/Tesela/) ·
[Desarrollo](Docs/DESARROLLO.md) · [Cómo contribuir](CONTRIBUTING.md)

## Qué hay

- **Ars Harmonica**, la app: acordes (con sus digitaciones, arpegios y disposiciones de piano y jazz), escalas (con el
  mástil y sus posiciones), análisis armónico de una progresión o de un fichero MIDI, MusicXML, MEI o ABC, corales a
  cuatro voces, contrapunto de especies, identificar un acorde tocándolo en el mástil o en un teclado MIDI, y series
  dodecafónicas. Exporta MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI.
- **Tonnetz**, la app: acordes, escalas, recorridos con P, L y R y partituras que suenan en el Tonnetz, la tabla
  armónica o un teclado isomórfico (Wicki-Hayden, Jankó, acordeón cromático…).
- **`armonia`**, la línea de comandos: lo mismo desde la terminal, en texto o en JSON, y partituras en PDF, SVG o PNG.
- **Los paquetes**, para usarlos en otro proyecto: `Armonia` (el motor), `Hexagonos` (rejillas hexagonales), y
  `Exposicion` y `Interfaz` (lo que comparten las apps).

## La línea de comandos

Cada [release](https://github.com/rododendro1/Tesela/releases) trae `armonia` ya compilada para Linux (x86_64 y
arm64, sin dependencias) y macOS, con su página de manual y el autocompletado para bash, zsh y fish. También se
compila con Swift 6: `swift build -c release --package-path Apps/ConsolaArmonia`.

```sh
armonia acorde Sol7/Si                                       # sus notas, su inversión y qué es cada una
armonia escala Re dórico --acordes                           # las notas y los acordes de cada grado
armonia analizar Do Lam Re7 Sol7 Do                          # grados, funciones y cadencias
armonia digitaciones Sol7/Si --instrumento ukelele --diagrama
armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf            # con LilyPond instalado
armonia acorde Sol7/Si --json | jq '.[0].notas'              # los datos en JSON, para scripts
echo "Do Mi Sol Sib" | armonia identificar                     # también de la entrada estándar
armonia revisar Do3 Mi4 Sol4 Do5, Re3 Fa4 La4 Re5 || echo mal  # con faltas, sale con código 3
armonia ayuda                                                # las órdenes (ayuda acorde: esa; ayuda --todo: todo)
armonia                                                      # en la terminal, una sesión: una orden por línea
armonia < ejercicios.txt                                     # una orden por línea; sale con el peor código
armonia midi acordes Do Fa Sol Do -o cadencia.mid           # -o: al fichero, también en la sesión
armonia acorde H7 --idioma de                                # las notas, también en el idioma elegido
```

Lee los nombres en español o en inglés (Do, C, Sib, Bb) y responde en el idioma de `--idioma`, o en el de
`ARMONIA_IDIOMA` (`export ARMONIA_IDIOMA=eu`; con `sistema`, el de `LANG`).

## Usar los paquetes en otro proyecto

```swift
dependencies: [
    .package(url: "https://github.com/rododendro1/Tesela.git", from: "0.4.4"),
],
targets: [
    .target(name: "MiApp", dependencies: [
        .product(name: "Armonia", package: "Tesela"),     // o Teoria, Hexagonos, Interfaz…
    ]),
]
```

```swift
import Armonia

Acorde("Sol7/Si").posicionCerrada(octava: 3)   // [Si3, Re4, Fa4, Sol4]
Acorde.identificar(notas: [.mi, .sol, .do]).first     // Do/Mi
Escala(.do).modo(grado: 2)                        // Re dórico
```

Los paquetes compilan con Swift 6.0 o posterior en macOS y en Linux. Cada paquete tiene su `CHANGELOG.md`, y la
documentación de DocC de todos está en [GitHub Pages](https://rododendro1.github.io/Tesela/). Mientras la versión sea
0.x, una versión nueva puede quitar lo que una anterior marcó como obsoleto.

## Las apps

Necesitan macOS con Xcode y [XcodeGen](https://github.com/yonaskolb/XcodeGen):

```sh
brew install xcodegen
cp Config/Local.xcconfig.ejemplo Config/Local.xcconfig   # tu equipo de firma y el prefijo de identificadores
./Scripts/generadores/generar_proyecto.sh                # crea Tesela.xcodeproj
open Tesela.xcodeproj                                    # elige el esquema ArsHarmonicaApp o TonnetzApp
```

## Más

- [Docs/DESARROLLO.md](Docs/DESARROLLO.md): qué hay en cada carpeta, las dependencias, las pruebas, el rendimiento, el fuzzing
  y el CI.
- [Packages/Armonia/README.md](Packages/Armonia/README.md): el motor, con ejemplos de todo lo que hace.
- [CONTRIBUTING.md](CONTRIBUTING.md) para contribuir y [SECURITY.md](.github/SECURITY.md) para avisar de un fallo de
  seguridad.

El código se publica con licencia MIT ([LICENSE](LICENSE)). Los iconos de las apps muestran a Kokopelli: en negro
sobre ámbar en Ars Harmonica y sobre un mosaico hexagonal en Tonnetz.
