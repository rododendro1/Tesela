// swift-tools-version:6.0
import PackageDescription

// La herramienta de línea de comandos `armonia`: la lógica en una biblioteca, para poder probarla,
// y el ejecutable, que solo la llama.
//
//     swift run armonia acorde Sol7/Si
//     swift run armonia ayuda
let package = Package(
    name: "ConsolaArmonia",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "armonia", targets: ["ArmoniaEjecutable"]),
        .library(name: "ConsolaArmonia", targets: ["ConsolaArmonia"]),
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia"),
        // Solo `Exposicion`, sin SwiftUI: el análisis y el coral que también enseñan las apps.
        .package(path: "../../Packages/Exposicion"),
    ],
    targets: [
        .target(
            name: "ConsolaArmonia",
            dependencies: [
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Exposicion", package: "Exposicion"),
            ]),
        // El directorio del ejecutable no se llama `armonia`: en sistemas de ficheros que no
        // distinguen mayúsculas (macOS, Windows) chocaría con otros nombres. El producto
        // sigue llamándose `armonia`.
        .executableTarget(name: "ArmoniaEjecutable", dependencies: ["ConsolaArmonia"]),
        .testTarget(
            name: "ConsolaArmoniaTests",
            dependencies: [
                "ConsolaArmonia",
                .product(name: "Armonia", package: "Armonia"),
            ]),
    ]
)
