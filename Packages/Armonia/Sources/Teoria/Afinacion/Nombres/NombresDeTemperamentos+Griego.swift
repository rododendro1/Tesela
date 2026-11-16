// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de los temperamentos del catálogo en griego. Qué es cada campo, en `NombresDeTemperamentos.swift`.

extension NombresDeTemperamentos {
    static let griego = Tabla([
        .init(.temperamentoIgual, "ίσος συγκερασμός"),
        .init(.pitagorico, "πυθαγόρειο κούρδισμα"),
        .init(.mesotonicoCuartoDeComa, "μεσοτονικό 1/4 κόμματος"),
        .init(.mesotonicoTercioDeComa, "μεσοτονικό 1/3 κόμματος"),
        .init(.mesotonicoDosSeptimosDeComa, "μεσοτονικό 2/7 κόμματος"),
        .init(.mesotonicoQuintoDeComa, "μεσοτονικό 1/5 κόμματος"),
        .init(.mesotonicoSextoDeComa, "μεσοτονικό 1/6 κόμματος"),
        .init(.werckmeisterIII, "Βέρκμαϊστερ III"),
        .init(.werckmeisterIV, "Βέρκμαϊστερ IV"),
        .init(.werckmeisterV, "Βέρκμαϊστερ V"),
        .init(.kirnbergerII, "Κίρνμπεργκερ II"),
        .init(.kirnbergerIII, "Κίρνμπεργκερ III"),
        .init(.vallotti, "Βαλλόττι"),
        .init(.young, "Γιανγκ"),
        .init(.kellner, "Κέλνερ", alias: ["Bach-Kellner"]),
        .init(.barnes, "Μπαρνς", alias: ["Bach-Barnes"]),
        .init(.lehman, "Λίμαν", alias: ["Bach-Lehman"]),
        .init(.afinacionJusta, "φυσικό κούρδισμα"),
        .init(.divisiones5, "5 ίσες διαιρέσεις"),
        .init(.divisiones7, "7 ίσες διαιρέσεις"),
        .init(.divisiones17, "17 ίσες διαιρέσεις"),
        .init(.divisiones19, "19 ίσες διαιρέσεις"),
        .init(.divisiones22, "22 ίσες διαιρέσεις"),
        .init(.divisiones31, "31 ίσες διαιρέσεις"),
        .init(.divisiones41, "41 ίσες διαιρέσεις"),
        .init(.divisiones43, "43 ίσες διαιρέσεις"),
        .init(.divisiones96, "96 ίσες διαιρέσεις"),
        .init(.cuartosDeTono, "τέταρτα του τόνου"),
        .init(.koronYSori, "κορόν και σορί"),
        .init(.comas53, "53 κόμματα Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 μόρια"),
        .init(.sruti22, "22 σρούτι"),
    ])
}
