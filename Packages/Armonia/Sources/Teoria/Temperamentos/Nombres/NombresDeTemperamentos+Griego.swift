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
        .init(.werckmeisterIII, "Werckmeister III"),
        .init(.kirnbergerII, "Kirnberger II"),
        .init(.kirnbergerIII, "Kirnberger III"),
        .init(.vallotti, "Vallotti"),
        .init(.young, "Young"),
        .init(.afinacionJusta, "φυσικό κούρδισμα"),
        .init(.divisiones19, "19 ίσες διαιρέσεις"),
        .init(.divisiones22, "22 ίσες διαιρέσεις"),
        .init(.divisiones31, "31 ίσες διαιρέσεις"),
        .init(.divisiones41, "41 ίσες διαιρέσεις"),
        .init(.cuartosDeTono, "τέταρτα του τόνου"),
        .init(.koronYSori, "κορόν και σορί"),
        .init(.comas53, "53 κόμματα Arel-Ezgi-Uzdilek"),
        .init(.moria72, "72 μόρια"),
        .init(.sruti22, "22 σρούτι"),
    ])
}
