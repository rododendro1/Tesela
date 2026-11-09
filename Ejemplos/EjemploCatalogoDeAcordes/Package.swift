// swift-tools-version:6.0
import PackageDescription

// El catálogo de acordes del motor en un fichero TSV, una fila por acorde:
//
//     swift run EjemploCatalogoDeAcordes                      # escribe catalogo-de-acordes.tsv
//     swift run EjemploCatalogoDeAcordes acordes.tsv         # en otro fichero
//     swift run EjemploCatalogoDeAcordes -                    # en la salida estándar
//     swift run EjemploCatalogoDeAcordes --bibtex obras.bib   # y las obras que citan, en BibTeX
let package = Package(
    name: "EjemploCatalogoDeAcordes",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "EjemploCatalogoDeAcordes", targets: ["EjemploCatalogoDeAcordes"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia")
    ],
    targets: [
        .executableTarget(
            name: "EjemploCatalogoDeAcordes",
            dependencies: [.product(name: "Armonia", package: "Armonia")])
    ]
)
