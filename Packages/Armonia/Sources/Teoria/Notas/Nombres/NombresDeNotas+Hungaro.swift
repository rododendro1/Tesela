// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en húngaro. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let hungaro = tabla([
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
        .init(.doCentral, "középső C"),
        .init(.laMasGraveDelPiano, "a zongora legmélyebb A hangja"),
        .init(.doMasAgudoDelPiano, "a zongora legmagasabb C hangja"),
        .init(.notaMidi0, "0-s MIDI-hang"),
        .init(.notaMidi127, "127-es MIDI-hang"),
    ])
}
