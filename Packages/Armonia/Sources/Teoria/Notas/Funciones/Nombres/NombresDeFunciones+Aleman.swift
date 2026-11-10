// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en alemán. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let aleman = Tabla([
        .init(.tonica, "Tonika"),
        .init(.supertonica, "Supertonika"),
        .init(.mediante, "Mediante"),
        .init(.subdominante, "Subdominante"),
        .init(.dominante, "Dominante"),
        .init(.superdominante, "Submediante"),
        .init(.sensible, "Leitton"),
        .init(.subtonica, "Subtonika"),
        .init(.finalis, "Finalis", alias: ["Schlusston"]),
        .init(.tenor, "Tenor", alias: ["Rezitationston", "Repercussa"]),
        .init(.confinalis, "Confinalis"),
        .init(.sa, "Sa"),
        .init(.pa, "Pa"),
        .init(.vadi, "Vadi"),
        .init(.samvadi, "Samvadi"),
        .init(.nyasa, "Nyasa"),
        .init(.qarar, "Qarar"),
        .init(.ghammaz, "Ghammaz"),
        .init(.yeden, "Yeden"),
        .init(.terceraBlue, "Blue-Terz"),
        .init(.quintaBlue, "Blue-Quinte"),
        .init(.septimaBlue, "Blue-Septime"),
        .init(.acciaccatura, "kurzer Vorschlag", alias: ["Acciaccatura"]),
        .init(.mordente, "Mordent"),
        .init(.grupeto, "Doppelschlag"),
        .init(.trino, "Triller"),
        .init(.notaDePaso, "Durchgangston"),
        .init(.bordadura, "Wechselnote"),
        .init(.apoyatura, "freier Vorhalt"),
        .init(.retardo, "Vorhalt"),
        .init(.anticipacion, "Antizipation"),
        .init(.escapada, "Echappée"),
        .init(.notaPedal, "Orgelpunkt"),
        .init(.notaLibre, "freie Dissonanz"),
    ])
}
