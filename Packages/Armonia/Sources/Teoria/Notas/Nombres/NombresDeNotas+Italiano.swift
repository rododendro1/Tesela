// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en italiano. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let italiano = tabla([
        .init(.la440, "La 440", alias: ["diapason standard"]),
        .init(.la442, "La 442"),
        .init(.la432, "La 432", alias: ["diapason verdiano"]),
        .init(.la415, "La 415", alias: ["diapason barocco"]),
        .init(.la430, "La 430", alias: ["diapason classico"]),
        .init(.la4225, "La 422,5", alias: ["diapason di Händel"], variantes: ["La 422.5"]),
        .init(.la435, "La 435", alias: ["diapason normale"]),
        .init(.la466, "La 466", alias: ["Chorton"]),
        .init(.la4525, "La 452,5", variantes: ["La 452.5"]),
        .init(.do256, "Do 256", alias: ["diapason scientifico"]),
        .init(.doCentral, "Do centrale"),
        .init(.laMasGraveDelPiano, "La più grave del pianoforte"),
        .init(.doMasAgudoDelPiano, "Do più acuto del pianoforte"),
        .init(.notaMidi0, "nota MIDI 0"),
        .init(.notaMidi127, "nota MIDI 127"),
    ])
}
