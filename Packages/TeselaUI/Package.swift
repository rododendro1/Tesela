// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TeselaUI",
    // SwiftUI y Canvas piden estas versiones. En Linux solo compila la lógica que no usa
    // SwiftUI (la notación y los ficheros para exportar): la interfaz está tras `#if canImport(SwiftUI)`,
    // para que el CI de Linux pueda construir y probar lo que se pueda.
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "TeselaUI", targets: ["TeselaUI"])
    ],
    dependencies: [
        .package(path: "../Armonia"),
        .package(path: "../TeselaPresentacion"),
        .package(path: "../Hexagonos"),
    ],
    targets: [
        .target(
            name: "TeselaUI",
            dependencies: [
                .product(name: "TeselaPresentacion", package: "TeselaPresentacion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
        .testTarget(
            name: "TeselaUITests",
            dependencies: [
                "TeselaUI",
                .product(name: "TeselaPresentacion", package: "TeselaPresentacion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
    ]
)
