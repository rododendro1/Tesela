// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en sueco. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let sueco = Tabla([
        .init(.tonica, "tonika"),
        .init(.supertonica, "supertonika"),
        .init(.mediante, "mediant"),
        .init(.subdominante, "subdominant"),
        .init(.dominante, "dominant"),
        .init(.superdominante, "submediant"),
        .init(.sensible, "ledton"),
        .init(.subtonica, "subtonika"),
        .init(.finalis, "finalis", alias: ["sluton"]),
        .init(.tenor, "tenor", alias: ["reciteringston"]),
        .init(.confinalis, "confinalis"),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vadi"),
        .init(.samvadi, "samvadi"),
        .init(.nyasa, "nyasa"),
        .init(.qarar, "qarar"),
        .init(.ghammaz, "ghammaz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "blue-ters"),
        .init(.quintaBlue, "blue-kvint"),
        .init(.septimaBlue, "blue-septima"),
        .init(.acciaccatura, "kort förslag"),
        .init(.mordente, "mordent"),
        .init(.grupeto, "dubbelslag"),
        .init(.trino, "drill"),
        .init(.notaDePaso, "genomgångston"),
        .init(.bordadura, "växelton"),
        .init(.apoyatura, "fri förhållning"),
        .init(.retardo, "förhållning"),
        .init(.anticipacion, "föregripning"),
        .init(.escapada, "échappée"),
        .init(.notaPedal, "orgelpunkt"),
        .init(.notaLibre, "fri dissonans"),
    ])
}
