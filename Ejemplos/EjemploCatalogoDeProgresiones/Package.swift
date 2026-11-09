// swift-tools-version:6.0
import PackageDescription

// El catálogo de progresiones del motor en un fichero TSV, una fila por progresión:
//
//     swift run EjemploCatalogoDeProgresiones                      # escribe catalogo-de-progresiones.tsv
//     swift run EjemploCatalogoDeProgresiones progresiones.tsv         # en otro fichero
//     swift run EjemploCatalogoDeProgresiones -                    # en la salida estándar
//     swift run EjemploCatalogoDeProgresiones --bibtex obras.bib   # y las obras que citan, en BibTeX
let package = Package(
    name: "EjemploCatalogoDeProgresiones",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "EjemploCatalogoDeProgresiones", targets: ["EjemploCatalogoDeProgresiones"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia")
    ],
    targets: [
        .executableTarget(
            name: "EjemploCatalogoDeProgresiones",
            dependencies: [.product(name: "Armonia", package: "Armonia")])
    ]
)
