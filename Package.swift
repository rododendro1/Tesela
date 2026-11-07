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
        .library(name: "Elementos", targets: ["Elementos"]),
        .library(name: "Teoria", targets: ["Teoria"]),
        .library(name: "Diagramas", targets: ["Diagramas"]),
        .library(name: "Partituras", targets: ["Partituras"]),
        .library(name: "Polifonia", targets: ["Polifonia"]),
        .library(name: "Formatos", targets: ["Formatos"]),
        .library(name: "Trastes", targets: ["Trastes"]),
        // Packages/Exposicion
        .library(name: "Exposicion", targets: ["Exposicion"]),
        // Packages/Interfaz
        .library(name: "Interfaz", targets: ["Interfaz"]),
    ],
    targets: [
        .target(name: "Hexagonos", path: "Packages/Hexagonos/Sources/Hexagonos"),

        .target(name: "Elementos", path: "Packages/Armonia/Sources/Elementos"),
        .target(name: "Teoria", dependencies: ["Elementos"], path: "Packages/Armonia/Sources/Teoria"),
        .target(
            name: "Diagramas",
            dependencies: ["Elementos", "Teoria", "Hexagonos"],
            path: "Packages/Armonia/Sources/Diagramas"),
        .target(
            name: "Partituras",
            dependencies: ["Elementos", "Teoria"],
            path: "Packages/Armonia/Sources/Partituras"),
        .target(
            name: "Polifonia",
            dependencies: ["Elementos", "Teoria", "Partituras"],
            path: "Packages/Armonia/Sources/Polifonia"),
        .target(
            name: "Formatos",
            dependencies: ["Elementos", "Teoria", "Partituras", "Polifonia"],
            path: "Packages/Armonia/Sources/Formatos"),
        .target(
            name: "Trastes",
            dependencies: ["Elementos", "Teoria", "Partituras"],
            path: "Packages/Armonia/Sources/Trastes"),
        .target(
            name: "Armonia",
            dependencies: ["Elementos", "Teoria", "Diagramas", "Partituras", "Polifonia", "Formatos", "Trastes"],
            path: "Packages/Armonia/Sources/Armonia"),

        .target(
            name: "Exposicion",
            dependencies: ["Armonia", "Hexagonos"],
            path: "Packages/Exposicion/Sources/Exposicion"),

        .target(
            name: "Interfaz",
            dependencies: ["Exposicion", "Armonia", "Hexagonos"],
            path: "Packages/Interfaz/Sources/Interfaz"),
    ]
)
