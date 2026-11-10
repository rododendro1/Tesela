// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en portugués. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let portugues = tabla([
        .init(.la440, "Lá 440", alias: ["diapasão padrão"]),
        .init(.la442, "Lá 442"),
        .init(.la432, "Lá 432", alias: ["diapasão de Verdi"]),
        .init(.la415, "Lá 415", alias: ["diapasão barroco"]),
        .init(.la430, "Lá 430", alias: ["diapasão clássico"]),
        .init(.la4225, "Lá 422,5", alias: ["diapasão de Händel"], variantes: ["Lá 422.5"]),
        .init(.la435, "Lá 435", alias: ["diapasão normal francês"]),
        .init(.la466, "Lá 466", alias: ["Chorton"]),
        .init(.la4525, "Lá 452,5", variantes: ["Lá 452.5"]),
        .init(.do256, "Dó 256", alias: ["afinação científica"]),
        .init(.doCentral, "Dó central"),
        .init(.laMasGraveDelPiano, "Lá mais grave do piano"),
        .init(.doMasAgudoDelPiano, "Dó mais agudo do piano"),
        .init(.notaMidi0, "nota MIDI 0"),
        .init(.notaMidi127, "nota MIDI 127"),
    ])
}
