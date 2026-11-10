// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en inglés. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let ingles = Tabla([
        .init(.tonica, "tonic"),
        .init(.supertonica, "supertonic"),
        .init(.mediante, "mediant"),
        .init(.subdominante, "subdominant"),
        .init(.dominante, "dominant"),
        .init(.superdominante, "submediant"),
        .init(.sensible, "leading tone", alias: ["leading note"]),
        .init(.subtonica, "subtonic"),
        .init(.finalis, "finalis", alias: ["final"]),
        .init(.tenor, "reciting tone", alias: ["tenor", "repercussio"]),
        .init(.confinalis, "confinalis", alias: ["cofinal"]),
        .init(.sa, "sa", alias: ["ṣaḍja"], variantes: ["shadja"]),
        .init(.pa, "pa", alias: ["pañcama"], variantes: ["panchama"]),
        .init(.vadi, "vādī"),
        .init(.samvadi, "saṃvādī", variantes: ["samvadi"]),
        .init(.nyasa, "nyāsa"),
        .init(.qarar, "qarār", alias: ["durak"], variantes: ["qarar"]),
        .init(.ghammaz, "ghammāz", alias: ["güçlü"]),
        .init(.yeden, "yeden"),
        .init(.terceraBlue, "blue third"),
        .init(.quintaBlue, "blue fifth", alias: ["flatted fifth"]),
        .init(.septimaBlue, "blue seventh"),
        .init(.acciaccatura, "acciaccatura", alias: ["crushed note", "short grace note"]),
        .init(.mordente, "mordent"),
        .init(.grupeto, "turn", alias: ["gruppetto"]),
        .init(.trino, "trill"),
        .init(.notaDePaso, "passing tone"),
        .init(.bordadura, "neighbor tone"),
        .init(.apoyatura, "appoggiatura"),
        .init(.retardo, "suspension"),
        .init(.anticipacion, "anticipation"),
        .init(.escapada, "escape tone"),
        .init(.notaPedal, "pedal tone"),
        .init(.notaLibre, "free tone"),
    ])
}
