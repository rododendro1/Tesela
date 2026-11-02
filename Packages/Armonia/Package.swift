// swift-tools-version:6.0
import PackageDescription

// La biblioteca se reparte en cinco módulos por capas, y `Armonia` los reexporta: quien escribe
// `import Armonia` ve la misma API de siempre. Lo que antes era interno y se usa entre capas es
// `package`: visible dentro de este paquete y no en la API pública.
//
//     ArmoniaNucleo            Fundamentos, Texto, Postonal
//     ArmoniaTeoria            Acordes, Escalas, Tonalidad
//     ArmoniaRepresentaciones  Afinacion, Color, Dibujo, Redes
//     ArmoniaPartitura         Modelo, Formatos
//     ArmoniaTrastes           Encordado, Mastil, Digitacion (instrumentos de cuerda con trastes)
//
// La geometría de las rejillas hexagonales (el Tonnetz, la tabla armónica, los teclados isomórficos) viene
// del paquete `Hexagonos`, que no depende de nada. `ArmoniaRepresentaciones` lo usa; `Armonia` no lo reexporta,
// para no meter sus nombres en el código de quien importa el motor: quien use la rejilla, `import Hexagonos`.
//
// `Scripts/comprobaciones/comprobar_modulos.py` vigila que las dependencias sean estas y no otras.

let hexagonos: Target.Dependency = .product(name: "Hexagonos", package: "Hexagonos")

/// Todos los módulos de la biblioteca, para las pruebas que cruzan capas.
let modulos: [Target.Dependency] = [
    "Armonia", "ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaRepresentaciones", "ArmoniaPartitura", "ArmoniaTrastes",
    hexagonos,
]

let package = Package(
    name: "Armonia",
    // Las mismas que piden las apps y ArmoniaUI. Sin esta línea SwiftPM asume macOS 10.13 / iOS 11, y la
    // biblioteca estándar de esas versiones no tiene APIs que el código puede usar sin darse cuenta.
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        // El producto de siempre: todo.
        .library(name: "Armonia", targets: ["Armonia"]),
        // Y uno por capa, para depender solo de lo que se usa.
        .library(name: "ArmoniaNucleo", targets: ["ArmoniaNucleo"]),
        .library(name: "ArmoniaTeoria", targets: ["ArmoniaTeoria"]),
        .library(name: "ArmoniaRepresentaciones", targets: ["ArmoniaRepresentaciones"]),
        .library(name: "ArmoniaPartitura", targets: ["ArmoniaPartitura"]),
        .library(name: "ArmoniaTrastes", targets: ["ArmoniaTrastes"]),
    ],
    dependencies: [
        .package(path: "../Hexagonos")
    ],
    targets: [
        .target(name: "ArmoniaNucleo"),
        .target(name: "ArmoniaTeoria", dependencies: ["ArmoniaNucleo"]),
        .target(
            name: "ArmoniaRepresentaciones",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", .product(name: "Hexagonos", package: "Hexagonos")]),
        .target(name: "ArmoniaPartitura", dependencies: ["ArmoniaNucleo", "ArmoniaTeoria"]),
        .target(name: "ArmoniaTrastes", dependencies: ["ArmoniaNucleo", "ArmoniaTeoria"]),
        // El módulo paraguas: reexporta los cinco y guarda la documentación (DocC).
        .target(
            name: "Armonia",
            dependencies: [
                "ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaRepresentaciones", "ArmoniaPartitura", "ArmoniaTrastes",
            ]),
        // Las pruebas de cada módulo dependen solo de él y de los que puede usar, como el módulo mismo: una prueba de
        // Núcleo que necesitara Teoría no compila. Ven lo `internal` con `@testable import`.
        .testTarget(name: "ArmoniaNucleoTests", dependencies: ["ArmoniaNucleo"]),
        .testTarget(name: "ArmoniaTeoriaTests", dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ApoyoDePruebas"]),
        .testTarget(
            name: "ArmoniaRepresentacionesTests",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaRepresentaciones", hexagonos, "ApoyoDePruebas"]),
        .testTarget(
            name: "ArmoniaPartituraTests",
            dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaPartitura", "ApoyoDePruebas"]),
        .testTarget(name: "ArmoniaTrastesTests", dependencies: ["ArmoniaNucleo", "ArmoniaTeoria", "ArmoniaTrastes"]),
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
