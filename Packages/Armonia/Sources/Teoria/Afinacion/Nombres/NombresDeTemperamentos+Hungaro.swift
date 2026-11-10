// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en hungaro. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let hungaro = Tabla([
        .init(.temperamentoIgual, "kiegyenlített hangolás"),
        .init(.pitagorico, "püthagoraszi hangolás"),
        .init(.mesotonicoCuartoDeComa, "1/4 kommás középhangú hangolás"),
        .init(.mesotonicoTercioDeComa, "1/3 kommás középhangú hangolás"),
        .init(.mesotonicoDosSeptimosDeComa, "2/7 kommás középhangú hangolás"),
        .init(.mesotonicoQuintoDeComa, "1/5 kommás középhangú hangolás"),
        .init(.mesotonicoSextoDeComa, "1/6 kommás középhangú hangolás"),
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.afinacionJusta, "tiszta hangolás"),
        .init(.divisiones19, "19 egyenlő részre osztott oktáv"),
        .init(.divisiones22, "22 egyenlő részre osztott oktáv"),
        .init(.divisiones31, "31 egyenlő részre osztott oktáv"),
        .init(.divisiones41, "41 egyenlő részre osztott oktáv"),
        .init(.cuartosDeTono, "negyedhangok"),
        .init(.koronYSori, "koron és szori"),
        .init(.comas53, "Arel-Ezgi-Uzdilek 53 kommája"),
        .init(.moria72, "72 mória"),
        .init(.sruti22, "22 śruti"),
    ])
}
