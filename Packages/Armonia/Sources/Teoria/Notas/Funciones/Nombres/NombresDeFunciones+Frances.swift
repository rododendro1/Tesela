// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en francés. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let frances = Tabla([
        .init(.tonica, "tonique"),
        .init(.supertonica, "sus-tonique"),
        .init(.mediante, "médiante"),
        .init(.subdominante, "sous-dominante"),
        .init(.dominante, "dominante"),
        .init(.superdominante, "sus-dominante"),
        .init(.sensible, "sensible"),
        .init(.subtonica, "sous-tonique"),
        .init(.finalis, "finale", alias: ["finalis"]),
        .init(.tenor, "teneur", alias: ["repercussio"]),
        .init(.confinalis, "confinale", alias: ["confinalis"]),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vādī"),
        .init(.samvadi, "saṃvādī"),
        .init(.nyasa, "nyāsa"),
        .init(.qarar, "qarār"),
        .init(.ghammaz, "ghammāz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "tierce blue"),
        .init(.quintaBlue, "quinte blue"),
        .init(.septimaBlue, "septième blue"),
        .init(.acciaccatura, "acciaccatura", alias: ["appoggiature brève"]),
        .init(.mordente, "mordant"),
        .init(.grupeto, "gruppetto"),
        .init(.trino, "trille"),
        .init(.notaDePaso, "note de passage"),
        .init(.bordadura, "broderie"),
        .init(.apoyatura, "appoggiature"),
        .init(.retardo, "retard"),
        .init(.anticipacion, "anticipation"),
        .init(.escapada, "échappée"),
        .init(.notaPedal, "pédale"),
        .init(.notaLibre, "note libre"),
    ])
}
