// swift-tools-version:6.0
import PackageDescription

// Lo que preparan las apps y la línea de comandos para enseñar el motor, sin SwiftUI: el análisis, el coral, la
// rearmonización, la transposición, la tablatura, los pentagramas, las redes de notas (el Tonnetz, la tabla armónica y
// los teclados), la escucha (MIDI) y los ficheros para exportar. Solo depende de `Armonia` y de `Hexagonos` (las
// casillas de las redes) y compila igual en Linux que en macOS; `TeselaUI` lo dibuja con SwiftUI, y la línea de
// comandos lo escribe en la terminal.
let package = Package(
    name: "TeselaPresentacion",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "TeselaPresentacion", targets: ["TeselaPresentacion"])
    ],
    dependencies: [
        .package(path: "../Armonia"),
        .package(path: "../Hexagonos"),
    ],
    targets: [
        .target(
            name: "TeselaPresentacion",
            dependencies: [
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
        .testTarget(
            name: "TeselaPresentacionTests",
            dependencies: [
                "TeselaPresentacion",
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
    ]
)
