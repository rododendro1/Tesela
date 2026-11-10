// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en gallego. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let gallego = tabla([
        .init(.la440, "La 440", alias: ["diapasón estándar"]),
        .init(.la442, "La 442"),
        .init(.la432, "La 432", alias: ["diapasón de Verdi"]),
        .init(.la415, "La 415", alias: ["diapasón barroco"]),
        .init(.la430, "La 430", alias: ["diapasón clásico"]),
        .init(.la4225, "La 422,5", alias: ["diapasón de Händel"], variantes: ["La 422.5"]),
        .init(.la435, "La 435", alias: ["diapasón normal francés"]),
        .init(.la466, "La 466", alias: ["Chorton"]),
        .init(.la4525, "La 452,5", variantes: ["La 452.5"]),
        .init(.do256, "Do 256", alias: ["afinación científica"]),
        .init(.doCentral, "Do central"),
        .init(.laMasGraveDelPiano, "La máis grave do piano"),
        .init(.doMasAgudoDelPiano, "Do máis agudo do piano"),
        .init(.notaMidi0, "nota MIDI 0"),
        .init(.notaMidi127, "nota MIDI 127"),
    ])
}
