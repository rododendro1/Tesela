// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en gallego. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let gallego = Tabla([
        .init(.tonica, "tónica"),
        .init(.supertonica, "supertónica"),
        .init(.mediante, "mediante"),
        .init(.subdominante, "subdominante"),
        .init(.dominante, "dominante"),
        .init(.superdominante, "superdominante"),
        .init(.sensible, "sensible"),
        .init(.subtonica, "subtónica"),
        .init(.finalis, "finalis", alias: ["nota final"]),
        .init(.tenor, "tenor", alias: ["nota de recitación"]),
        .init(.confinalis, "confinalis"),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vādī"),
        .init(.samvadi, "saṃvādī"),
        .init(.nyasa, "nyāsa"),
        .init(.qarar, "qarār"),
        .init(.ghammaz, "ghammāz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "terceira blue"),
        .init(.quintaBlue, "quinta blue"),
        .init(.septimaBlue, "sétima blue"),
        .init(.acciaccatura, "acciaccatura"),
        .init(.mordente, "mordente"),
        .init(.grupeto, "grupeto"),
        .init(.trino, "trilo"),
        .init(.notaDePaso, "nota de paso"),
        .init(.bordadura, "bordadura"),
        .init(.apoyatura, "apoiatura"),
        .init(.retardo, "retardo"),
        .init(.anticipacion, "anticipación"),
        .init(.escapada, "escapada"),
        .init(.notaPedal, "nota pedal"),
        .init(.notaLibre, "nota libre"),
    ])
}
