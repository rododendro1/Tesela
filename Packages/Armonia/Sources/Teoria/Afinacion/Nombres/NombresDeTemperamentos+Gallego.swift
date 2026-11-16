// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en gallego. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let gallego = Tabla([
        .init(.temperamentoIgual, "temperamento igual"),
        .init(.pitagorico, "afinación pitagórica"),
        .init(.mesotonicoCuartoDeComa, "mesotónico de 1/4 de coma"),
        .init(.mesotonicoTercioDeComa, "mesotónico de 1/3 de coma"),
        .init(.mesotonicoDosSeptimosDeComa, "mesotónico de 2/7 de coma"),
        .init(.mesotonicoQuintoDeComa, "mesotónico de 1/5 de coma"),
        .init(.mesotonicoSextoDeComa, "mesotónico de 1/6 de coma"),
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.werckmeisterIV, "Werckmeister IV"),
        .init(.werckmeisterV, "Werckmeister V"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.kellner, "Kellner", alias: ["Bach-Kellner"]),
        .init(.barnes, "Barnes", alias: ["Bach-Barnes"]),
        .init(.lehman, "Lehman", alias: ["Bach-Lehman"]),
        .init(.afinacionJusta, "afinación xusta"),
        .init(.divisiones5, "5 divisións iguais"),
        .init(.divisiones7, "7 divisións iguais"),
        .init(.divisiones17, "17 divisións iguais"),
        .init(.divisiones19, "19 divisións iguais"),
        .init(.divisiones22, "22 divisións iguais"),
        .init(.divisiones31, "31 divisións iguais"),
        .init(.divisiones41, "41 divisións iguais"),
        .init(.divisiones43, "43 divisións iguais"),
        .init(.divisiones96, "96 divisións iguais"),
        .init(.cuartosDeTono, "cuartos de ton"),
        .init(.koronYSori, "koron e sori"),
        .init(.comas53, "53 comas de Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 moria"),
        .init(.sruti22, "22 śruti"),
    ])
}
