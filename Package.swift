// swift-tools-version:6.0
import PackageDescription

// GENERADO por Scripts/generadores/generar_paquete_raiz.py a partir de los Package.swift de Packages/: no se edita a
// mano. Tras cambiar un paquete, `python3 Scripts/generadores/generar_paquete_raiz.py` (el CI comprueba que está al
// día).
//
// Los paquetes de `Packages/`, para usarlos desde otro proyecto por URL:
//
//     .package(url: "https://github.com/rododendro1/Tesela.git", branch: "main")
//
// SwiftPM solo lee el `Package.swift` de la raíz de un repositorio, así que este reúne los paquetes con los mismos
// módulos y dependencias que cada uno declara en su carpeta. Dentro del repositorio se sigue trabajando con aquellos
// (`cd Packages/Armonia && swift test`): aquí no hay pruebas.

let package = Package(
    name: "Tesela",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        // Packages/Hexagonos
        .library(name: "Hexagonos", targets: ["Hexagonos"]),
        // Packages/Armonia
        .library(name: "Armonia", targets: ["Armonia"]),
        .library(name: "ArmoniaElementos", targets: ["ArmoniaElementos"]),
        .library(name: "ArmoniaTeoria", targets: ["ArmoniaTeoria"]),
        .library(name: "ArmoniaDiagramas", targets: ["ArmoniaDiagramas"]),
        .library(name: "ArmoniaPartitura", targets: ["ArmoniaPartitura"]),
        .library(name: "ArmoniaFormatos", targets: ["ArmoniaFormatos"]),
        .library(name: "ArmoniaTrastes", targets: ["ArmoniaTrastes"]),
        // Packages/TeselaExposicion
        .library(name: "TeselaExposicion", targets: ["TeselaExposicion"]),
        // Packages/TeselaInterfaz
        .library(name: "TeselaInterfaz", targets: ["TeselaInterfaz"]),
    ],
    targets: [
        .target(name: "Hexagonos", path: "Packages/Hexagonos/Sources/Hexagonos"),

        .target(name: "ArmoniaElementos", path: "Packages/Armonia/Sources/ArmoniaElementos"),
        .target(
            name: "ArmoniaTeoria",
            dependencies: ["ArmoniaElementos"],
            path: "Packages/Armonia/Sources/ArmoniaTeoria"),
        .target(
            name: "ArmoniaDiagramas",
            dependencies: ["ArmoniaElementos", "ArmoniaTeoria", "Hexagonos"],
            path: "Packages/Armonia/Sources/ArmoniaDiagramas"),
        .target(
            name: "ArmoniaPartitura",
            dependencies: ["ArmoniaElementos", "ArmoniaTeoria"],
            path: "Packages/Armonia/Sources/ArmoniaPartitura"),
        .target(
            name: "ArmoniaFormatos",
            dependencies: ["ArmoniaElementos", "ArmoniaTeoria", "ArmoniaPartitura"],
            path: "Packages/Armonia/Sources/ArmoniaFormatos"),
        .target(
            name: "ArmoniaTrastes",
            dependencies: ["ArmoniaElementos", "ArmoniaTeoria", "ArmoniaPartitura"],
            path: "Packages/Armonia/Sources/ArmoniaTrastes"),
        .target(
            name: "Armonia",
            dependencies: [
                "ArmoniaElementos", "ArmoniaTeoria", "ArmoniaDiagramas", "ArmoniaPartitura", "ArmoniaFormatos",
                "ArmoniaTrastes",
            ],
            path: "Packages/Armonia/Sources/Armonia"),

        .target(
            name: "TeselaExposicion",
            dependencies: ["Armonia", "Hexagonos"],
            path: "Packages/TeselaExposicion/Sources/TeselaExposicion"),

        .target(
            name: "TeselaInterfaz",
            dependencies: ["TeselaExposicion", "Armonia", "Hexagonos"],
            path: "Packages/TeselaInterfaz/Sources/TeselaInterfaz"),
    ]
)
