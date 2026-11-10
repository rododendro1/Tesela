// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en húngaro. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let hungaro = Tabla([
        .init(.tonica, "tonika"),
        .init(.supertonica, "szupertonika"),
        .init(.mediante, "mediáns"),
        .init(.subdominante, "szubdomináns"),
        .init(.dominante, "domináns"),
        .init(.superdominante, "szubmediáns"),
        .init(.sensible, "vezetőhang"),
        .init(.subtonica, "szubtonika"),
        .init(.finalis, "finalis", alias: ["záróhang"]),
        .init(.tenor, "tenor", alias: ["recitáló hang"]),
        .init(.confinalis, "confinalis"),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vádi"),
        .init(.samvadi, "szamvádi"),
        .init(.nyasa, "nyásza"),
        .init(.qarar, "qarár"),
        .init(.ghammaz, "ghammáz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "blue terc"),
        .init(.quintaBlue, "blue kvint"),
        .init(.septimaBlue, "blue szeptim"),
        .init(.acciaccatura, "rövid előke"),
        .init(.mordente, "mordent"),
        .init(.grupeto, "gruppetto"),
        .init(.trino, "trilla"),
        .init(.notaDePaso, "átmenőhang"),
        .init(.bordadura, "váltóhang"),
        .init(.apoyatura, "appoggiatura"),
        .init(.retardo, "késleltetés"),
        .init(.anticipacion, "anticipáció"),
        .init(.escapada, "szökőhang"),
        .init(.notaPedal, "orgonapont"),
        .init(.notaLibre, "szabad hang"),
    ])
}
