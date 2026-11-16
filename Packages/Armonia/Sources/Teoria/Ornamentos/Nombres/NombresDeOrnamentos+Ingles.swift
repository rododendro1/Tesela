// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los ornamentos del catálogo en inglés. Qué es cada campo, en `NombresDeOrnamentos.swift`.

extension NombresDeOrnamentos {
    static let ingles = Tabla([
        .init(.trino, "trill"),
        .init(.trinoConTerminacion, "trill with termination"),
        .init(.trinoCorto, "short trill", alias: ["Pralltriller"]),
        .init(.mordente, "mordent", alias: ["lower mordent"]),
        .init(.mordenteSuperior, "upper mordent", alias: ["Schneller"]),
        .init(.grupeto, "turn", alias: ["gruppetto"]),
        .init(.grupetoInvertido, "inverted turn"),
        .init(.apoyaturaSuperior, "upper appoggiatura"),
        .init(.apoyaturaInferior, "lower appoggiatura"),
        .init(.schleifer, "slide", alias: ["Schleifer"]),
    ])
}
