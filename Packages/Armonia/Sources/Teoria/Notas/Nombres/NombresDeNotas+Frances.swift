// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en francés. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let frances = tabla([
        .init(.la440, "La 440", alias: ["diapason standard"]),
        .init(.la442, "La 442"),
        .init(.la432, "La 432", alias: ["diapason de Verdi"]),
        .init(.la415, "La 415", alias: ["diapason baroque"]),
        .init(.la430, "La 430", alias: ["diapason classique"]),
        .init(.la4225, "La 422,5", alias: ["diapason de Haendel"], variantes: ["La 422.5"]),
        .init(.la435, "La 435", alias: ["diapason normal"]),
        .init(.la466, "La 466", alias: ["Chorton"]),
        .init(.la4525, "La 452,5", variantes: ["La 452.5"]),
        .init(.do256, "Do 256", alias: ["diapason scientifique"]),
        .init(.doCentral, "do central"),
        .init(.laMasGraveDelPiano, "la le plus grave du piano"),
        .init(.doMasAgudoDelPiano, "do le plus aigu du piano"),
        .init(.notaMidi0, "note MIDI 0"),
        .init(.notaMidi127, "note MIDI 127"),
    ])
}
