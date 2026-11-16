// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en italiano. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let italiano = Tabla([
        .init(.temperamentoIgual, "temperamento equabile"),
        .init(.pitagorico, "accordatura pitagorica"),
        .init(.mesotonicoCuartoDeComa, "mesotonico a 1/4 di comma"),
        .init(.mesotonicoTercioDeComa, "mesotonico a 1/3 di comma"),
        .init(.mesotonicoDosSeptimosDeComa, "mesotonico a 2/7 di comma"),
        .init(.mesotonicoQuintoDeComa, "mesotonico a 1/5 di comma"),
        .init(.mesotonicoSextoDeComa, "mesotonico a 1/6 di comma"),
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
        .init(.afinacionJusta, "intonazione naturale"),
        .init(.divisiones5, "5 divisioni uguali"),
        .init(.divisiones7, "7 divisioni uguali"),
        .init(.divisiones17, "17 divisioni uguali"),
        .init(.divisiones19, "19 divisioni uguali"),
        .init(.divisiones22, "22 divisioni uguali"),
        .init(.divisiones31, "31 divisioni uguali"),
        .init(.divisiones41, "41 divisioni uguali"),
        .init(.divisiones43, "43 divisioni uguali"),
        .init(.divisiones96, "96 divisioni uguali"),
        .init(.cuartosDeTono, "quarti di tono"),
        .init(.koronYSori, "koron e sori"),
        .init(.comas53, "53 comma di Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 moria"),
        .init(.sruti22, "22 śruti"),
    ])
}
