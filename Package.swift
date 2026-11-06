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
        .library(name: "ArmoniaNucleo", targets: ["ArmoniaNucleo"]),
        .library(name: "ArmoniaTeoria", targets: ["ArmoniaTeoria"]),
        .library(name: "ArmoniaRepresentaciones", targets: ["ArmoniaRepresentaciones"]),
        .library(name: "ArmoniaPartitura", targets: ["ArmoniaPartitura"]),
        .library(name: "ArmoniaFormatos", targets: ["ArmoniaFormatos"]),
        .library(name: "ArmoniaTrastes", targets: ["ArmoniaTrastes"]),
        // Packages/TeselaPresentacion
        .library(name: "TeselaPresentacion", targets: ["TeselaPresentacion"]),
        // Packages/TeselaUI
        .library(name: "TeselaUI", targets: ["TeselaUI"]),
    ],
    targets: [
        .target(name: "Hexagonos", path: "Packages/Hexagonos/Sources/Hexagonos"),

        .target(name: "ArmoniaNucleo", path: "Packages/Armonia/Sources/ArmoniaNucleo"),
        .target(name: "ArmoniaTeoria", dependencies: ["ArmoniaNucleo"], path: "Packages/Armonia/Sources/ArmoniaTeoria"),
        .target(
            name: "ArmoniaRepresentaciones",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "Hexagonos"],
            path: "Packages/Armonia/Sources/ArmoniaRepresentaciones"),
        .target(
            name: "ArmoniaPartitura",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria"],
            path: "Packages/Armonia/Sources/ArmoniaPartitura"),
        .target(
            name: "ArmoniaFormatos",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaPartitura"],
            path: "Packages/Armonia/Sources/ArmoniaFormatos"),
        .target(
            name: "ArmoniaTrastes",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaPartitura"],
            path: "Packages/Armonia/Sources/ArmoniaTrastes"),
        .target(
            name: "Armonia",
            dependencies: [
                "ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaRepresentaciones", "ArmoniaPartitura", "ArmoniaFormatos",
                "ArmoniaTrastes",
            ],
            path: "Packages/Armonia/Sources/Armonia"),

        .target(
            name: "TeselaPresentacion",
            dependencies: ["Armonia", "Hexagonos"],
            path: "Packages/TeselaPresentacion/Sources/TeselaPresentacion"),

        .target(
            name: "TeselaUI",
            dependencies: ["TeselaPresentacion", "Armonia", "Hexagonos"],
            path: "Packages/TeselaUI/Sources/TeselaUI"),
    ]
)
