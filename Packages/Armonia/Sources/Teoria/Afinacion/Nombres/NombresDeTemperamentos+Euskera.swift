// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en euskera. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let euskera = Tabla([
        .init(.temperamentoIgual, "tenperamentu berdina"),
        .init(.pitagorico, "afinazio pitagorikoa"),
        .init(.mesotonicoCuartoDeComa, "1/4 komako mesotonikoa"),
        .init(.mesotonicoTercioDeComa, "1/3 komako mesotonikoa"),
        .init(.mesotonicoDosSeptimosDeComa, "2/7 komako mesotonikoa"),
        .init(.mesotonicoQuintoDeComa, "1/5 komako mesotonikoa"),
        .init(.mesotonicoSextoDeComa, "1/6 komako mesotonikoa"),
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
        .init(.afinacionJusta, "afinazio justua"),
        .init(.divisiones5, "5 zatiketa berdin"),
        .init(.divisiones7, "7 zatiketa berdin"),
        .init(.divisiones17, "17 zatiketa berdin"),
        .init(.divisiones19, "19 zatiketa berdin"),
        .init(.divisiones22, "22 zatiketa berdin"),
        .init(.divisiones31, "31 zatiketa berdin"),
        .init(.divisiones41, "41 zatiketa berdin"),
        .init(.divisiones43, "43 zatiketa berdin"),
        .init(.divisiones96, "96 zatiketa berdin"),
        .init(.cuartosDeTono, "tonu-laurdenak"),
        .init(.koronYSori, "koron eta sori"),
        .init(.comas53, "Arel-Ezgi-Uzdileken 53 komak"),
        .init(.moria72, "72 moria"),
        .init(.sruti22, "22 śruti"),
    ])
}
