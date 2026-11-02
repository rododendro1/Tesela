// swift-tools-version:6.0
import PackageDescription

// Fuzzing de lo que el motor lee de fuera (MIDI, MusicXML, MXL, MEI, ABC, teclados UIL y los textos de las apps y
// de la línea de comandos) con libFuzzer y AddressSanitizer. Solo en Linux, que es donde Swift trae libFuzzer:
//
//     swift build -c release --product FuzzArmonia --scratch-path .build/fuzz \
//         -Xswiftc -sanitize=fuzzer,address -Xswiftc -DFUZZING
//     swift run FuzzArmonia --semillas semillas           # los casos de partida (sin libFuzzer)
//     LSAN_OPTIONS=suppressions=fugas-ajenas.supp .build/fuzz/release/FuzzArmonia corpus semillas -max_total_time=600
//
// Sin esas opciones, `swift run FuzzArmonia crash-…` vuelve a leer los ficheros que dejó un fallo, para repetirlo.
let package = Package(
    name: "FuzzArmonia",
    // Como `Armonia`: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de otro con uno más alto.
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "FuzzArmonia", targets: ["FuzzArmonia"])
    ],
    dependencies: [
        .package(path: "../../Packages/Armonia")
    ],
    targets: [
        .target(
            name: "LecturaAlAzar",
            dependencies: [.product(name: "Armonia", package: "Armonia")]),
        .executableTarget(name: "FuzzArmonia", dependencies: ["LecturaAlAzar"]),
        .testTarget(name: "LecturaAlAzarTests", dependencies: ["LecturaAlAzar"]),
    ]
)
