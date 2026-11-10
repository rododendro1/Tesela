// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en portugues. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let portugues = Tabla([
        .init(.temperamentoIgual, "temperamento igual"),
        .init(.pitagorico, "afinação pitagórica"),
        .init(.mesotonicoCuartoDeComa, "mesotónico de 1/4 de coma"),
        .init(.mesotonicoTercioDeComa, "mesotónico de 1/3 de coma"),
        .init(.mesotonicoDosSeptimosDeComa, "mesotónico de 2/7 de coma"),
        .init(.mesotonicoQuintoDeComa, "mesotónico de 1/5 de coma"),
        .init(.mesotonicoSextoDeComa, "mesotónico de 1/6 de coma"),
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.afinacionJusta, "afinação justa"),
        .init(.divisiones19, "19 divisões iguais"),
        .init(.divisiones22, "22 divisões iguais"),
        .init(.divisiones31, "31 divisões iguais"),
        .init(.divisiones41, "41 divisões iguais"),
        .init(.cuartosDeTono, "quartos de tom"),
        .init(.koronYSori, "koron e sori"),
        .init(.comas53, "53 comas de Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 mória"),
        .init(.sruti22, "22 śrutis"),
    ])
}
