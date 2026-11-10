// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las notas del catálogo en griego. Qué es cada campo, en `NombresDeNotas.swift`.

extension NombresDeNotas {
    static let griego = tabla([
        .init(.la440, "Λα 440"),
        .init(.la442, "Λα 442"),
        .init(.la432, "Λα 432"),
        .init(.la415, "Λα 415"),
        .init(.la430, "Λα 430"),
        .init(.la4225, "Λα 422,5", variantes: ["Λα 422.5"]),
        .init(.la435, "Λα 435"),
        .init(.la466, "Λα 466", alias: ["Chorton"]),
        .init(.la4525, "Λα 452,5", variantes: ["Λα 452.5"]),
        .init(.do256, "Ντο 256"),
        .init(.doCentral, "κεντρικό Ντο"),
        .init(.laMasGraveDelPiano, "το χαμηλότερο Λα του πιάνου"),
        .init(.doMasAgudoDelPiano, "το ψηλότερο Ντο του πιάνου"),
        .init(.notaMidi0, "νότα MIDI 0"),
        .init(.notaMidi127, "νότα MIDI 127"),
    ], enGriego: true)
}
