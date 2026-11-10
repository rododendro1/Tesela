// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en sueco. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let sueco = tabla([
        .init(.la440, "A 440"),
        .init(.la442, "A 442"),
        .init(.la432, "A 432"),
        .init(.la415, "A 415"),
        .init(.la430, "A 430"),
        .init(.la4225, "A 422,5", variantes: ["A 422.5"]),
        .init(.la435, "A 435"),
        .init(.la466, "A 466", alias: ["Chorton"]),
        .init(.la4525, "A 452,5", variantes: ["A 452.5"]),
        .init(.do256, "C 256"),
        .init(.doCentral, "ettstrukna C"),
        .init(.laMasGraveDelPiano, "pianots lägsta A"),
        .init(.doMasAgudoDelPiano, "pianots högsta C"),
        .init(.notaMidi0, "MIDI-ton 0"),
        .init(.notaMidi127, "MIDI-ton 127"),
    ])
}
