// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en catalán. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let catalan = tabla([
        .init(.la440, "La 440", alias: ["diapasó estàndard"]),
        .init(.la442, "La 442"),
        .init(.la432, "La 432", alias: ["diapasó de Verdi"]),
        .init(.la415, "La 415", alias: ["diapasó barroc"]),
        .init(.la430, "La 430", alias: ["diapasó clàssic"]),
        .init(.la4225, "La 422,5", alias: ["diapasó de Händel"], variantes: ["La 422.5"]),
        .init(.la435, "La 435", alias: ["diapasó normal francès"]),
        .init(.la466, "La 466", alias: ["Chorton"]),
        .init(.la4525, "La 452,5", variantes: ["La 452.5"]),
        .init(.do256, "Do 256", alias: ["afinació científica"]),
        .init(.doCentral, "Do central"),
        .init(.laMasGraveDelPiano, "La més greu del piano"),
        .init(.doMasAgudoDelPiano, "Do més agut del piano"),
        .init(.notaMidi0, "nota MIDI 0"),
        .init(.notaMidi127, "nota MIDI 127"),
    ])
}
