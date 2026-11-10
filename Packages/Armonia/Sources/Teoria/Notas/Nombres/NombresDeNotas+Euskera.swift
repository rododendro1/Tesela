// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en euskera. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let euskera = tabla([
        .init(.la440, "La 440"),
        .init(.la442, "La 442"),
        .init(.la432, "La 432"),
        .init(.la415, "La 415"),
        .init(.la430, "La 430"),
        .init(.la4225, "La 422,5", variantes: ["La 422.5"]),
        .init(.la435, "La 435"),
        .init(.la466, "La 466", alias: ["Chorton"]),
        .init(.la4525, "La 452,5", variantes: ["La 452.5"]),
        .init(.do256, "Do 256"),
        .init(.doCentral, "erdiko Do"),
        .init(.laMasGraveDelPiano, "pianoaren La baxuena"),
        .init(.doMasAgudoDelPiano, "pianoaren Do altuena"),
        .init(.notaMidi0, "MIDI 0 nota"),
        .init(.notaMidi127, "MIDI 127 nota"),
    ])
}
