// swift-tools-version:6.0
import PackageDescription

// La biblioteca se reparte en siete módulos por capas, y `Armonia` los reexporta: quien escribe
// `import Armonia` ve la misma API de siempre. Lo que antes era interno y se usa entre capas es
// `package`: visible dentro de este paquete y no en la API pública.
//
//     Elementos   Fundamentos, Texto, Postonal
//     Teoria      Acordes, Escalas, Tonalidad, Afinacion
//     Diagramas   Color, Dibujo, Redes
//     Partituras  Modelo, Dibujo
//     Polifonia   Coral (armonización a cuatro voces, bajo cifrado), Contrapunto (especies), sobre Partituras
//     Formatos    MusicXML, MXL, MEI, ABC, MIDI y LilyPond: exportar e importar
//     Trastes     Encordado, Mastil, Digitacion (instrumentos de cuerda con trastes), sobre Partituras
//
// La geometría de las rejillas hexagonales (el Tonnetz, la tabla armónica, los teclados isomórficos) viene
// del paquete `Hexagonos`, que no depende de nada. `Diagramas` lo usa; `Armonia` no lo reexporta,
// para no meter sus nombres en el código de quien importa el motor: quien use la rejilla, `import Hexagonos`.
//
// `Scripts/comprobaciones/comprobar_modulos.py` vigila que las dependencias sean estas y no otras.

let hexagonos: Target.Dependency = .product(name: "Hexagonos", package: "Hexagonos")

/// Todos los módulos de la biblioteca, para las pruebas que cruzan capas.
let modulos: [Target.Dependency] = [
    "Armonia", "Elementos", "Teoria", "Diagramas", "Partituras", "Polifonia",
    "Formatos", "Trastes", hexagonos,
]

let package = Package(
    name: "Armonia",
    // Las mismas que piden las apps y Interfaz. Sin esta línea SwiftPM asume macOS 10.13 / iOS 11, y la
    // biblioteca estándar de esas versiones no tiene APIs que el código puede usar sin darse cuenta.
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        // El producto de siempre: todo.
        .library(name: "Armonia", targets: ["Armonia"]),
        // Y uno por capa, para depender solo de lo que se usa.
        .library(name: "Elementos", targets: ["Elementos"]),
        .library(name: "Teoria", targets: ["Teoria"]),
        .library(name: "Diagramas", targets: ["Diagramas"]),
        .library(name: "Partituras", targets: ["Partituras"]),
        .library(name: "Polifonia", targets: ["Polifonia"]),
        .library(name: "Formatos", targets: ["Formatos"]),
        .library(name: "Trastes", targets: ["Trastes"]),
    ],
    dependencies: [
        .package(path: "../Hexagonos")
    ],
    targets: [
        .target(name: "Elementos"),
        .target(name: "Teoria", dependencies: ["Elementos"]),
        .target(
            name: "Diagramas",
            dependencies: ["Elementos", "Teoria", .product(name: "Hexagonos", package: "Hexagonos")]),
        .target(name: "Partituras", dependencies: ["Elementos", "Teoria"]),
        .target(name: "Polifonia", dependencies: ["Elementos", "Teoria", "Partituras"]),
        .target(name: "Formatos", dependencies: ["Elementos", "Teoria", "Partituras", "Polifonia"]),
        .target(name: "Trastes", dependencies: ["Elementos", "Teoria", "Partituras"]),
        // El módulo paraguas: reexporta los siete y guarda la documentación (DocC).
        .target(
            name: "Armonia",
            dependencies: [
                "Elementos", "Teoria", "Diagramas", "Partituras", "Polifonia",
                "Formatos", "Trastes",
            ]),
        // Las pruebas de cada módulo dependen solo de él y de los que puede usar, como el módulo mismo: una prueba de
        // Elementos que necesitara Teoría no compila. Ven lo `internal` con `@testable import`.
        .testTarget(name: "ElementosTests", dependencies: ["Elementos"]),
        .testTarget(name: "TeoriaTests", dependencies: ["Elementos", "Teoria", "ApoyoDePruebas"]),
        .testTarget(
            name: "DiagramasTests",
            dependencies: ["Elementos", "Teoria", "Diagramas", hexagonos, "ApoyoDePruebas"]),
        .testTarget(
            name: "PartiturasTests",
            dependencies: ["Elementos", "Teoria", "Partituras", "ApoyoDePruebas"]),
        .testTarget(
            name: "PolifoniaTests",
            dependencies: ["Elementos", "Teoria", "Partituras", "Polifonia", "ApoyoDePruebas"]),
        .testTarget(
            name: "FormatosTests",
            dependencies: [
                "Elementos", "Teoria", "Partituras", "Polifonia", "Formatos", "ApoyoDePruebas",
            ]),
        .testTarget(
            name: "TrastesTests",
            dependencies: ["Elementos", "Teoria", "Partituras", "Trastes"]),
        // Las que cruzan capas: entradas no válidas y propiedades de todo el motor, la API poco usada, y los dibujos
        // guardados en `Referencias` con que se comparan los de ahora (ReferenciasSVGTests).
        .testTarget(name: "ArmoniaTests", dependencies: modulos + ["ApoyoDePruebas"], exclude: ["Referencias"]),
        // Lo que comparten las pruebas de varios módulos (el generador al azar con semilla y el lector de XML con que se
        // comprueban los ficheros exportados y los dibujos). No es parte del motor.
        .target(name: "ApoyoDePruebas", path: "Tests/ApoyoDePruebas"),
        .testTarget(name: "ArmoniaExhaustivasTests", dependencies: modulos),
        // Los ejemplos de la documentación usan también la rejilla (`CoordenadaAxial`, `FormasDeMapa`…).
        .testTarget(name: "ArmoniaDocumentacionTests", dependencies: ["Armonia", hexagonos]),
    ]
)
