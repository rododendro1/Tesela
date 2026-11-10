// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las funciones de nota del catálogo en ruso. Qué es cada campo, en `NombresDeFunciones.swift`.

extension NombresDeFunciones {
    static let ruso = Tabla([
        .init(.tonica, "тоника"),
        .init(.supertonica, "супертоника"),
        .init(.mediante, "медианта"),
        .init(.subdominante, "субдоминанта"),
        .init(.dominante, "доминанта"),
        .init(.superdominante, "субмедианта"),
        .init(.sensible, "вводный тон"),
        .init(.subtonica, "субтоника"),
        .init(.finalis, "финалис"),
        .init(.tenor, "тенор", alias: ["реперкусса"]),
        .init(.confinalis, "конфиналис"),
        .init(.sa, "са", alias: ["sa"]),
        .init(.pa, "па", alias: ["pa"]),
        .init(.vadi, "вади", alias: ["vādī"]),
        .init(.samvadi, "самвади", alias: ["saṃvādī"]),
        .init(.nyasa, "ньяса", alias: ["nyāsa"]),
        .init(.qarar, "карар", alias: ["qarār"]),
        .init(.ghammaz, "гаммаз", alias: ["ghammāz"]),
        .init(.yeden, "йеден", alias: ["yeden"]),
        .init(.terceraBlue, "блюзовая терция"),
        .init(.quintaBlue, "блюзовая квинта"),
        .init(.septimaBlue, "блюзовая септима"),
        .init(.acciaccatura, "короткий форшлаг"),
        .init(.mordente, "мордент"),
        .init(.grupeto, "группетто"),
        .init(.trino, "трель"),
        .init(.notaDePaso, "проходящий звук"),
        .init(.bordadura, "вспомогательный звук"),
        .init(.apoyatura, "неприготовленное задержание"),
        .init(.retardo, "задержание"),
        .init(.anticipacion, "предъём"),
        .init(.escapada, "отлетающий звук"),
        .init(.notaPedal, "органный пункт"),
        .init(.notaLibre, "свободный звук"),
    ])
}
