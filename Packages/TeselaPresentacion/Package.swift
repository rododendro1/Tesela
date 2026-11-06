// swift-tools-version:6.0
import PackageDescription

// Lo que preparan las apps y la línea de comandos para enseñar el motor, sin SwiftUI: el análisis, el coral, la
// rearmonización, la transposición, la tablatura, los pentagramas, la escucha (MIDI) y los ficheros para exportar.
// Solo depende de `Armonia` y compila igual en Linux que en macOS; `TeselaUI` lo dibuja con SwiftUI, y la
// línea de comandos lo escribe en la terminal.
let package = Package(
    name: "TeselaPresentacion",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "TeselaPresentacion", targets: ["TeselaPresentacion"])
    ],
    dependencies: [
        .package(path: "../Armonia")
    ],
    targets: [
        .target(
            name: "TeselaPresentacion",
            dependencies: [
                .product(name: "Armonia", package: "Armonia")
            ]),
        .testTarget(
            name: "TeselaPresentacionTests",
            dependencies: [
                "TeselaPresentacion",
                .product(name: "Armonia", package: "Armonia"),
            ]),
    ]
)
