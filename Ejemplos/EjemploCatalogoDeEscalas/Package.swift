// swift-tools-version:6.0
import PackageDescription

// El catálogo de escalas del motor en un fichero TSV, una fila por escala:
//
//     swift run EjemploCatalogoDeEscalas                      # escribe catalogo-de-escalas.tsv
//     swift run EjemploCatalogoDeEscalas escalas.tsv          # en otro fichero
//     swift run EjemploCatalogoDeEscalas -                    # en la salida estándar
//     swift run EjemploCatalogoDeEscalas --tradicion india    # solo las de una tradición
//     swift run EjemploCatalogoDeEscalas --bibtex obras.bib   # y las obras que citan, en BibTeX
let package = Package(
    name: "EjemploCatalogoDeEscalas",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "EjemploCatalogoDeEscalas", targets: ["EjemploCatalogoDeEscalas"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia")
    ],
    targets: [
        .executableTarget(
            name: "EjemploCatalogoDeEscalas",
            dependencies: [.product(name: "Armonia", package: "Armonia")])
    ]
)
