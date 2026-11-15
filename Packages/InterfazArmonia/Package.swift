// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "InterfazArmonia",
    // SwiftUI y Canvas piden estas versiones. En Linux solo compila la lógica que no usa
    // SwiftUI (la notación y los ficheros para exportar): la interfaz está tras `#if canImport(SwiftUI)`,
    // para que el CI de Linux pueda construir y probar lo que se pueda.
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "InterfazArmonia", targets: ["InterfazArmonia"])
    ],
    dependencies: [
        .package(path: "../Armonia"),
        .package(path: "../ExposicionArmonia"),
        .package(path: "../Hexagonos"),
    ],
    targets: [
        .target(
            name: "InterfazArmonia",
            dependencies: [
                .product(name: "ExposicionArmonia", package: "ExposicionArmonia"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
        .testTarget(
            name: "InterfazArmoniaTests",
            dependencies: [
                "InterfazArmonia",
                .product(name: "ExposicionArmonia", package: "ExposicionArmonia"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
    ]
)
