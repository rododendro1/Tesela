// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en catalán. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let catalan = Tabla([
        .init(.tonica, "tònica"),
        .init(.supertonica, "supertònica"),
        .init(.mediante, "mediant"),
        .init(.subdominante, "subdominant"),
        .init(.dominante, "dominant"),
        .init(.superdominante, "superdominant"),
        .init(.sensible, "sensible"),
        .init(.subtonica, "subtònica"),
        .init(.finalis, "finalis", alias: ["nota final"]),
        .init(.tenor, "tenor", alias: ["nota de recitació"]),
        .init(.confinalis, "confinalis"),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vādī"),
        .init(.samvadi, "saṃvādī"),
        .init(.nyasa, "nyāsa"),
        .init(.qarar, "qarār"),
        .init(.ghammaz, "ghammāz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "tercera blue"),
        .init(.quintaBlue, "quinta blue"),
        .init(.septimaBlue, "setena blue"),
        .init(.acciaccatura, "acciaccatura"),
        .init(.mordente, "mordent"),
        .init(.grupeto, "grupet"),
        .init(.trino, "trinat"),
        .init(.notaDePaso, "nota de pas"),
        .init(.bordadura, "brodadura"),
        .init(.apoyatura, "appoggiatura"),
        .init(.retardo, "retard"),
        .init(.anticipacion, "anticipació"),
        .init(.escapada, "escapada"),
        .init(.notaPedal, "nota pedal"),
        .init(.notaLibre, "nota lliure"),
    ])
}
