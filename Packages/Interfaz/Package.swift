// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Interfaz",
    // SwiftUI y Canvas piden estas versiones. En Linux solo compila la lógica que no usa
    // SwiftUI (la notación y los ficheros para exportar): la interfaz está tras `#if canImport(SwiftUI)`,
    // para que el CI de Linux pueda construir y probar lo que se pueda.
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Interfaz", targets: ["Interfaz"])
    ],
    dependencies: [
        .package(path: "../Armonia"),
        .package(path: "../Exposicion"),
        .package(path: "../Hexagonos"),
    ],
    targets: [
        .target(
            name: "Interfaz",
            dependencies: [
                .product(name: "Exposicion", package: "Exposicion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
        .testTarget(
            name: "InterfazTests",
            dependencies: [
                "Interfaz",
                .product(name: "Exposicion", package: "Exposicion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
    ]
)
