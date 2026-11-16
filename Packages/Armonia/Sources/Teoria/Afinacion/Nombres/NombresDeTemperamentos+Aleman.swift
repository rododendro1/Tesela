// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en aleman. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let aleman = Tabla([
        .init(.temperamentoIgual, "gleichstufige Stimmung"),
        .init(.pitagorico, "pythagoreische Stimmung"),
        .init(.mesotonicoCuartoDeComa, "1/4-Komma-mitteltönig"),
        .init(.mesotonicoTercioDeComa, "1/3-Komma-mitteltönig"),
        .init(.mesotonicoDosSeptimosDeComa, "2/7-Komma-mitteltönig"),
        .init(.mesotonicoQuintoDeComa, "1/5-Komma-mitteltönig"),
        .init(.mesotonicoSextoDeComa, "1/6-Komma-mitteltönig"),
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
        .init(.afinacionJusta, "reine Stimmung"),
        .init(.divisiones5, "5-stufige gleichstufige Stimmung"),
        .init(.divisiones7, "7-stufige gleichstufige Stimmung"),
        .init(.divisiones17, "17-stufige gleichstufige Stimmung"),
        .init(.divisiones19, "19-stufige gleichstufige Stimmung"),
        .init(.divisiones22, "22-stufige gleichstufige Stimmung"),
        .init(.divisiones31, "31-stufige gleichstufige Stimmung"),
        .init(.divisiones41, "41-stufige gleichstufige Stimmung"),
        .init(.divisiones43, "43-stufige gleichstufige Stimmung"),
        .init(.divisiones96, "96-stufige gleichstufige Stimmung"),
        .init(.cuartosDeTono, "Vierteltöne"),
        .init(.koronYSori, "Koron und Sori"),
        .init(.comas53, "53 Kommata nach Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 Moria"),
        .init(.sruti22, "22 Shrutis"),
    ])
}
