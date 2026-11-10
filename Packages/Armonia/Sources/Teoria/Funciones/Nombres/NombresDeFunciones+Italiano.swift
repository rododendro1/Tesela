// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en italiano. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let italiano = Tabla([
        .init(.tonica, "tonica"),
        .init(.supertonica, "sopratonica"),
        .init(.mediante, "mediante"),
        .init(.subdominante, "sottodominante"),
        .init(.dominante, "dominante"),
        .init(.superdominante, "sopradominante"),
        .init(.sensible, "sensibile"),
        .init(.subtonica, "sottotonica"),
        .init(.finalis, "finalis", alias: ["finale"]),
        .init(.tenor, "tenor", alias: ["corda di recita"]),
        .init(.confinalis, "confinalis"),
        .init(.sa, "sa"),
        .init(.pa, "pa"),
        .init(.vadi, "vādī"),
        .init(.samvadi, "saṃvādī"),
        .init(.nyasa, "nyāsa"),
        .init(.qarar, "qarār"),
        .init(.ghammaz, "ghammāz"),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "terza blue"),
        .init(.quintaBlue, "quinta blue"),
        .init(.septimaBlue, "settima blue"),
        .init(.acciaccatura, "acciaccatura"),
        .init(.mordente, "mordente"),
        .init(.grupeto, "gruppetto"),
        .init(.trino, "trillo"),
        .init(.notaDePaso, "nota di passaggio"),
        .init(.bordadura, "nota di volta"),
        .init(.apoyatura, "appoggiatura"),
        .init(.retardo, "ritardo"),
        .init(.anticipacion, "anticipazione"),
        .init(.escapada, "nota sfuggita"),
        .init(.notaPedal, "pedale"),
        .init(.notaLibre, "nota libera"),
    ])
}
