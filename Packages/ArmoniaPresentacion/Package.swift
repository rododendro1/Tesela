// swift-tools-version:6.0
import PackageDescription

// Lo que preparan las apps y la línea de comandos para enseñar el motor, sin SwiftUI: el análisis, el coral, la
// rearmonización, la transposición, la tablatura, los pentagramas, la escucha (MIDI) y los ficheros para exportar.
// Solo depende de `Armonia` y compila igual en Linux que en macOS; `ArmoniaUI` lo dibuja con SwiftUI, y la
// línea de comandos lo escribe en la terminal.
let package = Package(
    name: "ArmoniaPresentacion",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "ArmoniaPresentacion", targets: ["ArmoniaPresentacion"])
    ],
    dependencies: [
        .package(path: "../Armonia")
    ],
    targets: [
        .target(
            name: "ArmoniaPresentacion",
            dependencies: [
                .product(name: "Armonia", package: "Armonia")
            ]),
        .testTarget(
            name: "ArmoniaPresentacionTests",
            dependencies: [
                "ArmoniaPresentacion",
                .product(name: "Armonia", package: "Armonia"),
            ]),
    ]
)
