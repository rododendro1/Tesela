// swift-tools-version:6.0
import PackageDescription

// Los catálogos del motor en ficheros TSV, uno por catálogo:
//
//     swift run EjemploCatalogos                          # escribe los ficheros en catalogos/
//     swift run EjemploCatalogos tsv                      # en otra carpeta
//     swift run EjemploCatalogos -                        # todos en la salida estándar, cada uno tras «# fichero.tsv»
//     swift run EjemploCatalogos - --solo escalas         # solo uno: escalas, acordes, progresiones, ritmos…
//     swift run EjemploCatalogos --tradicion india        # solo las escalas de una tradición
//     swift run EjemploCatalogos --bibtex obras.bib       # y las obras que citan, en BibTeX
let package = Package(
    name: "EjemploCatalogos",
    // Como `Armonia` y `Exposicion`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno
    // más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "EjemploCatalogos", targets: ["EjemploCatalogos"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia"),
        // Las medidas de cada acorde, descritas una sola vez (`MedidaDeAcorde`).
        .package(path: "../../Packages/Exposicion"),
    ],
    targets: [
        .executableTarget(
            name: "EjemploCatalogos",
            dependencies: [
                .product(name: "Armonia", package: "Armonia"),
                .product(name: "Exposicion", package: "Exposicion"),
            ])
    ]
)
