// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en frances. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let frances = Tabla([
        .init(.temperamentoIgual, "tempérament égal"),
        .init(.pitagorico, "accord pythagoricien"),
        .init(.mesotonicoCuartoDeComa, "mésotonique à 1/4 de comma"),
        .init(.mesotonicoTercioDeComa, "mésotonique à 1/3 de comma"),
        .init(.mesotonicoDosSeptimosDeComa, "mésotonique à 2/7 de comma"),
        .init(.mesotonicoQuintoDeComa, "mésotonique à 1/5 de comma"),
        .init(.mesotonicoSextoDeComa, "mésotonique à 1/6 de comma"),
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.afinacionJusta, "intonation juste"),
        .init(.divisiones19, "19 divisions égales"),
        .init(.divisiones22, "22 divisions égales"),
        .init(.divisiones31, "31 divisions égales"),
        .init(.divisiones41, "41 divisions égales"),
        .init(.cuartosDeTono, "quarts de ton"),
        .init(.koronYSori, "koron et sori"),
        .init(.comas53, "53 commas d'Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 moria"),
        .init(.sruti22, "22 shrutis"),
    ])
}
