// swift-tools-version:6.0
import PackageDescription

// Los demás catálogos del motor en ficheros TSV, uno por catálogo (los de acordes, escalas y progresiones tienen su
// propio ejemplo):
//
//     swift run EjemploCatalogos                  # escribe los ficheros en catalogos/
//     swift run EjemploCatalogos tsv              # en otra carpeta
//     swift run EjemploCatalogos -                # todos en la salida estándar, cada uno tras «# fichero.tsv»
let package = Package(
    name: "EjemploCatalogos",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "EjemploCatalogos", targets: ["EjemploCatalogos"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia")
    ],
    targets: [
        .executableTarget(
            name: "EjemploCatalogos",
            dependencies: [.product(name: "Armonia", package: "Armonia")])
    ]
)
