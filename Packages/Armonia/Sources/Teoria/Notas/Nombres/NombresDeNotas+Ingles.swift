// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en inglés. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let ingles = tabla([
        .init(.la440, "A440", alias: ["concert pitch", "standard pitch"]),
        .init(.la442, "A442"),
        .init(.la432, "A432", alias: ["Verdi pitch"]),
        .init(.la415, "A415", alias: ["baroque pitch"]),
        .init(.la430, "A430", alias: ["classical pitch"]),
        .init(.la4225, "A422.5", alias: ["Handel's pitch"]),
        .init(.la435, "A435", alias: ["French pitch", "diapason normal"]),
        .init(.la466, "A466", alias: ["Chorton"]),
        .init(.la4525, "A452.5", alias: ["Old Philharmonic pitch"]),
        .init(.do256, "C256", alias: ["scientific pitch", "Sauveur pitch"]),
        .init(.doCentral, "middle C"),
        .init(.laMasGraveDelPiano, "lowest A of the piano"),
        .init(.doMasAgudoDelPiano, "highest C of the piano"),
        .init(.notaMidi0, "MIDI note 0"),
        .init(.notaMidi127, "MIDI note 127"),
    ])
}
