// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en ingles. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let ingles = Tabla([
        .init(.temperamentoIgual, "equal temperament", alias: ["12-TET", "12-EDO"]),
        .init(.pitagorico, "Pythagorean tuning"),
        .init(.mesotonicoCuartoDeComa, "1/4 comma meantone", alias: ["meantone", "quarter-comma meantone"]),
        .init(.mesotonicoTercioDeComa, "1/3 comma meantone"),
        .init(.mesotonicoDosSeptimosDeComa, "2/7 comma meantone"),
        .init(.mesotonicoQuintoDeComa, "1/5 comma meantone"),
        .init(.mesotonicoSextoDeComa, "1/6 comma meantone"),
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
        .init(.afinacionJusta, "just intonation"),
        .init(.divisiones5, "5 equal divisions of the octave", alias: ["5-TET", "5-EDO"]),
        .init(.divisiones7, "7 equal divisions of the octave", alias: ["7-TET", "7-EDO"]),
        .init(.divisiones17, "17 equal divisions of the octave", alias: ["17-TET", "17-EDO"]),
        .init(.divisiones19, "19 equal divisions of the octave", alias: ["19-TET", "19-EDO"]),
        .init(.divisiones22, "22 equal divisions of the octave", alias: ["22-TET", "22-EDO"]),
        .init(.divisiones31, "31 equal divisions of the octave", alias: ["31-TET", "31-EDO"]),
        .init(.divisiones41, "41 equal divisions of the octave", alias: ["41-TET", "41-EDO"]),
        .init(.divisiones43, "43 equal divisions of the octave", alias: ["43-TET", "43-EDO"]),
        .init(.divisiones96, "96 equal divisions of the octave", alias: ["96-TET", "96-EDO"]),
        .init(.cuartosDeTono, "quarter tones", alias: ["24-TET", "24-EDO"]),
        .init(.koronYSori, "koron and sori"),
        .init(.comas53, "Arel-Ezgi-Uzdilek 53 commas", alias: ["53 commas", "53-EDO"]),
        .init(.moria72, "72 moria"),
        .init(.sruti22, "22 shrutis", alias: ["śruti", "shruti"]),
    ])
}
