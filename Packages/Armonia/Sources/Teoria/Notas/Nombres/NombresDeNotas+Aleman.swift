// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en alemán. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let aleman = tabla([
        .init(.la440, "A 440", alias: ["Kammerton", "Standardstimmton"]),
        .init(.la442, "A 442"),
        .init(.la432, "A 432", alias: ["Verdi-Stimmung"]),
        .init(.la415, "A 415", alias: ["Barockstimmung"]),
        .init(.la430, "A 430", alias: ["klassische Stimmung"]),
        .init(.la4225, "A 422,5", alias: ["Händels Stimmgabel"], variantes: ["A 422.5"]),
        .init(.la435, "A 435", alias: ["Pariser Kammerton"]),
        .init(.la466, "A 466", alias: ["Chorton"]),
        .init(.la4525, "A 452,5", variantes: ["A 452.5"]),
        .init(.do256, "C 256", alias: ["wissenschaftliche Stimmung"]),
        .init(.doCentral, "mittleres C"),
        .init(.laMasGraveDelPiano, "tiefstes A des Klaviers"),
        .init(.doMasAgudoDelPiano, "höchstes C des Klaviers"),
        .init(.notaMidi0, "MIDI-Note 0"),
        .init(.notaMidi127, "MIDI-Note 127"),
    ])
}
