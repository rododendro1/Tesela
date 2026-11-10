// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en griego. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let griego = Tabla([
        .init(.tonica, "τονική"),
        .init(.supertonica, "υπερτονική"),
        .init(.mediante, "μέση"),
        .init(.subdominante, "υποδεσπόζουσα"),
        .init(.dominante, "δεσπόζουσα"),
        .init(.superdominante, "υπερδεσπόζουσα"),
        .init(.sensible, "προσαγωγέας"),
        .init(.subtonica, "υποτονική"),
        .init(.finalis, "τελική"),
        .init(.tenor, "τένορ"),
        .init(.confinalis, "δευτερεύουσα τελική"),
        .init(.sa, "σα", alias: ["sa"]),
        .init(.pa, "πα", alias: ["pa"]),
        .init(.vadi, "βάντι", alias: ["vādī"]),
        .init(.samvadi, "σαμβάντι", alias: ["saṃvādī"]),
        .init(.nyasa, "νιάσα", alias: ["nyāsa"]),
        .init(.qarar, "καράρ", alias: ["qarār"]),
        .init(.ghammaz, "γκαμάζ", alias: ["ghammāz"]),
        .init(.yeden, "γιεντέν", alias: ["yeden"]),
        .init(.terceraBlue, "μπλου τρίτη"),
        .init(.quintaBlue, "μπλου πέμπτη"),
        .init(.septimaBlue, "μπλου έβδομη"),
        .init(.acciaccatura, "ατσιακατούρα"),
        .init(.mordente, "μορντέντε"),
        .init(.grupeto, "γκρουπέτο"),
        .init(.trino, "τρίλια"),
        .init(.notaDePaso, "διαβατική νότα"),
        .init(.bordadura, "γειτονική νότα"),
        .init(.apoyatura, "αποτζιατούρα"),
        .init(.retardo, "καθυστέρηση"),
        .init(.anticipacion, "πρόληψη"),
        .init(.escapada, "νότα διαφυγής"),
        .init(.notaPedal, "νότα πεντάλ"),
        .init(.notaLibre, "ελεύθερη νότα"),
    ])
}
