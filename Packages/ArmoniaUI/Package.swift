// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ArmoniaUI",
    // SwiftUI y Canvas piden estas versiones. En Linux solo compila la lógica que no usa
    // SwiftUI (la notación y los ficheros para exportar): la interfaz está tras `#if canImport(SwiftUI)`,
    // para que el CI de Linux pueda construir y probar lo que se pueda.
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "ArmoniaUI", targets: ["ArmoniaUI"])
    ],
    dependencies: [
        .package(path: "../Armonia"),
        .package(path: "../ArmoniaPresentacion"),
        .package(path: "../Hexagonos"),
    ],
    targets: [
        .target(
            name: "ArmoniaUI",
            dependencies: [
                .product(name: "ArmoniaPresentacion", package: "ArmoniaPresentacion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
        .testTarget(
            name: "ArmoniaUITests",
            dependencies: [
                "ArmoniaUI",
                .product(name: "ArmoniaPresentacion", package: "ArmoniaPresentacion"),
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Hexagonos", package: "Hexagonos"),
            ]),
    ]
)
