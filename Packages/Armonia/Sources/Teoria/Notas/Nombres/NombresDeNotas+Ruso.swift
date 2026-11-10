// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en ruso. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let ruso = tabla([
        .init(.la440, "Ля 440"),
        .init(.la442, "Ля 442"),
        .init(.la432, "Ля 432"),
        .init(.la415, "Ля 415"),
        .init(.la430, "Ля 430"),
        .init(.la4225, "Ля 422,5", variantes: ["Ля 422.5"]),
        .init(.la435, "Ля 435"),
        .init(.la466, "Ля 466", alias: ["Chorton"]),
        .init(.la4525, "Ля 452,5", variantes: ["Ля 452.5"]),
        .init(.do256, "До 256"),
        .init(.doCentral, "до первой октавы"),
        .init(.laMasGraveDelPiano, "самое низкое ля фортепиано"),
        .init(.doMasAgudoDelPiano, "самое высокое до фортепиано"),
        .init(.notaMidi0, "MIDI-нота 0"),
        .init(.notaMidi127, "MIDI-нота 127"),
    ])
}
